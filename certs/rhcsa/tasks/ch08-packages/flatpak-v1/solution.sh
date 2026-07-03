#!/usr/bin/env bash
dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y --system flathub org.gnome.gedit
flatpak uninstall -y --system org.gnome.Calculator
