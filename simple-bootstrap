#!/bin/bash
yum update -y
yum install httpd24 -y
service httpd start
chkconfig httpd on
echo "<html><body><h1>It's working</h1></body></html>" > /var/www/html/index.html
