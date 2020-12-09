for p in */ncbi_dataset/data/

do

cd $p

for f in 6 9 12 15 18 21
do
for i in *ref.fa
do
len=$(awk '!/^>/{print length($1)}' $i|head -1)
echo $len
id=$(echo $i|tr -d "ref.fa")
echo $id
awk '!/^>/{if(length($1)<='`expr $len - $f`' || length($1)>='`expr $len + $f`'){print g}}/^>/{g=$1}' "$id"ref_ortho@.fa |awk '{gsub(">","",$0);print $0}' >> "$f"_exclude.txt

done

for x in *ref_ortho@.fa

do

grep -A1 -f "$f"_exclude.txt $x > rmfile.fa
grep -v -f rmfile.fa $x > "${x%.fa}"_"$f"_corrected.fa
rm rmfile.fa

done

done

cd ../../..

done
