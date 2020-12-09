for i in $(cat Gene_sybol_Id_transcripts.txt|cut -d $'\t' -f 1)

do

mkdir $i

iso=$(cat Gene_sybol_Id_transcripts.txt|grep $i|cut -d $'\t' -f 3,4|tr "\t" "\n"|tr " " "\n"|wc -l)
echo "iso="$iso

for j in $(cat primates_taxid.txt)

do

./datasets gene-descriptors symbol $i --taxonomy $j > gene_des.tmp
cds=$(cat gene_des.tmp|tr "," "\n"|grep "cds"|wc -l)

if [[ $cds -ge $iso ]]
then

id=$(cat gene_des.tmp|tr "," "\n"|grep '"gene_id"'|cut -d ":" -f 2 |tr -d "\"") 

name=$(cat gene_des.tmp|tr "," "\n"|grep '"taxname"'|cut -d ":" -f 2 |tr -d "\""|tr " " "_")

echo $id >> ./$i/"$i"_Gene_id.txt

echo $name"	"$id >> ./$i/"$i"_taxname_geneid.txt

fi

rm gene_des.tmp

done

./datasets download gene --inputfile ./$i/"$i"_Gene_id.txt --filename ./$i/"$i"_ortholog_genes.zip

unzip -d ./$i/ ./$i/"$i"_ortholog_genes.zip

if test -f $i/ncbi_dataset/data/rna.fna

then

for f in $(cat Gene_sybol_Id_transcripts.txt|grep "$i"|cut -d $'\t' -f 3,4)

do
Rscript ~/IKBIP_gene_selection_project/scripts/biomart_run.r $f $i
done

cd $i/ncbi_dataset/data/

~/IKBIP_gene_selection_project/scripts/GetORFs.sh

cd ../../..

fi

done 


