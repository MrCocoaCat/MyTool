#!/bin/bash
#host user passwd
#
# 
cat list.txt | while read line
do  
	#echo $host
	arr=($line)
	host=${arr[0]}
	UserName=${arr[1]}
	Passwd=${arr[2]}
        echo $host $UserName $Passwd	
        #expect -c "  
        #    set timeout 5;  
	#		
	#    spawn ssh-copy-id -i /root/.ssh/id_rsa.pub iiebc@${host}
        #    expect {  
	#			\"yes/no\" { send \"yes\r\"; exp_continue } 			
        #        \"*assword\" { send \"iiecas\r\" }  
        #         
        #     } ;  
        #    expect eof 
       # "  
done 
