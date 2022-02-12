#!/usr/bin/perl
#
# ./json-source | perl json.pl tablename
#
# e.g. ./imap imap.gmail.com:993 username@gmail.com password | perl json.pl emails

use strict;
use lib ".";
use JSON;
use LWP::Simple;
use Data::Dumper;
use DataLib;
use LWP::Simple;
$|++;
my $tablename = shift;
die "Tablename required!" unless $tablename;
my $str = join("", <STDIN>);
my $data = decode_json($str);
my @httpdump;

#use Data::Dumper;
loadEntity($tablename, $data);

	DataLib::AoH2Table("UrlStore", \@httpdump);
	DataLib::AoH2Table("ImportLog", [{Name=>$tablename, Url=>""}]);

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
		if (!ref($v)) {
			return $v
		}
		if (ref($v) eq 'JSON::PP::Boolean') {
			return $v
		}
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
	DataLib::AoH2Table($tablename, \@out, "DROP");
}



