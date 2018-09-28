#!/bin/perl

use strict;
require "./dataJam.pl";

my $classes = ["ALIAS","BASEBOARD","BIOS","BOOTCONFIG","CDROM","COMPUTERSYSTEM","CPU","CSPRODUCT","DATAFILE","DCOMAPP","DESKTOP","DESKTOPMONITOR","DEVICEMEMORYADDRESS","DISKDRIVE","DISKQUOTA","DMACHANNEL","ENVIRONMENT","FSDIR","GROUP","IDECONTROLLER","IRQ","JOB","LOADORDER","LOGICALDISK","LOGON","MEMCACHE","MEMORYCHIP","MEMPHYSICAL","NETCLIENT","NETLOGIN","NETPROTOCOL","NETUSE","NIC","NICCONFIG","NTDOMAIN","NTEVENT","NTEVENTLOG","ONBOARDDEVICE","OS","PAGEFILE","PAGEFILESET","PARTITION","PORT","PORTCONNECTOR","PRINTER","PRINTERCONFIG","PRINTJOB","PROCESS","PRODUCT","QFE","QUOTASETTING","RDACCOUNT","RDNIC","RDPERMISSIONS","RDTOGGLE","RECOVEROS","REGISTRY","SCSICONTROLLER","SERVER","SERVICE","SHADOWCOPY","SHADOWSTORAGE","SHARE","SOFTWAREELEMENT","SOFTWAREFEATURE","SOUNDDEV","STARTUP","SYSACCOUNT","SYSDRIVER","SYSTEMENCLOSURE","SYSTEMSLOT","TAPEDRIVE","TEMPERATURE","TIMEZONE","UPS","USERACCOUNT","VOLTAGE","VOLUME","VOLUMEQUOTASETTING","VOLUMEUSERQUOTA","WMISET"];

sub convertWMIC{
	my @wmic = @_;
	my $deets = {};
	my $table = [];
	for my $l (@wmic) {
		chomp $l;
		$l =~ s/\w$//g;
		if ( $l =~ /^\s+$/) {
			if (keys %$deets > 0 ) {
				push @$table, $deets;
				$deets = {};
			}
			next;
		}
		my ($key, $val) = split /=/,$l,2;
		chomp $val;
		$deets->{$key} = $val;
	};
	$table;
}
for my $t (["Processes", "process"], ["Programs","product"], ["Services","service"], ["Startup","startup"] ) {
	#DataJam::AoH2Table($t->[0], convertWMIC(`wmic $t->[1] list full`));
}

for my $t (@$classes) {
	DataJam::AoH2Table('t_'.$t, convertWMIC(`wmic $t list full`));
}
