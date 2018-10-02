#!/bin/perl

use strict;
use DBI;
use DBD::mysql;
use Data::Dumper;
require "./DataJam.pl";

my $dbh = DBI->connect("DBI:mysql:database=qa_careem;host=qa-main-db.careem-engineering.com;port=3306", "qa.srv.book.promotion.w2", "qKkzlmJISv6IjhsE");


my $sth = $dbh->prepare("SELECT Table_Name, Column_Name, Is_Nullable, Table_Schema, Data_Type FROM INforMATION_SCHEMA.CoLuMNS");
$sth->execute();
my @out;
while (my $ref = $sth->fetchrow_hashref()) {
    #print Dumper $ref;
    push @out, $ref;
    #print "Found a row: id = $ref->{'id'}, name = $ref->{'name'}\n";
}
DataJam::AoH2Table("Mysql", \@out, "DROP");
