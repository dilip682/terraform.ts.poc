#!/bin/bash
sudo yum install -y nfs-utils
sudo mkdir -p /usr/share/client_folders
sudo echo '${fs_name}.efs.${region}.amazonaws.com:/ /usr/share/client_folders nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0' | tee -a /etc/fstab
sudo mount -a
