#Used to keep the specified tips in phylogenetic tree of primates obtained from Time Tree (http://www.timetree.org/).

library(ape)
Tl<-commandArgs(trailingOnly=TRUE)
S <-scan(Tl, character())
M<-read.tree("../primates_species.nwk")
N<-keep.tip(M,S)
write.tree(N,"trimmed_tree.nw")
