use Paws;
use Storable qw/dclone/;
use Data::Dumper;
use JSON;
use Data::Structure::Util qw(
  has_utf8 utf8_off utf8_on unbless get_blessed get_refs
  has_circular_ref circular_off signature
);
require "./DataLib.pm";
use strict;

my $dynamodb = Paws->service( 'DynamoDB', region => "eu-west-1" );
my $table = shift;
chomp $table;

#Get data from dynamoDB

print "Scanning table '$table'\n";
my @t;
my $QueryOutput = $dynamodb->Scan(
    'TableName' => $table,
    'Limit'     => 1000
);
my $qo = dclone($QueryOutput);
unbless($qo);
ProcessQuery($qo);

#while (my $last =  $QueryOutput->{LastEvaluatedKey}) {
#$QueryOutput = $dynamodb->Scan('TableName' => $table, ExclusiveStartKey=>$last);
#my $qo = dclone($QueryOutput);
#unbless($qo);
#ProcessQuery($qo);
#warn "Fetching more...\n";
#}

sub ProcessQuery {
    my $QueryOutput = shift;
    foreach my $item ( $QueryOutput->{Items} ) {
        foreach my $i (@$item) {

            my $data = encode_json( $i->{Map} ) . "\n";
            my %n;
            my $m = $i->{Map};
            foreach my $key ( keys %$m ) {
                $n{$key} = encode_json( [ $m->{$key} ] );
            }
            push @t, \%n;
        }
    }
}

my $tname = $table;
$tname =~ s/\./_/g;
DataLib::AoH2Table( $tname, \@t, "DROP", "DEAMAZONIFY" );
exit 0;

#print "Query: ";
#my $QueryOutput = $dynamodb->Query(
#'TableName'              => $table
#);
#print Dumper($QueryOutput);
#
#
#my $GetItemOutput = $dynamodb->GetItem(
#'TableName' => 'Testing'
#);
#
#print "Get item:";
#print Dumper($GetItemOutput);
