#!/bin/bash

sudo mkdir /beehive/
sudo chmod 777 /beehive/
sudo mkdir /archive_git/
sudo chmod 777 /archive_git/

sshfs -p 222 apache@packages.altlinux.org:/archive_git/ /archive_git/
sshfs -p 222 apache@packages.altlinux.org:/beehive/ /beehive/

