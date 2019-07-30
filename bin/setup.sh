#!/bin/bash

sudo mkdir /beehive/ /archive_git/ /people/ /ports/ /roland/ /tasks
sudo chmod 777 /archive_git/ /people/ /beehive/ /ports/ /roland/ /tasks

sshfs -p 222 apache@packages.altlinux.org:/srpms/ /srpms
sshfs -p 222 apache@packages.altlinux.org:/gears/ /gears
sshfs -p 222 apache@packages.altlinux.org:/people/ /people/

sshfs -p 222 apache@packages.altlinux.org:/beehive/ /beehive/
sshfs -p 222 apache@packages.altlinux.org:/roland/ /roland/
sshfs -p 222 apache@packages.altlinux.org:/ports/ /ports/
sshfs -p 222 apache@packages.altlinux.org:/tasks/ /tasks

sshfs -p 222 apache@packages.altlinux.org:/home/nosrpm/e2k/ /home/nosrpm/e2k/
