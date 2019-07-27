#!/bin/sh
VERSION=1.1156-vsc1.33.1
USER=coder

# code-server install
wget "https://github.com/cdr/code-server/releases/download/$VERSION/code-server$VERSION-linux-x64.tar.gz" -O temp.tgz
tar -C /opt -xvf temp.tgz
ln -s "/opt/code-server$VERSION-linux-x64" /opt/code-server
rm temp.tgz

# Supported variables (USER, PASSWORD, PORT and WORKDIR)
adduser --disabled-password --gecos "" $USER
usermod -aG sudo $USER
su -c "touch /home/$USER/.sudo_as_admin_successful" $USER
printf "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/code-server
printf "USER=$USER\n" > /opt/code-server/env
if [ ! -z $PASSWORD ]; then
  printf "PASSWORD=$PASSWORD\n" >> /opt/code-server/env
fi
if [ ! -z $PORT ]; then
  printf "PORT=$PORT\n" >> /opt/code-server/env
fi
if [ ! -z $WORKDIR ]; then
  if [ ! -d $WORKDIR ]; then
    su -c "mkdir -p $WORKDIR" $USER
  fi
  printf "WORKDIR=$WORKDIR\n" >> /opt/code-server/env
fi

# Service setup and startup
wget https://raw.githubusercontent.com/aielo/vscodaemon/master/daemon/sysvinit.service -O /etc/init.d/code-server
chmod +x /etc/init.d/code-server
update-rc.d code-server defaults
service code-server start