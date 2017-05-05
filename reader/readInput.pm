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
# arg2: (Reference of) Hash of section
# arg3: (Reference of) Hash of characters
# arg4: (Reference of) Current scene id
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
# arg1: (Reference to) Hash of option in current plot
# arg2: User answer
#
# return: Cooresponding plot number
#
sub goPlot {
  my %option = %{$_[0]};
  my $myAns = $_[1];
  my $result = 0;
  
  if (exists($option{$myAns})) {
    $result = $option{$myAns};
  } elsif ($myAns eq 'q') {
    $result = 0;
  } else {
    # The user input does not match with any options in this plot
    $result = -1;
  }
  
  return $result;
}


1;