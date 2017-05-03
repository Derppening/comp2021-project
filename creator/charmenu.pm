package creator;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use reader::import;
use util::die;

# Characters Menu in Creator Mode
#
# arg1: (Reference to) character hash
#
sub CharsMenu {
  if (scalar(@_) != 1) {
    util::DieArgs("creator::CharsMenu()", 1, scalar(@_));
  }
  
  my %chars = %{$_[0]};
  while (1) {
    # print gui
    util::PrintAtPos('m', 't', "=== Creator Mode: Character Menu ===");
    util::PrintAtPos('l', 2, "show: Show list of characters");
    util::PrintAtPos('l', 4, "quit: Quit to file menu");
    
    util::SetCursorPos('l', "bb");
    util::ClearLine();
    util::SetCursorPos('l', "bb");
    print ": ";
    
    my $resp = "";
    $resp = <STDIN>;
    chomp($resp);
    
    if ($resp eq "quit") {
      last;
    } elsif ($resp eq "show") {
      ShowChars(\%chars);
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

# Menu to show all characters in the scene
#
# arg1: (Reference to) hash of characters
#
sub ShowChars {
  if (scalar(@_) != 1) {
    util::DieArgs("creator::ShowChars()", 1, scalar(@_));
  }
  
  system("clear");
  util::PrintAtPos('m', 't', "=== Creator Mode: Show Characters ===");
  
  my %chars = %{$_[0]};
  util::SetCursorPos('l', 2);
  
  # sort by key and list all characters
  foreach my $key (sort {$a <=> $b} (keys %chars)) {
    print "$key: $chars{$key}\n";
  }
  
  print "\nPress <ENTER> to continue...";
  <STDIN>;
  system("clear");
}

1;