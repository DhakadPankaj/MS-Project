#generating STAR ref genome

~/STAR-2.7.5c/source/STAR --runThreadN 4 --runMode genomeGenerate --genomeDir ~/IKBIP_gene_selection_project/DNM1_SRA/Chloro_sab_RNA_seq/STAR_ref_genome --genomeFastaFiles GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna  --sjdbGTFfile GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.gtf

#
for i in $(ls -lrt|cut -d " " -f10|grep ".fastq.gz"|awk '{gsub("_1.fastq.gz","",$0);gsub("_2.fastq.gz","",$0);print $0}'|sort -u)
do
echo $i" starting"
gunzip "$i"_1.fastq.gz
gunzip "$i"_2.fastq.gz

~/STAR-2.7.3a/source/./STAR --runMode alignReads --outSAMtype BAM SortedByCoordinate --genomeDir ~/viplav/DNM1/Chlorocebus_sabaeus_genome/STAR-rna-seq --outFileNamePrefix "$i"_rna- --readFilesIn  "$i"_1.fastq "$i"_2.fastq

samtools index -b -@16 "$i"_rna-Aligned-sorted.out.bam

done

#nohup ~/STAR-2.7.3a/source/./STAR --runMode alignReads --outSAMtype BAM SortedByCoordinate --genomeDir /workdirectory/STAR-RNAseq/STAR_ref_genome --outFileNamePrefix rna_map  --readFilesIn  *_1.fastq *_2.fastq --runThreadN 5 &

#nohup ~/STAR-2.7.3a/source/./STAR --runThreadN 8 --runMode genomeGenerate --genomeDir ~/viplav/DNM1/Chlorocebus_sabaeus_genome/STAR-rna-seq --genomeFastaFiles GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna  --sjdbGTFfile GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.gtf &

