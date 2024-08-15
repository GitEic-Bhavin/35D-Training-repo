# # 2. System Metrics
# # Monitor CPU usage, memory utilization, disk space, and network statistics.
# # Capture process information including top processes consuming resources.

# # CPU Usage
# echo "Show CPU Utilization"
# echo
# top | head -n 10

# echo 
# echo 

# echo "Show memory usage"
# free -h | head -n 10

# echo
# echo

# # echo "Show Network Statistics"
# # netstat | head -n 10
# # echo

# echo "Show Top Process Info"
# ps aux | head -n 10
# echo
# echo

# # 3.Parse system logs (e.g., syslog) for critical events and errors.
# echo
# echo "Parse system logs (e.g., syslog) for critical events and errors."
# echo
# echo

# if [ -f /var/log/syslog ]
# then 
#     grep -iE  "ERROR|CRITICAL" /var/log/syslog | tail -n 10 
# fi

# echo
# echo

# echo "5. Check status of Apache2"
# src=`systemctl status apache2`
# if [ $? = 0 ]
# then
#     echo "Apache is running"
#     else
#         echo "Apache is not running"
# fi
# echo
# echo
# echo "Disk Usage"
# echo


# # Disk Usage

# Threshhold=50

# disk_usage=$(df -h | tail -n1 | awk '{print $5}' | sed 's/%//')

# # here, sed it use to interact with stream editor 
# # 's' -- Substitution Operations
# # % -- find for charactor %
# # // -- replace % with nothing. 
# # If Disk Usage 10% , it will replace with 10. bcz, Threshhold value in 50 not 50%.

# if [ "$disk_usage" -gt "$Threshhold" ]
# then
#   echo "Disk Usage is running low! Disk Usage: $disk_usage%"
# else
#   echo "Disk Usage is within acceptable limits. Disk Usage: $disk_usage%"
# fi
# echo
# echo


# # 
System_Metric() {
  echo "Show System Metrics"
  echo
  echo "===================="
  Disk_Usage=$(top -bn1 | grep  "Cpu(s)" |  sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
  echo $Disk_Usage

  echo
  echo "Network Statistics"
  echo "===================="
  echo
  echo "NetworkStat=$(netstat -i)"
  echo 
  echo
  echo "Show Top Process"
  echo
  echo "====================="
  echo
  echo "TP=$(top | head -n 10)"
  echo
  echo
  echo "======================"
  echo
  echo "Memory Usage=$(free -h | head -n 10)"
  echo
  echo
  echo "======================="
  echo
  echo "Disk Space=$(df -h )"
  echo
  echo

}
# System_Metric

Health_Check() {
  echo
  echo "Show Service is active or disabled"
  echo
  echo "==========================="
  echo
  echo "Apache-Service=$(systemctl is-active apache2)"
  echo
  echo "Mysql-Service=$(systemctl is-active mysql)"
  echo
  echo "Check Ping"
  echo
  echo "============================"
  echo
  ping -c1 google.com
  if [ $? == 0 ]
  then 
    echo "Google is reachable by sending 1 Pkg."
  else
    echo "Google is unreachable"
  fi
echo
echo
}

echo
echo "Show ThreshHold"
echo
echo "================================"
echo

Threshhold () {

  Threshhold=50

  disk_usage=$(df -h | tail -n1 | awk '{print $5}' | sed 's/%//')

# here, sed it use to interact with stream editor 
# 's' -- Substitution Operations
# % -- find for charactor %
# // -- replace % with nothing. 
# If Disk Usage 10% , it will replace with 10. bcz, Threshhold value in 50 not 50%.

if [ "$disk_usage" -gt "$Threshhold" ]
then
  echo "Disk Usage is running low! Disk Usage: $disk_usage%"
else
  echo "Disk Usage is within acceptable limits. Disk Usage: $disk_usage%"
fi
echo
echo

}
Threshhold

echo
echo "Show Log status"
echo
Log_analysis () {

  if [ -e /var/log/syslog ]
then 
    grep -iE  "ERROR|CRITICAL" /var/log/syslog | tail -n 10 
fi


}
Log_analysis

echo "Creating report file"

Report_file="/tmp/Day10-report_$(date +'%Y%m%d_%H%M%S').txt"
echo "System Report $(date)" >> $Report_file
System_Metric >> $Report_file
Health_Check >> $Report_file
Threshhold >> $Report_file
Log_analysis >> $Report_file

echo
echo "Asking for user input"
echo "======================="
echo
while true
do
  read -p "Choose any option, 1) System Metric 2) Health Check 3) Threshhold 4) Log Analysis 5) Choose q to quit." CHOICE
  case $CHOICE in
  1) System_Metric;;
  2) Health_Check;;
  3) Threshhold;;
  4) Log_analysis;;
  q) echo "Good by" && break;;
  esac
done

