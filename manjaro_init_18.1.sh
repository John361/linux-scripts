#!/bin/bash

# Author: Hoareau John
# Description: For my personal virtual machines using Manjaro, I run this after OS installation
# Notes: Must be used as root
# Title: manjaro_init_18.1.sh
# Usage: ./manjaro_init_18.1.sh



# Change pacman conf
cp /etc/pacman.conf /etc/pacman_origin.conf
sed -i '/#Color/c\Color' /etc/pacman.conf
sed -i '/#TotalDownload/c\TotalDownload' /etc/pacman.conf
sed -i '/#VerbosePkgLists/c\VerbosePkgLists\nILoveCandy' /etc/pacman.conf


# Update, upgrade and add tools
pacman -Syu --noconfirm

pacman -Rs falkon --noconfirm
pacman -Rs konversation --noconfirm
pacman -Rs imagewriter --noconfirm

pacman -Syu micro-manjaro --noconfirm
pacman -Syu code --noconfirm
pacman -Syu firefox --noconfirm


# workspace configuration
mkdir /home/user/Documents/gitspace


# rust
curl https://sh.rustup.rs -sSf | sh
mkdir /home/user/Documents/gitspace/rust


# qt framework : if you do not install this, install gcc for rust
pacman -Syu qtcreator --noconfirm
pacman -Syu gdb --noconfirm
pacman -Syu cmake --noconfirm
mkdir /home/user/Documents/gitspace/cpp


# python
pacman -Syu python-pip --noconfirm
pip install virtualenv
mkdir /home/user/Documents/gitspace/python


# git configuration
git config --global user.name "Your name"
git config --global user.email "Your email address"
chown -R user:user /home/user/Documents/gitspace


# reboot at end
reboot
