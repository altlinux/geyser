#!/bin/bash -l

echo "Start mon scripts at $(date +%Y%m%d%H%M%S)" >> /tmp/up.log

folders='/people /beehive /ports /roland /tasks /gears /home/nosrpm/e2k /srpms /archive'
root=$(dirname "$(realpath $0)")

for f in $folders; do
    echo  $root/mon.sh $f >> /tmp/up.log
    nohup $root/mon.sh $f >> /tmp/up.log 2>&1 &
done
