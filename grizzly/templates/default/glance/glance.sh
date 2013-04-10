#!/bin/bash
source /root/adminrc.sh
read -p "Upload cirros-0.3.0 qcow image? (Y/N)"
if [ "$(echo $REPLY | tr '[:upper:]' '[:lower:]')" == "y" ]; then 

glance image-create --name cirros-0.3.0-qcow-image --is-public true --container-format bare --disk-format qcow2 --copy-from http://xenlet.stu.neva.ru/cirros/0.3.0/x86_64/disk.img

fi

read -p "Upload ubuntu-12.04 ami image? (Y/N)"
if [ "$(echo $REPLY | tr '[:upper:]' '[:lower:]')" == "y" ]; then 

	RAMDISK=$(glance image-create --name ubuntu12_ramdisk --disk-format ari --container-format ari --is-public true --copy-from http://xenlet.stu.neva.ru/ubuntu/12.04/x86_64/initrd.img-3.2.0-23-generic | grep id | awk '{print $4}')

	KERNEL=$(glance image-create --name ubuntu12_kernel --disk-format aki --container-format aki --is-public true --copy-from http://xenlet.stu.neva.ru/ubuntu/12.04/x86_64/vmlinuz-3.2.0-23-generic | grep id | awk '{print $4}')

	glance image-create --name ubuntu-12.04-ami-image --is-public true --disk-format ami --container-format ami --property kernel_id=$KERNEL --property ramdisk_id=$RAMDISK --copy-from http://xenlet.stu.neva.ru/ubuntu/12.04/x86_64/disk.img

fi

read -p "Upload debian-6.0 ami image? (Y/N)"
if [ "$(echo $REPLY | tr '[:upper:]' '[:lower:]')" == "y" ]; then 

	RAMDISK=$(glance image-create --name debian6_ramdisk --disk-format ari --container-format ari --is-public true --copy-from http://xenlet.stu.neva.ru/debian/6.0/x86_64/initrd.img-3.2.0-23-generic | grep id | awk '{print $4}')

	KERNEL=$(glance image-create --name debian6_kernel --disk-format aki --container-format aki --is-public true --copy-from http://xenlet.stu.neva.ru/debian/6.0/x86_64/vmlinuz-3.2.0-23-generic | grep id | awk '{print $4}')

	glance image-create --name debian-6.0-ami-image --is-public true --disk-format ami --container-format ami --property kernel_id=$KERNEL --property ramdisk_id=$RAMDISK --copy-from http://xenlet.stu.neva.ru/debian/6.0/x86_64/disk.img

fi

read -p "Upload centos-6.3 ami image? (Y/N)"
if [ "$(echo $REPLY | tr '[:upper:]' '[:lower:]')" == "y" ]; then
 
	RAMDISK=$(glance image-create --name centos63_ramdisk --disk-format ari --container-format ari --is-public true --copy-from http://xenlet.stu.neva.ru/centos/6.0/x86_64/initramfs-2.6.32-279.5.2.el6.x86_64.img | grep id | awk '{print $4}')

	KERNEL=$(glance image-create --name centos63_kernel --disk-format aki --container-format aki --is-public true --copy-from http://xenlet.stu.neva.ru/centos/6.0/x86_64/vmlinuz-2.6.32-279.5.2.el6.x86_64 | grep id | awk '{print $4}')

	glance image-create --name centos-6.3-ami-image --is-public true --disk-format ami --container-format ami --property kernel_id=$KERNEL --property ramdisk_id=$RAMDISK --copy-from http://xenlet.stu.neva.ru/centos/6.0/x86_64/disk.img

fi

read -p "Upload scientific-6.3 ami image? (Y/N)"
if [ "$(echo $REPLY | tr '[:upper:]' '[:lower:]')" == "y" ]; then
 
	RAMDISK=$(glance image-create --name scientific63_ramdisk --disk-format ari --container-format ari --is-public true --copy-from http://xenlet.stu.neva.ru/scientificlinux/6.3/x86_64/initramfs-2.6.32-279.5.1.el6.x86_64.img | grep id | awk '{print $4}')

	KERNEL=$(glance image-create --name scientific63_kernel --disk-format aki --container-format aki --is-public true --copy-from http://xenlet.stu.neva.ru/scientificlinux/6.3/x86_64/vmlinuz-2.6.32-279.5.1.el6.x86_64 | grep id | awk '{print $4}')

	glance image-create --name  scientific-6.3-ami-image --is-public true --disk-format ami --container-format ami --property kernel_id=$KERNEL --property ramdisk_id=$RAMDISK --copy-from http://xenlet.stu.neva.ru/scientificlinux/6.3/x86_64/disk.img

fi

read -p "Upload freebsd-9.1 raw image? (Y/N)"
if [ "$(echo $REPLY | tr '[:upper:]' '[:lower:]')" == "y" ]; then
	glance image-create --name freebsd-9.1-raw-image --is-public true --disk-format raw --container-format bare --copy-from http://xenlet.stu.neva.ru/freebsd/9.1/x86_64/disk.img
fi
