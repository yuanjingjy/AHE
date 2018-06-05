#!/bin/sh
path="L:/MinGW/msys/1.0/database/mimic2wdb/matched/"
cd $path  #change to the file directory

dir=$(ls -l $path | awk '/^d/ {print $NF}')

for i in $dir;do 
	index=${i:1:5}
	if [ $index -gt 12100 ]
	then
		cd $i
		echo "===========Processing $i=========="
		for filename in `ls *n.hea`;do
			for filename_n in  ${filename%%.*}; do 
				wfdb2mat -r $filename_n
			done
		done

		for filename_m in `ls *m.hea`;do
			mv $filename_m   L:/Available/$i
		done

		for filename_mat in `ls *m.mat`;do
			mv $filename_mat L:/Available/$i
		done

		cd ..
	fi
done
