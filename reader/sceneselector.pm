package reader;

use strict;
use warnings 'FATAL' => 'all';

use lib qw(..);

use util::die;
use Data::Dumper;

# Choose to read which files
#
# return: filename
#
sub SceneSelector {
  #  my $dir = "./";
  #  my @files = glob( $dir . '/*.txt' );
  my $resp = "";
  my $numoffiles = 1;

  opendir my $dir, "./" or die "Cannot open directory: $!";
  my @files = grep(/\.txt$/, readdir($dir));
  closedir $dir;

  system("clear");

  print "=============Scene selection=============\n";

  foreach my $file (@files) {
    if ($file eq "art.txt") {
      next;
    }
    print $numoffiles++ . ". " . $file . "\n";
  }

  print "\nWhich scene file would you like to open? ";
  $resp = <STDIN>;
  chomp($resp);

  if ($resp =~ /\D/) {
    print "$resp: Not a valid file number";
    sleep(2);
    util::ClearLine();
    return SceneSelector();
  } elsif (int($resp) >= $numoffiles) {
    print "$resp: Not a valid file number";
    sleep(2);
    util::ClearLine();
    return SceneSelector();
  }

  print "=========================================\n";

  return $files[$resp];
}


1;