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

# Install ansible-galaxy roles & collections
ansible-galaxy install ${update_choice:+--force} elliotweiser.osx-command-line-tools || exit_with_message "Ansible elliotweiser.osx-command-line-tools install/update failed"
ansible-galaxy collection install ${update_choice:+--force} community.general || exit_with_message "Ansible community.general install/update failed"

ansible-playbook playbook.yaml -K || exit_with_message "Ansible playbook failed"

echo "Completed install!"