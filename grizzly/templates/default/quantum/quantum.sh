#! /bin/bash
# create floating ip pool for quantum
NETWORK="195.208.117.182/26"
POOL_BEGIN="195.208.117.240"
POOL_END="195.208.117.253"
GATEWAY="195.208.117.254"

source /root/adminrc.sh
ADMIN=$(keystone tenant-list | awk '/admin/{print $2}')
exist=$(quantum net-list | grep -o "floating-pool")
if [ -n "$exist" ] ; then
	echo "Already exists, doing nothing"
else
	EXT_NET=$(quantum net-create --tenant-id $ADMIN floating-pool --router:external=True | awk '/ id /{print $4}')
	EXT_SUBNET=$(quantum subnet-create --tenant-id $ADMIN --allocation-pool start=$POOL_BEGIN,end=$POOL_END --gateway $GATEWAY floating-pool $NETWORK --enable_dhcp=False | awk '/ id /{print $4}')
fi
