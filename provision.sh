#!/bin/bash -x
NODE_TYPE=$1
NODE_IP=$2
K3S_VERSION=$3
K3S_CLUSTER_NAME=$4
K3S_TOKEN=$5
K3S_DATASTORE_ENDPOINT=$6
K3S_PARAMS=$7

cd /vagrant

# Install etcd on all masters
if [ "$NODE_TYPE" == "master" ]; then
  apt update && apt install -y etcd
  etcd_file=/etc/default/etcd
  [ -f $etcd_file ] && mv $etcd_file "${etcd_file}.`date +'%Y%m%d'`"
  (
  echo ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
  echo ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2379
  ) > $etcd_file
  systemctl enable etcd
  systemctl start etcd
fi

# Adding entries in hosts file into /etc/hosts
hosts_file=/etc/hosts
while IFS= read -r line
do
  grep -q "$line" $hosts_file
  if [ $? -eq 1 ]; then
    echo Adding $line into $hosts_file
    echo $line >> $hosts_file
  fi
done < `pwd`/hosts

# Download k3s.
wget --quiet "https://github.com/rancher/k3s/releases/download/v$K3S_VERSION/k3s"
mv k3s /usr/local/bin && chmod +x /usr/local/bin/k3s

# Create /etc/default/k3s service environment file
(
echo K3S_NODE_IP=$NODE_IP
echo K3S_TOKEN=$K3S_TOKEN
echo K3S_TLS_SAN=$K3S_CLUSTER_NAME
echo K3S_DATASTORE_ENDPOINT=$K3S_DATASTORE_ENDPOINT
echo K3S_URL="https://${K3S_CLUSTER_NAME}:6443"
) > /etc/default/k3s

# Create k3s.service
if [ "$NODE_TYPE" == "master" ]; then
  start_command="\/usr\/local\/bin\/k3s server --node-ip \$K3S_NODE_IP --tls-san \$K3S_TLS_SAN $K3S_PARAMS"
else
  start_command="\/usr\/local\/bin\/k3s agent --node-ip \$K3S_NODE_IP $K3S_PARAMS"
fi
echo $start_command
sed "s/ExecStart.*/ExecStart=$start_command/g" `pwd`/k3s.service > /lib/systemd/system/k3s.service
systemctl enable k3s
systemctl start k3s

