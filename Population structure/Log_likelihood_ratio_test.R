LRT <- function(x){
  for(i in 1:(length(x)-1)){
    LR <- -2*(x[i]-x[i+1])
    p.val <- pchisq(LR, df = 1, lower.tail = FALSE)
    print(paste(i,"versus",i+1,p.val))
    }
}

LogLike<-c(-543703940.0,-496792580.0,-495431700.0,-495540900.0,-495547680.0,-495558500.0)
LRT(LogLike)
