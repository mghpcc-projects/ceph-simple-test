# ceph-simple-test
Exploring simple Vagrant setup for learning about Ceph Luminous

Some Ceph testing scripts that can be used with
http://docs.ceph.com/docs/master/start/ to get familiar
with components of Ceph.

# Lessons so far trying CentOS7 as the Ceph backend distribution.

The instructions in http://docs.ceph.com/docs/master/start/ relating to CentOS7 do not work – don’t try and follow them. In particular there appears to have been a discoonnect for the last two years between the RHEL development team and the CentOS7 downstream team. 

https://bugzilla.redhat.com/show_bug.cgi?id=1292577 has some details on the disconnect. The entry describes a broken situation that seemingly has been unfixed for 2+ years. The docs at doc.ceph.com fail to mention this, which almost certainly has wasted a lot of time for people over the last two years. Although Redhat is the lead sponsor
for Ceph and for CentOS7 there is apparently little overlap. Per the bugzilla thread

```
The CentOS Storage SIG Ceph repos do not currently match up with the downstream RH Ceph Storage product. The two are maintained by almost entirely separate groups of people. They are not connected in the way that CentOS itself and RHEL Base are connected, for example, or RDO and RHEL OSP, etc.

Eventually we need to get more alignment there, but that's not the reality today. (If you have a support contract with RH it would be good to pass this feedback up through your RH support representatives.)
```

this problem appears to have persisted for more than two years.


# Lessons so far trying ceph-ansible

Another possible approach is ceph-ansible - https://github.com/ceph/ceph-ansible. This is an important
go to location for production Ceph deployments. For learning, the ceph-ansible system is quite complicated.
There are many YAML configuration files, only a few of which need site settings. The documentation
at http://docs.ceph.com/ceph-ansible/master/ is relatively sparse. 

Applying the ceph-ansible instructions and targetting CentOS7 as the backend distribution
failed in similar ways to direct efforts with hand configuration. ceph-ansible does reportedly work
for others with the Redhat Ceph Storage v1 (RHCS v1). RHCS is now at v3.0, so it is unclear whether
working with v1 is good, bad or neutral.

# Lessons so far trying Debian Stretch as the backend Ceph distribution.

Debian Stretch does seem to work as a backend based on Luminous following the instructions in 
http://docs.ceph.com/docs/master/start/. One instruction has a small missing 
qualifier. The command
```
ceph-deploy install {node}
```
needs the explicit flag ```--release luminous``` to work 
with Luminous. It should read
```
ceph-deploy install {node} --release luminous
```

A vagrant setup, command notes and helper scripts for testing this way have been
archived in this repo.

The current Debian NTP setup is generating some errors that should be fixed before
using this setup for too much.

# Files



