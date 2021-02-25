#!/usr/bin/env perl
use strict;
use warnings;

#This perl script will read in the multi-fasta file to verify validity of the ORF.
#It will detect in-frame stop codons, DNA "ambiguity" characters other than N, lack of stop codon at the end of the sequence and lack of start codon at the beginning of start codon.

my $orffile = $ARGV[0];
my $counter=0;
my $orfcount=0;
my $header='';
my $name;
my $seq='';
my $len;
my $newseq;
my %sequence;

open(ORF, "$orffile") || die "File not found: '$orffile'.\n";
while (<ORF>) {
	chomp($_);
	if ($_=~/^>(.*)/) {
		if ($seq ne ""){$sequence{$header}=$seq;}
		$header = $1;$counter++;$seq = '';
	} else {$seq.=$_;}
}
$sequence{$header}=$seq;
foreach $name (keys %sequence) {
	$len = length($sequence{$name});
	$newseq=substr($sequence{$name}, 0, -3);
	if ($sequence{$name} =~ m/ATG(?:[ATGC]{3}(?<!TAG|TAA|TGA)){13,}(?:TAG|TAA|TGA)$/){$orfcount++;}
	else{print "$name\n";}
}

print "$orfcount out of $counter sequences validated as ORFs.\n"
