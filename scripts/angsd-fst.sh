#!/bin/bash
#PBS -S /bin/bash
#PBS -N African
#PBS -l select=1:ncpus=16
#PBS -l walltime=72:00:00
#PBS -q hmq
#PBS -e sample-err.txt
#PBS -o sample-out.txt

cd $PBS_O_WORKDIR

NPROCS=`wc -l < $PBS_NODEFILE`

#SCRDIR=/scratch/sagars17/trilok

#mkdir -p $SCRDIR

module load  gcc/7.3.0
module load  java/11.0


cd /home2/sagars17/ANGSD_african/
#../samtools-1.9/samtools faidx -@16 /home2/sagars17/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna


java -version

for i in $(cat contig-list.txt)
do
pop="African"
/opt/apps/application/angsd/angsd -GL 2 -ref /home2/sagars17/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -anc /home2/sagars17/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -fold 1 -dosaf 1 -baq 1 -C 50 -setMinDepthInd 4 -minInd 3 -minMapQ 30 -minQ 20 -b BAMlist_african.txt -r $i  -nThreads 16 -out "$i"-"$pop"
/opt/apps/application/angsd/misc/realSFS "$i"-"$pop".saf.idx -r $i > "$i"-"$pop".sfs

/opt/apps/application/angsd/angsd -bam BAMlist_african.txt -out "$i"-"$pop" -doThetas 1 -doSaf 1 -pest "$i"-"$pop".sfs -fold 1 -GL 2 -baq 1 -C 50 -setMinDepthInd 4 -minInd 3 -minMapQ 30 -minQ 20 -nThreads 16 -r $i -anc /home2/sagars17/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -ref /home2/sagars17/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna
#Estimate for every Chromosome/scaffold
/opt/apps/application/angsd/misc/thetaStat do_stat "$i"-"$pop".thetas.idx
#Do a sliding window analysis based on the output from the make_bed command.
/opt/apps/application/angsd/misc/thetaStat do_stat "$i"-"$pop".thetas.idx -win 50000 -step 10000 -outnames "$pop".thetasWindow.gz

done
