#!/bin/bash
#author:liyubo
#
basepath=$(cd `dirname $0`; pwd)
cd $basepath

HOSTS=`cat list.txt`
#echo $HOSTS
UserName=$1
Passwd=$2
for host in $HOSTS
do
        echo $HOSTS
        expect -c "
            set timeout 5;
            spawn ssh-copy-id -i /root/.ssh/id_rsa.pub ${UserName}@${host}
            expect {
                     "yes/no" { send \"yes\r\"; exp_continue }
                     "password" { send \"${Passwd}\r\" }
                     "already" { exit }

             } ;
            expect eof
        "
done
