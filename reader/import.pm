package reader;

use strict;
use warnings FATAL => 'all';

use lib qw(..);

use util::die;
use Data::Dumper;

# Reads from a file
#
# var1: Filename to import from
# var2: Hash to write section headers to
#
# return: Array containing all lines of the file
#
sub Import {
  if (scalar(@_) != 2) {
    util::DieArgs("reader::Import()", 2, scalar(@_));
  }
  
  my $filename = $_[0];
  my %sections = %{$_[1]};
  my @file;
  
  # open the file for reading
  open(my $fh, '<:encoding(UTF-8)', $filename)
      or util::DieOpenFile("reader::Import()", $filename, $!);
  
  # read the headers of the structure, and store the text into an array
  for (my $linenum = 1; my $row = <$fh>; ++$linenum) {
    chomp $row;
    $file[$linenum] = $row;
    if ($row =~ /^\[.+\]$/) {
      my $tmp = $&;
      $tmp =~ s/^\[(.+)\]$/$1/;
      $sections{$tmp} = $linenum;
    }
  }
  
  close $fh;
  
  # make a sorted version of the hash
  my @section_arr = sort { $sections{$a} <=> $sections{$b} } keys(%sections);
  my @section_lines = @sections{@section_arr};
  
  {
    # find the range of the plot
    my $plot_end = 0;
    foreach my $i (@section_lines) {
      if ($i > $sections{'plot'}) {
        $plot_end = $i;
        last;
      }
    }
    if ($plot_end == 0) {
      $plot_end = scalar(@file);
    }
    
    my %tmp_hash;
    
    # assign the plot elements into the temp hash
    for (my $i = $sections{'plot'}; $i < $plot_end; ++$i) {
      my $tmp = $file[$i];
      if ($tmp =~ /^\d+\./) {
        my $num = $&;
        $num =~ s/^(\d+)\./$1/;
        $tmp_hash{$num} = $i;
      }
    }
    
    # write the temp hash into the main sections hash
    $sections{'plot'} = \%tmp_hash;
  }
  
  # reassign the sections hash back to the original one
  %{$_[1]} = %sections;
  
  return @file;
}


1;