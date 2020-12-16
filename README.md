## Overview
This project provisions a one master one worker HA Kubernetes cluster using `k3s` with `vagrant` and `VirtualBox`. HA is accomplished by using `etcd` as cluster data store.
Starting point is one master one worker, however, any number of masters/workers can be provisioned by changing the settings in `config.yaml`.

## Prerequisites
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Quickstart
```
$ git clone https://github.com/tfjmp/k3s_cluster.git
$ cd k3s_cluster
$ vagrant up
$ ssh vagrant@172.20.22.10 -i .vagrant/machines/master01/virtualbox/private_key sudo cat /etc/rancher/k3s/k3s.yaml > k3s.yaml
$ sed -i 's/127.0.0.1/172.20.22.10/g' k3s.yaml
$ export KUBECONFIG=$(pwd)/k3s.yaml
$ kubectl get node -o wide
```
Replace `172.20.20.10` with correct master's IP if changed from default.

## Compatible Boxes
* `ubuntu/bionic64`
* `debian/buster64`
* `centos/7`

## Troubleshooting
__Problem__: k3s won't start completely.

Make sure `k3s.datastoreEndpoint` in `config.yaml` is reachable for all master nodes. Do a telnet to that host and port and make sure it connects.


__Problem__: kubectl won't connect.

Make sure `k3s.clusterName` is reachable on port `6443` from where `kubectl` is executed.
