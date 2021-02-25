#!/bin/bash

for i in *African.saf.idx
do

~/angsd/misc/realSFS $i ${i%African.saf.idx}Caribbean.saf.idx -P 6 -fold 1 > ${i%African.saf.idx}2DSFS.ml
~/angsd/misc/realSFS fst index $i ${i%African.saf.idx}Caribbean.saf.idx -sfs ${i%African.saf.idx}2DSFS.ml -P 6 -fstout ${i%African.saf.idx}
~/angsd/misc/realSFS fst stats2 ${i%African.saf.idx}.fst.idx -win 1000 -step 100 -P 6 > ${i%African.saf.idx}1k-100.window
~/angsd/misc/realSFS fst stats2 ${i%African.saf.idx}.fst.idx -win 1000 -step 1000 -P 6 > ${i%African.saf.idx}1k-1k.window
~/angsd/misc/realSFS fst stats2 ${i%African.saf.idx}.fst.idx -win 1 -step 1 -P 6 > ${i%African.saf.idx}persite.window
~/angsd/misc/realSFS saf2theta ${i%African.saf.idx}Caribbean.saf.idx -outname ${i%African.saf.idx}Caribbean -sfs ${i%African.saf.idx}Caribbean.sfs -fold 1
~/angsd/misc/realSFS saf2theta $i -outname ${i%African.saf.idx}African -sfs ${i%African.saf.idx}African.sfs -fold 1
~/angsd/misc/thetaStat do_stat ${i%African.saf.idx}African.thetas.idx -win 1 -step 1 -outnames ${i%African.saf.idx}African.theta.thetasWindow.gz
~/angsd/misc/thetaStat do_stat ${i%African.saf.idx}Caribbean.thetas.idx -win 1 -step 1 -outnames ${i%African.saf.idx}Caribbean.theta.thetasWindow.gz

done
