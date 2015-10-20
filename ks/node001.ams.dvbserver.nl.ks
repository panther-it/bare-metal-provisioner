#!/bin/bash
# Kickstart for Fedora
auth --enableshadow --passalgo=sha512
  
install
url --url=https://download.fedoraproject.org/pub/fedora/linux/releases/22/Server/x86_64/os

lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts=us

rootpw secret
user --groups=wheel --name=sterburg --password=<%= node.root_password %>

network --hostname node001.ams.dvbserver.nl
network --bootproto=static --device=bond0 --gateway=94.75.235.190 --ip=94.75.235.130 --nameserver=8.8.8.8,8.8.4.4 --netmask=255.255.255.192 --noipv6 --activate --bondslaves=eno2,eno1 --bondopts=miimon=1,balance-tlb
timezone Europe/Amsterdam --isUtc

bootloader --location=mbr --boot-drive=sda --append="crashkernel=auto"
zerombr
clearpart --all --initlabel --drives=sda
part pv.01 --fstype=lvmpv --ondisk=sda --size=22000 --grow
volgroup os pv.01
logvol swap --fstype=swap --size=10000 --label=swap --name=swap --vgname=os
logvol / --fstype=xfs --size=20000 --label=/ --name=root --vgname=os
logvol /var/lib/docker --fstype=xfs --size=1000 --grow --label=/var/lib/docker --name=var_lib_docker --vgname=os

services --enabled=chronyd

reboot
  
%packages --nobase
@core
@standard
@editors
@headless-management
@server-hardware-support
@server-product
@domain-client
@container-management
chrony

  
%end
  
%post --log=/var/log/ks.log
echo Kickstart post

%end
