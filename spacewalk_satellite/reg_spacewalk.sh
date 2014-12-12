#!/bin/bash
#
#	Oildex spacewalk registration script for CentOS v2.0
#
#	Dustin Morgan <dmorgan@oildex.com>
#
#	Oct, 3rd 2014
#
#	Usage: Intended to work on any centos variant
#              Within Oildex internal/external environments
#
#

KERNEL=$(uname -r)
ARCH=$(uname -i)

#clean cache
yum clean all
#Remove remote repos
mv /etc/yum.repos.d/* /root/

#Activation Keys

#Centos 7
CentOS_7="1-870fcca86d743de7bcf6bc6c1aaaa6bb"

#Centos 6
CentOS_6="1-2a90cb37a23350155f30c9611e42204a"

#Centos 5
CentOS_5_32="1-eb2eaac3e423ab007a2d26973f03a94a"
CentOS_5_64="1-17d1841093bae4dc00781b90106f3ced"

#Centos 4
CentOS_49_32="1-b9b8e21c6c8c9242de1b28691ac212ea"
CentOS_47_32="1-df7d24a31a37ac80d2bd80d998d206a7"
CentOS_46_32="1-d8179f458d41f041667cc4fcda733fc0"
CentOS_45_32="1-bee98c071631c052cc3621e277f7da92"
CentOS_44_32="1-68d3d116e7a99c0c11cf662af2ff9722"

#Oracle Linux 6
OraclLinux_6="1-f46a8da531da3023cb537ba70f687eb8"

## KERNELS
#CentOS 4
EL44="2.6.9-42.0.3.ELsmp"
EL45="2.6.9-55.ELsmp"
EL46="2.6.9-67.0.22.ELsmp"
EL47="2.6.9-78.0.5.ELsmp"
EL49="2.6.9-100.ELsmp"
if [ $KERNEL = $EL49 ]; then KEY=$CentOS_49_32; fi
if [ $KERNEL = $EL47 ]; then KEY=$CentOS_47_32; fi
if [ $KERNEL = $EL46 ]; then KEY=$CentOS_46_32; fi
if [ $KERNEL = $EL45 ]; then KEY=$CentOS_45_32; fi
if [ $KERNEL = $EL44 ]; then KEY=$CentOS_44_32; fi

#CentOS 5 Kernels in Oildex
if [ `uname -r|grep el5` ] && [ `uname -i|grep i386` ]; then KEY=$CentOS_5_32; fi
if [ `uname -r|grep el5` ] && [ `uname -i|grep x64` ]; then KEY=$CentOS_5_64; fi

#CentOS 6
#if [ echo $KERNEL|grep el6 ]; then KEY=$CentOS_6; fi 

#CentOS 7
#if [ echo $KERNEL|grep el7 ]; then KEY=$CentOS_7; fi

#Re-enable base repos incase this script failed once before
mv /root/*.repo /etc/yum.repos.d/

echo $KEY

#update deps for tools packages
curl -k -O https://spacewalk.example.com/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm

#Install Dependancies for spacewalk-tools
if [ `uname -r|grep el5` ]; then

#Grab rhn tools copied to pub from the spacewalk-client repo
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/rhn-check-2.2.7-1.el5.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/rhn-client-tools-2.2.7-1.el5.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/rhn-setup-2.2.7-1.el5.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/rhnlib-2.5.72-1.el5.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/$ARCH/rhnsd-5.0.14-1.el5.$ARCH.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/yum-rhn-plugin-2.2.7-1.el5.noarch.rpm

#Deps
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/$ARCH/pyOpenSSL-0.6-2.el5.$ARCH.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/$ARCH/python-dmidecode-3.10.13-1.el5_5.1.$ARCH.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/$ARCH/python-ethtool-0.6-2.el5.$ARCH.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL5/$ARCH/libnl-1.0-0.10.pre5.5.i386.rpm

curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-CentOS-5
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-EPEL-5
fi

#CentOS 6
if [ $KEY = $CentOS_6 ]; then
yum -y update libudev
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/dbus-python-0.83.0-6.1.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/python-ethtool-0.6-5.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/pyOpenSSL-0.10-2.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/python-gudev-147.1-4.el6_0.1.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/m2crypto-0.20.2-9.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/libgudev1-147-2.51.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/pkgconfig-0.23-9.1.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/python-dmidecode-3.10.13-3.el6_4.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/pygobject2-2.20.0-5.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/usermode-1.102-3.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/libxml2-python-2.7.6-14.el6_5.2.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/libxml2-2.7.6-14.el6_5.2.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/python-ethtool-0.6-5.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/deps/libnl-1.1.4-2.el6.x86_64.rpm

#Grab rhn tools copied to pub from the spacewalk-client repo
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/python-hwdata-1.7.3-1.el6.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/rhn-check-2.2.7-1.el6.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/rhn-client-tools-2.2.7-1.el6.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/rhn-setup-2.2.7-1.el6.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/rhnlib-2.5.72-1.el6.noarch.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/rhnsd-5.0.14-1.el6.x86_64.rpm
curl -k -O https://spacewalk.example.com/pub/rhn-tools/EL6/yum-rhn-plugin-2.2.7-1.el6.noarch.rpm

#import keys
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-CentOS-6
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-EPEL-6
fi

#Install the tools
yum -y --nogpgcheck localinstall *.rpm

curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-puppetlabs
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-spacewalk-2012
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-spacewalk-2014
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-RPMForge
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-Mongo
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-PGDG
curl -k -O https://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-SPACEWALK-KEY

#Install the tools
rpm --import RPM-GPG-*

#Activate & Register host with CentOS 6.5 x64 spacewalk.example.com key
rhnreg_ks --serverUrl=https://spacewalk.example.com/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=$KEY

#Install pkg to run commands from satellite and get confs
yum -y install rhncfg-actions rhncfg-client

#Set permissions for remote commands
rhn-actions-control --enable-all

#cleanup
rm -f *.rpm RPM-GPG*

