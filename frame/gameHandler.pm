package frame::gameHandler;

use strict;
use warnings 'FATAL' => 'all';

use Data::Dumper;

use lib qw(..);

use util::die;

sub SaveGame {
  if (scalar(@_) != 1) {
    util::DieArgs("frame::gameHandler::SaveGame()", 1, scalar(@_));
  }
  
  my %data = %{$_[0]};
  my @data;
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
  
  $filename = $filename.".sav";
  push @data, "savefile=$filename";
  WriteToFile($filename, \@data);
  chdir "../";

  return 0;
}

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