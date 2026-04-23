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

# External configs
git clone https://github.com/NvChad/starter ~/.config/nvim

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
