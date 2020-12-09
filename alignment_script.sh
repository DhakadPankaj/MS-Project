for i in PRANK MUSCLE CLUSTALW MAFFT
 
do

perl ~/guidance.v2.02/www/Guidance/guidance.pl --program GUIDANCE --seqFile $1 --msaProgram $i --seqType codon --outDir "$1"_"$i" --genCode 1 --bootstraps 100

seqkit sort "$1"_"$i"/MSA."$i".aln.With_Names > "$1"_"$i".aln
done

mumsa -g -s "$1"_PRANK.aln "$1"_MUSCLE.aln "$1"_CLUSTALW.aln "$1"_MAFFT.aln >> "$1"_mumsa_QC.log

