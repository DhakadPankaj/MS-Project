#!/bin/bash

cd ANGSD_african

~/samtools/./samtools faidx GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna

pop="African"

for i in $(cat contig-list.txt)
do

~/angsd/./angsd -GL 2 -ref GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -anc GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -dosaf 1 -baq 1 -C 50 -setMinDepthInd 4 -minInd 3 -minMapQ 30 -minQ 20 -b BAMlist_african.txt -r $i -nThreads 16 -out "$i"-"$pop"

~/angsd/misc/realSFS "$i"-"$pop".saf.idx -P 16 -fold 1 -r $i > "$i"-"$pop".sfs

done

wait

cd ../ANGSD_caribbean

~/samtools/./samtools faidx GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna

pop="Caribbean"

for i in $(cat contig-list.txt)
do

~/angsd/./angsd -GL 2 -ref GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -anc GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -dosaf 1 -baq 1 -C 50 -setMinDepthInd 4 -minInd 3 -minMapQ 30 -minQ 20 -b BAMlist_african.txt -r $i -nThreads 16 -out "$i"-"$pop"

~/angsd/misc/realSFS "$i"-"$pop".saf.idx -P 16 -fold 1 -r $i > "$i"-"$pop".sfs

done
