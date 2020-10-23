EXTDEV=ppp0
Link_Speed=29999
Other_Speed=29999
vpn_speed=3000

/usr/sbin/tc qdisc del dev $EXTDEV root    2> /dev/null > /dev/null

#以下是上传限速
#-------------------------------------------------------------------------------------------
/usr/sbin/tc qdisc add dev $EXTDEV root handle 1: htb default 500
#定义 class
/usr/sbin/tc class add dev $EXTDEV parent 1: classid 1:1 htb rate ${Link_Speed}kbit ceil ${Link_Speed}kbit

/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:11 htb rate ${vpn_speed}kbit ceil ${vpn_speed}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:12 htb rate ${vpn_speed}kbit ceil ${vpn_speed}kbit

/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:500 htb rate ${Other_Speed}kbit ceil ${Other_Speed}kbit

#将匹配到的端口做标记
iptables -A OUTPUT -t mangle -p tcp --sport 51011 -j MARK --set-mark 11
iptables -A OUTPUT -t mangle -p tcp --sport 51012 -j MARK --set-mark 12

#以iptables标记作为过滤器
tc filter add dev $EXTDEV parent 1:0 protocol ip handle 11 fw flowid 1:11
tc filter add dev $EXTDEV parent 1:0 protocol ip handle 12 fw flowid 1:12

#定义队列
/usr/sbin/tc qdisc add dev $EXTDEV parent 1:11 handle 11: sfq perturb 10
/usr/sbin/tc qdisc add dev $EXTDEV parent 1:12 handle 12: sfq perturb 10

/usr/sbin/tc qdisc add dev $EXTDEV parent 1:500 handle 500: sfq perturb 10
