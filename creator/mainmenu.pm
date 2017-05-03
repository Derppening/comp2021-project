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
    util::PrintAtPos('l', 3, "list [PATH]: List all text files in [PATH]");
    util::PrintAtPos('l', 5, "quit: Quit");
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
      EditMenu($filename);
      system("clear");
    } elsif ((substr $resp, 0, 4) eq "list") {
      my $path = "";
      if (length $resp < 5) {
        $path = ".";
      } else {
        $path = substr $resp, 5;
      }
      ListFiles($path);
    } else {
      util::SetCursorPos('l', "b");
      print "$resp: Invalid option";
      sleep(2);
      util::SetCursorPos('l', "b");
      util::ClearLine();
    }
  }
}

sub ListFiles {
  if (scalar(@_) != 1) {
    util::DieArgs("creator::ListFiles()", 1, scalar(@_));
  }

  my $path = $_[0];

  my $dir;
  if (!(opendir $dir, $path)) {
    util::PrintAtPos('l', 'b', "Cannot read $path: $!");
    sleep(2);
    util::SetCursorPos('l', 'b');
    util::ClearLine();

    return;
  }

  my @files = grep(/\.txt$/,readdir($dir));
  closedir $dir;

  system("clear");
  util::PrintAtPos('m', 't', "=== Creator Mode: Show Files in $path ===");

  util::SetCursorPos('l', 2);

  foreach my $file (@files) {
    print "$file\n";
  }

  print "\nPress <ENTER> to continue...";
  <STDIN>;
  system("clear");
}

1;