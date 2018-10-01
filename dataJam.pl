package DataJam;

use strict;
use Data::Dumper;
use DBI;
use Digest::MD5 qw(md5 md5_hex md5_base64);
my $uuid_num = 1;

sub uuid {
    return $uuid_num++;
}

my $cmd = shift;

my $home = $ENV{"HOME"} || $ENV{"HOMEPATH"};
my $dir = $home . "/myData";
mkdir($dir);

my $file = $dir . "/default.sqlite";
print "Using db file $file\n";
unless (-e $file) {
    print "Can't find database file $file!\n";
}
my $dbh = DBI->connect("dbi:SQLite:dbname=$file","","");
if (!$dbh) {
    print "Could not open $file\n";
    exit(1);
}

#sub link {
    #my $col = pop @_;
    #my @tables = @_;
#
    #my @tableNames=();
    #my @tableBits=();
    #foreach (@tables) {
        #my $tname = uuid();
        #push @tableBits, $_."AS ".$tname." ";
        #push @tableNames, $tname;
    #}
    #my $q = join(" JOIN ", @tableBits);
    #$q .= " ON $tableNames[0] = $tableNames[1] ";
    #return $q;
#}

sub make_table_name {
    return "table_".uuid();
    #my $input = shift;
    #return md5_hex($input);
}

#Puts an Array of Hashes into a new table
#
#The column names are taken from the keys of the first hash in the array
#
#Returns:  The table name
sub AoH2Table {
    my $timestamp = time();
    my $add_timestamp = 0;
       my $table_name = shift;
    my $AoH = shift;
    return unless @$AoH;
    my @options = @_;
    if (grep (/^DROP$/, @options)) {
	print "Dropping table $table_name\n";
        $dbh->do("DROP TABLE IF EXISTS $table_name");
}
    if (!$AoH->[0]->{imported}) {
    	$add_timestamp=1;
	$AoH->[0]->{imported} = $timestamp;
    }
    my %headers;
    foreach my $h (@$AoH) {
  	my @keys = keys %$h;
	$headers{$_}++ foreach @keys;
	}
	my @headers = keys %headers;
    my $numCols = @headers;
    my $cmd = "CREATE TABLE IF NOT EXISTS $table_name ( ".makeHeaderDecls(@headers).makeIndexDecls(@headers)  ." )\n";
    print "Creating table: ".$cmd."\n";
    $dbh->do($cmd);
	my $headerqry = '"'.join('","', @headers).'"';
        my $interp = join(",", ("?")x$numCols);
	my $cmd = "INSERT INTO $table_name ($headerqry) VALUES($interp);";
        my $sth = $dbh->prepare($cmd);
    foreach my $h ( @$AoH) {
	$h->{imported} = $timestamp if $add_timestamp;
	my %h = (%$h);
        my @vals = @h{@headers};
	#print $cmd;
            $sth->execute(@vals);
        }
    return $table_name;
}


#sub dateRange {
#use Date::Simple qw/date/;
#use Date::Range;
#my ( $start, $end ) = @_;
#my $range = Date::Range->new( $start, $end );
#my @all_dates = $range->dates;
#
#return oneColTable(@all_dates);
#}

my $default_sql = q!
! ;

my $sql = $cmd || $default_sql;

#Get a list of installed cpan modules
#SELECT * FROM -[multiColSpaceTable([qw/name version/],`ssh -A server.com "cpan -l"`)]- ;
#Select all processes with more than 0.05%
#SELECT * FROM -[multiColSpaceHeaderTable(`ps auxwww`)]- where percentMEM>0.05;
#Select all files from a directory
#SELECT * FROM -[multiColSpaceTable([qw/perms something userid groupid size month day year name/], `ls -nl | tail -n +2`)]- ;
#
#SELECT DISTINCT A.data FROM -[oneColTable(`ls`)]- AS A  JOIN -[oneColTable(`ls *pl`) ]- AS B ON A.data = B.data ;
#SELECT data FROM -[dateRange('2016-10-01', '2016-10-16')]-;
sub oneColTable {
    my @res = @_;
    my $table_name = make_table_name();
    $dbh->do("CREATE TABLE IF NOT EXISTS $table_name ( data NUMERIC )");
    my $sth = $dbh->prepare("INSERT INTO $table_name (data) VALUES(?);");
    chomp $_ foreach @res;
    $sth->execute($_) foreach @res;
    return $table_name;
}

sub makeHeaderDecls {
    my @cols = @_;
    my $decls = '"'.join('" NUMERIC,"', @cols).'" NUMERIC';
    return $decls;
}

sub makeIndexDecls {
    my @cols = @_;
    my $d = '"'.join('","', @cols).'"';
    my $decls = ",\nPRIMARY KEY (".$d.")\n";
    return $decls;
}

sub multiColSpaceHeaderTable {
    my @lines = @_;
    chomp $_ foreach @lines;
    my $headerLine = shift @lines;
    $headerLine =~ s/^\s+//g;
    $headerLine =~ s/\%/percent/g;
    $headerLine =~ s/\//_/g;
    my @cols = split /\s+/, $headerLine;
    warn "Found headers @cols\n";
    return multiColSpaceTable(\@cols, @lines);
}

#Mainly used to import from command line apps like ps
#Give it an array of column names, and the lines in text format, and it will break the lines in columns (based on spaces) and put them in a table
sub multiColSpaceTable {
    my $headers = shift;
    my $numCols = scalar(@$headers);
    my $interp = join(",", ("?")x$numCols);
    my @res = @_;
    my $table_name = make_table_name();
    #print "CREATE TABLE IF NOT EXISTS $table_name ( ".makeHeaderDecls(@$headers)." )\n";
    $dbh->do("CREATE TABLE IF NOT EXISTS $table_name ( ".makeHeaderDecls(@$headers)." )");
    #print "INSERT INTO $table_name (".join(",", @$headers)." ) VALUES($interp);\n";
    my $sth = $dbh->prepare("INSERT INTO $table_name (".join(",",@$headers)." ) VALUES($interp);");
    chomp $_ foreach @res;
    foreach (@res) {
        my @cols = split /\s+/, $_, $numCols;
        next unless (scalar(@cols) == $numCols);
        $sth->execute(@cols);
    }
    return $table_name;
}


sub doOneInsert {
    my $sql = shift;
    #print "Processing $sql\n";
    $sql =~ s/-\[(.+?)\]-/PLACEHOLDER/;
    return $sql unless $1;
    #print $sql."\n";
    my $table = eval $1;
    #print $@;

    $sql =~ s/PLACEHOLDER/$table/;
    return $sql;
}

my $old_sql = "";
while ($sql ne $old_sql) {
    $old_sql = $sql;
    $sql = doOneInsert($sql);
}
#print $sql."\n";
#my @res = @{$dbh->selectall_arrayref($sql)};
#print(join(",", @$_)."\n") foreach @res;
1;
