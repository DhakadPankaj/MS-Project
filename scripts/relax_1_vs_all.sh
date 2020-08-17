mkdir Relax_results
mkdir Relax_logfiles
mkdir relax_json_files

for i in  *_PRANK.aln
do

modeltest-ng -i $i -o "$i"modeltest

##To extract model from log file 
model=$(awk '{if($1=="BIC"){print $2}}' *log| tail -1)
echo $model
mkdir "$i"_modeltest_out 
mv "$i"modeltest* "$i"_modeltest_out 

~/raxml-ng_v0.9.0_linux_x86_64/raxml-ng --all --msa $i --model $model --bs-trees 1000 --threads 4 --prefix boot 

~/raxml-ng_v0.9.0_linux_x86_64/raxml-ng --consense MR --tree boot.raxml.bootstraps --prefix cons

mkdir "$i"_raxml_out

mv boot* cons* "$i"_raxml_out


tree=$(cat "$i"_raxml_out/*TreeMR)

taxcount=`grep ">" "$i"|wc -l`
grep ">" "$i"|sed 's/>//g' > "$i"taxlist.txt

mkdir results_"$i"

for focal in `cat "$i"taxlist.txt`
do
backtaxlist=`grep -v "$focal" "$i"taxlist.txt|tr "\n" " "`

echo $tree|sed "s/$focal/$focal{Foreground}/g" > "$i"temp.tree
#for each set of background species create a tree file
for backs in `echo $backtaxlist|tr " " "\n"`
do
sed -i "s/$backs/$backs{back}/g" "$i"temp.tree
done
cat "$i" > focal_"$focal"_relax
cat "$i"temp.tree >> focal_"$focal"_relax
workdir=`pwd`
#Create a config file to run HYPHY
echo -ne "1\n7\n"$workdir"/focal_"$focal"_relax\n2\n2\n" > relax.config
#Run HYPHYMP
HYPHYMPI < relax.config > "$workdir"/results_"$i"/focal_"$focal"_relax.txt

pval=$(awk '/"p-value"/{gsub(":","\n",$1);gsub(",","",$1); print $1 }' focal_"$focal"_relax.RELAX.json| tail -1)
kval=$(awk '/"relaxation or intensification parameter":/{gsub(":","\n",$0);gsub(",","",$0); print $0 }' focal_"$focal"_relax.RELAX.json| tail -1)

mv messages* focal_"$focal".log
mv focal_"$focal".log Relax_logfiles

echo $focal"	"$pval"	"$kval>>Relax_results/"$i"_relax_results.txt

mv *.json relax_json_files
rm focal_"$focal"_relax
done


done
