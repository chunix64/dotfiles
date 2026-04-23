#!/bin/bash

# Enable services
sudo systemctl enable ly@tty2.service
sudo systemctl enable --now NetworkManager
systemctl --user enable --now pipewire pipewire-pulse wireplumber

chsh -s /usr/bin/zsh
