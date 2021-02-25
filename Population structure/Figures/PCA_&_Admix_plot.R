library(ggplot2)
library(RcppCNPy)
setwd("~/IKBIP_gene_selection_project/PCA/without_e2/")
Population<-c(rep("Caribbean",16),rep("African",16))
C <- as.matrix(npyLoad("./PCA_vervet.cov.npy"))
e <- eigen(C)

png(filename = "PCA_plot.png",width = 480,height = 450,res = 120)
ggplot(data = data.frame(e$vectors[,1:2]),aes(x = X1,y = X2,color = Population),
       xlab="PC1",ylab="PC2")+
       geom_point()+
       xlab("PC1")+
       ylab("PC2")+
       theme(legend.position = c(0.50,0.85))
dev.off()

q <- npyLoad("./PCA_vervet.admix.Q.npy")

## order according to population
png(filename = "Admixture_Plot.png")
barplot(t(q)[,1:32],col=c("#F8766D", "#00BFC4"),border = NA,space=0,
        xlab="Individuals", ylab="Admixture proportions")
text(tapply(1:length(Population),Population,mean),-0.05,unique(Population),
     xpd=T)
abline(v=cumsum(sapply(unique(Population), function(x){sum(Population==x)})),
       col=1,lwd=1.2)
dev.off()
