#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

use Data::Dumper;

use lib '.';

use creator::mainmenu;
use frame::base;
use frame::gameHandler;
use reader::import;
use reader::importchars;
use reader::readplot;
use reader::sceneselector;
use util::terminal;

# Displays the version text and quits
#
sub VersionText {
  print "Die Pfeilschwanzkrebse 1.0.0-prelease\n";
  exit;
}

# Displays the help text and exits
#
sub HelpText {
  print "Usage: perl main.pl [OPTION]... [FILE]\n";
  print "\n";
  print "With no FILE, will prompt user to choose one.\n";
  print "\n";
  print "  -c, --creator\t\tuse creator mode\n";
  print "      --help\t\tdisplay this help and exit\n";
  print "      --version\t\toutput version information and exit\n";
  exit;
}

# Main Function
#
# Acts as a pseudo-entry point to the program
#
# var: Flattened array of command line arguments
#
sub main {
  # A C-like main function as the entry point.
  # argc and argv meaning "argument count" and "argument vector"
  my $argc = scalar(@_);
  my @argv = @_;
  
  # forces flush after every print
  $| = 1;
  
  # read through all command-line arguments
  my $filename = "";
  my $creator = 0;
  foreach my $arg (@argv) {
    if ($arg eq "--version") {
      VersionText();
    } elsif ($arg eq "--help") {
      HelpText();
    } elsif ($arg eq "-c" || $arg eq "--creator") {
      $creator = 1;
    } elsif (substr($arg, 0, 1) eq '-') {
      print "$arg: Invalid argument\n";
      exit;
    } else {
      $filename = $arg;
    }
  }
  
  # check if program is entering creator mode
  if ($creator == 1) {
    creator::MainMenu($filename);
    
    util::PrintAtPos('l', 'b', "Press <ENTER> to continue...");
    util::SetCursorPos('r', 'b');
    <STDIN>;
    system("clear");
    
    exit;
  }
  
  # tests, tb removed
#  my @dummy = ("Hello", "World!");
#  frame::gameHandler::SaveGame(\@dummy);
  
#  @dummy = frame::gameHandler::GetSaves();
  
#  frame::gameHandler::LoadGame();
  
#  exit;
  
  # call SceneSelector module if user didn't supply a scene
  my %data = reader::SceneSelector() if ($filename eq "");
  if (!(exists $data{'scenefile'})) {
    print "Selected file is not a valid scene file!\n";
    exit;
  }
  $filename = $data{'scenefile'};

  # make sure we could open the file, and give a friendly message if we can't
  if (!(open(my $fh, '<:encoding(UTF-8)', $filename))) {
    print "Cannot read from $filename: $!\n";
    exit;
  }

  # inflate the scene file
  my %section;
  my @file = reader::Import($filename, \%section);
  my %chars = reader::ImportChars(\@file, \%section);

  if (exists $data{'savefile'}) {
    print "Loaded game from $data{'savefile'}";
    delete($data{'savefile'});
    sleep(2);
  } else {
    frame::base::welcome();
  }
  frame::base::scene(\@file, \%section, \%chars, \%data);
}

# Program Entry Point
main(@ARGV);
