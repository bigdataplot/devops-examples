## ======================================== ##
##  User Setup / User Profile Backup (Host)
## ======================================== ##
sudo su

## Setup Admin Account
export DGNM='docker'
export DGID='2048'


## Only if no exist or different uid/gid
## Setup Docker Group
groupdel $DGNM || true
groupadd $DGNM
groupmod -g $DGID $DGNM
newgrp $DGNM
exit




## --------------------------------------!! ##
## Setup Host Directory
mkdir -p /apps/supervisor/log
chmod 700 /apps/supervisor
chown root:root /apps/supervisor

## Only if not exits
cd /apps/supervisor
git clone https://github.com/mlazarov/supervisord-monitor.git


exit

## ======================================== ##
##             Docker Build (Host)
## ======================================== ##
for file in *; do
    sed $'s/[^[:print:]\t]//g' "$file" > "$file.temp"
    rm "$file"
    mv "$file.temp" "$file"
done

sudo docker build -t bigdataplot/supervisor-monitor:s1.01 .

sudo docker login --username bigdataplot
sudo docker push bigdataplot/supervisor-monitor:s1.01


## ======================================== ##
##             Run from Docker
## ======================================== ##
# Or just run if build exists
sudo docker run --name supervisor-monitor \
    --detach \
    --restart always\
    --publish 9011:80 \
    --volume /etc/localtime:/etc/localtime:ro \
    --env SERVERS="server1=localhost" \
    --env USERNAME="admin" \
    --env PASSWORD="admin" \
    --env CONTACT_EMAIL="your@email.com" \
    --env SERVER_NAME="Support Center" \
    bigdataplot/supervisor-monitor:s1.01



# Nrg Note
sudo docker run \
    --name supervisor-monitor \
    --detach \
    --restart always\
    --publish 9011:80 \
    --volume /etc/localtime:/etc/localtime:ro \
    --env SERVERS="CVT-Support=txlinhdpneop1.retail.nrgenergy.com" \
    --env PORT="9002" \
    --env USERNAME="testuser" \
    --env PASSWORD="testpass" \
    --env CONTACT_EMAIL="cvtsupport@nrg.com" \
    --env SERVER_NAME="CVT Support Center" \
    bigdataplot/supervisor-monitor:s1.01



## ======================================== ##
## ======================================== ##
## ======================================== ##
##  User Setup / User Profile Backup (Host)
## ======================================== ##
sudo su

## Setup Admin Account
export DGNM='docker'
export DGID='2048'


## Only if no exist or different uid/gid
## Setup Docker Group
groupdel $DGNM || true
groupadd $DGNM
groupmod -g $DGID $DGNM
newgrp $DGNM
exit

## !!------------------------------------- ##
## If you want to use your local profiles, no need to run the following
## Run this part only if necessary (to create admin account)
## Setup  Admin Permission (dockeradm)
export NUSER='dockeradm'
export NUID='2046'
userdel -r $NUSER || true
adduser $NUSER --gecos "Docker Admin,,," --disabled-password --uid $NUID
groupmod -g $NUID $NUSER
echo "$NUSER:bigpass" | chpasswd
echo "$NUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#adduser $NUSER sudo
su $NUSER -c "ln -s /apps/datahub /home/$NUSER/datahub"
usermod -a -G $DGNM $NUSER

rm /home/$NUSER/datahub || true
su $NUSER -c "ln -s /apps/datahub /home/$NUSER/datahub"

## --------------------------------------!! ##
## Setup Host Directory
mkdir -p /apps/datahub
chmod 770 /apps/datahub
chown root:$DGNM /apps/datahub


## Backup User Profile Backups
rm -rf /apps/prfsync/ || true
mkdir -p /apps/prfsync/

## Setup UID filter limit (Ubuntu from 1000/CentOS from 500):
export UGIDLIMIT=1000

## Now copy /etc/passwd accounts to /apps/prfsync/passwd.mig using awk to filter out system account (i.e. only copy user accounts)
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd > /apps/prfsync/passwd.mig
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group > /apps/prfsync/group.mig
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > /apps/prfsync/shadow.mig

## Copy /etc/gshadow (rarely used):
cp /etc/gshadow /apps/prfsync/gshadow.mig

## Fix permission
chmod -R 640 /apps/prfsync
chown -R root:$DGNM /apps/prfsync

exit

## Move to current work directory
#sudo sh -c 'cp /apps/prfsync/*.mig ./'

## ======================================== ##

sudo docker run --name ubuntu-test02 \
    -itd \
    --publish 9002:80 \
    --volume /apps/prfsync:/apps/prfsync \
    --volume /home:/home \
    --volume /etc/localtime:/etc/localtime:ro \
    ubuntu:16.04


## ======================================== ##
##  Update User Profile (Docker Container)
## ======================================== ##
sudo docker exec -it ubuntu-test02 bash

export UGIDLIMIT=1000
awk -v LIMIT=$UGIDLIMIT -F: '$3<LIMIT' /etc/passwd > /apps/prfsync/passwd0.mig
awk -v LIMIT=$UGIDLIMIT -F: '$3<LIMIT' /etc/group > /apps/prfsync/group0.mig
awk -v LIMIT=$UGIDLIMIT -F: '$3<LIMIT {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > /apps/prfsync/shadow0.mig


rm /etc/passwd
cat /apps/prfsync/passwd0.mig >> /etc/passwd
cat /apps/prfsync/passwd.mig >> /etc/passwd

rm /etc/group
cat /apps/prfsync/group0.mig >> /etc/group
cat /apps/prfsync/group.mig >> /etc/group

rm /etc/shadow
cat /apps/prfsync/shadow0.mig >> /etc/shadow
cat /apps/prfsync/shadow.mig >> /etc/shadow

rm /etc/gshadow
cat /apps/prfsync/gshadow.mig >> /etc/gshadow

exit

# Then return
sudo docker exec -it ubuntu-test02 bash





## ======================================== ##
## ======================================== ##




https://medium.com/@jayden.chua/use-supervisor-to-run-your-python-tests-13e91171d6d3

sudo docker exec -it ubuntu-test bash

https://stackoverflow.com/questions/27341846/using-supervisor-as-cron


* * * * * supervisorctl start <taskname>


nano application/config/supervisor.php

$config['supervisor_servers'] = array(
        'CVT-Support' => array(
            'url' => 'http://txlinhdpneop1.retail.nrgenergy.com/RPC2',
            'port' => '9001',
            'username' => 'testuser',
            'password' => 'testpass'
            ),

        'Job-Support' => array(
            'url' => 'http://txlinhdpneop1.retail.nrgenergy.com/RPC2',
            'port' => '9002',
            'username' => 'testuser',
            'password' => 'testpass'
            ),




