#! /bin/bash 

# POC Script
# Script to do general scans on OSCP network

# Important run script as ROOT

# Usage
# Scan network for webservers,
# ./network_scan.sh web

# Do Fast Scan on Network 
# ./network_scan.sh fast

# Do service scan on network 
# ./network_scan.sh service

# Scan all TCP ports on a single host
# ./network_scan.sh single <IP>

# Scan output will be located at 
# /boxes/Boxes


# Look for web servers on the network

web_scan(){
	echo "************************************"
	echo "Starting Web Scan"

	while IFS= read -r line
	do 
	    mkdir -p /boxes/Boxes/"$line"/"Web"/"web"
	    nmap -p 80,443,8080 -oA /boxes/Boxes/"$line"/"Web"/"web" "$line"
	done < "$server_file"
}

# Do a fast scan on the network
fast_scan(){
	echo "************************************"
	echo "Fast Scan"	

	while IFS= read -r line
	do 
	    mkdir -p /boxes/Boxes/"$line"/"Fast"/"fast"
	    nmap -F -oA /boxes/Boxes/"$line"/"Fast"/"fast" "$line"
	done < "$server_file"
}

# Do a service scan on network
service_scan(){
	echo "************************************"
	echo "Service Scan"
	
	while IFS= read -r line
	do 
	    mkdir -p /boxes/Boxes/"$line"/"Service_Scan"/"service_scan"
	    nmap -sC -sV -oA /boxes/Boxes/"$line"/"Service_Scan"/"service_scan" "$line"
	done < "$server_file"
}

# Do a full scan on a single host
single_server_scan(){
	echo "************************************"
	echo "Scanning $1"

        mkdir -p /boxes/Boxes/"$1"/"$1"
    	nmap -p- -oA /boxes/Boxes/"$1"/"all_ports" "$1"
}

server_file="servers.txt"

# Check if scan type argument was passed in
if [ -z "$1" ]
then 
	echo "Script Usage: ./network_scan.sh <Scan Type>"
	exit 0
fi

# Process Argument
if [[ "$1" == "web" ]]
then 
	web_scan
elif [[ "$1" == "fast" ]] 
then 
	fast_scan

elif [[ "$1" == "service" ]]
then 
	full_scan

elif [[ "$1" == "single" ]]
then 
	if [[ -z "$2" ]]
	then 
		echo "MISSING IP! Single host scan usage ./network_scan.sh single <ip>"
		exit 0
	else
		single_server_scan "$2"
	fi

else
	echo "Valid scan types: web,fast,full"
fi

# Ignore below lines of code
# mkdir -p Boxes/10.11.1.{1..254}

#while IFS= read -r line
#do 
    #echo "$line"
 #   nmap -sC -sV  -oA Boxes/"$line"/"$line" "$line"
  #  echo ""
# done < "$server_file"


