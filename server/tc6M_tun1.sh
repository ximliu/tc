#!/bin/sh -x
# 以下脚本文件用在服务器端，对于OPENVPN客户端的下载流量进行限速（即服务器端出流量），带宽单位为kbits/s
#定义链路带宽
LinkCeilDownSpeed=30000            #链路最大下载带宽
LinkCeilUploadSpeed=30000          #链路最大上传带宽
LinkRateDownSpeed=29000           #链路保障下载带宽
LinkRateUploadSpeed=29000         #链路保障上传带宽

#定义VPN 用户的最大带宽和保障带宽
UserCeilDownSpeed=29000         #特殊用户最大下载带宽
UserCeilUploadSpeed=29000       #特殊用户最大上传带宽
UserRateDownSpeed=29000        #特殊用户保障下载带宽
UserRateUploadSpeed=29000      #特殊用户保障上传带宽

#定义其他用户的最大带宽合保障带宽
OtherCeilDownSpeed=29000             #其他用户最大下载带宽
OtherCeilUploadSpeed=29000           #其他用户最大上传带宽
OtherRateDownSpeed=29000            #其他用户保障下载带宽
OtherRateUploadSpeed=29000          #其他用户保障上传带宽

#新定义客户带宽
speed29m=29000
speed24m=24000
speed16m=16000
speed8m=8000
speed7m=7000
speed6m=6000
speed5m=5000
speed4m=4000
speed3m=3000
speed2_5m=2500
speed2m=2000
speed1m=1000


#定义限速网卡
EXTDEV=tun1

#定义VPN客户端地址前缀，
vpn_address_pre=172.16.2
#定义对多少个OPENVPN客户端IP进行限速，第一个为172.16.2.2 
vpn_total_number=33

# 清除接口上的队列及 mangle 表
/usr/sbin/tc qdisc del dev $EXTDEV root    2> /dev/null > /dev/null

#以下是上传限速
#-------------------------------------------------------------------------------------------
/usr/sbin/tc qdisc add dev $EXTDEV root handle 1: htb default 255
#定义 class
/usr/sbin/tc class add dev $EXTDEV parent 1: classid 1:1 htb rate ${LinkRateUploadSpeed}kbit ceil ${LinkCeilUploadSpeed}kbit

#home
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:6 htb rate ${speed29m}kbit ceil ${speed29m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:7 htb rate ${speed29m}kbit ceil ${speed29m}kbit
#dx
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:8 htb rate ${speed29m}kbit ceil ${speed29m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:9 htb rate ${speed29m}kbit ceil ${speed29m}kbit
#hunan
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:10 htb rate ${speed29m}kbit ceil ${speed29m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:11 htb rate ${speed29m}kbit ceil ${speed29m}kbit
#505
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:12 htb rate ${speed16m}kbit ceil ${speed16m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:13 htb rate ${speed16m}kbit ceil ${speed16m}kbit
#506
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:14 htb rate ${speed8m}kbit ceil ${speed8m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:15 htb rate ${speed8m}kbit ceil ${speed8m}kbit
#tky
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:16 htb rate ${speed8m}kbit ceil ${speed8m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:17 htb rate ${speed8m}kbit ceil ${speed8m}kbit
#yibixi
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:18 htb rate ${speed4m}kbit ceil ${speed4m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:19 htb rate ${speed4m}kbit ceil ${speed4m}kbit
#sdxh
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:20 htb rate ${speed5m}kbit ceil ${speed5m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:21 htb rate ${speed5m}kbit ceil ${speed5m}kbit
#tjty
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:22 htb rate ${speed3m}kbit ceil ${speed3m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:23 htb rate ${speed3m}kbit ceil ${speed3m}kbit
#liaoly
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:24 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:25 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
#zhangzhao
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:26 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:27 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
#sdtdlt
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:28 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:29 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
#xzshouyou
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:30 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:31 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
#ganjin
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:32 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:33 htb rate ${speed2_5m}kbit ceil ${speed2_5m}kbit
/usr/sbin/tc class add dev $EXTDEV parent 1:1 classid 1:255 htb rate ${OtherRateUploadSpeed}kbit ceil ${OtherCeilUploadSpeed}kbit

#定义匹配VPN客户端地址
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.6 flowid 1:6
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.7 flowid 1:7
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.8 flowid 1:8
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.9 flowid 1:9
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.10 flowid 1:10
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.11 flowid 1:11
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.12 flowid 1:12
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.13 flowid 1:13
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.14 flowid 1:14
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.15 flowid 1:15
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.16 flowid 1:16
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.17 flowid 1:17
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.18 flowid 1:18
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.19 flowid 1:19
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.20 flowid 1:20
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.21 flowid 1:21
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.22 flowid 1:22
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.23 flowid 1:23
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.24 flowid 1:24
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.25 flowid 1:25
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.26 flowid 1:26
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.27 flowid 1:27
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.28 flowid 1:28
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.29 flowid 1:29
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.30 flowid 1:30
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.31 flowid 1:31
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.32 flowid 1:32
/usr/sbin/tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.2.33 flowid 1:33

#定义队列
for((i = 6; i <= $vpn_total_number; i++))
do
   /usr/sbin/tc qdisc add dev $EXTDEV parent 1:$i handle $i: sfq perturb 10
done
/usr/sbin/tc qdisc add dev $EXTDEV parent 1:255 handle 255: sfq perturb 10
echo "`date` 成功执行了限速策略"
