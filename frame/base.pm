#!/usr/bin/perl

use strict;
use warnings;

use lib qw(..);

#use Scalar::Util qw(looks_like_number);
use reader::import;

# Package declaration
package frame::base;

sub welcome {
  print "Welcome to the game. Choose an alternative by typing a number. Press q to quit the game. \n";
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
  my $playerAns = "start";
  my $numAlt = 3; #Should be reset later on
  my $sceneInd = 0; #Should be reset later on
  my $sceneText = "Once upon a time...\n What do you choose?\n1. Hot Milk Tea\n2. Iced Lemon Tea\n3. Ice Coffee\n";
  while(lc($playerAns) ne "q"){
    #$sceneText = reader::import::??($playerAns,$sceneInd); # Something like this
    
    print $sceneText;
    chomp($playerAns = <STDIN>);
    
    while(isAns($numAlt,$playerAns)==0){
      print "You did not write a valid answer. Please try again.\n";
      chomp($playerAns = <STDIN>);
    }
  }
}

# All Perl modules need to end with a true value.
1;
