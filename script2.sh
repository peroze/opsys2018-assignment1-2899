#!/bin/bash

mkdir -p uncommpressed
tar xf $1 -C uncommpressed
mkdir -p assignments  
files="$(find uncommpressed/ -name "*.txt")"
for i in $files; 
do
	exec < $i
	while read line;
	do
 		if [[ $line = https* ]] ; then
		(  # Ανοίγω παρενθέσεις για να αλλάξω προσορινά το $PWD 
		cd assignments
		(git clone $line  &> /dev/null  && echo $line": Cloning OK" ) || <&2 echo $line": Cloning FAILED"  || echo $line": Cloning OK"
		)  
		break  
 		fi
done
done
cd assignments
repos="$(find -maxdepth 1 -mindepth 1 -type d)"
for i in $repos
do
	echo $i:
	dicts=$(find $i/ -mindepth 1 -type d | wc -l)
	txts=$(find $i/ -mindepth 1 -name "*.txt" | wc -l)
	temp=$(find $i/ -mindepth 1 -type f | wc -l)
	oths=$(($temp-$txts))
	echo Number of directories: $dicts
	echo Number of txt files: $txts
	echo Number of other files: $oths
	cordarA=$(find $i/ -maxdepth 1 -name "dataA.txt" | wc -l)
	cormor=$(find $i/ -maxdepth 1 -type d -name "more" | wc -l)
	if [ $cormor -eq 0 ] || [ $cordarA -eq 0 ] ; 
	then 
		echo Directory structure is NOT OK
	else
		cordatB=$(find $i/more/ -mindepth 1 -name "dataB.txt" | wc -l)
		cordatC=$(find $i/more/ -mindepth 1 -name "dataC.txt" | wc -l)
		if [ $cordatB -eq 0 ] || [ $cordatC -eq 0 ] ; 
		then 
			echo Directory structure is NOT OK
		else
			echo Directory structure is OK
		fi
	fi
done
