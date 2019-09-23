#!/bin/bash

## Description: A quick and dirty script for pulling PCAPs from the Firepower JDBC (java) console. 


## Example export
cd /home/steven/JDBC-demo && export CLASSPATH=$CLASSPATH:.:$(pwd)/lib/vjdbc.jar:$(pwd)/lib/commons-logging-1.1.jar
cd /home/steven/JDBC-demo/bin

# We must install the cert from the JDBC driver package. 
sudo java InstallCert fmc.iacon.cybertron

read -p "What is the FMC hostname or IP address? " FMC
read -p "What username shall we use? " USERNAME
read -sp "Password: " PASSWORD
read -p "What is the Intrusion event ID? " EVENTID

echo -en "SELECT packet_data FROM intrusion_event_packet WHERE event_id='${EVENTID}';" | java RunQuery fmc.iacon.cybertron $USERNAME $PASSWORD $SQLCMD  | grep -a -v -E '(sfdb|^$|count|packet|---)' > tmp.out 

python3 /home/steven/JDBC-demo/bin/offset-fix.py tmp.out | od -Ax -tx1 -v | text2pcap -T1234,1234 - "event_id_${EVENTID}.pcap"

tcpdump -Xvvv -r "event_id_${EVENTID}.pcap" 
