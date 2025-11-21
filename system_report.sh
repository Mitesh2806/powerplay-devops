#!/bin/bash

echo "========================================"
echo "System Report: $(date)"
echo "========================================"

# a. Current date and time
echo "Date/Time: $(date)"

# b. Uptime
echo "Uptime: $(uptime -p)"

# c. CPU usage (%)
# Uses top to grab CPU line, extracts idle percentage, and subtracts from 100
echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"

# d. Memory usage (%)
echo "Memory Usage:"
free -h | awk '/Mem:/ {print "Used: " $3 " / Total: " $2}'

# e. Disk usage (%)
echo "Disk Usage:"
df -h / | awk 'NR==2 {print "Used: " $3 " / Total: " $2 " (" $5 ")"}'

# f. Top 3 processes by CPU usage
echo "Top 3 Processes by CPU:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 4

echo "----------------------------------------"
echo ""



# 1. Get disk usage percentage (Extracts just the number, e.g., 45)
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# 2. Set the threshold (Set to 80 for final submission, 10 for testing)
THRESHOLD=80

# 3. Check and Alert
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "WARNING: Disk usage is above $THRESHOLD% ($DISK_USAGE%). Sending alert..."

    # Replace emails with your actual verified identities
    aws ses send-email \
        --from "miteshmaity280603@gmail.com" \
        --destination "ToAddresses=miteshmaity280603@gmail.com" \
        --message "Subject={Data='Alert: High Disk Usage'},Body={Text={Data='Warning: Disk usage on mitesh-devops is currently at $DISK_USAGE%.'}}" \
        --region eu-north-1
else
    echo "Disk usage is normal ($DISK_USAGE%)."
fi