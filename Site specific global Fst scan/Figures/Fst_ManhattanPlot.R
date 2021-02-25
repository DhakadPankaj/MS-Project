library(dplyr)
library(ggplot2)

ManhattanPlot<-function(Allchr_50K_window_counts, ytitle)
  {Allchr_50K_window_counts[,5]<-0.5*(Allchr_50K_window_counts[,2]+Allchr_50K_window_counts[,3])

nCHR <- length(unique(Allchr_50K_window_counts$V1))
Allchr_50K_window_counts$BPcum <- NA
s <- 0
nbp <- c()
for (i in unique(Allchr_50K_window_counts$V1)){
  nbp[i] <- max(Allchr_50K_window_counts[Allchr_50K_window_counts$V1 == i,]$V3)
  Allchr_50K_window_counts[Allchr_50K_window_counts$V1 == i,"BPcum"] <- Allchr_50K_window_counts[Allchr_50K_window_counts$V1 == i,"V5"] + s
  s <- s + nbp[i]
}

axis.set <- Allchr_50K_window_counts %>%
  group_by(V1) %>%
  summarize(center = (max(BPcum) + min(BPcum)) / 2)
ylim <- max(Allchr_50K_window_counts$V4) + 0.02


ggplot(data = subset(Allchr_50K_window_counts, subset = V4 != 0), aes(x = BPcum,y = V4, shape = 20,size = 0.4 ,color = as.factor(V1)))+
  geom_point(alpha = 0.50) +
  geom_hline(yintercept = min(Allchr_50K_window_counts[which(ntile(Allchr_50K_window_counts$V4,10000)==10000),4]),colour="#990000", linetype="dashed")+
  scale_x_continuous(label = axis.set$V1, breaks = axis.set$center) +
  scale_y_continuous(expand = c(0,0), limits = c(0, ylim)) +
  scale_color_manual(values = rep(c("#008600","#00CE00"), nCHR)) +
  scale_shape_identity()+
  scale_size_identity()+
  labs(x = NULL,
       y = ytitle) +
  theme_minimal() +
  theme(
    legend.position = "none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(angle = 90, size = 8,face = "bold", vjust = 0.1)
  )
}
