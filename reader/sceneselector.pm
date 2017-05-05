# reader/sceneselector.pm
#
# Provides a GUI for the user to choose which scene or savefile they want
# to load from.
#

package reader;

use strict;
use warnings 'FATAL' => 'all';

use lib qw(..);

use frame::gameHandler;
use util::die;

# Choose to read which files
#
# return: filename
#
sub SceneSelector {
  #  my $dir = "./";
  #  my @files = glob( $dir . '/*.txt' );
  my $resp = "";
  my $numoffiles = 0;

  opendir my $dir, "./" or die "Cannot open directory: $!";
  my @files = grep(/[^art]\.txt$/, readdir($dir));
  closedir $dir;

  system("clear");

  util::PrintAtPos('m', 't', "=== Scene Selection ===");

  util::SetCursorPos('l', 2);
  print "Start a new story from an existing plot: \n\n";

  foreach my $file (@files) {
    print ++$numoffiles . ". " . $file . "\n";
  }

  my @saves = frame::gameHandler::GetSaves();

  if (@saves) {
    print "\nOr load from a savefile. (type 'load') \n";
  }

  print "\n(selection): ";

  $resp = <STDIN>;
  chomp($resp);

  my %data = ();

  if ($resp eq "load") {
    %data = frame::gameHandler::LoadGame();
  } elsif ($resp =~ /[\D\s]+/ or $resp eq "") {
    print "$resp: Not a valid file number\n";
    sleep(2);
    util::ClearLine();
    return SceneSelector();
  } elsif (int($resp) > $numoffiles || int($resp) < 1) {
    print "$resp: Not a valid file number\n";
    sleep(2);
    util::ClearLine();
    return SceneSelector();
  }

  if (!%data) {
    print "=========================================\n";
    $data{'scenefile'} = $files[int($resp - 1)];
  }
  return %data;
}


1;