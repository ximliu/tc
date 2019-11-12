#!/bin/bash
DATE=$(date +%F" "%H:%M)
#国内路由查询
route_tun1=`/usr/sbin/ip route show table 10 | grep '1.0.1.0/24'`
route_length=${#route_tun1}
if [ $route_length == 0 ]
then
   echo -e "$DATE $Client Table 10 国内路由丢失" >> /var/log/VpnServer.log
   /root/chnroutes/vpn-up.sh
#else
#   echo "路由正常"
fi
