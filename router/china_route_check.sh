DATE=$(date +%F" "%H:%M)
#国内路由查询
route_tun1=`/usr/sbin/ip route show table 10 | grep '1.0.1.0/24'`
route_length=${#route_tun1}
if [ $route_length == 0 ]
then
   echo -e "$DATE $Client 国内路由丢失，请检查" | mail -s "$Client 国内路由丢失，请检查" -c $MAIL $MAIL2
   /root/static_route.sh
   /root/chnroutes/vpn-up.sh
   /root/dst_noVPN_route.sh
   /root/mutiUDP2raw.sh
#else
#   echo "路由正常"
fi
