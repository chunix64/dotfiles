#!/bin/bash

# Pacman base
sudo pacman -S --needed --noconfirm base base-devel less
sudo pacman -S --needed --noconfirm curl wget git
sudo pacman -S --needed --noconfirm rustup cmake cpio pkg-config gcc

# Rust toolchain
rustup default stable
