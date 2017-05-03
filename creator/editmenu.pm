package creator;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use creator::charmenu;
use creator::plotmenu;
use reader::import;
use util::die;

sub EditMenu {
  if (scalar(@_) != 1) {
    util::DieArgs("creator::EditMenu()", 1, scalar(@_));
  }
  
  my $filename = $_[0];
  if ($_[0] eq "") {
    util::SetCursorPos('l', 'bb');
    print "Enter file name to read from: ";
    $filename = <STDIN>;
    chomp($filename);
    util::SetCursorPos(0, 0);
    util::ClearLine();
  }

  if (!(open(my $fh, '<:encoding(UTF-8)', $filename))) {
    util::PrintAtPos('l', 'b', "Cannot read from $filename: $!");
    sleep(2);
    util::SetCursorPos('l', 'b');
    util::ClearLine();

    return;
  }

  system("clear");
  
  my %section;
  my @file = reader::Import($filename, \%section);
  my %chars = reader::ImportChars(\@file, \%section);
  
  while (1) {
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
      my $command = "vim " . $filename;
      system($command);

      util::SetCursorPos('l', "bb");
      print "Do you want to reload the file? (y/n) ";
      my $rl_ans = <STDIN>;
      chomp($rl_ans);

      if ($rl_ans eq 'y') {
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
      util::SetCursorPos('l', "b");
      print "$resp: Invalid option";
      sleep(2);
      util::SetCursorPos('l', "b");
      util::ClearLine();
    }
  }
}

1;