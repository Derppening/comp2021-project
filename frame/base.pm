#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

use lib qw(..);

#use Scalar::Util qw(looks_like_number);
use reader::import;
use reader::readInput;

# Package declaration
package frame::base;

sub welcome {
  print "Welcome to the game. Select your choice by typing an option. \nPress q to quit the game. \n";
  
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
  my @file = @{$_[0]};
  my %section = %{$_[1]};
  my %char = %{$_[2]};
  
  my $playerAns = "";
  my %opinion;
  my $numAlt = 1; #Should be reset later on
  my $sceneInd = 1; #Should be reset later on
  my $sceneText = "\n";
  
  while(lc($playerAns) ne "q"){
    system("clear");
    
    util::PrintAtPos('m', 2, "#".$sceneInd);
    util::SetCursorPos('l', 4);
    %opinion = reader::readInput(\@file, \%section, \%char, $sceneInd);
    
    #print $sceneText;
    util::SetCursorPos('l', "bb");
    util::ClearLine();
    util::SetCursorPos('l', "bb");
    print ": ";
    chomp($playerAns = <STDIN>);
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
