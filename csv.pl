#!/usr/bin/perl

use strict;

use Text::CSV;
use Data::Dumper;
require "./DataJam.pl";
 
my $tablename = shift;

$tablename || die "Please provide tablename";

my @rows;
my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
                or die "Cannot use CSV: ".Text::CSV->error_diag ();
	 
	my @columns = $csv->getline( *STDIN );
	$csv->column_names(@columns);
	while ( my $row = $csv->getline_hr( *STDIN ) ) {
		        push @rows, $row;
		}
		$csv->eof or $csv->error_diag();

DataJam::AoH2Table($tablename, \@rows, "DROP");
DataJam::AoH2Table("ImportLog",[{Name=>$tablename, Url=>""}]);
