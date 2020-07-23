#!/bin/bash -l

folders='/people /beehive /ports /roland /tasks /gears /home/nosrpm/e2k /srpms /archive'

for f in $folders; do
    echo  bin/mon.sh $f >> /tmp/up.log
    nohup bin/mon.sh $f >/dev/null 2>&1 &
done
