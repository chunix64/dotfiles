#!/bin/bash

if ! command -v paru &> /dev/null; then
  git clone https://aur.archlinux.org/paru.git
  cd paru
  yes | makepkg -si
  cd ..
fi
