#!/usr/bin/env bash
dnf install -y flatpak &>/dev/null
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &>/dev/null
flatpak install -y --system flathub org.gnome.Calculator &>/dev/null
flatpak remote-delete --force flathub &>/dev/null
flatpak uninstall -y --system org.gnome.gedit &>/dev/null || true
