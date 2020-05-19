#!/usr/bin/env bash

PATH_TO_DIR=$(dirname $0)
CONF_FILE_PATH=$PATH_TO_DIR/10-mycniconf
CNI_PLUGIN_PATH=$PATH_TO_DIR/mycniplugin

CONF_FILE_CONTENT=$(cat $CONF_FILE_PATH)
BRIDGE_NAME=$(echo $CONF_FILE_CONTENT | jq -r '.name')

BRIDGE_IP_ADDRESS=$(echo $CONF_FILE_CONTENT | jq -r '.plugins[0].nodeCidr' | sed -E "s/[0-9]{1,3}\/[0-9]{1,2}/1\/24/g")

echo $BRIDGE_IP_ADDRESS


echo "Creating bridge"
ip link add $BRIDGE_NAME type bridge
ip link set $BRIDGE_NAME up
ip addr add $BRIDGE_IP_ADDRESS dev $BRIDGE_NAME

echo "Enabling packet forwarding"
sudo sysctl net.ipv4.ip_forward=1

echo "Installing plugin"
ln $CONF_FILE_PATH /etc/cni/net.d/10-mycniconf
chmod u+x $CNI_PLUGIN_PATH
ln $CNI_PLUGIN_PATH /opt/cni/bin/mycniplugin
