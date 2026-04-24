#!/bin/bash

if ! command -v paru &> /dev/null; then
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ..
fi
