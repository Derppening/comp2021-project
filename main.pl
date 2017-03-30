#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

# This statement loads the file dummy/hello_world.pm
use dummy::hello_world;

sub main {
  # A C-like main function as the entry point.
  # argc and argv meaning "argument count" and "argument vector"
  my $argc = scalar(@_);
  my @argv = @_;
  
  # I believe at this point, we will likely be creating our own modules, so
  # for now, I will import a dummy module to show how to create and import
  # the modules.
  # Calls HelloWorld() from dummy/hello_world.pm
  dummy::hello_world::HelloWorld();
}

main(\@ARGV);
