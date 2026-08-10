#!/usr/bin/env bash
sudo pacman -S fprintd || exit
sudo sed -i '1iauth\t\tsufficient\tpam_fprintd.so' /etc/pam.d/sudo || exit
echo "Go to Settings -> Users -> Configure Fingerprint Authentication... to set up your fingerprint."
