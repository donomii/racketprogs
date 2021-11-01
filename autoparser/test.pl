use strict; #ALWAYS!
use warnings; #ALWAYS!
use File::Find;

use File::Slurp;
use Data::Dumper;

sub tokenise {
    split /\s+/, join(" ", @_);
}
my $count=0;
my $countTok;
sub processFile {
    return unless $_;
    return if -d $_;
    return unless /\.go$/;
    print $_."\n";
   my @toks =  tokenise(read_file($_));

    while (my ($index, $elem) = each @toks) {
    $countTok->[$index]{$elem}++;
    
}
    if ($count++>1001 )    {print Dumper($countTok);$count=0}
}
find(\&processFile,"/Users/jeremyprice/go");

print Dumper($countTok);
