# util/die.pm
#
# Provides user-friendly messages when dying
#

package util;

use strict;
use warnings FATAL => 'all';

# Outputs a dying message due to incorrect number of args
#
# arg1: Function name
# arg2: Expected num of args
# arg3: Given num of args (usually scalar(@_))
#
sub DieArgs {
  die $_[0], ": Incorrect number of arguments. Expected ", $_[1], ", got ", $_[2], ".\n";
}

# Outputs a dying message due to file opening
#
# arg1: Function name
# arg2: Filename
# arg3: Error (usually $!)
#
sub DieOpenFile {
  die $_[0], ": Cannot open file ", $_[1], ": ", $_[2], ".\n";
}

# Outputs a dying message due to directory opening
#
# arg1: Function name
# arg2: Directory opening
# arg3: Error (usually $!)
#
sub DieOpenDir {
  die $_[0], ": Cannot open directory ", $_[1], ": ", $_[2], ".\n";
}

1;