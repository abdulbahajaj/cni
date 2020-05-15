#!/usr/bin/env bash

ln 10-mycniconf /etc/cni/net.d/10-mycniconf
chmod u+x mycniplugin
ln mycniplugin /opt/cni/bin/mycniplugin
