#!/bin/bash

sudo mkdir /beehive/ /archive_git/ /people/ /ports/ /roland/
sudo chmod 777 /archive_git/ /people/ /beehive/ /ports/ /roland/

sshfs -p 222 apache@packages.altlinux.org:/archive_git/ /archive_git/
sshfs -p 222 apache@packages.altlinux.org:/beehive/ /beehive/
sshfs -p 222 apache@packages.altlinux.org:/people/ /people/
sshfs -p 222 apache@packages.altlinux.org:/roland/ /roland/
sshfs -p 222 apache@packages.altlinux.org:/ports/ /ports/
