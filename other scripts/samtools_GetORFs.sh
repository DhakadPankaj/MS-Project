#!/bin/bash

#Extract ORFs from blast output (SAM file).

for i in *.fa
do 
samtools faidx $i

for j in *.sam
do

x=`grep ">" "$i"|sed 's/>//g'`
y=`awk '/@SQ/ {gsub("SN:","",$2); print $2}' "$j"`

if [ "$x" = "$y" ]
then 

#sam to bam (with sorting)
samtools view -bt "$i".fai  "$j"|samtools sort -o "$j"_sort.bam 

#samtools indexing
samtools index "$j"_sort.bam  "$j"_sort.bam.bai

#extract gene sequence from alignment file 
samtools mpileup -uf $i "$j"_sort.bam | bcftools call -c | vcfutils.pl vcf2fq > "$j".fq

fi
done
done
