#!/bin/perl

use strict;
use DBI;
use JSON;
use DBD::mysql;
use Data::Dumper;
use DataLib;
my $deets = DataLib::get_config("mysql");

if (!$deets) {
    die "Could not locate mysql connect details in the private database";
}

my @connect = ("DBI:mysql:database=$deets->{database};host=$deets->{server};port=$deets->{port}", $deets->{username}, $deets->{password});

print "Connecting to: $deets->{database}\n";
my $dbh = DBI->connect(@connect);


my $sth = $dbh->prepare("SELECT Table_Name, Column_Name, Is_Nullable, Table_Schema, Data_Type FROM INforMATION_SCHEMA.CoLuMNS");
$sth->execute();
my @out;
while (my $ref = $sth->fetchrow_hashref()) {
    #print Dumper $ref;
    push @out, $ref;
    #print "Found a row: id = $ref->{'id'}, name = $ref->{'name'}\n";
}
DataLib::AoH2Table("Mysql", \@out, "DROP");
