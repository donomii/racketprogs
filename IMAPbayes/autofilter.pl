use strict;
select((select(STDOUT), $|=1)[0]);
use Net::IMAP::Client;
use Data::Dumper;
use Getopt::Long qw/:config bundling/;
use Algorithm::NaiveBayes;
my $nb = Algorithm::NaiveBayes->new;

my $probabilityThreshold = 0.99;    #Messages that score lower than this will not be moved
my $maxSpeakWords = 25;             #Trim the announce message to this
my $config = eval `cat config.perl`;

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
$nb->train;
$imap->select($folder);

foreach my $mess ( @$messages ) {
        my $flags = $imap->get_flags($mess);
        my $results = $imap->fetch([$mess], "BODY[TEXT]") ;
        $imap->store($mess, '');
        my $text = $results->[0]->{'BODY[TEXT]'};
        my $summaries = $imap->get_summaries($mess);
        my ($categories, $scores) = predict(make_attribs($summaries,$text));
        my $choice = shift @$categories;
        my $score = shift @$scores;
        #warn "($choice) $score\n";

        if ($score>$probabilityThreshold) {
            $imap->copy([$mess], $choice);
            $imap->add_flags([$mess], '\\Deleted');
            $imap->expunge;
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
            my ($categories, $scores) =  predict(make_attribs($summaries,$text));
            my $h = {};
            foreach my $i (0..scalar(@$categories)) {
                $h->{$scores->[$i]} = $categories->[$i];
            }
            #Find highest score
            my $highscore = 0;
            foreach my $score (@$scores) {if ($score>$highscore) {$highscore = $score}}

            my $choice = $h->{$highscore};
            my $score = $highscore;
            foreach (@$summaries) {
                my @from = map {$_} @{$_->from};
                my $from = join(",", @from);
                    print "\n$choice($score): ",$from, " : ",$_->subject;
                    my $sub  = $_->subject;
                    $sub =~ s/^.+\]//g;
                    $sub =~ s/\)|\(//g;
                    my $displayChoice = $choice;
                    $displayChoice =~ s!$folder/!!g;
                    my @bits = split(/\s+/, $sub, $maxSpeakWords); #Limit the number of words we have to speak in case of a ridiculously long subject
                    pop @bits;
                    $sub = join(" ", @bits);

                    if ($score>$probabilityThreshold) {
                        system("say", "-v", "Daniel",  "${displayChoice}. $sub");;
                        system("svarmrMessage", "localhost", "4816",  "user-notify", "${displayChoice}: ". $sub);
                        #FIXME check the folder exists before marking deleted
                        $imap->copy([$mess], $choice);
                        $imap->add_flags([$mess], '\\Deleted');
                        #$imap->expunge;
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
      }
    }
    push @sel, $text;

    $text = join(" ", @sel);
    use HTML::Strip;
    my $hs = HTML::Strip->new();

    my $text = $hs->parse( $text );
    $text =~ s/\.\s+/ /g;
    $text =~ s/['",(){}_]/ /g;
    $text =~ s/\[|\]|=>/ /g;
    $text =~ s/=\r\n/ /g;
    $text =~ s/=\n/ /g;
    $text =~ s/\n/ /g;
    $text =~ s/=/ /g;
    $text =~ s/\s+/ /g;
    #print "------\n";
    #warn "Text for analysis: $text\n";
    #print "------\n";
    my @words = split /\s+/, $text;
    my %attribs=();
    my @smallwords = grep { !/-/ } grep { length($_)<20 } @words;
    #warn join(",", @smallwords)."\n";
    foreach my $i ( 0..scalar(@smallwords)-1 ) {
        $attribs{$smallwords[$i]." ".$smallwords[$i+1]." ".$smallwords[$i+2]}++ ;
    }
    foreach my $i ( 0..scalar(@smallwords) ) {
        $attribs{$smallwords[$i]." ".$smallwords[$i+1]}++ ;
    }
    foreach my $i ( 0..scalar(@smallwords)+1 ) {
        $attribs{$smallwords[$i]}++ ;
    }
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
        print "Training on $folder...";

        my $messages = $imap->search('ALL' ,undef,"US-ASCII" );
        my $count = 0;
        foreach my $mess ( @$messages ) {
            if ($count++>1000) { next;}
            #if ($mess>200) {next;}
            my $flags = $imap->get_flags($mess);
            my $results = $imap->fetch([$mess], "BODY[TEXT]") ;
            $imap->store($mess, $flags);
            if ($results) {
                #print "Folder: $folder, id: $mess\n";
                my $text = $results->[0]->{'BODY[TEXT]'};
                my $summaries = $imap->get_summaries($mess);
                my $attribs = make_attribs($summaries,$text);
                #print $text;
                if (scalar(keys %$attribs)>0) {
                    $count++;
                    #print Dumper(\%attribs);
                    train({attributes => $attribs, label => $folder});
                }
            }
        }
        print $count."\n";
    }
    #print Dumper($nb);
}

sub train {
    my $features = shift;
    #print Dumper $features;

  $nb->add_instance (attributes => $features ->{attributes} , label => $features -> {label} );
}

sub predict {
#return (["INBOX"],[0.0]);#
    my $attributes = shift;
  my $result = $nb->predict (attributes => $attributes);
  my @sorted =  sort { $result->{$a} < $result->{$b} } keys %$result;
  my @vals = map { $result->{$_} } @sorted;
  return \@sorted, \@vals;
}
