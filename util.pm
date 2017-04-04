package util;

use strict;
use warnings FATAL => 'all';

# Outputs a dying message due to incorrect number of args
#
# var1: Function name
# var2: Expected num of args
# var3: Given num of args (usually scalar(@_))
#
sub DieArgs {
  die $_[0], ": Incorrect number of arguments. Expected ", $_[1], ", got ", $_[2], ".\n";
}

# Outputs a dying message due to file opening
#
# var1: Function name
# var2: Filename
# var3: Error (usually $!)
#
sub DieOpenFile {
  die $_[0], ": Cannot open file ", $_[1], ": ", $_[2], ".\n";
}

1;