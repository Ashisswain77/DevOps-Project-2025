#!/bin/bash
set -xe

echo "Running install.sh script..."

# Install Apache if not already installed
sudo yum install -y httpd

# Enable and restart Apache
sudo systemctl enable httpd
sudo systemctl restart httpd

# Optional: Copy build files to Apache web root (adjust path as needed)
# sudo cp -r dist/* /var/www/html/

# Set permissions
sudo chmod -R 755 /var/www/html

echo "Deployment finished."
