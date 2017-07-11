#!/bin/bash -v

ADMIN_USER1="dicky"

echo 'creating user'
sudo su;
useradd -m $ADMIN_USER1;
usermod -a -G wheel $ADMIN_USER1;
usermod -a -G adm $ADMIN_USER1;
echo "$ADMIN_USER1        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

echo 'copy key'
mkdir -p /home/$ADMIN_USER1/.ssh;
chmod -R 700 /home/$ADMIN_USER1/.ssh;
cp /home/ec2-user/.ssh/authorized_keys /home/$ADMIN_USER1/.ssh/;
chmod 400 /home/$ADMIN_USER1/.ssh/authorized_keys;
chown -R $ADMIN_USER1.$ADMIN_USER1 /home/$ADMIN_USER1;

yum update -y

echo '==>exiting init...'
