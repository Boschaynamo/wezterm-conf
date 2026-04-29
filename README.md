## Windows
```
git clone

New-Item -ItemType SymbolicLink `
  -Path "C:\Users\$USER\.config\wezterm" `
  -Target "$PATH-TO-REPO\wezterm-conf"
```
## Ubuntu
```
ln -s $PATH-TO-REPO/wezterm-conf ~/.config/wezterm
```
