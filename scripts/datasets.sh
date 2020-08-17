#if datasets is not in bin
#./datasets download gene --inputfile GNAO1_ortholog_geneid.txt --filename GNAO1_ortholog_genes.zip

awk '{if(NR!=1){gsub(","," ",$1); print $1}}' $1 | awk '{print $1}' > geneid.txt

datasets download gene --inputfile geneid.txt --filename data_genes.zip

unzip data_genes.zip 

dir= pwd
echo $dir
cp ncbi_dataset/data/data_table.tsv ncbi_dataset/data/rna.fna $dir

