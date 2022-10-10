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

# Tip
If this error shows up while installing Kubernetes cluster:
```
[init] Using Kubernetes version: v1.25.2
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR CRI]: container runtime is not running: output: E1010 14:47:06.968395    1128 remote_runtime.go:948] "Status from runtime service failed" err="rpc error: code = Unimplemented desc = unknown service runtime.v1alpha2.RuntimeService"
time="2022-10-10T14:47:06Z" level=fatal msg="getting status of runtime: rpc error: code = Unimplemented desc = unknown service runtime.v1alpha2.RuntimeService"
, error: exit status 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
```

Then, follow what [this guy](https://www.reddit.com/r/kubernetes/comments/utiymt/comment/i9h3fgg/?utm_source=share&utm_medium=web2x&context=3) suggests:

```
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm init

