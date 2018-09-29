#!/usr/bin/perl

use strict;
use JSON;
use LWP::Simple;
use Data::Dumper;
require './dataJam.pl';
use LWP::Simple;
$|++;

use XML::Simple qw(:strict);
my $site = shift;
my $base = ($site =~ /^(.*)\$/);
print "Downloading data from site: $site\n";
my $str = get($site);
        my $ref = XMLin($str, KeyAttr =>[],ForceArray => ['Schema', 'EntityType']);
	foreach my $schema ( @{$ref->{"edmx:DataServices"}->{Schema}}) {
		#print Dumper $schema;
		foreach my $entity ( @{$schema->{EntityType}}) {
			my $name = $entity->{Name};
			next if ($name =~ /Thing/);
			my $url = "https://api.parliament.uk/odata/$name";
			print $url."\n";
			loadEntity($name, $url);
		}
	}
	exit;


sub loadEntity {
	my $tablename = shift;
	my $url = shift;
	print "Loading $tablename from $url\n";

	my $str = get($url);

	my $data = eval {decode_json($str)};
	return unless $data;
	my @value = @{$data->{value}};
	my @httpdump;

	sub clean {
		my $v = shift;
		return $v unless $v;
		return $v unless ref($v);
		#print Dumper $v;
		#print "***".ref($v)."***\n";
		if (ref($v) eq 'SCALAR') {
			return $v
		}
		if (ref($v) eq 'ARRAY') {
			if (@$v==0) {
				return undef;
			}
			if (@$v==1) {
				return $v->[0];
			}
		}
		return encode_json($v);
	}

	my @out;
	foreach my $row (@value) {
		my $newrow;
		foreach my $key (keys %$row) {
			$newrow->{$key} = clean($row->{$key});	
			my $v = $newrow->{$key};
			if ($v =~ /^http/) {
				print "Downloading $v";
				my $str = get($v);
				#print "Got: $str";
				push @httpdump, {url => $v, data =>$str, type => 'text/html'};
			}
		}
		#print Dumper $newrow;
		push @out, $newrow;
	}

	print "Loading ".scalar(@out)." rows into $tablename\n";
	DataJam::AoH2Table($tablename, \@out, "DROP");
	DataJam::AoH2Table("UrlStore", \@httpdump);
	DataJam::AoH2Table("ImportLog", [{Name=>$tablename, Url=>$url}]);
}



