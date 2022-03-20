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
my $limit = 100000000;
my $count = 0;
chomp $table;

#Get data from dynamoDB

warn "Scanning table '$table'\n";
my @t;
my $QueryOutput = $dynamodb->Scan(
    'TableName' => $table,
    'Limit'     => $limit,
);
my $qo = dclone($QueryOutput);
#unbless($qo);
ProcessQuery($QueryOutput);

#$count += $QueryOutput->Items;

warn "Starting loop\n";

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

my $resume = {
          'car_driver_id' => bless( {
                                      'N' => '49676163'
                                    }, 'Paws::DynamoDB::AttributeValue' ),
          'creation_date' => bless( {
                                      'N' => '1511853909194'
                                    }, 'Paws::DynamoDB::AttributeValue' )
        };

while (my $lastObj =  $QueryOutput->LastEvaluatedKey) {
    warn "More to fetch" if ($lastObj);
    my $last = $lastObj->Map;
    if ($resume) {
        $last = $resume;
        $resume = undef;
    }
    CleanUpAttribute($last);
    warn Dumper($last);

    #$total += $QueryOutput->Items;
    warn "Fetched $count items\n";
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

my $headersDumped;
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
            #push @t, \%n;
            $count++;
            my $tname = $table;
            $tname =~ s/\./_/g;
            print $m->{latitude}->{N}, "," , $m->{longitude}->{N}, "\n";
            my $row = DataLib::deAmazonifyHash($m);
            if (!$headersDumped) {
                print join(',', sort keys %$row), "\n";
                $headersDumped++;
            }
            print join(',', map { $row->{$_} } sort keys %$row), "\n";
            #DataLib::AoH2Table( $tname, [\%n], "DEAMAZONIFY" );
            #DataLib::Flush();
        }
    }
}

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
