      use PPI;
my $fname = <STDIN>;
chomp $fname;

sub quote {
	s!\r!!g;
	s!\\!\\\\!g;
	s/"/\\"/g;
	return $_;
}

my %visited = ();

sub extract_subs {
      my $fname = shift;
      my $no_recurse = shift;
      # Load a document from a file
      my $Document = PPI::Document->new($fname);

      # Strip out comments
      $Document->prune('PPI::Token::Comment');

      # Find all the named subroutines
      my $sub_nodes = $Document->find(
            sub { $_[1]->isa('PPI::Statement::Sub') and $_[1]->name }
      );
      # Find all the use and require statements
      my $include_nodes = $Document->find(
            sub { $_[1]->isa('PPI::Statement::Include') and $_[1]->module }
      );
	  
      my @sub_names = map { print '("'.$_->name.'" . "'.quote($_->block).'")'."\n"; } @$sub_nodes;
      my @include_names = map {my $mod = $_->module; unless ($visited{$mod}++) {my $text = `perldoc -m $mod`; unless($no_recurse<1){extract_subs(\$text, $no_recurse-1);}} } @$include_nodes;                            
      
      # Save the file
#      $Document->save('My/Module.pm.stripped');
}
      print "(";
     extract_subs($fname,2);
     print ")";