package reader;

#use strict;
#use warnings FATAL => 'all';

use lib qw(..);

use Data::Dumper;
use util::die;
use reader::import;

# Read input from users
#
# var1: (Reference of) File content array
# var2: Hash of section
# var3: Hash of characters
# var4: Current scene id
#
# return: Hash of option in current plot
#
#$sceneText = reader::import::??(\@file,$playerAns,$sceneInd); # Something like this
  sub readInput { 
    my @file = @{$_[0]};
    my %section = %{$_[1]};
    my %char = %{$_[2]};
    my $sceneId = $_[3];
    my $sceneText = "";
    my %option = ReadPlot(\@file, \%section, \%char, $sceneId);

    #print Dumper(\%option);

    return %option;
  }

# Return the plot number according to the options
#
# var1: Hash of option in current plot
# var2: User answer
#
# return: Cooresponding plot number
  sub goPlot {
    my %option = %{$_[0]};
    my $myAns = $_[1];
    my $result = 0;

    if(exists($option{$myAns})) {
        $result = $option{$myAns};
    } 
    else {
        # The user input is not match with any options in this plot
        print "Invalid option, Please input again\n";
        $result = -1;
    }

    return $result;
  }


1;