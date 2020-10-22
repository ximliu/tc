#!/bin/bash
rx_pre=$(cat /proc/net/dev | grep eth0 | tr : " " | awk '{print $2}')
rx_pre_GB=`echo "scale=2;$rx_pre/1024/1024/1024" | bc`
echo "eth0 rx flow is: $rx_pre_GB GB"
used_flow=`echo "scale=2;$rx_pre_GB*1.2" | bc`
echo "used_flow is 120 precent of eth0 rx flow is: $used_flow GB"
remain_flow=`cat /root/flow_count/remain_flow`
echo "remain flow is: $remain_flow"
remain_flow=`echo "scale=2;$remain_flow-$used_flow" | bc`
echo "remain flow - used flow is: $remain_flow"
echo $remain_flow > /root/flow_count/remain_flow
