~/referee-1.1.21/helper-scripts/./bam_split.sh -b $1 -f ~/viplav/DNM1/Chlorocebus_sabaeus_genome/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -a
wait
cd /workdit/new-referee/bamsplit-angsd
for i in `ls -1 *glf.gz`
do
python ~/referee-1.1.21/referee.py -gl $i -ref ~/viplav/DNM1/Chlorocebus_sabaeus_genome/GCF_000409795.2_Chlorocebus_sabeus_1.1_genomic.fna -p 16 --correct -o "${i%.glf.gz}"-referee-corrected
done
