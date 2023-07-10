#!/bin/bash

# Get user input for cron time
read -p "Enter the cron schedule (like */5 * * * * for every 5 minutes): " cron_schedule

# Get user input for log file path and name
read -p "Enter the path and name for the log file (like /home/ebryx/logfile.log): " log_file

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "Installing nmap..."
    sudo apt-get update
    sudo apt-get install nmap -y
fi

# Create a log file
#LOG_FILE="/home/ebryx/logfile.log"
touch $log_file

# Set up cron job
CRON_CMD="$cron_schedule /usr/bin/nmap -sS >> $log_file"
(crontab -l ; echo "$CRON_CMD") | crontab -

echo "Cron job set up successfully."

