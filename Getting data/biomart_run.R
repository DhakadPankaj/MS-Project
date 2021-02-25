library(biomaRt)

TID<-commandArgs(trailingOnly=TRUE)

mart <- useMart("ensembl", dataset="hsapiens_gene_ensembl")
seq <- getSequence(id=TID[1],seqType="coding", type="ensembl_transcript_id",mart = mart)

exportFASTA(seq,file=paste(TID[2],"/ncbi_dataset/data/",TID[1],"ref.fa", sep = ""))
