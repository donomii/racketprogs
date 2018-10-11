use Paws;
use Data::Dumper;
use JSON;
use Data::Structure::Util qw(
  has_utf8 utf8_off utf8_on unbless get_blessed get_refs
  has_circular_ref circular_off signature
);
require "./DataLib.pm";
use strict;
 



my $dynamodb = Paws->service('DynamoDB', region => "eu-west-1");
my $table = shift;
chomp $table;

#Get data from dynamoDB

print "Scanning table '$table'\n";
my @t;
my $QueryOutput = $dynamodb->Scan(
      'TableName'              => $table,
      #'Limit' => 100
      );
      unbless($QueryOutput);

      foreach my $item ($QueryOutput->{Items}) {
        foreach my $i (@$item) {
            warn Dumper($i);
              my $data =  encode_json($i->{Map})."\n";
              print $data."\n";
              my %n;
              my $m = $i->{Map};
              foreach my $key (keys %$m) {
                $n{$key} = encode_json([$m->{$key}]);
              }
              warn Dumper(\%n);
              push @t, \%n; 
          }
      }
      my $tname = $table;
        $tname =~ s/\./_/g;
    DataLib::AoH2Table($tname, \@t, "DROP");
    exit 0 ;

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
