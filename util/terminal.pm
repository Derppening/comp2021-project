# util/terminal.pm
#
# Provides interfaces to manipulate the cursor of terminals
#
# Note: This file uses Term::ReadKey, which may not be installed by default.
#

package util;

use strict;
use warnings FATAL => 'all';

use Term::Cap;
use Term::ReadKey;

use lib qw(..);

use util::die;

# Gets the current terminal via Term::Cap
#
# return: Current terminal
#
sub GetCurrentTerm {
  my $terminal = Term::Cap->Tgetent();
  return $terminal;
}

# Gets the size of the current terminal
#
# return: Array in format of {x_size, y_size}, where sizes are in terms of
#     characters
#
sub GetTermSize {
  my @term = GetTerminalSize();
  splice @term, 2;
  return @term;
}

# Resets the position of the cursor
#
sub ResetCursor {
  my $terminal = GetCurrentTerm();
  SetCursorPos(0, 0);
}

# Sets the position of the cursor.
#
# This function allows using x and y coordinates, as well as relative
# coordinates. In particular:
# - Width:
#   - 'l': Left side of console (i.e. x = 0)
#   - 'r': Right side of console (i.e. x = x_size - 1)
# - Height:
#   - 't' Top of console (i.e. y = 0)
#   - 'm': Middle of console (i.e. y = (y_size / 2) - 1)
#   - 'b': Bottom of console (i.e. y = y_size - 1)
#   - 'bb': Second-bottom row of console (i.e. y = y_size - 2)
#
# arg1: new x-position of the cursor
# arg2: new y-position of the cursor
#
sub SetCursorPos {
  if (scalar(@_) != 2) {
    DieArgs("util::SetCursorPos()", 2, scalar(@_));
  }
  
  (my $term_w, my $term_h) = GetTermSize();
  
  my $w;
  my $h;
  
  # check if $w and $h are supplied with correct arguments
  if ($_[0] =~ /\D/) {
    if ($_[0] eq "l") {
      $w = 0;
    } elsif ($_[0] eq "r") {
      $w = $term_w - 1;
    } else {
      die "util::SetCursorPos(): Wrong type supplied to argument 0. \n";
    }
  } else {
    $w = $_[0];
  }
  
  if ($_[1] =~ /\D/) {
    if ($_[1] eq "t") {
      $h = 0;
    } elsif ($_[1] eq "m") {
      $h = $term_h / 2 - 1;
    } elsif ($_[1] eq "b") {
      $h = $term_h - 1;
    } elsif ($_[1] eq "bb") {
      $h = $term_h - 2;
    } else {
      die "util::PrintAtPos(): Wrong type supplied to argument 1. \n";
    }
  } else {
    $h = $_[1];
  }
  
  my $terminal = GetCurrentTerm();
  print $terminal->Tgoto("cm", $w, $h);
}

# Print a string at a given position of the console.
#
# This function allows using x and y coordinates, as well as relative
# coordinates. In particular:
# - Width:
#   - 'l': Left side of console (i.e. x = 0)
#   - 'm': Middle of console
#   - 'r': Right side of console (i.e. x = x_size - 1)
# - Height:
#   - 't" Top of console (i.e. y = 0)
#   - 'm': Middle of console (i.e. y = (y_size / 2) - 1)
#   - 'b': Bottom of console (i.e. y = y_size - 1)
#   - 'bb': Second-bottom row of console (i.e. y = y_size - 2)
#
# The cursor position will be reset to (0, 0) after the function is executed.
#
# arg1: x-position of the text
# arg2: y-position of the text
# arg3: the text itself
#
sub PrintAtPos {
  if (scalar(@_) != 3) {
    DieArgs("util::PrintAtPos()", 3, scalar(@_));
  }
  
  my $w;
  my $h;
  my $line = $_[2];
  
  (my $term_w, my $term_h) = GetTermSize();
  
  # check if $w and $h are supplied with correct arguments
  if ($_[0] =~ /\D/) {
    if ($_[0] eq "l") {
      $w = 0;
    } elsif ($_[0] eq "m") {
      $w = int(($term_w - length($line)) / 2);
    } elsif ($_[0] eq "r") {
      $w = $term_w - length($line) - 1;
    } else {
      die "util::PrintAtPos(): Wrong type supplied to argument 0. \n";
    }
  } else {
    $w = $_[0];
  }
  
  if ($_[1] =~ /\D/) {
    if ($_[1] eq "t") {
      $h = 0;
    } elsif ($_[1] eq "m") {
      $h = int($term_h / 2 - 1);
    } elsif ($_[1] eq "b") {
      $h = $term_h - 1;
    } elsif ($_[1] eq "bb") {
      $h = $term_h - 2;
    } else {
      die "util::PrintAtPos(): Wrong type supplied to argument 1. \n";
    }
  } else {
    $h = $_[1];
  }
  
  SetCursorPos($w, $h);
  print $line;
  ResetCursor();
}

# Clears the line at the current cursor position
#
sub ClearLine {
  print "\r\e[K";
}

1;