# reader/readplot.pm
#
# Reads plot elements or ASCII art.
#

package reader;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use util::die;
use open ':std', ':encoding(UTF-8)';

# Interprets and outputs the plot to stdout
#
# arg1: (Reference of) File content array
# arg2: (Reference of) Sections hash
# arg3: (Reference of) Characters hash
# arg4: Plot point number
#
# return: Hash containing possible choices
#
sub ReadPlot {
  if (scalar(@_) != 4) {
    util::DieArgs("reader::ReadPlot()", 4, scalar(@_));
  }
  
  my @file = @{$_[0]};
  my %sections = %{$_[1]};
  my %chars = %{$_[2]};
  my $plotnum = $_[3];
  
  # read the plot lines
  my @plot;
  {
    my $end = exists $sections{'plot'}{$plotnum + 1} ? $sections{'plot'}{$plotnum + 1} : scalar(@file);
    for (my $i = $sections{'plot'}{$plotnum} + 1; $i < $end; ++$i) {
      push @plot, $file[$i];
    }
  }
  
  my %hash;
  
  # loop through all the lines
  foreach my $line (@plot) {
    $line =~ s/^[\s\t]+//;
    $line =~ s/\$([\d]+)/$chars{$1}/g;
    if ($line =~ /^#.*/) {
      next;
    } elsif ($line =~ /\(art=.+\)/) {
      # art
      $line =~ s/\(art=(.+)\)/$1/;
      ReadArt($line);
    } elsif ($line =~ /^\(opt=.+\)/) {
      # option
      $line =~ s/\(opt=(.+)\)/$1/;
      my @array = split /,/, $line;
      $array[0] =~ s/\"//g;
      $array[1] =~ s/\"//g;
      print "$array[1]: $array[0]\n";
      $hash{$array[1]} = $array[2];
    } else {  # line
      print "$line\n";
    }
  }
  
  return %hash;
}

# Displays the ASCII art from art.txt (currently hardcoded)
#
# arg1: Tag of artwork
#
sub ReadArt {
  if (scalar(@_) != 1) {
    util::DieArgs("reader::ReadArt()", 1, scalar(@_));
  }
  
  my $tag = $_[0];
  
  open(my $fh, '<:encoding(UTF-8)', "art.txt")
      or util::DieOpenFile("reader::ReadArt()", "art.txt", $!);
  
  my $display = 0;
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /^\(.+\)/) {
      $row =~ s/^\((.+)\)/$1/;
      if ($row eq $tag) {
        $display = 1;
      } else {
        $display = 0;
      }
    } elsif ($display == 1) {
      print "$row\n" if ($row ne "");
    }
  }
}

1;