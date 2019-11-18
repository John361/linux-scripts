#!/bin/bash

# Author: Hoareau John
# Description: Write your banner message then run the script
# Notes: Must be used as root
# References: https://www.tecmint.com/protect-ssh-logins-with-ssh-motd-banner-messages/
# Title: linux_banner_message.sh
# Usage: ./linux_banner_message.sh



cat << EOF > /etc/issue_hoareau_john.net
##################################################################
# Welcome to Hoareau John server                                 #
# All connections are monitored and recorded.                    #
# Disconnect IMMEDIATELY if you are not an authorized user!      #
##################################################################
EOF

sed -i '/#Banner none/c\Banner /etc/issue_hoareau_john.net' /etc/ssh/sshd_config
systemctl restart sshd
