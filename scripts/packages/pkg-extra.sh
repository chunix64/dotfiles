#!/bin/bash

# System
sudo pacman -S --needed --noconfirm ly networkmanager zsh

# Pipewire audio
sudo pacman -S --needed --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Wayland base
sudo pacman -S --needed --noconfirm wayland xorg-xwayland qt5-wayland qt6-wayland gtk3 gtk4 glfw-wayland

# Hyprland base
sudo pacman -S --needed --noconfirm hyprland uwsm hyprpolkitagent hyprpaper hyprcursor hyprlock hypridle hyprshot

# Hyprland dependencies
sudo pacman -S --needed --noconfirm xdg-desktop-portal-hyprland hyprland-qt-support

# WM packages
sudo pacman -S --needed --noconfirm waybar dunst wofi fcitx5 fcitx5-bamboo

# User applications
sudo pacman -S --needed --noconfirm firefox nemo fastfetch neovim kitty lsd

# Fonts
sudo pacman -S --needed --noconfirm noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-mononoki-nerd ttf-jetbrains-mono-nerd
