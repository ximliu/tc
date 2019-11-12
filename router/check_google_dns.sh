#!/bin/bash
MAIL="71764912@qq.com"
MAIL2="zcm8483@163.com"
Client="Client_name"
DATE=$(date +%F" "%H:%M)
COUNT=`cat /root/checkAlive/count.txt`

#连接数监测
Current_conn=`cat /proc/sys/net/netfilter/nf_conntrack_count`
if [ $Current_conn -ge 50000 ]
then
   echo -e "$DATE $Client 当前连接数为$Current_conn" | mail -s "$Client 连接数为$Current_conn" -c $MAIL $MAIL2
fi
echo "$DATE $Client 当前连接数为$Current_conn" >> /var/log/VpnServer.log

#设备存储空间监测
SPACE=`df -lh | grep 'sda1' | awk '{print $5}' | sed  's/%//'`
if [ $SPACE -ge 70 ]
then
   echo -e "$DATE $Client 现在磁盘使用量为$SPACE" | mail -s "$Client 空间超过70%告警" -c $MAIL $MAIL2
fi

echo "$DATE $Client              当前磁盘存储使用量% $SPACE "  >> /var/log/VpnServer.log

ping_result=$(ping -i 0.2 -c 100 www.google.com)
#丢包率
packet=$(echo $ping_result | grep "packet loss" | awk -F ',' '{print $3}' | awk -F '%' '{print $1}')
#平均延时
AvgRtt=$(echo $ping_result | grep rtt | awk -F '/' '{printf $5}' | awk -F '.' '{printf $1}')

if [ $packet -ge 20 ]
then
   echo -e "$DATE $Client ping google 当前丢包率为% $packet，请立刻检查服务器是否有异常" | mail -s "$Client ping谷歌丢包率为% $packet" -c $MAIL $MAIL2
   ((COUNT++))
   echo $COUNT > /root/checkAlive/count.txt
   if [ $COUNT -ge 3 ]
   then
                /root/mutiUDP2raw.sh >> /var/log/udp2raw.log
                echo "$DATE 检测程序检测到3次丢包率大于20，程序自动重启udp2raw 程序" >> /var/log/udp2raw.log
        fi
else
        echo '0' > /root/checkAlive/count.txt
fi
if [ $AvgRtt -ge 350 ]
then
   echo -e "$DATE $Client ping google 当前平均延时为$AvgRtt ms，请立刻检查服务器是否有异常" | mail -s "$Client ping谷歌延时为$AvgRtt ms" -c $MAIL $MAIL2
fi

echo "$DATE $Client                           ping谷歌当前丢包率为% $packet"  >> /var/log/VpnServer.log
echo "$DATE $Client                                              ping谷歌当前平均延时为$AvgRtt ms"  >> /var/log/VpnServer.log
