#!/usr/bin/perl  
 #use strict;  
 use warnings;  
 use List::Util qw(min max);  
 #perl fixbases.pl example.fasta example.coverage > example.corrected.fasta  
 # Input parameters  
 my $genome = $ARGV[0];  
 my $coverage = $ARGV[1];  
 my $totalcount=0;  
 my $minreadcoverage=20;# minimum number of reads required at site to consider it  
 my $maxreadcoverage=200;  
 my $maxindelcount=5;  
 open FASTA2, $coverage or die $!;  
 while($line = <FASTA2>){  
 chomp $line;$line=$line . "\t}";  
 my @jelly=split(/\s+/,$line);  
 splice @jelly, 4, 0, 'SnowWhite', 'Humbert';  
 my $scaf=$jelly[0];  
 my $pos=$jelly[1];  
 my $oldbase=$jelly[2];  
 my $totalreads=$jelly[3];  
 my @jellyA=split(/\:/,$jelly[7]);#A  
 my @jellyC=split(/\:/,$jelly[8]);#C  
 my @jellyG=split(/\:/,$jelly[9]);#G  
 my @jellyT=split(/\:/,$jelly[10]);#T  
 my @jellyN=split(/\:/,$jelly[11]);#N  
 my $indelcount=0;  
 if(!($jelly[12]=~ /\}/)){  
 my @jellyindel=split(/\:/,$jelly[12]);#indel  
 $indelcount=$jellyindel[1];  
 }  
 my @counts;  
 push @counts,$jellyA[1];  
 push @counts,$jellyC[1];  
 push @counts,$jellyG[1];  
 push @counts,$jellyT[1];  
 push @counts,$jellyN[1];  
 push @counts,$indelcount;  
     if(($totalreads>$minreadcoverage)&&($indelcount<$maxindelcount)&&($totalreads<$maxreadcoverage)){$totalcount++;  
 my $maxbase= max @counts;  
 my $maxbasepercent=$maxbase*0.1;  
 my $maxbaseval=$oldbase;  
 if($jellyA[1]==$maxbase){$maxbaseval="A";}  
 elsif($jellyC[1]==$maxbase){$maxbaseval="C";}  
 elsif($jellyG[1]==$maxbase){$maxbaseval="G";}  
 elsif($jellyT[1]==$maxbase){$maxbaseval="T";}  
 elsif($jellyN[1]==$maxbase){$maxbaseval="N";}  
 else{$maxbaseval=$oldbase;}  
 my $maxbaseval2=lc $maxbaseval;  
 if((($oldbase=~ /[Aa]/)&&($jellyA[1]==0))||(($oldbase=~ /[Cc]/)&&($jellyC[1]==0))||(($oldbase=~ /[Gg]/)&&($jellyG[1]==0))||(($oldbase=~ /[Tt]/)&&($jellyT[1]==0))){  
 print LOGS "$scaf\t$pos\t$pos\t$maxbaseval\t$oldbase.\t$jellyA[1]\t$jellyC[1]\t$jellyG[1]\t$jellyT[1]\t$jellyN[1]\tzero\t$totalreads\n";  
 my $key=">" . $scaf;  
 my $prepos=$pos-1;#1 based positions  
 substr($seqs{$key},$prepos,1)= $maxbaseval;  
 }  
 elsif((($oldbase=~ /[Aa]/)&&($jellyA[1]<$maxbasepercent))||(($oldbase=~ /[Cc]/)&&($jellyC[1]<$maxbasepercent))||(($oldbase=~ /[Gg]/)&&($jellyG[1]<$maxbasepercent))||(($oldbase=~ /[Tt]/)&&($jellyT[1]<$maxbasepercent))){  
 print LOGS "$scaf\t$pos\t$pos\t$maxbaseval\t$oldbase.\t$jellyA[1]\t$jellyC[1]\t$jellyG[1]\t$jellyT[1]\t$jellyN[1]\tpercent\t$totalreads\n";  
 my $key=">" . $scaf;  
 my $prepos=$pos-1;#1 based positions  
 substr($seqs{$key},$prepos,1)= $maxbaseval;  
 }  
     }  
  }#end of while loop  
 close FASTA2;  
 my $iso;  
 foreach $iso (sort keys %seqs) {  
 print "$iso\n$seqs{$iso}\n";  
 }  

 print LOGS "$totalcount\n";  
 close LOGS;  
