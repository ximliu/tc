#!/bin/bash
MAIL="71764912@qq.com"
MAIL2="80402620@qq.com"

#ping google 监测
for ip in $(cat /usr/mysys/checkAlive/ip_google_dns|sed "/^#/d")    #ip_list是当前目录下IP表
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
         echo -e "Date : $DATE\nHost : $ip\nProblem : Ping is failed." | mail -s "鑫互联506房间Ping google DNS 失败告警" -c $MAIL $MAIL2
     #else
     #    echo "$ip ping is successful."
     fi

#连接数监测
Current_conn=`cat /proc/sys/net/netfilter/nf_conntrack_count`
if [ $Current_conn -ge 50000 ]
then
   echo -e "$Date 506房间VPN设备连接数告警 \n当前连接数已经超过5W，请立刻检查是否有异常，现在为$Current_conn" | mail -s "鑫互联506房间连接数告警" -c $MAIL $MAIL2
fi

#设备存储空间监测
SPACE=`df -lh | grep 'sda2' | awk '{print $5}' | sed  's/%//'`
if [ $SPACE -ge 70 ]
then
   echo -e "$Date 506房间的空间超过70%，现在为$SPACE" | mail -s "鑫互联506房间VPN设备空间超过70%告警" -c $MAIL
fi
