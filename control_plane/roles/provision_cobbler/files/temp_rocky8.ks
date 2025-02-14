#version=RHEL8

# Use network installation
url --url http://ip:port/cblr/links/rocky-x86_64/

# SELinux configuration
selinux --disabled

# Firewall configuration
firewall --disabled

# text install
text

# Do not configure the X Window System
skipx

# Keyboard layouts
keyboard us

# System language
lang ks_language

# Network information
network  --bootproto=dhcp --device=link --onboot=on --activate

# Root password
rootpw --iscrypted ks_password

# System services
services --enabled="chronyd"

# System timezone
timezone --utc ks_timezone

# System bootloader configuration
bootloader --location=mbr

# Tell it to blow away the master boot record on the hard drive
zerombr

# Tell it to do a dumb move and blow away all partitions
clearpart --all --initlabel

# Auto partitioning
autopart

# Reboot after installation
reboot

%packages
@core
net-tools
%end

%post --log=/root/ks-post.log
yum groupinstall "Infiniband Support" -y
yum install infiniband-diags perftest qperf -y
%end