    package Joy;

    use strict;
    use warnings;
    use Filter::Util::Call;
    use Data::Dumper;

    use constant TRUE => 1;
    use constant FALSE => 0;
    
    sub finishlist
      {
        my $input = shift;
        unless (scalar(@{$input})) { die "List not terminated";}
        my $tok = token($input);
        print "finishlist got token :$tok:\n";
        if ($tok){return [ $tok, @{finishlist($input)}]}
        return [undef()];
      }

    sub finishsym
      {
        my $input = shift;
        unless (scalar(@{$input})) {print "finishsym input exhausted\n"; return '';}
        my $c = shift @{$input};
        #print "finishsym processing :$c:\n";
        if ($c =~ /[a-zA-Z]/) {return $c.finishsym($input);}
        #print "finishsym returning ''\n";
        unshift @{$input}, $c;
        return '';
      }
      sub finishnum
      {
        my $input = shift;
        unless (scalar(@{$input})) {print "finishnum input exhausted\n"; return '';}
        my $c = shift @{$input};
        #print "finishnum processing :$c:\n";
        if ($c =~ /[0-9]/) {return $c.finishnum($input);}
        #print "finishnum returning ''\n";
        unshift @{$input}, $c;
        return '';
      }
    sub finishstring
      {
        my $input = shift;
        return "" unless scalar(@{$input});
        my $c = shift @{$input};
        if ($c ne '"') {return $c.finishstring($input);}
        return '';
      }
    sub token
      {
        my $input = shift;
        return "" unless scalar(@{$input});
        my $c = shift @{$input};
        #print "token processing :$c:\n";
        if ($c =~ /\s/)         {return token($input);}
        if ($c eq '"')         {return new JString(finishstring($input));}
        if ($c =~ /[0-9]/)  {return new JNumber($c.finishnum($input));}
        if ($c =~ /[a-zA-Z]/)  {return new JSymbol($c.finishsym($input));}
        if ($c eq '[')  {return new JList(finishlist($input));}
    
        return undef();
      }
    sub import {
       my ($type) = @_;
       my (%context) = (
         #Enabled => defined $ENV{DEBUG},
         #InTraceBlock => FALSE,
         Filename => (caller)[1],
         LineNo => 0,
         LastBegin => 0,
       );
       filter_add(bless \%context);
    }

    sub Die {
       my ($self) = shift;
       my ($message) = shift;
       my ($line_no) = shift || $self->{LastBegin};
       die "$message at $self->{Filename} line $line_no.\n"
    }

    sub filter {
       my ($self) = @_;
       my ($status);
       $status = filter_read();
       ++ $self->{LineNo};

       

          if (/^\s*joy\((.*)\)\s*;\s*$/ ) {
            my $prog = $1;
            #my @prog = reverse( split /\s+/, $prog);
            my @prog = split //, $prog;
            my $input = \@prog;
            my $tok = token($input);
            my @res = ();
            while ($tok)
              { push @res, $tok->as_perl(); $tok=token($input);}
            #foreach (@prog){$res .= "&". $_.";\n";}
            @res = reverse @res;
            #my $debug = "print 'Stack is: '. join(',',reverse(\@_)).\"\n\";\n";
            my $debug = "";
            my $res=join $debug, @res;
            #print "res :",$res,":\n";
            $_=$res;
          }
                 return $status;
              }
    1;
    package JType;
    sub new {my $class = shift;  my %h=();$h{value} = shift; bless \%h,$class}
    sub value {my $self = shift; return $self->{value}}
    
    package JString;
    our @ISA = qw(JType);
    sub as_perl       { my $self = shift; return 'push @_, "'.$self->value."\";\n"}
    sub as_deferred {my $self = shift; return ' "'.quotemeta($self->value).'" '}
    
    package JNumber;
    our @ISA = qw(JType);
    sub as_perl { my $self = shift; return 'push @_, '.$self->value.";\n"}
    sub as_deferred {my $self = shift; return ' '.$self->value.' '}
    
    package JSymbol;
    our @ISA = qw(JType);
    sub as_perl { my $self = shift; return '&'.$self->{value}.";\n";}
    sub as_deferred {my $self=shift; return ' "'.quotemeta($self->value).'" '}
    
    package JList;
    use Data::Dumper;
    our @ISA = qw(JType);
    sub as_deferred { my $self = shift; return $self->as_perl();}
    sub as_perl {my $self=shift; 
      my @vals = grep {defined($_)} @{$self->value};
      print "***VAL list is ", Dumper(@vals);
      my @elems = grep {defined($_) || $_} map {$_->as_deferred}   @vals;
      my $elems = 'push @_, ['.join(",", @elems)."];\n";
      print "*** elems is ", Dumper(@elems),"\n\n\n";
                          return $elems;}
