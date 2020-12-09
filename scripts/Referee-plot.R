carribean.ALL.referee.result$Lineage <- c("Caribbean","Caribbean","Caribbean","Caribbean","Caribbean","Caribbean","Caribbean","Caribbean","Caribbean","Caribbean","Caribbean","Caribbean","Caribbean")
african.ALL.referee.result$Lineage<-c("African","African","African","African","African","African","African","African","African","African","African","African","African")
Africa.coding.plot.referee.result$Lineage<-c("African (coding)")
Africa.noncoding.plot.result.referee$Lineage<-c("African (non-coding)")
carrib.coding.plot.referee.result$Lineage<-c("Caribbean (coding)")
carrib.noncoding.plot.result.referee$Lineage<-c("Caribbean (non-coding)")
Africa.coding.plot.referee.result$Correct <- Africa.coding.plot.referee.result$V2/260576306
carrib.coding.plot.referee.result$Correct <- carrib.coding.plot.referee.result$V2/260576306
Africa.noncoding.plot.result.referee$Correct <-Africa.noncoding.plot.result.referee$V2/2529080022
carrib.noncoding.plot.result.referee$Correct <- carrib.noncoding.plot.result.referee$V2/2529080022

CvsNC <- rbind(Africa.coding.plot.referee.result,Africa.noncoding.plot.result.referee,carrib.coding.plot.referee.result,carrib.noncoding.plot.result.referee)

ggplot(data = CvsNC,aes(V1,Correct,color=Lineage))+
  geom_point()+
  geom_line()+
  xlab("Referee quality score threshold")+
  ylab("Number of corrections")+ ylim(c(0,0.0001)) +
  xlim(c(50, 90))+
  theme(legend.position = c(0.78,0.83))


full.carribean.ALL.referee.result$Lineage<-c("Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean","Complete_Caribbean") 
referee <- rbind(carribean.ALL.referee.result,african.ALL.referee.result,full.carribean.ALL.referee.result)
#african.ALL.referee.result$V3 <- NULL
#carribean.ALL.referee.result$V3 <- NULL
ggplot(data = referee,aes(V1,V2,color=Lineage))+
  geom_point()+
  geom_line()+
  xlab("Referee quality score threshold")+
  ylab("Number of corrections")+
  theme(legend.position = c(0.8,0.85))

ggplot(data = carib.merged.coverage.referee.result)+
 geom_histogram(aes(V1), breaks=c(seq(0, 290, by=10), max(carib.merged.coverage.referee.result$V1)),position = "identity")+ 
  xlim(c(0,300))+ylim(c(0,300))

