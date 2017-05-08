# creator/editmenu.pm
#
# Manages all menus after loading a scene file in Creator Mode
#

package creator;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use creator::charmenu;
use creator::plotmenu;
use reader::import;
use util::die;

# Menu after loading a file in Creator Mode
#
# arg1: Filename to a scene file
#
sub EditMenu {
    if (scalar(@_) != 1) {
        util::DieArgs("creator::EditMenu()", 1, scalar(@_));
    }
    
    my $filename = $_[0];
    if ($_[0] eq "") {
        # empty filename: prompt user
        util::SetCursorPos('l', 'bb');
        print "Enter file name to read from: ";
        $filename = <STDIN>;
        chomp($filename);
    }
    
    # check if the file exists and is valid, output a message if it's not okay
    if (!(open(my $flecheck, '<:encoding(UTF-8)', $filename))) {
        util::PrintAtPos('l', 'b', "Cannot read from $filename: $!");
        sleep(2);
        util::SetCursorPos('l', 'b');
        util::ClearLine();
        
        return;
    } elsif ($filename eq "art.txt") {
        util::PrintAtPos('l', 'b', "Cannot read from art file");
        sleep(2);
        util::SetCursorPos('l', 'b');
        util::ClearLine();
        
        return;
    }
    
    system("clear");
    
    # inflate the scene file
    my %section;
    my @file = reader::Import($filename, \%section);
    my %chars = reader::ImportChars(\@file, \%section);
    
    while (1) {
        # print gui
        util::PrintAtPos('m', 't', "=== Creator Mode: Loaded $filename ===");
        util::PrintAtPos('l', 2, "char: Enter characters menu");
        util::PrintAtPos('l', 3, "plot: Enter plot menu");
        util::PrintAtPos('l', 4, "edit: Edit file in vim");
        util::PrintAtPos('l', 6, "quit: Quit to main menu");
        
        util::SetCursorPos('l', "bb");
        util::ClearLine();
        util::SetCursorPos('l', "bb");
        print ": ";
        
        my $resp = "";
        $resp = <STDIN>;
        chomp($resp);
        
        if ($resp eq "quit") {
            system("clear");
            last;
        } elsif ($resp eq "char") {
            system("clear");
            CharsMenu(\%chars);
            system("clear");
        } elsif ($resp eq "plot") {
            system("clear");
            PlotMenu(\@file, \%section, \%chars, $filename);
            system("clear");
        } elsif ($resp eq "edit") {
            # edit file in vim
            my $command = "vim ".$filename;
            system($command);
            
            util::SetCursorPos('l', "bb");
            print "Do you want to reload the file? (y/n) ";
            my $rl_ans = <STDIN>;
            chomp($rl_ans);
            
            if ($rl_ans eq 'y') {
                # reinflate the scene
                @file = reader::Import($filename, \%section);
                %chars = reader::ImportChars(\@file, \%section);
                
                util::SetCursorPos('l', "bb");
                util::ClearLine();
                util::PrintAtPos('l', "bb", "File successfully reloaded");
                util::PrintAtPos('l', 'b', "Press <ENTER> to continue...");
                <STDIN>;
                util::SetCursorPos('l', 'b');
                util::ClearLine();
            }
        } else {
            # not valid
            util::SetCursorPos('l', "b");
            print "$resp: Invalid option";
            sleep(2);
            util::SetCursorPos('l', "b");
            util::ClearLine();
        }
    }
}

1;