#!/bin/bash

# Author: Hoareau John
# Description:
#    - Give ssh access for a specific user in given servers:
#        - Create the user
#        - Add his public key
#        - Edit his bash profile
#        - Expire his password
# Enhancements:
#    - For each part of the process, check if not already done (e.g: user creation)
#    - Move user const variables to the script arguments
# Notes:
#    - For an automatic process, the user that run the script must already have access to all listed servers. Otherwise, he must have root passwords
#    - Change values in "CONST VARIABLES" part if needed
#    - In this context, prod|preprod server are differenced by 12|112
# Title: give_ssh_access.sh
# Usage: ./give_ssh_access.sh



################### CONST VARIABLES ###################
SERVERS=(
    192.168.1.11
    192.168.1.112
    192.168.1.13
)

SCRIPT_EXECUTOR_USER="root"

GIVEN_USER_PUBLIC_KEY=""
GIVEN_USER_PC_NAME="user@domain"
GIVEN_USER_USERNAME="user|username"
GIVEN_USER_DEFAULT_PASSWORD="badpasswd"
################### CONST VARIABLES ###################



################### FUNCTIONS ###################
create_user() {
    echo "Creating user ${GIVEN_USER_USERNAME} in server ${1}"
    create_user_command="useradd -g wheel -d /home/${GIVEN_USER_USERNAME} -s /bin/bash -m ${GIVEN_USER_USERNAME} -p ${GIVEN_USER_DEFAULT_PASSWORD}"
    ssh -t ${SCRIPT_EXECUTOR_USER}@${1} ${create_user_command}
}

add_public_key_to_authorized_key() {
    echo "Add ${GIVEN_USER_USERNAME} public key in /etc/ssh/authorized_keys folder in server ${1}"
    add_public_key_to_authorized_key_command="echo ssh-rsa ${GIVEN_USER_PUBLIC_KEY} ${GIVEN_USER_PC_NAME} > /etc/ssh/authorized_keys/${GIVEN_USER_USERNAME}"
    ssh -t ${SCRIPT_EXECUTOR_USER}@${1} ${add_public_key_to_authorized_key_command}
}

edit_bash_profile() {
    echo "Edit ${GIVEN_USER_USERNAME} bash profile in server ${1} (${2})"

    edit_bash_profile_echo_command="echo \"PS1='\[\033[1;35m\][\u@\H ($2) \W]$\[\e[0m\] '\""
    edit_bash_profile_path_command="/home/${GIVEN_USER_USERNAME}/.bash_profile"
    edit_bash_profile_command="${edit_bash_profile_echo_command} >> ${edit_bash_profile_path_command}"

    ssh -t ${SCRIPT_EXECUTOR_USER}@${1} ${edit_bash_profile_command}
}

expire_user_password() {
    echo "Set ${GIVEN_USER_USERNAME} password expiration in server ${1}"
    expire_user_password_command="passwd -e ${GIVEN_USER_USERNAME}"
    ssh -t ${SCRIPT_EXECUTOR_USER}@${1} ${expire_user_password_command}
}
################### FUNCTIONS ###################



################### SCRIPT ###################
for i in "${SERVERS[@]}"
    do
        create_user ${i}        
        add_public_key_to_authorized_key ${i}

        if [ ${#i} -eq 14 ]
        then
            edit_bash_profile ${i} "PREPROD"
        else
            edit_bash_profile ${i} "PROD"
        fi

        expire_user_password ${i}
    done

echo "User ${GIVEN_USER_USERNAME} can now connect to all listed servers. He will be prompted to change his password, being disconnected and then he can reconnect"
################### SCRIPT ###################
