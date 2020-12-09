#!/usr/bin/perl

use strict;
use warnings;
use CPAN;

CPAN::Shell->force(qw(
install 
Bundle::BioPerl
Bio::DB::ESoap
CJFIELDS/BioPerl-Network-1.006900.tar.gz
CJFIELDS/BioPerl-DB-1.006900.tar.gz));
