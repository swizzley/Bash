#!/bin/bash
#
#	Oildex spacewalk registration script for CentOS 6.5 x64 v1.0
#
#	Dustin Morgan <dmorgan@oildex.com>
#
#	Sep. 12, 2014
#
#	Usage: Intended to work on minimal installs
#              And pre-existing web-connected hosts on the LAN
#
#

#update deps for centos 6.4
#yum -y update libudev

#Remove remote repos
mv /etc/yum.repos.d/* /root/

#Install Dependancies for spacewalk-tools
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/dbus-python-0.83.0-6.1.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/python-ethtool-0.6-5.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/pyOpenSSL-0.10-2.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/python-gudev-147.1-4.el6_0.1.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/m2crypto-0.20.2-9.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/libgudev1-147-2.51.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/pkgconfig-0.23-9.1.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/python-dmidecode-3.10.13-3.el6_4.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/pygobject2-2.20.0-5.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/usermode-1.102-3.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/libxml2-python-2.7.6-14.el6_5.2.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/libxml2-2.7.6-14.el6_5.2.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/python-ethtool-0.6-5.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/deps/libnl-1.1.4-2.el6.x86_64.rpm

#Grab rhn tools copied to pub from the spacewalk-client repo
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/python-hwdata-1.7.3-1.el6.noarch.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/rhn-check-2.2.7-1.el6.noarch.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/rhn-client-tools-2.2.7-1.el6.noarch.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/rhn-setup-2.2.7-1.el6.noarch.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/rhnlib-2.5.72-1.el6.noarch.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/rhnsd-5.0.14-1.el6.x86_64.rpm
#curl -O http://spacewalk.example.com/pub/rhn-tools/OL-6/yum-rhn-plugin-2.2.7-1.el6.noarch.rpm
curl -O http://spacewalk.example.com/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm

#Install the tools
yum -y localinstall *.rpm


#import keys
rpm --import http://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-puppetlabs
rpm --import http://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-SPACEWALK-KEY
rpm --import http://spacewalk.example.com/pub/rpm-gpg/RPM-GPG-KEY-Oracle

#Activate & Register host with CentOS 6.5 x64 spacewalk.example.com key
rhnreg_ks --serverUrl=https://spacewalk.example.com/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=1-f46a8da531da3023cb537ba70f687eb8

#Install pkg to run commands from satellite and get confs
yum -y install rhncfg-actions rhncfg-client

#Set permissions for remote commands
rhn-actions-control --enable-all

#cleanup
rm -f *.rpm
