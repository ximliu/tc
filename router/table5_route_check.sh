#!/bin/bash
DATE=$(date +%F" "%H:%M)
#table5 Server 路由查询
route_table5=`/usr/sbin/ip route show table 5`
route_length5=${#route_table5}
if [ $route_length5 == 0 ]
then
   echo -e "$DATE $Client Table 5 Server 路由丢失" >> /var/log/VpnServer.log
   /root/mutiUDP2raw.sh
   /root/static_route.sh
#else
#   echo "Table 5 路由正常"
fi
