for i in  *_PRANK.aln
do

modeltest-ng -i $i -o "$i"modeltest

##To extract model from log file 
model=$(awk '{if($1=="BIC"){print $2}}' *log| tail -1)
echo $model
mkdir "$i"_modeltest_out 
mv "$i"modeltest* "$i"_modeltest_out 

~/raxml-ng_v0.9.0_linux_x86_64/raxml-ng --all --msa $i --model TrN+G4 --bs-trees 1000 --threads 6 --prefix 1k_boots

~/raxml-ng_v0.9.0_linux_x86_64/raxml-ng --consense MR --tree 1k_boot.raxml.bootstraps --prefix cons

mkdir "$i"_raxml_out

mv boot* cons* "$i"_raxml_out

done
