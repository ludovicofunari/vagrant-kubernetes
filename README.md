[![vagrant-up](https://github.com/ludovicofunari/vagrant-kubernetes/actions/workflows/vagrant-up.yml/badge.svg?branch=main)](https://github.com/ludovicofunari/vagrant-kubernetes/actions/workflows/vagrant-up.yml)

# Quickly Setup a Kubernetes Cluster
## Using Vagrant and Ansible
This repository helps creating a Kubernetes cluster using `Vagrant` for the setup of the Virtual Machines and `Ansible` for the scripts installation.

> **Note:** Edit the `Vagrantfile` as needed, e.g. with the right architecture, number of VMs, CPU, memory etc. 

Some useful commands:

```bash
vagrant up                             # starts and provisions the vagrant environment

vagrant up --provisioner=virtualbox    # starts and provisions the vagrant environment
vagrant provision                      # if already up you can apply some changes
vagrant halt                           # stops the vagrant machine
vagrant global-status                  # to view all vagrants vm globally
vagrant plugin list                    # list the installed plugin
vagrant plugin install vagrant-libvirt # install libvirt plugin
vagrant up --no-parallel               # avoid parallelism
```

## New: use vagrant and ansible separately
```bash
controller_ip: CONTROLLER_IP,
arch: ARCH,
ubuntu_release: UBUNTU_RELEASE,
pod_cidr: POD_CIDR,
```
```bash
ansible-playbook \
  -i hosts \
  --extra-vars "controller_ip=CONTROLLER_IP" \
  --extra-vars "arch=ARCH" \
  --extra-vars "ubuntu_release=UBUNTU_RELEASE" \
  --extra-vars "pod_cidr=POD_CIDR" \
  kubernetes-setup/controller-playbook.yml
```

