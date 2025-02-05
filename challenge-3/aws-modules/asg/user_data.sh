#!/bin/bash
# Update package repository
sudo yum update -y
# Install required packages
sudo yum install -y httpd git
# Start and Enable
sudo systemctl start httpd
sudo systemctl enable httpd
# Remove existing files to avoid conflicts
sudo rm -rf /var/www/html
# Clone the Git repository (replace with your repo URL)
sudo git clone https://github.com/eleston-campus/eleston-campus.github.io.git /var/www/html
# Set proper permissions
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html
# Restart Apache to serve new content
sudo systemctl reload httpd


