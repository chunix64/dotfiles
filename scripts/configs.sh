#!/bin/bash

replace_dir() {
    local src="$1"
    local dest="$2"

    if [ -d "$dest" ]; then
        rm -rf "$dest"
    fi

    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
}

mkdir $HOME/.config

cp -r ../home/. "$HOME/"

# Replace specific configs
replace_dir "../config/hypr" "$HOME/.config/hypr"
replace_dir "../config/dunst" "$HOME/.config/dunst"
replace_dir "../config/waybar" "$HOME/.config/waybar"

# GTK themes
mkdir -p $HOME/.themes
mkdir -p $HOME/.local/share/icons/
git clone https://github.com/EliverLara/Nordic ~/.themes/Nordic
curl -LO https://github.com/guillaumeboehm/Nordzy-cursors/releases/download/v2.4.0/Nordzy-cursors.tar.gz
curl -LO https://github.com/guillaumeboehm/Nordzy-cursors/releases/download/v2.4.0/Nordzy-hyprcursors.tar.gz
tar -zxvf Nordzy-cursors.tar.gz -C $HOME/.local/share/icons
tar -zxvf Nordzy-hyprcursors.tar.gz -C $HOME/.local/share/icons

gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"
gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'

# External configs
rm -rf ~/.config/nvim
git clone https://github.com/NvChad/starter ~/.config/nvim
