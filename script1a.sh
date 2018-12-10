#!/bin/bash
while read line;
do
 if [[ $line = \#* ]] ; then 
	continue
 else 
	URL=$line
	currentfilename=${URL//\//_}_curr  # Ειχα με προβλημα με τα / στο URL οποτε για το ονομα των αρχείων χρησιμοποιώ το url με _ αντι για / 
	newfilename=${URL//\//_}_new
	if [ -f $newfilename.html ];   # Αν υπαρχει το αρχειο συμαινει οτι η ιστοσελιδα εχει αρχικοποιηθει 
	then
		curl -s $URL > $newfilename.html || >&2 echo ${URL}" FAILED" 
		if [ ! 0 -eq $?] ; # Εαν η curl απαίτυχε σύμφωνα με τις παραδοχές το αποθηκεύω για να βγάλει διαφοά αν τρέξη την επόμενη φορά οποτε τρέχω μονο την mv
		 then
			Difference="$(diff $newfilename.html $currentfilename.html)"
			if [ "0" != "${#Difference}" ] ;     
			then 
				echo $URL
			fi
		fi
		mv $newfilename.html $currentfilename.html
	else
		curl -s $URL > $currentfilename.html || >&2 echo ${URL}" FAILED"	
		echo  ${URL}" INIT"
	fi
 fi
done < "$1"
