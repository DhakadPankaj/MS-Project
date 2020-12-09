table <- commandArgs(trailingOnly=TRUE)
p_val <- read.table(table)
p_vec <- as.vector(t(p_val)[4,])
p_corr<-p.adjust(p_vec, method = "BH")
p_val[,5] <- p_corr
write.table(p_val,"HyPhy_result.tsv",sep = "\t", col.names = c("Test","Reference","K_val","P_val","P_adjusted"), row.names = FALSE)
