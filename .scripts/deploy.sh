#!/bin/bash
set -e

echo "Deployment started ..."

# Pull the latest version of the app
sudo git pull origin main
echo "New changes copied to server !"

# Activate Virtual Env
source venv/bin/activate
echo "Virtual env 'venv' Activated !"

echo "Installing Dependencies..."
sudo pip install -r requirements.txt --no-input

echo "Running Database migration"
sudo python3 manage.py makemigrations
sudo python3 manage.py migrate
# Deactivate Virtual Env
deactivate
echo "Virtual env 'venv' Deactivated !"

# for frontend changes
sudo rm -rf build
sudo npm install
echo "installing packages for react"
sudo npm run build
echo "build the new file"
sudo cp -r build /var/www/html/build
echo "copying new file to the directory "

sudo systemctl restart nginx 
echo "restarting nginx"

echo "Deployment Finished!"