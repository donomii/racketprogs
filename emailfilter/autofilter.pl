use strict;
select((select(STDOUT), $|=1)[0]);
    use Net::IMAP::Client;
	use Data::Dumper;
use Getopt::Long qw/:config bundling/;
use Algorithm::NaiveBayes;
  my $nb = Algorithm::NaiveBayes->new;

my $probabilityThreshold = 0.99;


my $options = {};
GetOptions(
    $options,
    'dir=s',      #OPTIONAL: FULL PATH to the input CSV. Otherwise in default path with constructed name.
    'dump!',     #Print all messages in the folder
    'verbose!',  #Prints generated SQL query
    'help|h|?!', #TODO: Print help
) or die "ERROR: Unrecognized command line options";
print Dumper $options;

my $folder = shift;
$folder || die "
Use:

autofilter <FOLDER>

Example:

autofilter INBOX
";
my %seen;

my @filters = (
[ "INBOX/a", sub { my $_ = shift; my @from = map {$_->{mailbox}.'@'.$_->{host}} @{$_->from}; my $from = join(",", @from); return $from =~ /noreply/ && $_->subject =~ /sub-a/; } ],
[ "INBOX/b", sub { my $_ = shift; if($_->sender){ my @from = map {$_->{mailbox}.'@'.$_->{host}} @{$_->sender}; my $from = join(",", @from); return $from =~ /sub-b/ }} ],
#[ "INBOX/officeSpam", sub { my $_ = shift; my @from = map {$_->{mailbox}.'@'.$_->{host}} @{$_->to}; my $from = join(",", @from); return $from =~ /dev.personal/ } ],
#[ "INBOX/devTech", sub { my $_ = shift; if ($_->to) {my @to = map {$_->{mailbox}."@".$_->{host}} @{$_->sender}; my $to = join(",", @to); return $to =~ /dev\.tech\@lists/ && $_->subject =~ /dev\.tech/; }} ],
[ "INBOX/c", sub { my $_ = shift; if ($_->to) {if ($_->sender) {my @to = map {$_->{mailbox}."@".$_->{host}} @{$_->sender}; my $to = join(",", @to); return $to =~ /ret-c/; }}} ],


);

    my $imap = Net::IMAP::Client->new(

        server => '',
        user   => '',
        pass   => '',
        ssl    => 1,                              # (use SSL? default no)
        ssl_verify_peer => 1,                     # (use ca to verify server, default yes)
        #ssl_ca_file => '/etc/ssl/certs/certa.pm', # (CA file used for verify server) or
       ssl_ca_path => '/etc/ssl/certs/',         # (CA path used for SSL)
        port   => 993                             # (but defaults are sane)

    ) or die "Could not connect to IMAP server";

    # everything's useless if you can't login
    $imap->login or
      die('Login failed: ' . $imap->last_error);

    # get folder hierarchy separator (cached at first call)
    my $sep = $imap->separator;
    # let's see what this server knows (result cached on first call)
    my $capab = $imap->capability;
       # or
    #my $knows_sort = $imap->capability( qr/^sort/i );

    # get list of folders
    my @folders = $imap->folders();
    print "Folders: ".join(",",@folders)."\n";

    # get total # of messages, # of unseen messages etc. (fast!)
    #my $status = $imap->status(@folders); # hash ref!
    #print Dumper($status);
    my $status = $imap->status($folder); # hash ref!
    #print Dumper($status);

    # select folder
    $imap->select($folder);
	#print $imap->last_error();


    # fetch all message ids (as array reference)
    #my $messages = $imap->search('ALL');

    # fetch all ID-s sorted by subject
    my $messages = $imap->search('ALL' ,undef,"US-ASCII" );
	foreach my $mess ( @$messages ) {
		$seen{$mess}++;
  #my $summaries = $imap->get_summaries($mess);#[ @messages ]);
    #foreach (@$summaries) {
        #print $_->uid, $_->subject, $_->date, $_->rfc822_size, "\n";
        #print join(', ', @{$_->from}); # etc.
        #}
	}
    train_folders();
    $nb->train;
    $imap->select($folder);
	foreach my $mess ( @$messages ) {
        #autofilter($mess);
        unless (filter($mess)) {
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
    }

	#print Dumper \@messages;
       # or
    #my $messages = $imap->search('ALL', [ 'SUBJECT' ]);

    # fetch ID-s that match criteria, sorted by subject and reverse date
    #my $messages = $imap->search({
        #FROM    => 'foo',
        #SUBJECT => 'bar',
    #}, [ 'SUBJECT', '^DATE' ]);

    # fetch message summaries (actually, a lot more)
	foreach my $mess ( 1..1 ) {
    my $summaries = $imap->get_summaries($mess);#[ @messages ]);
    foreach (@$summaries) {
        #print $_->uid, $_->subject, $_->date, $_->rfc822_size, "\n";
        #print join(', ', @{$_->from}); # etc.
    }
}

    # fetch full message
    #my $data = $imap->get_rfc822_body($msg_id);
    #print $$data; # it's reference to a scalar

    # fetch full messages
    #my @msgs = $imap->get_rfc822_body([ @messages ]);
    #print $$_ for (@msgs);

	print "Waiting for changes....";
    $imap->select($folder);
	while (1) {

	$imap->noop;
	my @notifications = $imap->notifications();
	if (scalar (@notifications)) {
        #print "Got notification\n";
    	my $messages = $imap->search('ALL' ,undef,"US-ASCII" );
	#print Dumper($messages);
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
            my $choice = shift @$categories;
            my $score = shift @$scores;
			#print "\nMessage: $mess\n";
			foreach (@$summaries) {
				my @from = map {$_} @{$_->from};
				my $from = join(",", @from);
                unless (filter($mess)) {
				    print "\n$choice($score): ",$from, " : ",$_->subject;
                    if ($score>$probabilityThreshold) {
                        $imap->copy([$mess], $choice);
                        $imap->add_flags([$mess], '\\Deleted');
                        #$imap->expunge;
                    }
                }
			}
	}
}
	sleep 1;
}
}



sub filter {
    my $mess = shift;
    my $moved = 0;
    my $summaries = $imap->get_summaries($mess);
    #warn "Summaries: ".Dumper(@$summaries)."\n";
    foreach my $summ(@$summaries) {
        my @from = map {$_} @{$summ->from};
        my $from = join(",", @from);
        #warn "Considering : ".Dumper($summ->to)."\n";
        foreach my $f ( @filters ) {
            if (($folder ne $f->[0]) && ($f->[1]($summ))) {
                $moved ++;
                #warn "Moving to ( $f->[0] )\n";
                $imap->copy([$mess], $f->[0]);
                $imap->add_flags([$mess], '\\Deleted');
                $imap->expunge;
            }
        }
    }
    return $moved;
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
            push @sel, $e->{mailbox}."@".$e->{host}
          }
        }
        push @sel, $summ->subject;
      }
    }
    push @sel, $text;

    $text = join(" ", @sel);
    $text =~ s/['",.(){}_]/ /g;
    $text =~ s/\[|\]|=>/ /g;
    $text =~ s/=\r\n/ /g;
    $text =~ s/=\n/ /g;
    $text =~ s/\n/ /g;
    $text =~ s/=/ /g;
    my @words = split /\s+/, $text;
    my %attribs;
    my @smallwords = grep { length($_)<20 } @words;
    foreach my $i ( 0..scalar(@smallwords)-1 ) {
        $attribs{$smallwords[$i]." ".$smallwords[$i+1]." ".$smallwords[$i+2]}++ ;
    }
    foreach my $i ( 0..scalar(@smallwords) ) {
        $attribs{$smallwords[$i]." ".$smallwords[$i+1]}++ ;
    }
    foreach my $i ( 0..scalar(@smallwords)+1 ) {
        $attribs{$smallwords[$i]}++ ;
    }
    return \%attribs;
}

sub train_folders {
    my @folders = $imap->folders();
    print "Scanning: @folders\n";
    for my $folder ( @folders ) {
        my $count =0;
        next if ($folder =~ /Draft|Sent|Deleted|Trash/i);
        next if ($folder =~ /^INBOX$/i);
        $imap->select($folder);
                    print "Training on $folder...";

        my $messages = $imap->search('ALL' ,undef,"US-ASCII" );
        foreach my $mess ( @$messages ) {
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
