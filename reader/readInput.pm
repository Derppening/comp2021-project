# reader/readInput.pm
#
# Interfaces between the base game and the plot reading functionality.
#

package reader;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use util::die;
use reader::import;

# Read input from users and return options hash table
#
# arg1: (Reference of) File content array
# arg2: Hash of section
# arg3: Hash of characters
# arg4: Current scene id
#
# return: Hash of option in current plot
#
sub readInput {
  my @file = @{$_[0]};
  my %section = %{$_[1]};
  my %char = %{$_[2]};
  my $sceneId = $_[3];
  my $sceneText = "";
  my %option = ReadPlot(\@file, \%section, \%char, $sceneId);
  
  return %option;
}

# Return the plot number according to the options
#
# arg1: Hash of option in current plot
# arg2: User answer
#
# return: Cooresponding plot number
sub goPlot {
  my %option = %{$_[0]};
  my $myAns = $_[1];
  my $result = 0;
  
  if (exists($option{$myAns})) {
    $result = $option{$myAns};
  } elsif ($myAns eq 'q') {
    $result = 0;
  } else {
    # The user input is not match with any options in this plot
    $result = -1;
  }
  
  return $result;
}


1;