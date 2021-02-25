install.packages("ggrepel")
library(ggrepel)
library(ggplot2)
RELAXplot <- function(x){
  x$iso <- NA
  x$Significance <- NA
  for(i in unique(x$V1)){
    x[x$V1==i,"iso"]<-seq(15,14+length(subset(x,x$V1==i)$V1),by = 1)
    }
  x[x$V5<=1e-4,"Significance"]<-c("Significant")
  x[x$V5>1e-4,"Significance"]<-c("Non-Significant")
#return(x)
ggplot(data = x, aes(V4,-log10(V5),colour=Significance))+
  geom_point(shape=x$iso, size=2)+
  scale_color_manual(values = c("Non-Significant" = "black", "Significant"="red"))+
  labs(x = "K-value",
       y = "-log(p-value)")+
  geom_label_repel(data=subset(x,Significance=="Significant"),aes(label = V2),hjust=0, vjust=0)
  }
RELAXplot(Chlorocebus_allgene_table)
