#!/bin/bash
#监测 udp2raw_amd64是否正常运行，不运行则自动启动
server1=`cat /root/mutiUDP2raw.sh | grep server1= | cut -f2 -d "'"`
server2=`cat /root/mutiUDP2raw.sh | grep server2= | cut -f2 -d "'"`
ps1="/root/udp2raw/udp2raw_amd64 -c -r$server1:50000 -l 127.0.0.1:1198 --raw-mode faketcp -k huayu888 --fix-gro"
ps2="/root/udp2raw/udp2raw_amd64 -c -r$server2:50000 -l 127.0.0.1:1199 --raw-mode faketcp -k huayu888 --fix-gro"

PROC=("$ps1" "$ps2")
for p in "${PROC[@]}"
do
  ps aux|grep "$p" |grep -v grep > /dev/null;
  if [ $? -eq 0 ]; then
    echo "`date` Process $p is running"
  else
    echo "`date` Process $p is not running. Prepare to start" >> /var/log/udp2raw.log
    /root/mutiUDP2raw.sh >> /var/log/udp2raw.log
    sleep 5
    echo -e "`date` Client_name 定期监测udp2raw异常，设备自动重新启动udp2raw进程" | mail -s "udp2raw进程重启提醒" your_email@qq.com
  fi
done
