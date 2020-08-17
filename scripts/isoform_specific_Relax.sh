mkdir Relax_results
mkdir Relax_logfiles
mkdir relax_json_files
mkdir relax_temp_files

modeltest-ng -i $1 -o "$1"modeltest

##To extract model from log file 
model=$(awk '{if($1=="BIC"){print $2}}' *log| tail -1)
echo $model
mkdir "$1"_modeltest_out 
mv "$1"modeltest* "$1"_modeltest_out 

~/raxml-ng_v0.9.0_linux_x86_64/raxml-ng --all --msa $1 --model TrN+G4 --bs-trees 1000 --threads 1 --prefix boot  

~/raxml-ng_v0.9.0_linux_x86_64/raxml-ng --consense MR --tree boot.raxml.bootstraps --prefix cons 

mkdir "$1"_raxml_out

mv boot* cons* "$1"_raxml_out

tree=$(cat "$1"_raxml_out/*TreeMR)

taxcount=`grep ">" "$1"|wc -l`
grep ">" "$1"|sed 's/>//g' > "$1"taxlist.txt

mkdir results_"$1"

for focal in `cat "$1"taxlist.txt`
do
backtaxlist=`grep -v "$focal" "$1"taxlist.txt|tr "\n" " "`

echo $tree|sed "s/$focal/$focal{Foreground}/g" > "$1"temp.tree
#for each set of background species create a tree file
for backs in `echo $backtaxlist|tr " " "\n"`
do
sed -i "s/$backs/$backs{back}/g" "$1"temp.tree
done
cat "$1" > focal_"$focal"_relax
cat "$1"temp.tree >> focal_"$focal"_relax
workdir=`pwd`
#Create a config file to run HYPHY
echo -ne "1\n7\n"$workdir"/focal_"$focal"_relax\n2\n2\n" > relax.config
#Run HYPHYMP
HYPHYMPI < relax.config > "$workdir"/results_"$1"/focal_"$focal"_relax.txt

pval=$(awk '/"p-value"/{gsub(":","\n",$1);gsub(",","",$1); print $1 }' focal_"$focal"_relax.RELAX.json| tail -1)
kval=$(awk '/"relaxation or intensification parameter":/{gsub(":","\n",$0);gsub(",","",$0); print $0 }' focal_"$focal"_relax.RELAX.json| tail -1)

mv messages* focal_"$focal".log
mv focal_"$focal".log Relax_logfiles

echo $focal"	"$pval"	"$kval>>Relax_results/"$1"_relax_results.txt

mv *.json relax_json_files
rm focal_"$focal"_relax
done
