#!/bin/bash

sudo mkdir -p /beehive/ /archive_git/ /people/ /ports/ /roland/ /tasks /gears /home/nosrpm/e2k/ /srpms /archive
sudo chmod 777 /archive_git/ /people/ /beehive/ /ports/ /roland/ /tasks /gears /home/nosrpm/e2k/ /srpms /archive

sshfs -p 222 apache@packages.altlinux.org:/srpms/ /srpms
sshfs -p 222 apache@packages.altlinux.org:/gears/ /gears
sshfs -p 222 apache@packages.altlinux.org:/people/ /people/

sshfs -p 222 apache@packages.altlinux.org:/beehive/ /beehive/
sshfs -p 222 apache@packages.altlinux.org:/roland/ /roland/
sshfs -p 222 apache@packages.altlinux.org:/ports/ /ports/
sshfs -p 222 apache@packages.altlinux.org:/tasks/ /tasks
sshfs -p 222 apache@packages.altlinux.org:/archive/ /archive

sshfs -p 222 apache@packages.altlinux.org:/home/nosrpm/e2k/ /home/nosrpm/e2k/
