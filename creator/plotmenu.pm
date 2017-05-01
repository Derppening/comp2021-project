package creator;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use reader::import;
use util::die;

sub PlotMenu {
  if (scalar(@_) != 4) {
    util::DieArgs("creator::PlotMenu()", 4, scalar(@_));
  }
  
  my @file = @{$_[0]};
  my %section = %{$_[1]};
  my %chars = %{$_[2]};
  my $filename = $_[3];
  
  while (1) {
    util::PrintAtPos('m', 't', "=== Creator Mode: Plot Menu ===");
    util::PrintAtPos('l', 2, "show [plot]: Show plot number [plot]");
    util::PrintAtPos('l', 3, "list: List all valid plot lines");
    util::PrintAtPos('l', 4, "edit [plot]: Edit plot number [plot] in vim");
    util::PrintAtPos('l', 6, "quit: Quit to file menu");
    
    util::SetCursorPos('l', "bb");
    util::ClearLine();
    util::SetCursorPos('l', "bb");
    print ": ";
    
    my $resp = "";
    $resp = <STDIN>;
    chomp($resp);
    
    if ($resp eq "quit") {
      last;
    } elsif ((substr $resp, 0, 4) eq "show") {
      if (length $resp < 5) {
        util::PrintAtPos('l', "b", "Please supply a plot number.");
        sleep(2);
        util::SetCursorPos('l', "b");
        util::ClearLine();
        next;
      }
      my $plotnum = substr $resp, 5;
      ShowPlot(\@file, \%section, \%chars, $plotnum);
    } elsif ($resp eq "list") {
      ListPlot(\%section);
    } elsif ((substr $resp, 0, 4) eq "edit") {
      my $linenum = 0;
      if (length $resp < 5) {
        $linenum = $section{'plot'}{1};
      } else {
        $linenum = $section{'plot'}{int(substr $resp, 5)};
      }
      my $command = "vim +" . $linenum . " " . $filename;
      system($command);
      system("clear");
    } else {
      util::SetCursorPos('l', "b");
      print "$resp: Invalid option";
      sleep(2);
      util::SetCursorPos('l', "b");
      util::ClearLine();
    }
  }
}

sub ListPlot {
  if (scalar(@_) != 1) {
    util::DieArgs("creator::ListPlot()", 1, scalar(@_));
  }
  
  system("clear");
  util::PrintAtPos('m', 't', "=== Creator Mode: List Plot Nodes ===");
  
  my %sections = %{$_[0]};
  util::SetCursorPos('l', 2);
  
  foreach my $key (sort {$a <=> $b} (keys %{$sections{'plot'}})) {
    print "$key: $sections{'plot'}{$key}\n";
  }
  
  print "\nPress <ENTER> to continue...";
  <STDIN>;
  system("clear");
}

sub ShowPlot {
  if (scalar(@_) != 4) {
    util::DieArgs("creator::ShowPlot()", 4, scalar(@_));
  }
  
  my @file = @{$_[0]};
  my %section = %{$_[1]};
  my %chars = %{$_[2]};
  my $plotnum = $_[3];
  
  system("clear");
  util::PrintAtPos('m', 't', "=== Creator Mode: Show Plot $plotnum ===");
  
  util::SetCursorPos('l', 2);
  
  my @plot;
  {
    my $end = exists $section{'plot'}{$plotnum + 1} ? $section{'plot'}{$plotnum + 1} : scalar(@file);
    for (my $i = $section{'plot'}{$plotnum} + 1; $i < $end; ++$i) {
      push @plot, $file[$i] if ($file[$i] ne "");  # ignore all empty lines
    }
  }
  
  foreach my $line (@plot) {
    $line =~ s/^[\s\t]+//;
    $line =~ s/\$([\d]+)/$chars{$1}/g;
    if ($line =~ /^#.*/) {
      next;
    } elsif ($line =~ /\(art=.+\)/) {  # art
      $line =~ s/\(art=(.+)\)/$1/;
      print "Art: $line\n";
    } elsif ($line =~ /^\(opt=.+\)/) {  # option
      $line =~ s/\(opt=(.+)\)/$1/;
      my @array = split /,/, $line;
      $array[0] =~ s/\"//g;
      $array[1] =~ s/\"//g;
      print "Option: $array[0] ($array[1])\n";
    } else {  # line
      print "$line\n";
    }
  }
  
  print "\nPress <ENTER> to continue...";
  <STDIN>;
  system("clear");
}

1;