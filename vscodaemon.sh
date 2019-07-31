#!/usr/bin/env sh

# Description:   vscodaemon installer
# Documentation: https://github.com/aielo/vscodaemon/blob/master/README.md
# Author:        Ricardo Aielo <ricardo.aielo@gmail.com>

set -e

abort() {
    MSG=$1
    echo "Error: $1" >&2
    exit 2
}

# Custom variables
while [ $# -gt 0 ]; do
  case "$1" in
    -g|--group)
      GROUP="$2"
      shift 2
      ;;
    -i|--install-dir)
      IDIR="$2"
      shift 2
      ;;
    -p|--password)
      PASSWD="$2"
      shift 2
      ;;
    -P|--port)
      PORT="$2"
      shift 2
      ;;
    -s|--grant-sudo)
      SUDO=1
      shift 1
      ;;
    -u|--user)
      USER="$2"
      shift 2
      ;;
    -v|--version)
      VERSION="$2"
      shift 2
      ;;
    -w|--work-dir)
      WDIR="$2"
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

# Dependency: wget or curl
[ $(which wget) ] && WGET=1 || [ $(which curl) ] || abort "wget or curl is required for installation"

# Dependency: sudo (--allow-sudo only)
[ $SUDO ] && [ ! $(which sudo) ] && abort "sudo is required for installation with --grant-sudo"

# Install
HOME=${IDIR:-/opt/code-server}
USER=${USER:-coder}
GROUP=${GROUP:-$USER}
WDIR=${WDIR:-$(getent passwd $USER | cut -d: -f6)}
[ $WGET ] && CMD="wget --max-redirect=0 -qSO-" || CMD="curl -sI"
VERSION=${VERSION:-$($CMD https://github.com/cdr/code-server/releases/latest 2>&1|sed -rn -e 's/^.*Location:.*tag\/(.*)(\r|$)/\1/p')}
[ -d $HOME ] || mkdir -p $HOME
[ $WGET ] && CMD="wget -qO" || CMD="curl -sLo"
$CMD $HOME/code-server.tgz https://github.com/cdr/code-server/releases/download/$VERSION/code-server$VERSION-linux-x64.tar.gz
tar -C $HOME -xf $HOME/code-server.tgz
mv $HOME/code-server$VERSION-linux-x64/* $HOME/
rm -Rf $HOME/code-server.tgz $HOME/code-server$VERSION-linux-x64

# Setup
[ $(getent passwd $USER) ] || useradd $USER -m -s /bin/bash
[ $(getent group $GROUP) ] || groupadd $GROUP && usermod -aG $GROUP $USER
[ -d $WDIR ] || su -c "mkdir -p $WDIR" $USER
[ $SUDO ] && echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/code-server
echo $VERSION > $HOME/version
[ -f $HOME/env ] && rm -f $HOME/env
for KEY in GROUP PASSWD PORT USER WDIR; do
  eval "VALUE=\$$KEY"
  [ -z $VALUE ] || echo "$KEY=$VALUE" >> $HOME/env
done
if [ -f /etc/environment ] && [ $(grep 'CODESERVER=' /etc/environment) ]; then
  sed -ri "s|(CODESERVER=).*|\1$HOME|g" /etc/environment
else
  echo CODESERVER=$HOME >> /etc/environment
fi

$($CMD /etc/init.d/code-server https://raw.githubusercontent.com/aielo/vscodaemon/refactor/unique-installer/daemon/code-server)
chmod +x /etc/init.d/code-server
update-rc.d code-server defaults

# Run
service code-server start
