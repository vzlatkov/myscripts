#/bin/bash

###This is a script for automatization of the installation and configuration of a Salt Stack master server. By VZlatkov (a.k.a. Xerxes)
###v1.0.1
### In this version we are going to set the basic installation of the Salt-master by updating and upgrading the OS and installing the needed dependencies. Then we are going to install the master server itself.


###This is the initial dependency installation part of the script
apt -y update
apt -y upgrade
apt -y install python3
apt -y install python3-pip
pip install salt #You first install the Salt Stack, then you configure it as a Master or Slave
# Download key
curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
# Create apt sources list file
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list
apt-get update
apt-get -y install salt-master

###Get the local IP and create a variable
IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1) #Assigns the local IP addr of the machine to a variable so we can use it

###Start the service
systemctl daemon-reload
systemctl start salt-master
systemctl restart salt-master


###     Tests if the conf file/dir exists   ###

if [ -d /etc/salt/master ]; #Checks if the dir exists
        then continue #If exists - skips the "elif/else" statement
        else #If it doesn't exist - creates the path and file
                mkdir /etc/salt/

	(
cat > /etc/salt/master<<EOF
interface: $IP
EOF
)

fi

###Create a Salt-key
salt-key -F master

###Restart the service
systemctl daemon-reload
systemctl restart salt-master
systemctl status salt-master
