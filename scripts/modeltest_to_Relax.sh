mkdir Relax_results
mkdir Relax_logfiles
mkdir relax_json_files
mkdir relax_temp_files

for i in  *_PRANK.aln
do

modeltest-ng -i $i -o "$i"modeltest

##To extract model from log file 
model=$(awk '{if($1=="BIC"){print $2}}' *log| tail -1)
echo $model
mkdir "$i"_modeltest_out 
mv "$i"modeltest* "$i"_modeltest_out 

~/raxml-ng_v0.9.0_linux_x86_64/raxml-ng --all --msa $i --model $model --bs-trees 1000 --threads 6 --prefix boot 

~/raxml-ng_v0.9.0_linux_x86_64/raxml-ng --consense MR --tree boot.raxml.bootstraps --prefix cons

mkdir "$i"_raxml_out

mv boot* cons* "$i"_raxml_out


tree=$(cat "$i"_raxml_out/*TreeMR)

taxcount=`grep ">" "$i"|wc -l`
grep ">" "$i"|sed 's/>//g' > taxlist.txt

mkdir results_"$i"

for focal in `cat taxlist.txt`
do
loopend=`echo $taxcount|awk '{print $1-2}'`
backtaxlist=`grep -v "$focal" taxlist.txt|tr "\n" " "`
for count in $(seq 1 $loopend);
do
echo $count
combcount=1
#getComb.pl is a perl script to get all possible combinations taking n taxa at a time
for back in `~/Diferential-selection/scripts/getCombs.pl $count $backtaxlist|tr " " "-"`
do
echo $tree|sed "s/$focal/$focal{Foreground}/g" > temp.tree
#for each set of background species create a tree file
for backs in `echo $back|tr "-" "\n"`
do
sed -i "s/$backs/$backs{back}/g" temp.tree
done
cat "$i" > focal_"$focal".comb_$count.comback_"$combcount"_
cat temp.tree >>focal_"$focal".comb_$count.comback_"$combcount"_
workdir=`pwd`
#Create a config file to run HYPHY
echo -ne "1\n7\n"$workdir"/focal_"$focal".comb_$count.comback_"$combcount"_\n2\n2\n" > relax.config
#Run HYPHYMP
HYPHYMPI < relax.config > "$workdir"/results_"$i"/focal_"$focal".comb_$count.comback_"$combcount"_.txt

pval=$(awk '/"p-value"/{gsub(":","\n",$1);gsub(",","",$1); print $1 }' focal_"$focal".comb_$count.comback_"$combcount"_.RELAX.json| tail -1)
kval=$(awk '/"relaxation or intensification parameter":/{gsub(":","\n",$0);gsub(",","",$0); print $0 }' focal_"$focal".comb_$count.comback_"$combcount"_.RELAX.json| tail -1)

mv messages* focal_"$focal".comb_$count.comback_"$combcount".log
mv focal_"$focal".comb_$count.comback_"$combcount".log Relax_logfiles

echo $focal"	"$back"	"$count"	"$combcount"	"$pval"	"$kval>>Relax_results/"$i"_relax_results.txt

mv *.json relax_json_files
mv focal_"$focal".comb_$count.comback_"$combcount"_  relax_temp_files
combcount=`echo $combcount|awk '{print $1+1}'`
done
done
done


done
