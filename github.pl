#!/usr/bin/perl

use strict;

use Net::GitHub;
require "./DataJam.pl";
use JSON;
sub dt {
	my $key = shift;
	my $valkey = shift;
	my $val	 = DataJam::get_config($key);
	print Dumper($val);
	if ($val) {
		return $val->{$valkey};
	}
	return undef;
}


my $gh = Net::GitHub->new( version => 3, login => dt(qw/github username/), pass => dt(qw/github password/));

my @myrepos = $gh->repos->list;
use Data::Dumper;
#print Dumper @repos;
DataJam::AoH2Table("MyRepos", \@myrepos, "DROP");


my %data = $gh->search->repositories({
		stars => '>100',
		    q => 'perl',
	sort  => 'stars',
    order => 'desc',
});
DataJam::AoH2Table("PerlGithub",$data{items}, "DROP");
while ($gh->search->has_next_page) {
	    my %more =  $gh->search->next_page;
DataJam::AoH2Table("PerlGithub",$more{items});
	        ## OR ##
		#    push @issues, $gh->issue->next_page;
		    }

