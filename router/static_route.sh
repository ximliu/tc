#!/bin/bash
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"
#添加固定路由
OLDGW=$(ip route show 0/0 | sed -e 's/^default//')

#1、内网路由,有核心交换，并且核心下面有其他网段时添加
#LAN=br0
#CoreIP=172.16.1.2
#ip route add 192.168.10.0/24 via $CoreIP dev $LAN proto static metric 100 table 5
#ip route add 192.168.11.0/24 via $CoreIP dev $LAN proto static metric 100 table 5
#为了保证网卡重启不丢失内网路由，需要在下面文件中添加内网路由
#/etc/sysconfig/network-scripts/route-eth1

#4、VPN服务器路由
server1=`cat /root/mutiUDP2raw.sh | grep server1= | cut -f2 -d "'"`
server2=`cat /root/mutiUDP2raw.sh | grep server2= | cut -f2 -d "'"`
ip route add $server1 $OLDGW table 5
ip route add $server2 $OLDGW table 5
