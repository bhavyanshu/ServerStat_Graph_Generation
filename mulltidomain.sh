#!/bin/bash       
echo "
#title           :benchmark.sh
#author		 :Bhavyanshu Parasher (bhavyanshu.spl@gmail.com)
#description     :Bash script to benchmark one or many webservers and plot the results into an image.
#date            :20130716
#version         :0.1    
#usage		 :bash benchmark.sh or (sh benchmark.sh)
#notes           :Refer to the README for more info or visit github project page (https://github.com/bhavyanshu/ServerStat_Graph_Generation).
#==============================================================================#"

total=50
concurrent=5
i=0


while [ $i -lt 1 ]
do

what="http://domain1.com/,http://domain2.com/" #Two domains example.You can add as many as you like by seperating by comma. 
  
	if [ -z "${what}" ];
	then
	echo "You did not specify a webserver to benchmark!"
	else
	OIFS=$IFS
	IFS=','
	arr=$what
	counter=0
	echo "set term png transparent truecolor" >> _temp.txt
	#echo "set terminal png" >> _temp.txt
	echo "set output 'out.png'" >> _temp.txt
	echo "set title 'Webserver' tc rgb 'green' font 'Times-Roman, 20'" >> _temp.txt
	echo "set size 1,1" >> _temp.txt
	
	echo "set key left top tc rgb 'black' " >> _temp.txt
	echo "set grid y " >> _temp.txt
	echo "set xlabel 'Requests' font 'Times-Roman, 25' tc rgb 'green'" >> _temp.txt
	echo "set ylabel 'Response time (ms)' font 'Times-Roman, 25' tc rgb 'green'" >> _temp.txt
	echo "set xtics font 'Times-Roman, 20' tc rgb 'green'" >> _temp.txt
	echo "set ytics font 'Times-Roman, 20' tc rgb 'green'" >> _temp.txt
	echo "set object 1 rectangle from graph 0, graph 0 to graph 1, graph 1 behind fc rgbcolor 'gray' fs noborder" >> _temp.txt
	plot="plot"
		for x in $arr
		do
				echo "> Running benchmark for $x"
				if [ "$counter" -gt 0 ];
				then
				plot=$plot","
				fi			     
				plot=$plot" 'benchmark_server_data_$counter.dat' using 10 smooth sbezier with lines title '$x' lc rgb 'blue'" #Need to change the color of curve for different domains. Help needed!
				ab -n $total -c $concurrent -k -g benchmark_server_data_$counter.dat -H 'Accept-Encoding:gzip,deflate' $x			
				counter=$(( counter + 1 ))		
			
		done
	IFS=$OIFS
	echo $plot >> _temp.txt
	gnuplot _temp.txt
	rm _temp.txt
	rm benchmark_server_data_*
	exit
	fi

i=1
done
