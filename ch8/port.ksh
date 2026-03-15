#!/bin/ksh
OS_NAME=$( uname -s )
if [[ $OS_NAME == "AIX" ]] ; then
    echo "--------------------------------------------------------------------------------------"
    printf "| %-20s | %-15s | Protocol | %-30s |\n" "Process" "PID" "Listening On";
    echo "--------------------------------------------------------------------------------------"
    netstat -Ana | awk '
    /[0-9\*].[0-9].+LISTEN/ {
        SOCKET=$1;
        IPPORT=$5;
        "rmsock " SOCKET " tcpcb" | getline SOCKOUT;
        split(SOCKOUT, sockarray, " ");
        gsub(/[\.\(\)]/, "", sockarray[10]);
        LISTENERS[ sprintf("| %-20s | %15d | %8s | %30s |", sockarray[10], sockarray[9], "TCP", IPPORT) ] = 1;
    }
    /udp.*.[0-9]/ {
        SOCKET=$1;
        IPPORT=$5;
        "rmsock " SOCKET " inpcb" | getline SOCKOUT;
        split(SOCKOUT, sockarray, " ");
        gsub(/[\.\(\)]/, "", sockarray[10]);
        LISTENERS[ sprintf("| %-20s | %15d | %8s | %30s |", sockarray[10], sockarray[9], "UDP", IPPORT) ] = 1;
    }
    END {
        for (var in LISTENERS)
            print var
    }' | sort | uniq
    echo "--------------------------------------------------------------------------------------"
else
    echo "ERROR: Requires AIX"
    exit 1
fi

