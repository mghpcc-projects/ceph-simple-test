#!/bin/bash

nf=vml.txt

echo '# Running preflight steps'
(
for nn in `cat $nf | grep -e ceph-admin -e ceph-ansible` ; do
 echo '# '$nn
 cat preflight.scr | vagrant ssh ${nn} -- cat '> preflight.scr'
 vagrant ssh ${nn} -- 'source preflight.scr'
done
) | tee preflight.log
echo '# done'


