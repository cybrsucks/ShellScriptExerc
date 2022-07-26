For Part 1 of Scripting exercise,
place ```checkStatus.sh``` and ```ipaddrList.txt``` in the same folder 

Execute ``` bash checkStatus.sh ``` to check if 
1) Host is online/offline
2) If port 20/FTP is open
3) If port 22/SSH is open
4) If port 80/http is open

### NOTE BEFORE EXECUTING, DO THE FOLLOWING:
1) on 192.168.181.134 (second host in same network), run:
- ```su```
- password: ```ass```
- ```sudo ufw allow 20```
- ```ls | nc -l -p 20```
##### this is to listen to port 20 and so that nmap can ping the open port 20 

### Some expected results:
``` ------------------------------------
------------------------------------
192.168.181.131 (host) is reachable
Port 20 ftp: closed
Port 22 ssh: open
Port 80 http: closed
------------------------------------
192.168.181.134 (second host in same network) is reachable
Port 20 ftp: open
Port 22 ssh: open
Port 80 http: closed
------------------------------------
www.google.com is reachable
Port 20 ftp: filtered
Port 22 ssh: filtered
Port 80 http: open 
------------------------------------
192.168.181.133 (host that does not exist) is down
Port 20 ftp: 
Port 22 ssh: 
Port 80 http: 
```
