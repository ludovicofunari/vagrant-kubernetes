RUN_ANSIBLE = true
## Vagrant Configuration Parameters
BOX_BASE = "generic/ubuntu2004" #"bento/ubuntu-20.04" 
UBUNTU_RELEASE = "focal" # focal (20.04), bionic (18.04), xenial (16.04)
ARCH = "amd64" # arch64 or amd64
VAGRANT_PROVIDER = "libvirt" # parallels, vmware_desktop, virtualbox, libvirt
CONTROLLER_CPU = 2
CONTROLLER_MEM = 2048
WORKERS = 4
WORKERS_CPU = 1
WORKERS_MEM = 1024

IP_BASE = "10.10.0."
CONTROLLER_IP_START = 100
CONTROLLER_IP = IP_BASE + "#{CONTROLLER_IP_START}"
WORKERS_IP_START = 101
POD_CIDR = "10.244.0.0/16"
PWD = ENV["PWD"] 

Vagrant.configure("2") do |config|
    if ARCH == "arm64"
        config.vm.box = "#{BOX_BASE + "-" + ARCH}"
    else
        config.vm.box = BOX_BASE
    end

    config.vm.synced_folder "#{PWD}/sharedDir", "/home/vagrant/sharedDir"

    # Provision the Kubernetes Controller
    config.vm.define "k8s-controller" do |node|
        node.vm.hostname = "k8s-controller"
        node.vm.network "private_network", ip: CONTROLLER_IP

        node.vm.provider VAGRANT_PROVIDER do |vb|
            vb.cpus = CONTROLLER_CPU
            vb.memory = CONTROLLER_MEM
        end

        if RUN_ANSIBLE == true
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "kubernetes-setup/controller-playbook.yml"
                ansible.extra_vars = {
                    controller_ip: CONTROLLER_IP,
                    arch: ARCH,
                    ubuntu_release: UBUNTU_RELEASE,
                    pod_cidr: POD_CIDR,
                }
            end
        end
    end

    # Provision the Kubernetes Workers
    (0..WORKERS).each do |i|

        config.vm.define "k8s-worker-#{i}" do |node|
            node.vm.hostname = "k8s-worker-#{i}"
            node.vm.network "private_network", ip: IP_BASE + "#{WORKERS_IP_START + i}"

            node.vm.provider VAGRANT_PROVIDER do |vb|
                vb.cpus = WORKERS_CPU
                vb.memory = WORKERS_MEM
            end

            if RUN_ANSIBLE == true
                node.vm.provision "ansible" do |ansible|
                    ansible.playbook = "kubernetes-setup/workers-playbook.yml"
                    ansible.extra_vars = {
                        worker_ip: IP_BASE + "#{WORKERS_IP_START + i}",
                        arch: ARCH,
                        ubuntu_release: UBUNTU_RELEASE,
                    }
                end
            end
        end
    end
end
