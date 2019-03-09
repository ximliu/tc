#!/bin/bash
MAIL="71764912@qq.com"
for ip in $(cat /root/checkAlive/ip_google_dns|sed "/^#/d")    #ip_list是当前目录下IP表
  do
     ping -c 1 $ip &>/dev/null            #三个ping有一个能通，说明服务器正常
     a=$?
     sleep 2
     ping -c 1 $ip &>/dev/null
     b=$?
     sleep 2
     ping -c 1 $ip &>/dev/null
     c=$?
     sleep 2
done
     DATE=$(date +%F" "%H:%M)
     if [ $a -ne 0 -a $b -ne 0 -a $c -ne 0 ];then
         echo -e "Date : $DATE\nHost : $ip\nProblem : Ping is failed." | mail -s "Ping google DNS Failed $ip failed From xinhulian_gateway" $MAIL
     #else
     #    echo "$ip ping is successful."
     fi
