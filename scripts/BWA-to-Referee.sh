for i in $(ls -lrt|cut -d " " -f9|grep ".fastq.gz"|awk '{gsub("_1.fastq.gz","",$0);gsub("_2.fastq.gz","",$0);print $0}'|sort -u)
do
echo $i" starting"
gunzip "$i"_1.fastq.gz
gunzip "$i"_2.fastq.gz

java -jar ~/picard/build/libs/picard.jar CreateSequenceDictionary R=/home/nagarjun/viplav/DNM1/Chlorocebus_sabaeus_genome/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna O=reference.dict

~/bwa-0.7.17/bwa mem -t 16 ~/viplav/DNM1/Chlorocebus_sabaeus_genome/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna "$i"_1.fastq "$i"_2.fastq > reads-mapped-"$i".sam

java -jar ~/picard/build/libs/picard.jar ReplaceSamHeader I=reads-mapped-"$i".sam HEADER=reference.dict O=reads-mapped-"$i"-hd.sam
rm reads-mapped-"$i".sam
~/samtools-1.10/samtools sort -@16 reads-mapped-"$i"-hd.sam -o "$i"_aligned.bam
rm reads-mapped-"$i"-hd.sam
~/samtools-1.10/samtools index -b -@16 "$i"_aligned.bam

~/referee-1.1.21/helper-scripts/./bam_split.sh -b "$i"_aligned.bam -f ~/viplav/DNM1/Chlorocebus_sabaeus_genome/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -a
wait
cd ~/IKBIP_gene_selection_project/DNM1_SRA/Chloro_sab_WGS_SRA/khorana2/bamsplit-angsd
for i in `ls -1 *glf.gz`
do
python ~/referee-1.1.21/referee.py -gl *.glf.gz -ref ~/viplav/DNM1/Chlorocebus_sabaeus_genome/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -p 16 --correct -o "${i%.glf.gz}"-referee-corrected
done

done

#Referee-for-exonic-region
bedtools intersect -abam reads.bam -b exons.bed > reads.touchingExons.bam
~/referee-1.1.21/helper-scripts/./bam_split.sh -b $1 -f ~/viplav/DNM1/Chlorocebus_sabaeus_genome/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -a
wait
cd ~/IKBIP_gene_selection_project/DNM1_SRA/Chloro_sab_WGS_SRA/khorana2/bamsplit-angsd
for i in `ls -1 *glf.gz`
do
python ~/referee-1.1.21/referee.py -gl *.glf.gz -ref ~/viplav/DNM1/Chlorocebus_sabaeus_genome/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -p 16 --correct -o "${i%.glf.gz}"-referee-corrected
done
