#!/bin/bash

nf=vml.txt

echo '# Running preflight-all steps'
(
for nn in `cat $nf ` ; do
 echo '# '$nn
 cat preflight-all.scr | vagrant ssh ${nn} -- cat '> preflight-all.scr'
 vagrant ssh ${nn} -- 'source preflight-all.scr'
done
) | tee preflight-all.log
echo '# done'


