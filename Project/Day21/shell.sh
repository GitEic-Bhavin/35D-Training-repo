memory_usage() {
    echo "See mamory usage"
    free -h
}
memory_usage

disk_usage() {
    echo
    echo "disk usage in GB Out of 338GB is" `du -sh /home/einfochips` | awk '{print $1}'
}
disk_usage

cpu_load() {
    echo
    echo "Cpu Load is "
    top -bn1 | grep -i "Cpu(s)"
}

cpu_load

log_mangagement() {
    echo 
    echo "Watch logs for deleted"
    cat /var/log/syslog | grep -i deleted | tail -n 6
}

log_mangagement

if [ $? -eq 0 ] 
then
  {
    memory_usage >> output.txt
    disk_usage >> output.txt
    cpu_load >> output.txt
    log_mangagement >> output.txt
  }
  echo "Report saved in output.txt"
fi