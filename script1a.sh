#!/bin/bash
while read line;
do
 if [[ $line = \#* ]] ; then 
	continue
 else 
	URL=$line
	currentfilename=${URL//\//_}_curr  # Ειχα με προβλημα με τα / στο URL οποτε για το ονομα των αρχείων χρησιμοποιώ το url με _ αντι για / 
	newfilename=${URL//\//_}_new
	if [ -f $currentfilename.html ];   # Αν υπαρχει το αρχειο σημαίνει οτι η ιστοσελίδα έχει αρχικοποιηθεί 
	then	
		curl -s $URL > $newfilename.html || >&2 echo ${URL}" FAILED" 
		if [ -f $newfilename.html ] ; # Αν δεν υπάρχει το αρχείο τοτε η curl απέτυχε, επομένος εκτελώ μονο την mv για να αποθύκευθρί το κένο και να γράψει οτι εγινε αλλαγη την επομενη φορά
		then
			Difference="$(diff $newfilename.html $currentfilename.html)"
			if [ "0" != "${#Difference}" ] ;     
			then 
				echo $URL
			fi
		fi
		mv $newfilename.html $currentfilename.html
	else
		( curl -s $URL > $currentfilename.html && echo  ${URL}" INIT" ) || >&2 echo ${URL}" FAILED"	
	fi
 fi
done < "$1"
