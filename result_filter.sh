
for i in */ncbi_dataset/data/

do

cd $i

gene=$(echo $i|tr -d "/ncbi_datase/data/")

echo $gene"	"$(cat *corrected.fa|grep ">"|awk '{gsub("__.*","",$0);print $0}'|sort -u|wc -l) >> ../../../count.txt

cd ../../..

done




while read line
do
cov=$(echo $line|tr " " "	"| cut -f2)
if [ $cov -ge 10 ]
then
echo $line >> correct_gene.txt
fi
done < <(cat count.txt)



mkdir Alignment
while read line
do 
gene=$(echo $line|tr " " "\t"| cut -f1)
echo $gene
mkdir Alignment/$gene
cp $gene/ncbi_dataset/data/*corrected.fa Alignment/$gene
done < <(cat correct_gene.txt)
