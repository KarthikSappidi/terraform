#!/bin/bash

##########
####Author-karthik sappidi####
###########

sudo apt update -y
sudo apt install -y nginx
sudo rm /var/www/html/*.html
sudo git clone https://github.com/KarthikSappidi/food.git /var/www/html


