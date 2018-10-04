#!/usr/bin/perl

use strict;

use Net::GitHub;
use lib "./";
use JSON;

use DataLib qw/conf/;

my $gh = Net::GitHub->new( version => 3, login => conf(qw/github username/), pass => conf(qw/github password/));

my @myrepos = $gh->repos->list;
use Data::Dumper;
#print Dumper @repos;
DataLib::AoH2Table("MyRepos", \@myrepos, "DROP");


my %data = $gh->search->repositories({
		stars => '>100',
		    q => 'perl',
	sort  => 'stars',
    order => 'desc',
});
DataLib::AoH2Table("PerlGithub",$data{items}, "DROP");
while ($gh->search->has_next_page) {
	    my %more =  $gh->search->next_page;
DataLib::AoH2Table("PerlGithub",$more{items});
	        ## OR ##
		#    push @issues, $gh->issue->next_page;
		    }

