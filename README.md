## Overview
This project provisions a k3s Kubernetes cluster with one master and 1 worker node using Vagrant and VirtualBox.
You can, however, have any number of master/worker nodes by changing the settings in `config.yaml`.

## Quickstart
```
$ git clone https://github.com/trankchung/k3s_cluster.git
$ cd k3s_cluster
$ vagrant up
$ export KUBECONFIG=$(pwd)/k3s.yaml
$ kubectl get node -o wide
```

## Troubleshooting
__Problem__: k3s won't start completely.

Make sure `k3s.datastoreEndpoint` in `config.yaml` is reachable for all master nodes. Do a telnet to that host and port and make sure it connects.


__Problem__: kubectl won't connect.

Make sure `k3s.clusterName` is reachable on port `6443` from where `kubectl` is executed.

