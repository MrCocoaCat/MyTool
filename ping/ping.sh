#!/bin/bash
HOSTS=`cat list.txt`
#echo $HOSTS
for host in $HOSTS  
do  
	echo "${host} \c"
	ping -c 5 -i 0.5 ${host}|grep loss
done 
