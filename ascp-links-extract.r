library( SRAdb )
sra_dbname <- 'SRAmetadb.sqlite'
sra_con <- dbConnect(dbDriver("SQLite"), sra_dbname)
in_acc <- c()
links<-getFASTQinfo (in_acc, srcType='fasp',sra_con = sra_con)
