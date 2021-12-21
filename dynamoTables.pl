use Paws;
use Data::Dumper;
require "./DataLib.pm";
use strict;
 
my $dynamodb = Paws->service('DynamoDB', region => "eu-west-1");
my $ListGlobalTablesOutput = $dynamodb->ListGlobalTables(
);

my $GlobalTables = $ListGlobalTablesOutput->GlobalTables;

#print "Global Tables:\n";
#print Dumper($GlobalTables);

my $ListTablesOutput = $dynamodb->ListTables();

#print "Local Tables:\n";
my $TN = $ListTablesOutput->TableNames;

my $TableNames = [];
#print Dumper($TN);
push @$TableNames, @$TN ;

while (my $last =  $ListTablesOutput->{LastEvaluatedTableName}) {   
    $ListTablesOutput = $dynamodb->ListTables(ExclusiveStartTableName=>$last);
    my $TN = $ListTablesOutput->TableNames;
    #print Dumper($TN);
    push @$TableNames, @$TN ;
}

my @t = map { { TableName => $_ } } @$TableNames;
#DataLib::AoH2Table("DynamoDbNames", \@t);

my $TableDeets = [];
foreach my $table (@$TableNames) {
    #next unless ($table =~ /Script/);
    my $DescribeTableOutput = $dynamodb->DescribeTable(
        'TableName' => $table
    );
     
# Results:
    print "Table details:";
    my $Table = $DescribeTableOutput->Table;
    #print Dumper($Table);
    print "Table: ", $Table->TableName,"\n";
    print "Table keys: ";

    foreach my $item (@{$Table->AttributeDefinitions}) {
        print  $item->AttributeName, ",";
    }
    print "\n";


    print "Scan: ".$Table->TableName."\n";
    my $ScanOutput = $dynamodb->Scan(
        Limit => 10,
        TableName            => $table
    );


foreach my $item (@{$ScanOutput->Items}){
    my $i = $item->Map;
    foreach my $key (keys %$i) {
        my $deets = {};
        $deets->{ColumnName}=$key;
        $deets->{TableName} = $table;
        push @$TableDeets, $deets;
        #print " ",$key, ":", ($i->{$key}{'S'}||$i->{$key}{'N'}), " ";
    }
    #print "\n";

}
print "\n";
}

DataLib::AoH2Table("DynamoDbDetails", $TableDeets);
