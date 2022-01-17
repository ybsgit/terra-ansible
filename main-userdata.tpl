#!/bin/bash
sudo hostnamectl set-hostname ${new_hostname} &&
sudo apt-get install -y apt-transport-https &&
sudo apt-get install -y software-properties-common wget &&
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add - &&
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list &&
sudo apt-get update &&
sudo apt-get install grafana -y
sudo systemctl enable grafana-server
sudo systemctl start grafana-server