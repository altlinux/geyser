#!/bin/bash -l

if [ -z "$1" ]; then
   exit 1
fi

echo $1
folder=$1

sudo mkdir -p $folder
sudo chmod 777 $folder

while true; do
   if [ -z "$(ls $folder 2>/dev/null)" ]; then
      sudo umount -l $folder
      eval $(ssh-agent)
      ssh-add
      sshfs -p 222 apache@packages.altlinux.org:$folder/ $folder -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
   else
      sleep 1
   fi
done
