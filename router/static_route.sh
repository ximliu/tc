#添加固定路由
OLDGW=$(ip route show 0/0 | sed -e 's/^default//')

#1、内网路由
LAN=eth1
CoreIP=172.16.1.2
ip route add 192.168.10.0/24 via $CoreIP dev $LAN proto static metric 100 table 5
ip route add 192.168.11.0/24 via $CoreIP dev $LAN proto static metric 100 table 5
ip route add 192.168.12.0/24 via $CoreIP dev $LAN proto static metric 100 table 5
#为了保证网卡重启不丢失内网路由，需要在下面文件中添加内网路由
#/etc/sysconfig/network-scripts/route-enp3s0

#2、隔壁路由
ip route add 192.168.50.0/24 $OLDGW  table 5
ip route add 192.168.55.0/24 $OLDGW  table 5
ip route add 192.168.56.0/24 $OLDGW  table 5

#3、集团路由
ip route add 192.168.0.0/24 $OLDGW  table 5

#4、VPN服务器路由
server1=`cat /root/mutiUDP2raw.sh | grep server1= | cut -f2 -d "'"`
server2=`cat /root/mutiUDP2raw.sh | grep server2= | cut -f2 -d "'"`
server3=`cat /root/mutiUDP2raw.sh | grep server3= | cut -f2 -d "'"`
server4=`cat /root/mutiUDP2raw.sh | grep server4= | cut -f2 -d "'"`
server5=`cat /root/mutiUDP2raw.sh | grep server5= | cut -f2 -d "'"`
ip route add $server1 $OLDGW  table 5
ip route add $server2 $OLDGW  table 5
ip route add $server3 $OLDGW  table 5
ip route add $server4 $OLDGW  table 5
ip route add $server5 $OLDGW  table 5
