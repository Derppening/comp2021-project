#!/usr/bin/perl

use strict;
use warnings;
use lib qw(..);
use util::die; 

package frame::gameHandler;


# todo:? set permissions(or modify somehow) so that you can't manipulate the savefiles by editing them in usual text editors
# todo: add content of saves directory to gitignore
# todo: let user input file name etc...
# todo: think about different cases and make them stupid-user-proof
# save variables into textfile
#
# arg 0: filename without .sav
# arg 1: sceneNumber
# ...
# ...
# output: none

sub saveVar{
	chdir '..\saves';
	if (open(my $checkfile, "$_[0].sav")){
		print "The file $_[0].sav already exists. Do you want to overwrite it? (y/n)\n";
		close ($checkfile);
		chomp(my $playerAns = <STDIN>);
		if (lc($playerAns) ne "y"){
			return 0;
		}
	}
	my $outfile;
	print $outfile "asjdf\n";
	for (my $i=1; $i<scalar(@_); $i++){
		print $outfile "$_[$i]\n";
	}
	close ($outfile);
	chdir '..\frame';
}

# read lines from file and put into array
#
# arg 0: filename without.sav
# 
# output: array with lines
sub openFile{
	chdir '..\saves';
	my @content;
	#warn "$0: open $_[0]: $!";
	if (open(my $INFILE, "$_[0].sav")){		
		while(<$INFILE>){
			chomp;
			push @content, $_;
		}
		close($INFILE);
	}
	else{
		warn "$0: open $_[0].sav: $!";
	}
	chdir '..\frame';
	return @content;
}

#
# arg 0: filename without .sav
# arg 1: reference to $sceneInd
# ...
#
# output: none

sub loadGame{
	my @content = openFile($_[0]);
	my $sceneInd_ref= $_[1];
	$$sceneInd_ref = $content[0];	


#
# arg 0: filename without .sav
#
# output: none
sub deleteGame{
	chdir '..\saves';
	chdir '..\frame';

# print out all .sav files in the saves directory
#
# arguments: none
#
# output: none

	my $dir;
	opendir($dir, '..\saves') or die "can't opendir saves: $!";
	my @saves = grep { /.+sav/} readdir($dir);
	closedir $dir;
	for my $item (@saves){
		print "$item\n";
	}
	

########################################
saveVar("save1","newText");
saveVar("save2",6,2,"tjosan");
#saveVar("save3.txt");
my @save2content = openFile("save2");
for my $item (@save2content){
	print "$item\n";
}

my $sceneInd;
loadGame("save2",\$sceneInd);
if ($sceneInd) {
	print "$sceneInd\n";
}




######################################