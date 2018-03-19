#!/bin/bash
nf=vml.txt

vagrant ssh ceph-ansible-node -- '/bin/rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub; 'ssh-keygen -f '~'/.ssh/id_rsa -t rsa -N \'\'
vagrant ssh ceph-ansible-node -- '/bin/rm ~/.ssh/known_hosts'

echo '# Propagating master key'
(
for nn in `cat $nf | grep -v ceph-ansible-node` ; do
 vagrant ssh ceph-ansible-node -- ssh-keyscan -H ${nn} '>> ~/.ssh/known_hosts'
 vagrant ssh ceph-ansible-node -- cat '~/.ssh/id_rsa.pub' | vagrant ssh ${nn} -- cat '>> ~/.ssh/authorized_keys'
done
) | tee setmasterkey.log
echo '# done'
