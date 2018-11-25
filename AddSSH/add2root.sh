#!/bin/bash
#
#

cd $(dirname $0)
HOSTS=`cat list.txt`
#echo $HOSTS
UserName=$1
Passwd=$2
for host in $HOSTS
do
      echo $host
      expect -c "
          set timeout 5;

          spawn ssh-copy-id -i /root/.ssh/id_rsa.pub ${UserName}@${host}
          expect {
                      "yes/no" { send \"yes\r\"; exp_continue }
              	      "*assword" { send \"${Passwd}\r\" }
  	                  "already" { exit }
           } ;
          expect eof
      "

      # move keys to root
      expect -c "
      	 set timeout 5
      	 spawn ssh -t ${UserName}@$host sudo mkdir -p /root/.ssh/
      	 expect {
                    	"*assword" { send \"${Passwd}\r\" }
      	  } ;
         spawn ssh -t ${UserName}@$host sudo cp /home/iiebc/.ssh/authorized_keys /root/.ssh/
         expect {
                    	"*assword" { send \"${Passwd}\r\" }
       	  } ;
      	 expect eof
      "
      # add flag.txt
      #ssh $HOSTS "sudo mkdir -p /opt/xnuca/;touch /opt/xnuca/flag.txt"
done
