awk 'BEGIN{FS="PREDICTED: "}{if($1~">"){gsub(">","");print ">"$2"_"$3} else {print $0}}' file|awk '{if($1~">") {gsub("IKBKB","iso1", $3); print $1" "$2" "$3} else {print $0}}'|awk '{if($1~">") {gsub(" ","_", $0); print $1} else {print $0}}'  > temp.fa

