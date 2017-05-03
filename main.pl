#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

use Data::Dumper;

use lib '.';

# This statement loads the file dummy/hello_world.pm
use creator::mainmenu;
use frame::base;
use reader::import;
use reader::importchars;
use reader::readplot;
use reader::sceneselector;
use util::terminal;

sub VersionText {
  print "Die Pfeilschwanzkrebse - Internal Build 20170503\n";
  exit;
}

sub HelpText {
  print "Usage: perl main.pl [OPTION]... [FILE]\n";
  print "\n";
  print "With no FILE, will prompt user to choose one.\n";
  print "\n";
  print "  -c, --creator\tuse creator mode\n";
  print "      --help\tdisplay this help and exit\n";
  print "      --version\toutput version information and exit\n";
  exit;
}

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

  if ($creator == 1) {
    creator::MainMenu($filename);

    util::PrintAtPos('l', 'b', "Press <ENTER> to continue...");
    util::SetCursorPos('r', 'b');
    <STDIN>;
    system("clear");

    exit;
  }

  $filename = reader::SceneSelector() if ($filename eq "");

  my %section;
  my @file = reader::Import($filename, \%section);
  my %chars = reader::ImportChars(\@file, \%section);
  
#  my %hash = reader::ReadPlot(\@file, \%section, \%chars, 1);

  # tests:
  frame::base::welcome();
  frame::base::scene(\@file, \%section, \%chars);
}

# Program Entry Point
main(@ARGV);
