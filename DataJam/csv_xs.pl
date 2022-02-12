#!/usr/bin/perl

use strict;

use Text::CSV_XS qw(csv);
use DataLib;
 
my $tablename = shift;
$tablename || die "Please provide tablename";

my $filename = shift;
$filename || die "Please provide filename";

my $aoh = csv (in => $filename, headers => "auto");

DataLib::AoH2Table($tablename, $aoh, "DROP");
DataLib::AoH2Table("ImportLog",[{Name=>$tablename, Url=>""}]);
