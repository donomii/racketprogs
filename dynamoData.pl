use Paws;
use strict;
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
my $limit = 1000;
my $count = 0;
chomp $table;

#Get data from dynamoDB

print "Scanning table '$table'\n";
my @t;
my $QueryOutput = $dynamodb->Scan(
    'TableName' => $table,
    'Limit'     => $limit,
);
my $qo = dclone($QueryOutput);
#unbless($qo);
ProcessQuery($QueryOutput);

#$count += $QueryOutput->Items;

print "Starting loop\n";

sub CleanUpAttribute {
    my $a = shift;
    foreach my $attr (values %$a) {
        foreach my $key ( keys %$attr ) {
            unless (
                    $attr->{$key} eq '0'  ||
                    (!ref($attr->{$key}) && length($attr->{$key}) >0) ||
                    (ref($attr->{$key}) eq 'HASH' && scalar keys %{$$attr->{$key}}) ||
                    (ref($attr->{$key}) eq 'ARRAY' && scalar @{$attr->{$key}})
                    ) { delete $attr->{$key} }
        }
    }
    return $a;
}

while (my $lastObj =  $QueryOutput->LastEvaluatedKey) {
    warn "More to fetch" if ($lastObj);
    my $last = $lastObj->Map;
    CleanUpAttribute($last);
    #print Dumper($last);

    #$count += $QueryOutput->Items;
if($count>$limit) {
    warn "Fetched $count items, exceeded limit $limit";
    last;
}
    $QueryOutput = $dynamodb->Scan('TableName' => $table, Limit => $limit,ExclusiveStartKey=>$last);
    #my $qo = dclone($QueryOutput);
    #unbless($qo);
    ProcessQuery($QueryOutput);
    warn "Fetching more...\n";
}

sub ProcessQuery {
    my $QueryOutput = shift;
    die "Query failed" unless $QueryOutput;
    foreach my $item ( $QueryOutput->Items ) {
        foreach my $i (@$item) {

            unbless($i);
            my $data = encode_json( $i->{Map} ) . "\n";
            my %n;
            my $m = $i->{Map};
            foreach my $key ( keys %$m ) {
                $n{$key} = encode_json( [ $m->{$key} ] );
            }
            push @t, \%n;
            $count++;
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
