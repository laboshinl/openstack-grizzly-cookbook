#! /bin/bash
ADMIN=$(keystone tenant-list | awk '/admin/{print $2}')
INT_NET=$(quantum net-create --tenant-id $ADMIN admin-net | awk '/ id /{print $4}')
INT_SUBNET=$(quantum subnet-create --tenant-id $ADMIN admin-net 172.16.0.0/24 | awk '/ id /{print $4}')
ROUTER=$(quantum router-create --tenant-id $ADMIN admin-router | awk '/ id /{print $4}')
quantum router-interface-add $ROUTER $INT_SUBNET
EXT_NET=$(quantum net-create --tenant-id $ADMIN ext_net --router:external=True | awk '/ id /{print $4}')
EXT_SUBNET=$(quantum subnet-create --tenant-id $ADMIN --allocation-pool start=195.208.117.134,end=195.208.117.139 --gateway 195.208.117.158 ext_net 195.208.117.128/27 --enable_dhcp=False | awk '/ id /{print $4}')
quantum router-gateway-set $ROUTER $EXT_NET
