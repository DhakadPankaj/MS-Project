for i in *.gz
do

zcat $i|sed -n '1~4s/^@/>/p;2~4p' > ${i%.fastq.gz}.fa

done


for f in 'ls -1 *.fa'
do

makeblastdb -in $f -out $f -dbtype nucl

done


for i in *.fa
do

blastn -task blastn -evalue 0.01 -db chlorocebus_sra_db -out blastn_"$i".out -num_threads 4 -outfmt 1 -query $i

done
