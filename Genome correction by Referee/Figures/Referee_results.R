library(dplyr)
library(ggplot2)

carib.merged.coverage.histogram$Lineage <- "Caribbean"
africa.merged.coverage.histogram$Lineage <- "African"
african.ALL.referee.result$Lineage<-"African"
carribean.ALL.referee.result$Lineage<-"Caribbean (downsampled)"
full.carribean.ALL.referee.result$Lineage<-"Caribbean (complete)"

combined_correction_threshold<-rbind(african.ALL.referee.result,carribean.ALL.referee.result,full.carribean.ALL.referee.result)
FigA<-ggplot(combined_correction_threshold,aes(x = V1,y = V2, color=Lineage))+
  geom_point()+
  geom_line()+
  xlab("Referee Quality score threshold")+
  ylab("Number of Corrections")+
  ggtitle("Number of bases corrected by referee by quality score threshold")+
  theme(panel.border = element_rect(colour = "black",
                                    fill=NA, size=0.65),
        axis.text.x = element_text(face="bold",
                                   color="black",
                                   size=8,
                                   hjust = 0.5),
        axis.text.y = element_text(face="bold",
                                   color="black",
                                   size=8),
        legend.position = c(0.75,0.85),
        title =   element_text(face="bold",
                               color="black",
                               size=9)

  )

unified.corrected.histogram<-rbind(carib.merged.coverage.histogram,africa.merged.coverage.histogram)
FigB<-ggplot(unified.corrected.histogram,aes(x=V1,y=V2,fill=Lineage))+
  geom_col(position = "dodge")+
  scale_x_discrete(limits=pos)+
  xlab("Coverage")+
  ylab("Number of Positions (Corrected)")+
  ggtitle("          Coverage distribution of corrected bases (coding region)")+
  theme(panel.border = element_rect(colour = "black",
                                    fill=NA, size=0.65),
        axis.text.x = element_text(face="bold",
                                   color="black",
                                   size=8,
                                   angle=45,
                                   hjust = 1),
        axis.text.y = element_text(face="bold",
                                   color="black",
                                   size=8),
        legend.position = c(0.8,0.85),
        title =   element_text(face="bold",
                               color="black",
                               size=9,
                               hjust = 0.5)
  )
FigA
FigB
