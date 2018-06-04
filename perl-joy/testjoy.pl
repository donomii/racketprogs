use lib ".";
use Joy;
use strict;

#@_ = ( "X", "Y", "Z");

joy( rollup  "Z" "Y" "X" "A" "A" "A");
print "Final stack is: ", join(",",reverse(@_)),"\n";
joy( rolldown  "Z" "Y" "X" "A" "A" "A");
print "Final stack is: ", join(",",reverse(@_)),"\n";
joy( rotate  "Z" "Y" "X" "A" "A" "A");
print "Final stack is: ", join(",",reverse(@_)),"\n";
joy( dupd  "Z" "Y" "X" "A" "A" "A");
print "Final stack is: ", join(",",reverse(@_)),"\n";
#joy(dip "X" [dup] "Y" "Z" "A" "A" "A");

sub dup         { push @_, $_[-1];}
sub Swap      {my @temp; push @temp, pop @_;push @temp, pop @_;push @_, @temp}
sub id            {}
sub rollup      {my @temp; for (1..3) {push @temp, pop @_;}push @_, $temp[0];push@_,$temp[2];push@_,$temp[1];}
sub rolldown      {&rollup;&rollup;}
sub rotate      {&Swap; &rollup;&rollup;}
sub i           {my @func = @{pop @_}; my $prog = '&'.join("; &", @func).';'; eval $prog;}
sub x           {my @func = $_[-1]; my $prog = '&'.join("; &", @func).';'; eval $prog;}
sub dupd      {push @_, ["dup"]; &dip}

sub dip       {&Swap; my $temp = pop @_;  &i ; push @_, $temp;}


  
