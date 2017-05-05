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

# Choose which scene/savefile to load from
#
# return: Hash of load data
#
sub SceneSelector {
  my $resp = "";
  my $numoffiles = 0;

  # read '*.txt' in './', except 'art.txt'
  opendir my $dir, "./" or die "Cannot open directory: $!";
  my @files = grep(/[^art]\.txt$/, readdir($dir));
  closedir $dir;

  system("clear");

  # print gui
  util::PrintAtPos('m', 't', "=== Scene Selection ===");
  util::SetCursorPos('l', 2);
  print "Start a new story from an existing plot: \n\n";
  foreach my $file (@files) {
    print ++$numoffiles . ". " . $file . "\n";
  }
  if (frame::GetSaves()) {
    print "\nOr load from a savefile. (type 'load') \n";
  }
  print "\n(selection): ";

  $resp = <STDIN>;
  chomp($resp);

  my %data = ();
  
  if ($resp eq "load") {
    # load from an existing save
    %data = frame::LoadGame();
    if (!%data) {
      return SceneSelector();
    }
  } elsif ($resp =~ /[\D\s]+/ or $resp eq "") {
    # invalid input: contains non-numeric/input is blank
    print "$resp: Not a valid file number\n";
    sleep(2);
    util::ClearLine();
    
    # recursively call this function until we have a valid input
    return SceneSelector();
  } elsif (int($resp) > $numoffiles || int($resp) < 1) {
    # invalid input: out-of-bounds
    print "$resp: Not a valid file number\n";
    sleep(2);
    util::ClearLine();
    
    # recursively call this function until we have a valid input
    return SceneSelector();
  }

  # %data is not blank implies a savefile is already loaded
  if (!%data) {
    print "=========================================\n";
    $data{'scenefile'} = $files[int($resp - 1)];
  }
  return %data;
}


1;