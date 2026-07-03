## Hint

- `dnf install -y flatpak`
- `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`
- `flatpak install -y flathub org.gnome.gedit` — omit `--user` to install system-wide
- `flatpak uninstall -y org.gnome.Calculator`
- `flatpak remotes` lists configured remotes; `flatpak list --app` lists installed applications
