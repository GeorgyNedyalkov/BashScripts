#!/bin/bash

#Some useful variables
MyHostname=$(hostname)
InstalledNumKernels=$(rpm -q kernel|wc -l)

# Save the used disk space to a file before cleaning the house
df -h > /home/space_before.txt

# Cleaning up /
rm -rfv /backup/*
rm -fv /*.tgz
rm -fv /*.tgz.*
rm -rfv /clean/*

# Cleaning up /boot/. Delete old kernels if there are more than 3 installed
echo "Your system has $InstalledNumKernels installed Kernels."
if [ $InstalledNumKernels -gt 3 ]
then
	echo "Deleting old kernels..."
	package-cleanup --oldkernels --count=3 -y
else
	echo "/boot/ should be OK. It has $(df -h | grep /dev|grep boot|awk '{print $4}') free space."
fi

# Cleaning up /home/
rm -rfv /home/backup-*.tar.gz
rm -rfv /home/cpmove-*.tar.gz
rm -rf /home/*/mail/new
rm -rf /home/*/mail/cur
rm -rfv /home/*/backup-*.tar.gz
rm -rfv /home/*/cpmove-*.tar.gz
rm -rfv /usr/local/apache/logs/archive/*
rm -rfv /usr/local/apache/logs/*.[0-9]*
rm -rfv /home/*/softaculous_backups
rm -fv /home/*/error_log
rm -fv /home/*/public_html/error_log
rm -fv /home/*/public_html/*/error_log
rm -fv /home/*/public_html/*/*/error_log
rm -fv /home/*/public_html/*/*/*/error_log
rm -fv /home/latest
rm -rfv /home/cprubygemsbuild
rm -rfv /home/cprubybuild
rm -rfv /home/cprestore
rm -rfv /home/cpeasyapache
rm -rfv /home/MySQL-install
rm -fvv /home/*/tmp/Cpanel_*
du -hs /home/*/*backup* |grep -v cpbackup-exclude

# Cleaning up /var/
rm -fv /var/log/*.gz
rm -fv /var/log/*-[0-9]*
rm -fv /var/log/archive/*.gz
rm -fv /var/log/apache2/*.gz
rm -rfv /var/log/apache2/archive/*
rm -rfv /var/log/dcpumon.backup
rm -rfv /var/log/dcpumon/2017
rm -rfv /var/log/dcpumon/2016
rm -rfv /var/log/dcpumon/2015
rm -rfv /var/log/dcpumon/2014
rm -rfv /var/log/dcpumon/2013
rm -rfv /var/log/dcpumon/2012
# Use ONLY if the MySQL log is too big
# cat /dev/null > /var/lib/mysql/$MyHostname.err

# Cleaning up /usr/
rm -fv /usr/local/apache/logs/*.gz
rm -rfv /usr/local/apache.backup/*
rm -rfv /usr/local/apache.backup_archive/*
rm -rfv /usr/local/cpanel/logs/archive/*

# Show the biggest mysql databases in /var/lib/mysql/
printf "\n\n"
printf "### Summary \n"
printf "### The biggest MySQL databases:\n"
if [[ $(du /var/lib/mysql/ -h|grep G|sort -k1n) ]]; then
    echo "$(du /var/lib/mysql/ -h|grep G|sort -k1n)"
else
    echo "$(du /var/lib/mysql/ -h|grep M|sort -k1n)"
fi

# Output the used disk space again after the cleaning
df -h > /home/space_after.txt

# Total
printf "\n"
printf "### Space comparison (before and after running the script)! \n\n"
printf "### Before: \n\n"
cat /home/space_before.txt
printf "\n"
printf "### After: \n\n"
cat /home/space_after.txt
printf "\n"

# Delete the comparison files
rm -f /home/space_before.txt
rm -f /home/space_after.txt

# The End
