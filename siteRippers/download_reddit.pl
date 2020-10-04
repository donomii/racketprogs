use strict;
use POSIX qw(floor);
 # Create a user agent object
  use LWP::UserAgent;
  my $ua = LWP::UserAgent->new;
  $ua->agent("MyApp/0.1 ");
my $start = shift;

  # Create a request
  sub download {
  my $index = shift;
  my $req = HTTP::Request->new(GET => 'http://www.reddit.com/comments/'.$index.'.json');
  #$req->content_type('application/x-www-form-urlencoded');
  #$req->content('query=libwww-perl&mode=dist');

  # Pass request to the user agent and get a response back
  my $res = $ua->request($req);

  # Check the outcome of the response
  if ($res->is_success) {
      open FH , ">", $index.'.json';
      print FH $res->content;
      close FH;
  }
  else {
      print $res->status_line, "\n";
  }
  }
  
  sub to_base {
  my ($a_num,  $alphabet) = @_;
  #[write a_num][newline]
  if (!  $a_num == 0) {
    if ( $a_num < 0) {die "must supply a positive integer"}
    
          my $l  = length $alphabet;
          my $q = floor ($a_num / $l);
          my $r  = $a_num % $l;
          my $letter  = substr $alphabet, $r,1;
      return to_base($q, $alphabet).$letter;
    }
}

sub search_in_string {
      my $s = shift;
      my $alphabet = shift;
      #print "Looking for $s in $alphabet\n";
      $alphabet =~ m/$s/;
      return $-[0];
  }

sub from_base {
  my ($a_num, $alphabet)=@_;
    #print "$a_num, $alphabet\n";
             my $l    =   length($alphabet);
             my @digits =  split //, $a_num;
#print "@digits\n";
             return 
  eval join "+", map { 
  my $index = $_; 
  $l**$index * search_in_string ( substr(reverse($a_num), $index, 1), $alphabet)} 0 .. (scalar(@digits)-1)
}
                       
  my $alpha = '0123456789abcdefghijklmnopqrstuvwxyz';
  print from_base('a', $alpha);
  print to_base(from_base('abcde', $alpha), $alpha);
  for my $i ( from_base($start,$alpha) .. from_base('zzzzz',$alpha) ) {
  print($i, to_base($i, $alpha),"\n");
  download(to_base($i, $alpha));
  }