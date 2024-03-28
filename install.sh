#!/bin/bash

function exit_with_message () {
   echo "$1"
   exit 1
}

read -p "Update Homebrew and Ansible during install? [y/N]: " update_choice

# Install/update Homebrew
which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit_with_message "Homebrew install failed"
elif [[ "$update_choice" =~ ^[Yy]$ ]]; then
  echo "Updating Homebrew..."
  brew upgrade && brew update || exit_with_message "Homebrew upgrade failed"
fi

# Install/update Ansible
which -s ansible
if [[ $? != 0 ]] ; then
  echo "Installing Ansible..."
  brew install ansible || exit_with_message "Ansible install failed"
elif [[ "$update_choice" =~ ^[Yy]$ ]]; then
  echo "Updating Ansible..."
  brew upgrade ansible || exit_with_message "Ansible upgrade failed" 
fi

echo "Completed install!"