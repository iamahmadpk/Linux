#!/bin/bash

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "Installing nmap..."
    sudo apt-get update
    sudo apt-get install nmap -y
fi

# Create a log file
LOG_FILE="/home/ebryx/logfile.log"
touch $LOG_FILE

# Set up cron job
#CRON_CMD="*/5 * * * * /usr/bin/nmap -sS >> $LOG_FILE"
#(crontab -l ; echo "$CRON_CMD") | crontab -

echo "Cron job set up successfully."

