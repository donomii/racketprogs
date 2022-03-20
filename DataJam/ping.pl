#!/usr/bin/perl

use strict;
require "./DataLib.pm";

#字节=32 时间=107ms TTL=54

while (1) {
	my $server = "entirety.praeceptamachinae.com";
	my $output = join("", `ping -n 1 $server`);

	if ($output =~ m/=(\d+)[^=]+=(\d+)[^=]+=(\d+)/) {
		my ($hops, $time, $ttl) =  ($1, $2, $3);
		#print "Hops: $hops, time: $time, ttl: $ttl\n";
		DataLib::AoH2Table("PraecepConnectivity", [{server => $server, hops => $hops, time => $time, ttl=>$ttl, connected=>1}])
	} else {
		DataLib::AoH2Table("PraecepConnectivity", [{server => $server, hops => -1, time => -1, ttl=>-1, connected=>0}])
	}
	sleep 1;
}

