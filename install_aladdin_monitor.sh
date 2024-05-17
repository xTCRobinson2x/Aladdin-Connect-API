#!/bin/bash

# Define variables
APP_USER="aladdin_monitor"
APP_DIR="/opt/aladdin_garage_monitor"
SERVICE_FILE="/etc/systemd/system/aladdin_garage_monitor.service"
LOG_FILE="/var/log/aladdin_garage_monitor.log"
PYTHON_SCRIPT="aladdin_garage_monitor.py"
CONF_FILE="config.py"

# Install necessary packages
echo "Installing necessary packages..."
sudo apt update
sudo apt install -y python3 python3-venv

# Create application user
echo "Creating application user..."
sudo useradd -r -s /bin/false $APP_USER

# Create application directory
echo "Setting up application directory..."
sudo mkdir -p $APP_DIR
sudo chown $APP_USER:$APP_USER $APP_DIR

# Copy Python script to application directory
echo "Copying Python script..."
sudo cp $PYTHON_SCRIPT $APP_DIR/
sudo cp $CONF_FILE $APP_DIR/
sudo chown $APP_USER:$APP_USER $APP_DIR/$PYTHON_SCRIPT
sudo chown $APP_USER:$APP_USER $APP_DIR/$CONF_FILE

# Set up Python virtual environment
echo "Setting up Python virtual environment..."
sudo -u $APP_USER python3 -m venv $APP_DIR/venv
sudo -u $APP_USER $APP_DIR/venv/bin/pip install requests

# Create systemd service file
echo "Creating systemd service file..."
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Garage Door Monitor Service
After=network.target

[Service]
ExecStart=$APP_DIR/venv/bin/python $APP_DIR/$PYTHON_SCRIPT
WorkingDirectory=$APP_DIR
StandardOutput=inherit
StandardError=inherit
Restart=always
User=$APP_USER

[Install]
WantedBy=multi-user.target
EOL

# Set permissions for the log file
echo "Setting permissions for the log file..."
sudo touch $LOG_FILE
sudo chown $APP_USER:$APP_USER $LOG_FILE

# Reload systemd and enable the service
echo "Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable aladdin_garage_monitor.service
sudo systemctl start aladdin_garage_monitor.service

echo "Installation complete. Check the service status with: sudo systemctl status aladdin_garage_monitor.service"
