#!/bin/bash
life=prod
conf_dir=/usr/share/tomcat8/conf
lib_dir=/usr/share/tomcat8/lib
sudo su
yum update -y
# Installing EFS
yum install -y nfs-utils
mkdir -p /usr/share/client_folders
echo '${fs_name}.efs.${region}.amazonaws.com:/ /usr/share/client_folders nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0' | tee -a /etc/fstab
sudo mount -a
# Removing Old java and installing new version of JAVA
yum remove java -y
yum install java-1.8.0-openjdk -y
# Install Tomcat
yum install tomcat8-admin-webapps.noarch 
cd $lib_dir
wget https://s3.ap-south-1.amazonaws.com/terraform-software/javax.mail.jar
wget https://s3.ap-south-1.amazonaws.com/terraform-software/ojdbc8.jar
#wget https://s3.ap-south-1.amazonaws.com/terraform-software/trade_engine_libraries/ojdbc7.jar
cd $conf_dir
rm -rf tomcat-users.xml tomcat8.conf server.xml
wget https://s3.ap-south-1.amazonaws.com/terraform-software/tomcat-files/tomcat-users.xml
wget https://s3.ap-south-1.amazonaws.com/terraform-software/tomcat-files/tomcat8.conf
wget https://s3.ap-south-1.amazonaws.com/terraform-software/tomcat-files/server.xml

chown root:tomcat tomcat-users.xml
chown root:tomcat tomcat8.conf
chown root:tomcat server.xml

yum install ImageMagick.x86_64 ImageMagick-devel.x86_64 -y
service tomcat8 start
chkconfig --level 2345 tomcat8 on
