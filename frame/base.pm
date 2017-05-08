# frame/base.pm
#
# Manages the general gameplay.
#

package frame;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use reader::import;
use reader::readInput;

# Displays the welcoming text
#
# Note: In frame::base::scene(), this method is reused to display help text
#
# arg1: (Optional:) Only display help text
#
sub welcome {
    if (scalar(@_) != 0 && scalar(@_) != 1) {
        util::DieArgs("frame::welcome()", "<2", scalar(@_));
    }
    if (!exists $_[0]) {
        print "Welcome to the game. ";
    } else {
        util::PrintAtPos("m", "t", "=== Help ===");
        util::SetCursorPos("l", 2);
    }
    print "Select your choice by typing an option. \n\n";
    print "Type '_save' to save the game any time.\n";
    print "Type 'q' to quit the game. \n\n";
    
    print "Type '_help' to show this help again.\n";
    
    util::PrintAtPos('l', 'b', "Press <ENTER> to continue...");
    util::SetCursorPos('r', 'b');
    <STDIN>;
    system("clear");
}

# Displays a scene, reads user input, and invokes the next scene
#
# arg1: (Reference to) file contents array
# arg2: (Reference to) plot header hash
# arg3: (Reference to) characters hash
# arg4: (Reference to) data hash
#
sub scene {
    if (scalar(@_) != 4) {
        util::DieArgs("frame::scene()", 4, scalar(@_));
    }
    
    my @file = @{$_[0]};
    my %section = %{$_[1]};
    my %char = %{$_[2]};
    my %data = %{$_[3]};
    
    my $playerAns = "";
    my %opinion = ();
    my $sceneInd = 1;
    
    $sceneInd = int($data{'scene'}) if exists $data{'scene'};
    
    while(lc($playerAns) ne "q"){
        system("clear");
        
        # read and display the plot text
        util::SetCursorPos('l', 1);
        %opinion = reader::readInput(\@file, \%section, \%char, $sceneInd);
        
        util::SetCursorPos('l', 'b');
        util::ClearLine();
        util::SetCursorPos('l', 'bb');
        util::ClearLine();
        util::SetCursorPos('l', "bb");
        print ": ";
        chomp($playerAns = <STDIN>);
        
        # read the option...
        if ($playerAns eq "_save") {
            $data{'scene'} = $sceneInd;
            if (SaveGame(\%data) == 0) {
                util::SetCursorPos('l', 5);
                util::ClearLine();
                print "Game successfully saved";
                sleep(2);
            }
            next;
        } elsif ($playerAns eq "_help") {
            system("clear");
            welcome(0);
            next;
        }
        
        # not a command: analyze using goPlot(...)
        my $plot_res = reader::goPlot(\%opinion, $playerAns);
        if ($plot_res eq - 1) {
            util::SetCursorPos('l', 'b');
            print "$playerAns: Invalid option";
            
            sleep(2);
            next;
        }
        
        # user responded with 'q'
        if ($plot_res eq 0) {
            print "Hope you enjoy the game. Bye :D";
            sleep(2);
            system("clear");
            last;
        }
        
        $sceneInd = $plot_res;
        
        system("clear");
    }
}

1;
