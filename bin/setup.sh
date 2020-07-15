#!/bin/bash

sudo mkdir -p /beehive/ /people/ /ports/ /roland/ /tasks /gears /home/nosrpm/e2k/ /srpms /archive
sudo chmod 777 /people/ /beehive/ /ports/ /roland/ /tasks /gears /home/nosrpm/e2k/ /srpms /archive

sshfs -p 222 apache@packages.altlinux.org:/srpms/ /srpms -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
sshfs -p 222 apache@packages.altlinux.org:/gears/ /gears -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
sshfs -p 222 apache@packages.altlinux.org:/people/ /people/ -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3

sshfs -p 222 apache@packages.altlinux.org:/beehive/ /beehive/ -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
sshfs -p 222 apache@packages.altlinux.org:/roland/ /roland/ -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
sshfs -p 222 apache@packages.altlinux.org:/ports/ /ports/ -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
sshfs -p 222 apache@packages.altlinux.org:/tasks/ /tasks -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
sshfs -p 222 apache@packages.altlinux.org:/archive/ /archive -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3

sshfs -p 222 apache@packages.altlinux.org:/home/nosrpm/e2k/ /home/nosrpm/e2k/ -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
