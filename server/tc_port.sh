EXTDEV=ppp0
Link_Speed=29999
Other_Speed=29999
vpn_speed=3000

/usr/sbin/tc qdisc del dev $EXTDEV root    2> /dev/null > /dev/null

#以下是上传限速
#-------------------------------------------------------------------------------------------
/usr/sbin/tc qdisc add dev $EXTDEV root handle 1: htb default 255
#定义 class
/usr/sbin/tc class add dev $EXTDEV parent 1: classid 1:1 htb rate ${Link_Speed}kbit ceil ${Link_Speed}kbit

/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:11 htb rate ${vpn_speed}kbit ceil ${vpn_speed}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:12 htb rate ${vpn_speed}kbit ceil ${vpn_speed}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:255 htb rate ${Other_Speed}kbit ceil ${Other_Speed}kbit

#定义匹配VPN客户端地址
#/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 10.8.0.6 flowid 1:6
#/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 10.8.0.7 flowid 1:7


#将匹配到的端口做标记
iptables -A OUTPUT -t mangle -p tcp --sport 51001 -j MARK --set-mark 11
iptables -A OUTPUT -t mangle -p tcp --sport 51002 -j MARK --set-mark 12

#以iptables标记作为过滤器
tc filter add dev $EXTDEV parent 1:0 protocol ip handle 11 fw flowid 1:11
tc filter add dev $EXTDEV parent 1:0 protocol ip handle 12 fw flowid 1:12


#定义队列
/usr/sbin/tc qdisc add dev $EXTDEV parent 1:11 handle 11: sfq perturb 10
/usr/sbin/tc qdisc add dev $EXTDEV parent 1:12 handle 12: sfq perturb 10

/usr/sbin/tc qdisc add dev $EXTDEV parent 1:255 handle 255: sfq perturb 10
echo "`date` 成功执行了限速策略"
