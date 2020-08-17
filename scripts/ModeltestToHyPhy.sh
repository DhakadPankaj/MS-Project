#!/bin/bash



modeltest-ng -i PRANK.aln -o PRANK_modeltest

model=$(awk '{if($1=="BIC"){print $2}}' PRANK_modeltest.log| tail -1 )
echo $model

mkdir Modeltest_files

mv PRANK_modeltest* Modeltest_files/

raxml-ng --all --msa PRANK.aln --model $model --bs-trees 1000 --threads 1 --prefix trees

raxml-ng --consense MR --tree trees.raxml.bootstraps --prefix cons

nw_topology trees.raxml.bootstraps | nw_order - | sort | uniq -c | sort -n >> Reordered_topology.txt


nw_topology trees.raxml.bootstraps | nw_order - | sort | uniq -c | sort -n | tail -3 | awk '{print $2}' >> top_topology.nw


nw_topology boot.raxml.bootstraps | nw_order - | sort | uniq -c | sort -n | grep "1 " | shuf -n 3 |awk '{print $2}' >> bad_topology.nw

mkdir raxml_output
mv trees.raxml* raxml_output/

cat top_topology.nw bad_topology.nw | awk '{gsub("Loxodonta_africana","Loxodonta_africana{Foreground}",$0); print $0}' > input_topologies.nw


count=0
for i in $(cat input_topologies.nw)
do
let count=count+1
cp PRANK.aln temp.aln
echo $i >> temp.aln
HYPHYMPI hyphy.txt
mv temp.aln.RELAX.json "$count"_topology.RELAX.json
pval=$(awk '/"p-value"/{gsub(":","\n",$1);gsub(",","",$1); print $1 }' "$count"_topology.RELAX.json| tail -1)
kval=$(awk '/"relaxation or intensification parameter":/{gsub(":","\n",$0);gsub(",","",$0); print $0 }' "$count"_topology.RELAX.json| tail -1)
mv messages* "$count"_topology.log
tree=$(echo $i|awk '{gsub("{Foreground}","",$1); print $1}')
echo $count" "$tree" "$pval" "$kval >> plot_hyphy.txt
rm temp.aln
done

mkdir HyPhy_output

mv *topology.log HyPhy_output/

mv *_topology.RELAX.json HyPhy_output/

mv plot_hyphy.txt HyPhy_output/
