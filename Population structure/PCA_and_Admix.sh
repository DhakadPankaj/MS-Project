#!/bin/bash

~/angsd/./angsd -GL 2 -out genolike -nThreads 10 -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1  -bam bam.filelist

PCANGSD=~/pcangsd/pcangsd.py

for i in {1..6}
do

python $PCANGSD -beagle genoLike.beagle.gz -admix -admix_K $i -threads 6 -o PCA_vervet

done
