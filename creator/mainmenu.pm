package creator;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use creator::editmenu;
use util::die;
use util::terminal;

sub MainMenu {
  if (scalar(@_) != 1) {
    util::DieArgs("creator::MainMenu()", 1, scalar(@_));
  }
  
  system("clear");
  
  while (1) {
    util::PrintAtPos("m", 't', "=== Creator Mode: Main Menu ===");
    util::PrintAtPos('l', 2, "load [FILE]: Load file");
    util::PrintAtPos('l', 4, "quit: Quit");
    util::SetCursorPos('l', "bb");
    util::ClearLine();
    util::SetCursorPos('l', "bb");
    print ": ";
  
    my $resp = "";
    $resp = <STDIN>;
    chomp($resp);
    
    if ($resp eq "quit") {
      last;
    } elsif ((substr $resp, 0, 4) eq "load") {
      my $filename = "";
      if (length $resp < 5) {
        $filename = $_[0];
      } else {
        $filename = substr $resp, 5;
      }
      system("clear");
      EditMenu($filename);
      system("clear");
    } else {
      util::SetCursorPos('l', "b");
      print "$resp: Invalid option";
      sleep(2);
      util::SetCursorPos('l', "b");
      util::ClearLine();
    }
  }
}

1;