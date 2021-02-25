#!/usr/bin/env perl
use strict;
use warnings;
use Algorithm::Combinatorics qw(combinations);

#This perl script will read in the number of species to sample (r), the list of n taxa. It will generate the list of all possible combinations nCr = n! / r! * (n - r)!
#Used to perform test of relaxation using different combinations of species as the background set.

#Usage:perl getCombs.pl $r_count $backtaxlist

#this is the number of species to sample
my $r_count=$ARGV[0];
shift @ARGV;

#generate combinations of taxa
my $comter = combinations(\@ARGV, $r_count);

#print the list
while (my $c = $comter->next) {
    print "@$c\n";
}
