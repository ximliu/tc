#!/bin/bash
DATE=$(date +%F" "%H:%M)
#table15 Server 路由查询
route_table15=`/usr/sbin/ip route show table 15`
route_length15=${#route_table15}
if [ $route_length15 == 0 ]
then
   echo -e "$DATE $Client Table 15 Server 路由丢失" >> /var/log/VpnServer.log
   /root/dst_noVPN_route.sh
else
   echo "Table 15 路由正常"
fi
