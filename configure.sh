#!/usr/bin/env bash

# Set computer name (as done via System Preferences → Sharing) if the name
# is similar to "User's Macbook Pro"
if scutil --get ComputerName | grep -q "'"; then
    read -p "Computer name (single lower case word): " computer
    sudo scutil --set ComputerName "$computer"
    sudo scutil --set HostName "$computer"
    sudo scutil --set LocalHostName "$computer"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$computer"
fi

# Configure git
username=`git config --global user.name`
if [ ! $username ]; then
    username=`finger $(whoami) | awk -F: '{ print $3 }' | head -n1 | sed 's/^ //'`
    git config --global user.name $username
fi
useremail=`git config --global user.email`
if [ ! $useremail ]; then
    read -p "GitHub email address: " useremail
    git config --global user.email $useremail
fi
githubuser=`git config --global github.user`
if [ ! $githubuser ]; then
    read -p "GitHub user name: " githubuser
    git config --global github.user $githubuser
fi
git config --global core.editor "subl --wait"

# Generate and upload ssh key to use with GitHub
ssh-keygen -t rsa -b 4096 -C $useremail -f ~/.ssh/id_rsa
echo "GitHub ssh key created, please enter your GitHub password: "
curl -u $githubuser --data "{\"title\":\"GitHub_$(date +%Y%m%d%H%M%S)\",\"key\":\"$(cat ~/.ssh/id_rsa.pub)\"}" https://api.github.com/user/keys
