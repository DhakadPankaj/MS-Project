# R
library( SRAdb )
sra_dbname <- 'SRAmetadb.sqlite'
sra_con <- dbConnect(dbDriver("SQLite"), sra_dbname)
in_acc <- c()
links<-getFASTQinfo (in_acc, srcType='fasp',sra_con = sra_con)

for i in $(cat SRA-links.txt)
do
~/.aspera/connect/bin/./ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh $i ./
done
