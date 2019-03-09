#!/bin/sh
OLDGW=$(ip route show 0/0 | sed -e 's/^default//')
#苹果
ip route add 17.128.0.0/9 $OLDGW table 15
#adobe flash
ip route add 47.89.13.219/32 $OLDGW table 15
#微软网盘
ip route add 13.64.0.0/11 $OLDGW table 15
ip route add 13.96.0.0/13 $OLDGW table 15
ip route add 13.104.0.0/14 $OLDGW table 15
#微软自动更新
ip route add 13.107.4.50/32 $OLDGW table 15
#未知
ip route add 117.18.232.240/32 $OLDGW table 15
#网站部门调整
ip route add 23.239.0.33 $OLDGW table 15
ip route add 47.244.39.167 $OLDGW table 15
ip route add 35.193.195.192 $OLDGW table 15
ip route add 34.95.93.181 $OLDGW table 15
