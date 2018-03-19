#
# Setup 
# =====
# ceph-admin-node     - runs ceph-deploy. Ceph public network.
#
# ceph-osd1           - hosts OSD1. Ceph public and cluster network.
#                       Also hosts MON, MGR and MDS for now.
# ceph-osd2           - hosts OSD2. Ceph public and cluster network.
# ceph-osd3           - hosts OSD3. Ceph public and cluster network.
#    :
#
# ceph-export1        - Ceph public network and export network.
#                       Mounts and exports RBD block device.
#    :
#
# ceph-export-client1 - Export network only. Mounts NFS export from ceph-export
#    :
#
#
NMONS=0
NMGRS=0
NMDSS=0
NEXPS=1
NECLS=1
NOSDS=3
EXPORT_SUBNET ="192.168.41"
PUBLIC_SUBNET ="192.168.42"
CLUSTER_SUBNET="192.168.43"
MEMORY=1024

Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-stretch64"
  # config.hostmanager.enabled = true
  # config.hostmanager.manage_host = false
  # config.hostmanager.manage_guest = true
  # config.hostmanager.ignore_private_ip = false
  # config.hostmanager.include_offline = true

  # Create cluster Ansible node connected to everything
  config.vm.define "ceph-ansible-node" do |node|
   node.vm.hostname = "ceph-ansible-node"
   node.vm.network :private_network, ip: "#{PUBLIC_SUBNET}.8"
   node.vm.network :private_network, ip: "#{CLUSTER_SUBNET}.8"
   node.vm.network :private_network, ip: "#{EXPORT_SUBNET}.8"
   node.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
   end
  end

  # Create ceph admin node 
  config.vm.define "ceph-admin-node" do |node|
   node.vm.hostname = "ceph-admin-node"
   node.vm.network :private_network, ip: "#{PUBLIC_SUBNET}.9"
   node.vm.network :private_network, ip: "#{CLUSTER_SUBNET}.9"
   node.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
   end
  end

  # Create NFS export mount nodes. These export RDB mounts to an external network.
  (0..NEXPS - 1).each do |i|
   config.vm.define "ceph-nexp#{i}" do |node|
    node.vm.hostname = "ceph-nexp#{i}"
    node.vm.network :private_network, ip: "#{PUBLIC_SUBNET}.2#{i}"
    node.vm.network :private_network, ip: "#{EXPORT_SUBNET}.2#{i}"
    node.vm.provider :virtualbox do |vb|
     vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
    end
   end
  end

  # Create NFS client nodes. These mount NFS exports of mounts of RDB block devices.
  (0..NECLS - 1).each do |i|
   config.vm.define "ceph-ncli#{i}" do |node|
    node.vm.hostname = "ceph-ncli#{i}"
    node.vm.network :private_network, ip: "#{EXPORT_SUBNET}.3#{i}"
    node.vm.provider :virtualbox do |vb|
     vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
    end
   end
  end

  # Create dedicated MON nodes. MON nodes are used to map names to object
  # store locations.
  (0..NMONS - 1).each do |i|
   config.vm.define "mon#{i}" do |mon|
    mon.vm.hostname = "mon#{i}"
    mon.vm.network :private_network, ip: "#{PUBLIC_SUBNET}.1#{i}"
    mon.vm.provider :virtualbox do |vb|
     vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
    end
   end
  end

  # Create any dedicared MDS nodes. MDS is used by CephFS
  (0..NMDSS - 1).each do |i|
   config.vm.define "mds#{i}" do |mds|
    mds.vm.hostname = "mds#{i}"
    mds.vm.network :private_network, ip: "#{PUBLIC_SUBNET}.7#{i}"
    mds.vm.provider :virtualbox do |vb|
     vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
    end
   end
  end

  # Create OSDs
  (0..NOSDS - 1).each do |i|
   config.vm.define "ceph-osd#{i}" do |osd|
    osd.vm.hostname = "ceph-osd#{i}"
    osd.vm.network :private_network, ip: "#{PUBLIC_SUBNET}.10#{i}"
    osd.vm.network :private_network, ip: "#{CLUSTER_SUBNET}.20#{i}"
    osd.vm.provider :virtualbox do |vb|
     unless File.exist?("disk-#{i}-0.vdi")
      vb.customize ['storagectl', :id,
                    '--name', 'OSD Controller',
                    '--add', 'scsi']
     end
     (0..1).each do |d|
      vb.customize ['createhd',
                    '--filename', "disk-#{i}-#{d}",
                    '--size', '11000'] unless File.exist?("disk-#{i}-#{d}.vdi")
      vb.customize ['storageattach', :id,
                    '--storagectl', 'OSD Controller',
                    '--port', 3 + d,
                    '--device', 0,
                    '--type', 'hdd',
                    '--medium', "disk-#{i}-#{d}.vdi"]
     end
     vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
    end
   end
  end

end
