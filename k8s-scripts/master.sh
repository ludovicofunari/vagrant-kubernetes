# #!/bin/bash
MASTER_IP="10.4.0.4"
NODENAME=$(hostname -s)
POD_CIDR="10.244.0.0/16"

#sudo kubeadm config images pull
sudo apt install jq -y
echo "Preflight Check Passed: Downloaded All Required Images"

echo "############### Copying K8s shortcuts #############"
cat <<EOF >> ~/.bashrc

## Kubernetes shortcuts

source <(kubectl completion bash)
complete -F __start_kubectl k

alias k="kubectl"

alias kgp="kubectl get po"
alias po="kubectl get po -o wide"
alias kgs="kubectl get svc"
alias svc="kubectl get svc -o wide"
alias kgn="kubectl get no"
alias no="kubectl get no -o wide"

alias kapp="kubectl apply -f"
alias kdel="kubectl delete -f"

do="--dry-run=client -o yaml"
gf="--grace-period=0 --force"
ks="-n kube-system"

alias jqk="jq '. | keys'"
EOF

source ~/.bashrc
echo "############ Copying K8s shortcuts... OK ##########"

echo "############### Creating K8s cluster... ############"
sudo kubeadm init --apiserver-advertise-address=$MASTER_IP  --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name $NODENAME

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "############# Creating K8s cluster... OK ###########"

echo "########### Install K8s network plugin... ############"
## Install K8s network plugin
## Calico
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml

## Flannel
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
echo "########### Install K8s network plugin... OK #########"


echo "###################################"
echo "############ ALL DONE! ############"
echo "###################################"