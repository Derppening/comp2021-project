#!/usr/bin/perl

#use strict;
#use warnings;

use lib qw(..);

#use Scalar::Util qw(looks_like_number);
use reader::import;
use reader::readInput;

# Package declaration
package frame::base;

sub welcome {
  print "Welcome to the game. Choose an alternative by typing a number. \nPress q to quit the game. \n";
}

sub isAns{ #$numAlt,$playerAns
  # if (looks_like_number($_[1])){
    for (my $i=1; $i<=$_[0] ; $i++){
        if ($i==$_[1]){
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

  my $playerAns = "start";
  my %opinion;
  my $numAlt = 1; #Should be reset later on
  my $sceneInd = 1; #Should be reset later on
  my $sceneText = "!!!!!!!Begin!!!!!!!!\n";

  while(lc($playerAns) ne "q"){
    %opinion = reader::readInput(\@file,\%section, \%char, $sceneInd);

    #print $sceneText;
    chomp($playerAns = <STDIN>);
    $sceneInd = reader::goPlot(\%opinion, $playerAns);
    
    #while(isAns($numAlt,$playerAns)==0 || $sceneInd eq -1){
    while($sceneInd eq -1) {
      print "You did not write a valid answer. Please try again.\n";
      print "scendId = $sceneInd\n";
      chomp($playerAns = <STDIN>);
       $sceneInd = reader::goPlot(\%opinion, $playerAns);
    }
    
    if($sceneInd eq 0) {
      print "Hope you enjoy the game. Bye :D\n";
      last;
    }
  }
}

# All Perl modules need to end with a true value.
1;
