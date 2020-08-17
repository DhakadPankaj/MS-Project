for i in */
do
cd $i

for x in *corrected.fa
do
perl ~/guidance.v2.02/www/Guidance/guidance.pl --program GUIDANCE --seqFile $x --msaProgram PRANK --seqType codon --outDir "$x"@ --genCode 1 --bootstraps 100

seqkit sort "$x"@/MSA.PRANK.aln.With_Names >"$x"_PRANK.aln
done
cd ..
done
