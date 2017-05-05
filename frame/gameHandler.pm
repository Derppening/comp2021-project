# frame/gameHandler.pm
#
# Manages the save/load feature of the game.
#

package frame::gameHandler;

use strict;
use warnings 'FATAL' => 'all';

use Data::Dumper;

use lib qw(..);

use util::die;

# Prompts the user for a filename, then saves a copy of the current state of
# the game.
#
# arg1: (Reference of) hash to all data which should be saved
#
sub SaveGame {
  if (scalar(@_) != 1) {
    util::DieArgs("frame::gameHandler::SaveGame()", 1, scalar(@_));
  }
  
  my %data = %{$_[0]};
  my @data;
  
  # convert the hash into an array
  foreach my $entry (keys %data) {
    if ($entry eq "savefile") {
      next;
    }
    push @data, "$entry=$data{$entry}";
  }
  
  # create the directory first
  if (!(-d "./saves")) {
    mkdir "./saves";
  }
  chdir "./saves";
  
  system("clear");
  util::PrintAtPos('m', 't', "=== Save Game ===");
  util::PrintAtPos('l', 2, "Enter the filename you want to save to.");
  util::PrintAtPos('l', 3, "If the file does not exist, it will be created for you.");
  
  util::SetCursorPos('l', 5);
  util::ClearLine();
  print "(*.sav): ";
  
  my $filename = <STDIN>;
  chomp($filename);
  
  # check if the file already exists
  if (open(my $filecheck, "$filename.sav")) {
    util::SetCursorPos('l', 5);
    util::ClearLine();
    print "$filename.sav already exists. Do you want to overwrite it? (y/N) ";
    my $resp = <STDIN>;
    chomp($resp);
    if ($resp ne "y") {
      util::PrintAtPos('l', 5, "WARNING: File not saved!");
      sleep(2);
      chdir "../";
      return 1;
    }
  }
  
  # add the filename to the savefile
  $filename = $filename.".sav";
  push @data, "savefile=$filename";
  WriteToFile($filename, \@data);
  chdir "../";

  return 0;
}

# Low-level handler to write data into a file
#
# arg1: Filename to write to
# arg2: (Reference of) array of line to write
#
sub WriteToFile {
  if (scalar(@_) != 2) {
    util::DieArgs("frame::gameHandler::WriteToFile()", 2, scalar(@_));
  }
  
  my $filename = $_[0];
  my @data = @{$_[1]};
  
  # ">" will create the file if it doesn't exist
  open(my $fh, '>:encoding(UTF-8)', $filename);
  foreach my $line (@data) {
    print $fh "$line\n";
  }
  close($fh);
}

# Low-level handler to read data from a file
#
# arg1: Filename to read from
#
# return: Array of lines present in the file
#
sub ReadFromFile {
  if (scalar(@_) != 1) {
    util::DieArgs("frame::gameHandler::ReadFromFile()", 1, scalar(@_));
  }
  
  my $filename = $_[0];
  my @lines = ();
  if (!open (my $fh, '<:encoding(UTF-8)', $filename)) {
    print "Cannot open $filename: $!";
    return @lines;
  }
  open (my $fh, '<:encoding(UTF-8)', $filename);
  chomp(@lines = <$fh>);
  close $fh;
  
  return @lines;
}

# Prompt the user to choose a savefile to load from, then loads the saved
# state of the game from the file.
#
# return; Hash of the attributes of the saved game
#
sub LoadGame {
  if (scalar(@_) != 0) {
    util::DieArgs("frame::gameHandler::LoadGame()", 0, scalar(@_));
  }
  
  system("clear");
  util::PrintAtPos('m', 't', "=== Load Game ===");
  
  my %data = ();
  
  if (!(-d "./saves")) {
    util::PrintAtPos('l', 2, "No saves found.");
    util::PrintAtPos('l', 4, "Press <ENTER> to continue...");
    <STDIN>;
    return %data;
  }

  my @lines = ();
  
  util::PrintAtPos('l', 2, "Choose a file to load from: ");
  util::SetCursorPos('l', 3);
  my @files = GetSaves();
  foreach my $file (@files) {
    print "- $file\n";
  }
  
  while (1) {
    util::SetCursorPos('l', 'bb');
    util::ClearLine();
    print "(*.sav): ";
  
    my $filename = <STDIN>;
    chomp($filename);
    $filename = $filename.".sav";
  
    util::SetCursorPos('l', 'b');
    chdir "./saves";
    @lines = ReadFromFile($filename);
    chdir "../";
    if (!(@lines)) {
      sleep(2);
      util::ClearLine();
      next;
    }

    last;
  }

  # put all attributes into a hash, then return it
  foreach my $line (@lines) {
    if ($line =~ /^(.+)=(.+)/) {
      $data{"$1"} = $2;
    }
  }

  return %data;
}

# Retrieve a list of all saved games under "./saves"
#
# return: Array of filenames under "./saves"
#
sub GetSaves {
  if (scalar(@_) != 0) {
    util::DieArgs("frame::gameHandler::ListSaves()", 0, scalar(@_));
  }
  
  my @saves = ();
  
  if (!(-d "./saves")) {
    return @saves;
  }
  
  my $dir;
  opendir $dir, "./saves";
  @saves = grep(/\.sav$/, readdir($dir));
  closedir $dir;
  return @saves;
}

# Low-level handler to delete a savefile from "./saves"
#
# arg1: Filename to the to-be-removed savefile
#
sub DeleteSave {
  if (scalar(@_) != 1) {
    util::DieArgs("frame::gameHandler::DeleteSave()", 1, scalar(@_));
  }
  
  my $filename = $_[0];
  
  chdir "./saves";
  if (-e $filename) {
    unlink $filename or print "Unable to delete $filename: $!";
  } else {
    print "Warning: $filename does not exist";
  }
  chdir "../";
}

1;