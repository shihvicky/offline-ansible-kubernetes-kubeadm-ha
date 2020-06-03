這個 repository 裡的 playbook，是給 CentOS 或 Red Hat 的主機使用。其目的在於如何在不能直接連上 Internet 的環境下，透過 kubeadm 安裝 Kubernetes cluster 。

(需要直接於 Internet 上透過 Ansible playbooks 安裝 Kubernetes cluster 的，請右轉至 https://github.com/MnrGreg/ansible-kubernetes-kubeadm-ha )



## 事先準備工作: ##

在使用之前，請事先先把 kubeadm 會使用到的 package 與 cotainer images 下載下來，並放到 yum server 與 container registry 上

How to use yum to download a package without installing it
https://access.redhat.com/solutions/10154

請參考上述的網頁，下載 kubernetes 相關的 package: kubeadm, kubectl 以及 kubelet

至於 Kubernetes images 的清單，可以在裝好 kubeadm 後，參考以下的網頁：

https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/

以 kubeadm config images list 以及 kubeadm config images pull 把會用到的 images pull 回來，
然後再 push 至 Harbor 這一類的 container registry 上


## Ansible inventory 設定： ##

請參考 inventory/hosts


## 設定共同的變數： ##

請參考 inventory/group_vars/all.yaml


## 執行方式： ##

### 全新安裝 ###

> \# ansible-playbook -i inventory/hosts playbooks/install-all.yaml -e 'target="k8s-nodes"' -e 'target_worker="k8s-workers"'

### 加入新的 worker node(s) ###

先修改 inventory/hosts ，將要加入的 worker node(s)，加在 [new-worker-node] 下方

> \# ansible-playbook -i inventory/hosts playbooks/install-new-worker-node.yaml -e 'target="new-worker-node"' -e 'target_worker="new-worker-node"'

執行後，會依序安裝以下的軟體

* cri-o
* haproxy        （Master node only)
* keepalived     （Master node only)
* kubeadm
* kubectl
* kubelet
* Kubernetes dashboard
* helm, 並透過 helm 安裝 metrics server
