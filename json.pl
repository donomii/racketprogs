#!/usr/bin/perl

use strict;
use JSON;
use LWP::Simple;
use Data::Dumper;
require './dataJam.pl';
use LWP::Simple;
$|++;
my $tablename = shift;
my $str = join("", <STDIN>);
my $data = eval {decode_json($str)};
my @httpdump;

loadEntity($tablename, $data);

	DataJam::AoH2Table("UrlStore", \@httpdump);
	DataJam::AoH2Table("ImportLog", [{Name=>$tablename, Url=>""}]);
sub loadEntity {
	my $tablename = shift;
	my $str = shift;
	return unless $data;
	my @value = @$data;
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
}



