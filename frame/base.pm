# frame/base.pm
#
# Manages the general gameplay.
#

package frame::base;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use reader::import;
use reader::readInput;

sub welcome {
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

sub isAns{
  #$numAlt,$playerAns
  # if (looks_like_number($_[1])){
  for (my $i = 1; $i <= $_[0]; $i++) {
    if ($i == $_[1]) {
      return 1;
    }
  }
  # }
  return 0;
}

sub scene {
  if (scalar(@_) != 4) {
    util::DieArgs("frame::base::scene()", 4, scalar(@_));
  }

  my @file = @{$_[0]};
  my %section = %{$_[1]};
  my %char = %{$_[2]};
  my %data = %{$_[3]};
  
  my $playerAns = "";
  my %opinion;
  my $numAlt = 1; #Should be reset later on
  my $sceneInd = 1; #Should be reset later on
  my $sceneText = "\n";

  $sceneInd = int($data{'scene'}) if exists $data{'scene'};
  
  while(lc($playerAns) ne "q"){
    system("clear");
    
    util::PrintAtPos('m', 2, "");
    util::SetCursorPos('l', 4);
    %opinion = reader::readInput(\@file, \%section, \%char, $sceneInd);

    util::SetCursorPos('l', "bb");
    util::ClearLine();
    util::SetCursorPos('l', "bb");
    print ": ";
    chomp($playerAns = <STDIN>);
    if ($playerAns eq "_save") {
      $data{'scene'} = $sceneInd;
      if (frame::gameHandler::SaveGame(\%data) == 0) {
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
    $sceneInd = reader::goPlot(\%opinion, $playerAns);
    
    while($sceneInd eq -1) {
      util::SetCursorPos('l', 'b');
      print "$playerAns: Invalid option";
      
      sleep(2);
      
      util::SetCursorPos('l', 'b');
      util::ClearLine();
      util::SetCursorPos('l', 'bb');
      util::ClearLine();
      util::SetCursorPos('l', "bb");
      print ": ";
      chomp($playerAns = <STDIN>);
      $sceneInd = reader::goPlot(\%opinion, $playerAns);
    }
    
    if ($sceneInd eq 0) {
      print "Hope you enjoy the game. Bye :D";
      sleep(2);
      system("clear");
      last;
    }
    system("clear");
  }
}

# All Perl modules need to end with a true value.
1;
