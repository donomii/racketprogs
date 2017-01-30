package main;
#note: add dryrun option
use strict;
select((select(STDOUT), $|=1)[0]);
use Net::IMAP::Client;
use Data::Dumper;
use Getopt::Long qw/:config bundling/;
use Algorithm::NaiveBayes;
# Create a new network with 1 layer, 5 inputs, and 5 outputs.
use AI::NeuralNet::BackProp;
my $net = new AI::NeuralNet::BackProp(3,30);
my $nnfile = "nnsave.net";
if ( -e $nnfile ) { 
    $net->load($nnfile);
}

my @all_categories;
sub make_nn_categories {
    my $cat = shift;
    my $out = join(" ", map { if ( $cat eq $_ ) { "yes" } else { "no" }} @all_categories);

}
# Add a small amount of randomness to the network
$net->random(0.001);

my $nb = Algorithm::NaiveBayes->new(purge=>undef);
my @docs = ();
my %cats = ();
my @mbayes = map { my $nb = Algorithm::NaiveBayes->new(purge=>undef);; $nb->add_instance(attributes => {"Dummy text", 1}, label=>"Dummy"); $nb  } 1..100;
map { $_->{adaboost} = {}; $_ } @mbayes;
my @random_samples = ();

sub ran {
    int(rand(scalar(@mbayes)));
}

#use AI::DecisionTree;
#my $dtree = new AI::DecisionTree;



my $tiered_classifiers = 0;
my $max_folder_messages = 5000;      #Maximum number of messages to process in each folder (because some of my folders have > 20,000 messages)
my $dryRun=0;
my $use_nn = 0;
my $probabilityThreshold = 0.999;    #Messages that score lower than this will not be moved
my $maxSpeakWords = 25;             #Trim the announce message to this
my $config = eval `cat config.perl`;
my $max_categorisers = 0;
my $boost = 0;                       #Adaptive boost the ensemble categorisers

my $folder = shift;
($folder) || die "
Use:

autofilter <FOLDER>

Example:

autofilter INBOX
";
print "Connection details\n".Dumper($config);
my %seen;

my $imap = Net::IMAP::Client->new(
    %$config
) or die "Could not connect to IMAP server";

# everything's useless if you can't login
$imap->login or
  die('Login failed: ' . $imap->last_error);

# get list of folders
my @folders = $imap->folders();
@all_categories = @folders;
print "Folders: ".join(",",@folders)."\n";

# select folder
$imap->select($folder);
#print $imap->last_error();


# fetch all message ids (as array reference)
#my $messages = $imap->search('ALL');

# fetch all ID-s sorted by subject
my $messages = $imap->search('ALL' ,undef,"US-ASCII" );
foreach my $mess ( @$messages ) {
    $seen{$mess}++;
}

train_folders();
warn "Training bayes model\n";
$nb->train;
$_->train foreach @mbayes;
warn "Training ada boost model with (".scalar(@random_samples).")\n";

if ($boost) {
    map {
        my $rs = $_;
        map {
            my $nb = $_;
          my $result = $nb->predict (attributes => $rs ->{attributes});
          my @sorted =  sort { $result->{$a} < $result->{$b} } keys %$result;
          my @vals = map { $result->{$_} } @sorted;
          warn "Single bayes predicts: ".$sorted[0]."\n";

            my $pred = shift @sorted;
            $nb->{adaboost}->{$pred} //=1.0;
            if ($pred eq $rs->{label}) {
                $nb->{adaboost}->{$pred}=$nb->{adaboost}->{$pred}+(1.0/scalar(@random_samples))/2.0;
            } else {
                $nb->{adaboost}->{$pred}=$nb->{adaboost}->{$pred}-(1.0/scalar(@random_samples))/2.0;
            }
        } @mbayes;
    } @random_samples;
}

#$dtree->train;
    map { warn Dumper($_->{adaboost})} @mbayes;
warn "Training complete\n";

#my %model = %{$nb->{model}};
#foreach my $k ( keys %model) {
#my $cat = $model{$k};
#my @skeys = sort { $cat->{$_} <=> $cat->{$b} } keys %$cat;
#print "$k: ".join(",", @skeys[0..10])."\n";
#}
$imap->select($folder);

warn "Processing existing messages in $folder(".scalar(@$messages).")\n";

foreach my $mess ( @$messages ) {
        my $flags = $imap->get_flags($mess);
        my $results = $imap->fetch([$mess], "BODY[TEXT]") ;
        $imap->store($mess, '');
        my $text = $results->[0]->{'BODY[TEXT]'};
        my $summaries = $imap->get_summaries($mess);
        warn "Subject: ".eval { $summaries->[0]->subject()}."\n";
        my ($categories, $scores) = predict(make_attribs($summaries,""));
        if ( $use_nn ) {
            if ($summaries->[0]) {
                        my $subject = $summaries->[0]->subject();
                        warn "Neural net predicts: ".$net->uncrunch($net->run($subject));
                    }
        }

        warn "---------\n";
        if (defined($categories)) {
            my $choice = shift @$categories;
            my $score = shift @$scores;
            # warn "($choice) $score\n";

            if ($score>=$probabilityThreshold) {
                if (!$dryRun ) {
                    $imap->copy([$mess], $choice);
                    $imap->add_flags([$mess], '\\Deleted');
                    $imap->expunge;
                }
            }
        }
}

# fetch full messages
#my @msgs = $imap->get_rfc822_body([ @messages ]);
#print $$_ for (@msgs);

print "Waiting for changes....";
$imap->select($folder);
while (1) {
    $imap->noop;
    my @notifications = $imap->notifications();
    if (scalar (@notifications)) {
        my $messages = $imap->search('ALL' ,undef,"US-ASCII" );

        foreach my $mess ( @$messages ) {
            if ($seen{$mess}==0) {
                #autofilter($mess);
                #print "unseen message: $mess\n";
                $seen{$mess}++;
                my $flags = $imap->get_flags($mess);
                my $results = $imap->fetch([$mess], "BODY[TEXT]") ;
                $imap->store($mess, '');
                my $text = $results->[0]->{'BODY[TEXT]'};
                my $summaries = $imap->get_summaries($mess);
                warn "Subject: ".$summaries->[0]->subject();
                my ($categories, $scores) =  predict(make_attribs($summaries,"")); #predict(make_attribs($summaries,$text));
        if ( $use_nn ) {
            if ($summaries->[0]) {
                        my $subject = $summaries->[0]->subject();
                        warn "Neural net predicts: ".$net->uncrunch($net->run($subject));
                    }
        }
                warn "--------\n";
                if (defined($categories)) {
                    my $choice = shift @$categories;
                    my $score = shift @$scores;
                    foreach (@$summaries) {
                        my @from = map {$_} @{$_->from};
                        my $from = join(",", @from);
                            warn "\n$choice($score): ",$from, " : ",$_->subject;
                            my $sub  = $_->subject;
                            $sub =~ s/^.+\]//g;
                            $sub =~ s/\)|\(//g;
                            my $displayChoice = $choice;
                            $displayChoice =~ s!$folder/!!g;
                            my @bits = split(/\s+/, $sub); #Limit the number of words we have to speak in case of a ridiculously long subject
                            if (scalar(@bits)>$maxSpeakWords) {
                                @bits = @bits[0..$maxSpeakWords];
                            }
                            $sub = join(" ", @bits);

                            if ($score>$probabilityThreshold) {
                                if($choice !~ /spam/i) {
                                    system("say", "-v", "Daniel",  "${displayChoice}. $sub");;
                                    system("svarmrMessage", "localhost", "4816",  "user-notify", "${displayChoice}: ". $sub);
                                }
                                #FIXME check the folder exists before marking deleted
                                if (!$dryRun) {
                                    $imap->copy([$mess], $choice);
                                    $imap->add_flags([$mess], '\\Deleted');
                                    #$imap->expunge;
                                }
                            }
                    }
                }
            }
        }
        sleep 1;
    }
}



sub autofilter {
    my $mess = shift;
    my $moved = 0;
    my $summaries = $imap->get_summaries($mess);
    foreach my $summ(@$summaries) {
        my @from = map {$_} @{$summ->from};
        my $from = join(",", @from);
        my $sub = $summ->subject;
        if ($sub =~ m/\[(.+?)\]/) {
            #print "Found list $1\n";
            #warn Dumper $imap->create_folder("INBOX/auto_".$1);
        }
    }
    return $moved;
}



sub make_attribs {
    my $summaries = shift;

    my $text = shift;
    my @sel;
    foreach my $summ ( @$summaries ) {
      foreach my $field ( qw/to from sender/ ) {
        if ($summ->$field()) {
          foreach my $e (@{$summ->$field()}){
            push @sel, $field . " " . $e->{mailbox}."@".$e->{host}
          }
        }
        #Problem here, subjects seem to be duplicated?
        push @sel, $summ->subject;
        #warn "Making attribs from message with subject: ".$summ->subject ."\n";
      }
    }
    push @sel, $text;

    $text = join(" ", @sel);
    use HTML::Strip;
    my $hs = HTML::Strip->new();

    my $text = $hs->parse( $text );
    $text =~ s/\.\s+/ /g;
    #$text =~ s/['",(){}_]/ /g;
    #$text =~ s/\[|\]|=>/ /g;
    $text =~ s/=\r\n/ /g;
    $text =~ s/=\n/ /g;
    $text =~ s/\n/ /g;
    $text =~ s/\r/ /g;
    $text =~ s/=/ /g;
    $text =~ s/\?/ /g;
    $text =~ s/_/ /g;
    $text =~ s/\s+/ /g;
    #print "------\n";
    #warn "Text for analysis: $text\n";
    #print "------\n";
    my @words = split /\s+/, $text;
    my %attribs=();
    my @smallwords = grep { !/-/ } grep { length($_)<20 } @words;
    #warn join(",", @smallwords)."\n";
    foreach my $i ( 0..scalar(@smallwords)-2 ) {
        $attribs{$smallwords[$i]." ".$smallwords[$i+1]." ".$smallwords[$i+2]." ".$smallwords[$i+3]}++ ;
    }
    foreach my $i ( 0..scalar(@smallwords)-1 ) {
        $attribs{$smallwords[$i]." ".$smallwords[$i+1]." ".$smallwords[$i+2]}++ ;
    }
    foreach my $i ( 0..scalar(@smallwords) ) {
        $attribs{$smallwords[$i]." ".$smallwords[$i+1]}++ ;
    }

    #Straight word counts are not very useful
    #foreach my $i ( 0..scalar(@smallwords)+1 ) {
        #$attribs{$smallwords[$i]}++ ;
    #}
    #print Dumper(\%attribs);
    return \%attribs;
}

sub train_folders {
    my @folders = $imap->folders();
    print "Scanning: @folders\n";
    my $input_folder = $folder;
    for my $folder ( @folders ) {
        my $count =0;

        print Dumper($imap->status($folder));
        $imap->select($folder);
        $imap->expunge();
        next if ($folder =~ /Draft|Sent|Deleted|Trash/i);
        next if ($folder =~ /^$input_folder$/i);
        #print "Training on $folder...";

        my $messages = $imap->search('ALL' ,undef,"US-ASCII" );
        my $count = 0;
        foreach my $mess ( @$messages ) {
            if ($count>$max_folder_messages) { next;}
            warn "Message number $count\n";
            my $flags = $imap->get_flags($mess);
            my $results = $imap->fetch([$mess], "BODY[TEXT]") ;
            $imap->store($mess, $flags);
            if ($results) {
                #print "Folder: $folder, id: $mess\n";
                my $text = $results->[0]->{'BODY[TEXT]'};
                my $summaries = $imap->get_summaries($mess);
                my $attribs = make_attribs($summaries,""); #make_attribs($summaries,$text);
        if ( $use_nn ) {
                if ($summaries->[0]) {
                    my $subject = $summaries->[0]->subject();
                    warn "NN training subject: $subject to output ".make_nn_categories($folder) ."\n";
                    $net->learn($subject, make_nn_categories($folder));
                    warn "NN saving to $nnfile\n";
                    $net->save($nnfile);
                    warn "Neural net predicts: ".$net->uncrunch($net->run($subject));
                }
        }
                my $doc = $text;
                if (scalar(keys %$attribs)>0) {
                    $count++;
                    #print Dumper(\%attribs);
                    $count++;
                    train({attributes => $attribs, label => $folder, orig => $summaries});
                }
            }
        }
        print $count."\n";
    }
    #print Dumper($nb);
}

my @nodes;
sub train {
    my $features = shift;
    #print Dumper $features;

    #warn "Attribs: ". Dumper($features ->{attributes});
  $nb->add_instance (attributes => $features ->{attributes} , label => $features -> {label} );
  if (ran(10) == 1) {push @random_samples, $features}
  for (my $i=0;$i<scalar(@mbayes);$i) {
      if ($tiered_classifiers) {
          #Bump difficult examples to a new categoriser
          my $r = ran();
          $nodes[$i]++;
          if($i>1){warn Dumper($features->{orig})}
          $mbayes[$i]->add_instance (attributes => $features ->{attributes} , label => $features -> {label} );
          $mbayes[$i]->train();
          my ($sorted, $vals) = single_predict($mbayes[$i], $features ->{attributes});
          my $cat = $sorted->[0];
          if( ($cat eq $features -> {label}) && (ran(10)>1)) {last}
          $i++;
          if ($i> $max_categorisers) { $max_categorisers = $i}
          warn Dumper(\@nodes);
      } else {
          #Train a subset of the categorisers
          if (ran(100)<10) {
            $mbayes[$i]->add_instance (attributes => $features ->{attributes} , label => $features -> {label} );
          }
          $i++;
      }
  }
  #$dtree->add_instance (attributes => $features ->{attributes} , result => $features -> {label} );
}

sub forest_predict {
  my $attributes = shift;
  my %scores;
  warn "Consulting $max_categorisers categorisers\n";
  foreach my $nb ( @mbayes[0..$max_categorisers] ) {
      my $result = $nb->predict (attributes => $attributes);
      map { my $scaling = $nb->{adaboost}->{$_} // 1.0;  $result->{$_} = $result->{$_} * $scaling} keys %$result;
      my @sorted =  sort { $result->{$a} < $result->{$b} } keys %$result;
      my @vals = map { $result->{$_} } @sorted;
      my $cat = shift @sorted;
      my $score = shift @vals;
      if ($score > $scores{$cat}) { $scores{$cat} = $score}
    }
  my $result = \%scores;
  warn "Multi-result ".Dumper($result)."\n";
  my @sorted =  sort { $result->{$a} < $result->{$b} } keys %$result;
  my @vals = map { $result->{$_} } @sorted;
  my $cat = $sorted[0];
  my $score = $vals[0];
  warn "Multi bayes predicts: $cat($score)\n";
  my $catm = $sorted[1];
  my $scorem = $vals[1];
  if ($scorem>$score/5) {
      warn "Minority report: $catm($scorem)\n";
  }

  return \@sorted, \@vals;
}

sub single_predict {
  my $nb = shift;
#return (["INBOX"],[0.0]);#
  my $attributes = shift;
  my $result = $nb->predict (attributes => $attributes);
  my @sorted =  sort { $result->{$a} < $result->{$b} } keys %$result;
  my @vals = map { $result->{$_} } @sorted;
  warn "Single bayes predicts: ".$sorted[0]."\n";
  return \@sorted, \@vals;
}

my $agree=0;
my $tot = 0;
sub predict {
#return (["INBOX"],[0.0]);#
  my $attributes = shift;
  my ($forest_cat, $forest_score) = forest_predict($attributes);
  #my $result = single_predict ($nb, $attributes);
  my ($sorted, $vals) = single_predict($nb, $attributes);
  $tot++;
  if ($forest_cat->[0] eq $sorted->[0]) { 
      return $sorted, $vals;
  } else {
      warn "Disagreement! ". $agree++."/".$tot."\n";
      return undef, undef;
  }
}
