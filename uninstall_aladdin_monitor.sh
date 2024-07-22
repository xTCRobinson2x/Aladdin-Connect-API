#!/bin/bash

APP_USER="aladdin_monitor"
APP_DIR="/opt/aladdin_garage_monitor"
SERVICE_FILE="/etc/systemd/system/aladdin_garage_monitor.service"
LOG_FILE="/var/log/aladdin_garage_monitor.log"
PYTHON_SCRIPT="aladdin_garage_monitor.py"
CONF_FILE="config.py"


# Stop and disable the service
echo "Stopping and disabling the service..."
sudo systemctl stop aladdin_garage_monitor.service
sudo systemctl disable aladdin_garage_monitor.service

# Remove the systemd service file
echo "Removing the systemd service file..."
sudo rm -f $SERVICE_FILE

# Reload systemd to apply changes
echo "Reloading systemd..."
sudo systemctl daemon-reload
sudo systemctl reset-failed

# Remove the application directory
echo "Removing the application directory..."
sudo rm -rf $APP_DIR

# Remove the log file
echo "Removing the log file..."
sudo rm -f $LOG_FILE

# Remove the application user
echo "Removing the application user..."
sudo userdel -r $APP_USER

echo "Uninstallation complete."
