#!/bin/bash
# set -evx

nf=vml.txt

echo '# Creating hosts.src'
(
for nn in `cat $nf` ; do
 vagrant ssh $nn -- ip -f inet a show eth1 | grep inet | awk '{print $2}' | awk -F/ '{print $1" '${nn}'"}'
done
) | tee hosts.src
echo '# done'

echo '# Setting /etc/hosts'
(
unset hh
for nn in `cat $nf` ; do
 export nn
 echo '#  '${nn}
 hh=${nn} ; echo "127.0.0.1   localhost" | vagrant ssh ${nn} -- 'cat >  hosts.new'
 hh=${nn} ; echo "127.0.1.1   ${hh}"     | vagrant ssh ${nn} -- 'cat >> hosts.new'
 cat hosts.src | vagrant ssh ${nn} -- 'cat >> hosts.new; sudo cp hosts.new /etc/hosts'
done
)
echo '# done'

# 'cp /etc/hosts hosts.s00; cat > hosts.s01 ; sudo cp hosts.s01 /etc/hosts'

