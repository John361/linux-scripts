#!/bin/bash

# Author: Hoareau John
# Description: Create a github ssh connection
# Notes: RSA_PATH variable value must be the same as given when the ssh-keygen input prompt
# Title: linux_ssh_github.sh
# Usage: ./linux_ssh_github.sh



################### CONST VARIABLES ###################
USER_EMAIL="Your email"
RSA_PATH="/home/user/.ssh/id_rsa_github"
################### CONST VARIABLES ###################



################### SCRIPT ###################
ssh-keygen -t rsa -b 4096 -C ${USER_EMAIL}
eval "$(ssh-agent -s)"
ssh-add ${RSA_PATH}

cat << EOF > ~/.ssh/config
Host github github.com
Hostname github.com
User git
IdentityFile ${RSA_PATH}
EOF

cat "${RSA_PATH}.pub"
echo "Copy this value, add it in your github account in the ssh setting from the web, then run 'ssh -T git@github.com'"
################### SCRIPT ###################
