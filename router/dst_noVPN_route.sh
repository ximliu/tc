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
