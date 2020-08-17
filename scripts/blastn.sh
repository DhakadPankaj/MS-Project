for i in `ls -1 *.f*a`

do

blastn -task blastn -evalue 0.0001 -db $i -out ~/Project/tpm4_gene/blast_output/"$i"_TPM4_201_hits -num_threads 6 -outfmt 6 -query /home/pd16/Project/tpm4_gene/iso2_TPM4_201_sequence.fa

blastn -task blastn -evalue 0.0001 -db $i -out ~/Project/tpm4_gene/blast_output/"$i"_TPM4_202_hits -num_threads 6 -outfmt 6 -query /home/pd16/Project/tpm4_gene/iso1_TPM4_202_sequence.fa

done

