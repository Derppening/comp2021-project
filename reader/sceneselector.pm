package reader;

use strict;
use warnings FATAL => 'all';

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
  my @files = grep(/\.txt$/,readdir($dir));
  closedir $dir;

  print "=============Scene selection=============\n";

  foreach my $file (@files) {
    print $numoffiles . ". " . $file . "\n";
    $numoffiles++;
  }

  print "\nWhich scenes file you would like to open? : ";
  $resp = <STDIN>;
  chomp($resp);
  print "=========================================\n";

  return $files[$resp - 1];
}


1;