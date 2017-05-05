package creator;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use creator::editmenu;
use util::die;
use util::terminal;

# Main menu to Creator Mode
#
# var1: Filename to a scene file. Empty if user did not specify one.
#
sub MainMenu {
  if (scalar(@_) != 1) {
    util::DieArgs("creator::MainMenu()", 1, scalar(@_));
  }
  
  system("clear");
  
  while (1) {
    # print gui
    util::PrintAtPos("m", 't', "=== Creator Mode: Main Menu ===");
    util::PrintAtPos('l', 2, "load [FILE]: Load file");
    util::PrintAtPos('l', 3, "list [PATH]: List all text files in [PATH]");
    util::PrintAtPos('l', 5, "quit: Quit");
    util::SetCursorPos('l', "bb");
    util::ClearLine();
    print ": ";
    
    my $resp = "";
    $resp = <STDIN>;
    chomp($resp);
    
    if ($resp eq "quit") {
      last;
    } elsif ((substr $resp, 0, 4) eq "load") {
      my $filename = "";
      if (length $resp < 5) {  # user did not specify filename
        $filename = $_[0];
      } else {  # user specified filename in command line
        $filename = substr $resp, 5;
      }
      
      EditMenu($filename);
    } elsif ((substr $resp, 0, 4) eq "list") {
      my $path = "";
      if (length $resp < 5) {  # user did not specify dir
        $path = ".";
      } else {  # user specified dir in command line
        $path = substr $resp, 5;
      }
      
      ListFiles($path);
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

# Lists all .txt files in a given directory
#
# Any text file named to "art.txt" will be ignored.
#
# arg1: Which directory to show txt files
#
sub ListFiles {
  if (scalar(@_) != 1) {
    util::DieArgs("creator::ListFiles()", 1, scalar(@_));
  }
  
  my $path = $_[0];
  
  # try to read from the directory, and notify user if there is an error
  my $dir;
  if (!(opendir $dir, $path)) {
    util::PrintAtPos('l', 'b', "Cannot read $path: $!");
    sleep(2);
    util::SetCursorPos('l', 'b');
    util::ClearLine();
    
    return;
  }
  
  # get all files ending with .txt
  my @files = grep(/\.txt$/, readdir($dir));
  closedir $dir;
  
  system("clear");
  util::PrintAtPos('m', 't', "=== Creator Mode: Show Files in $path ===");
  
  util::SetCursorPos('l', 2);
  
  # loop and pritn every file, skipping art.txt
  foreach my $file (@files) {
    if ($file eq "art.txt") {
      next;
    }
    print "$file\n";
  }
  
  print "\nPress <ENTER> to continue...";
  <STDIN>;
  system("clear");
}

1;