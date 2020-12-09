mkdir Relax_logfiles
mkdir relax_temp_files


taxcount=`grep ">" "$1"_PRANK.aln|wc -l`
grep ">" "$1"_PRANK.aln|sed 's/>//g' > "$1"_taxlist.txt

mkdir results_"$1"

Rscript ~/IKBIP_gene_selection_project/scripts/Relax_tree.r $1_taxlist.txt

tree=$(cat trimmed_tree.nw)

for focal in `cat $1_taxlist.txt`

do

backtaxlist=`grep -v "$focal" $1_taxlist.txt|tr "\n" " "`
ref=$(echo $backtaxlist|tr " " ",")
echo $tree|sed "s/$focal/$focal{Foreground}/g" > $1_temp.tree
#for each set of background species create a tree file
for backs in `echo $backtaxlist|tr " " "\n"`
do

sed -i "s/$backs/$backs{back}/g" $1_temp.tree
done
cat "$1"_PRANK.aln > "$focal"_tree_labelled
cat $1_temp.tree >> "$focal"_tree_labelled
workdir=`pwd`
#Create a config file to run HYPHY
echo -ne "14\n9\n1\n"$workdir"/"$focal"_tree_labelled\ny\n2\n2\n1\n" > $1_relax.config
#Run HYPHYMPI
HYPHYMP < $1_relax.config > "$workdir"/results_"$1"/results.focal_"$focal".txt

pval=$(awk '/"p-value"/{gsub(":","\n",$1);gsub(",","",$1); print $1 }' "$focal"_tree_labelled.RELAX.json| tail -1)

kval=$(awk '/"relaxation or intensification parameter":/{gsub(":","\n",$0);gsub(",","",$0); print $0 }' "$focal"_tree_labelled.RELAX.json| tail -1)

#mv messages* focal_"$focal".log
mv focal_"$focal".log Relax_logfiles

mv "$focal"_tree_labelled.RELAX.json results_"$1"/
echo $focal"	"$ref"	"$kval"	"$pval >> "$1"_plot_hyphy.txt


done

Rscript ~//IKBIP_gene_selection_project/scripts/p_value_multiple_correc.R "$1"_plot_hyphy.txt

mv HyPhy_result.tsv "$1"_HyPhy_result.tsv



rm $1_temp.tree

rm $1_taxlist.txt
