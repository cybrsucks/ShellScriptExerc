#!/bin/bash

# 192.168.131.128

# netstat -atun | grep 443
 
# NO_OF_LINES_IN_TEXTFILE= wc -l computerlist.txt | grep -Eo '[0-9]*'
# IP_ADDRESS_IN_TEXTFILE= cat computerlist.txt

echo "----------------------------"
echo "----------------------------"

for i in $(cat computerlist.txt); 
   do
      echo "ip address: " $i
      ### check if host is reachable (ping request)
      ping -c1 $i 2>&1 >/dev/null
      # echo $?
      ### exit status code 0 means host is reachable
      ### exit status code > 0 means unreachable
      if [ $? -eq 0 ]
         then
	    echo "host is reachable"
	 else
	    echo "host is down"
	 fi
      # nmap $i -p 20 
      
      ### check ftp/ssh/http port state (open/filtered/closed)
      echo "Port 20 ftp: " $(nmap $i -p 20 | awk  '/(open|filtered|closed)/{print $2}')
      echo "Port 22 ssh: " $(nmap $i -p 22 | awk  '/(open|filtered|closed)/{print $2}')
      echo "Port 80 http: " $(nmap $i -p 80 | awk  '/(open|filtered|closed)/{print $2}')
      # while ! ping -c1 $i &>/dev/null; do echo "Ping Fail - `date`"; done ; echo "Host Found - `date`" ;
      echo "----------------------------"
      done
wait
# nmap -p 20 -oG - $i
# nmap localhost -p 25 | awk  '/(open|filtered|closed)/{print $2}'

### Done by cybrsucks
