for i in */ncbi_dataset/data/

do

cd $i
echo $i
> exclude.txt
for f in *ref.fa

do

id=$(echo $f|tr -d "ref.fa")

#echo $id


for g in $(cat "$id"ref_ortho@.fa|grep ">")

do
#echo $g
awk 'BEGIN{t=0}/'$g'/{print $0; t=1; next}/^>/{t=0}{if(t==1){print $0}}' "$id"ref_ortho@.fa > tmp.fa




b1=$(blastn -query $f -subject tmp.fa -outfmt "7 qcovs"|awk '!/^#/{print $1}'|tr "	" "\n"|sort -n|head -1)

b2=$(blastn -query tmp.fa -subject $f -outfmt "7 qcovs"|awk '!/^#/{print $1}'|tr "	" "\n"|sort -n|head -1)

b=$(echo -e "$b1\n$b2"|sort -n|head -1) 

if [ $b -le 98 ]
then

echo $g |awk '{gsub(">","",$0);print $0}'>> exclude.txt
 
fi

rm tmp.fa

done

done

for x in *ref_ortho@.fa

do

grep -A1 -f exclude.txt $x > rmfile.fa

grep -v -f rmfile.fa $x > "${x%.fa}"_corrected.fa

rm rmfile.fa

done

cd ../../..

done
