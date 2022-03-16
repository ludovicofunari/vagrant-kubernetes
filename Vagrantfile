## Vagrant Configuration Parameters
BOX_BASE = "bento/ubuntu-20.04" 
UBUNTU_RELEASE = "focal" # focal (20.04), bionic (18.04), xenial (16.04)
ARCH = "arm64" # arch64 or amd64
VAGRANT_PROVIDER = "parallels" # parallels, vmware_desktop, virtualbox, libvirt
CONTROLLER_CPU = 2
CONTROLLER_MEM = 2048
WORKERS = 2
WORKERS_CPU = 1
WORKERS_MEM = 1024

IP_BASE = "10.0.0."
CONTROLLER_IP_START = 10
CONTROLLER_IP = IP_BASE + "#{CONTROLLER_IP_START}"
WORKERS_IP_START = 100
POD_CIDR = "192.168.0.0/16"
PWD = ENV["PWD"] 
SHARED_DIR_HOST = "sharedDir"
SHARED_DIR_GUEST = "/etc/vagrant/sharedDir"
SHARED_NFS_DIR = "/kubedata"

Vagrant.configure("2") do |config|
    if ARCH == "arm64"
        config.vm.box = "#{BOX_BASE + "-" + ARCH}"
    else
        config.vm.box = BOX_BASE
    end
    
    config.vm.synced_folder SHARED_DIR_HOST, SHARED_DIR_GUEST, create: true

    # Provision the Kubernetes Controller
    config.vm.define "k8s-controller-1" do |node|

        node.vm.hostname = "k8s-controller-1"
        node.vm.network "private_network", ip: CONTROLLER_IP

        node.vm.provider VAGRANT_PROVIDER do |vb|
            vb.name = "k8s-controller-1"
            vb.cpus = CONTROLLER_CPU
            vb.memory = CONTROLLER_MEM
        end

        node.vm.provision "ansible" do |ansible|

            ansible.playbook = "kubernetes-setup/controller-playbook.yml"
            ansible.extra_vars = {
                controller_ip: CONTROLLER_IP,
                arch: ARCH,
                ubuntu_release: UBUNTU_RELEASE,
                pod_cidr: POD_CIDR,
                shared_dir_guest: SHARED_DIR_GUEST,
            }

            # ansible.playbook = "ubench-setup/controller-ubench-playbook.yml"
            # ansible.extra_vars = {
                # controller_ip: CONTROLLER_IP,
                # shared_nfs_dir: SHARED_NFS_DIR,
            # }
        end

    end

    # Provision the Kubernetes Workers
    (1..WORKERS).each do |i|

        config.vm.define "k8s-worker-#{i}" do |node|

            node.vm.hostname = "k8s-worker-#{i}"
            node.vm.network "private_network", ip: IP_BASE + "#{WORKERS_IP_START + i}"

            node.vm.provider VAGRANT_PROVIDER do |vb|
                vb.name = "k8s-worker-#{i}"
                vb.cpus = WORKERS_CPU
                vb.memory = WORKERS_MEM
            end

            node.vm.provision "ansible" do |ansible|

                ansible.playbook = "kubernetes-setup/workers-playbook.yml"
                ansible.extra_vars = {
                    controller_ip: CONTROLLER_IP,
                    arch: ARCH,
                    ubuntu_release: UBUNTU_RELEASE,
                    shared_dir_guest: SHARED_DIR_GUEST,
                    shared_nfs_dir: SHARED_NFS_DIR,
                }

                # ansible.playbook = "ubench-setup/worker-ubench-playbook.yml"
                # ansible.extra_vars = {
                    # controller_ip: CONTROLLER_IP,
                    # shared_nfs_dir: SHARED_NFS_DIR,
                # }
            end
            
        end

    end

end
