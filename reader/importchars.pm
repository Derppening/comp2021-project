# reader/importchars.pm
#
# Manages the importing of characters for a scene file.
#

package reader;

use strict;
use warnings FATAL => 'all';

# Imports character names into a hash
#
# arg1: (Reference of) File contents array
# arg2: (Reference of) Sections hash
#
# return: Hash of characters
#
sub ImportChars {
    if (scalar(@_) != 2) {
        util::DieArgs("reader::ImportChars()", 2, scalar(@_));
    }
    
    my @file = @{$_[0]};
    my %sections = %{$_[1]};
    
    # write character names into a hash
    my %chars;
    for (my $i = $sections{'characters'} + 1, my $j = 1; ; ++$i) {
        my $s = $file[$i];
        if ($s =~ /^\[.+\]$/) {  # end of character section
            last;
        } elsif ($s =~ /^#.*/) {  # "# ..." is a comment. ignore
            next;
        }
        $chars{$j++} = $s if ($s ne "");  # ignore all empty lines
    }
    
    return %chars;
}

1;