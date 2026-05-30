# dotfiles

> My personal dotfiles — Hyprland, Neovim, Kitty, and friends.

## Structure

```
dotfiles/
├── install.sh
└── arch/
    ├── hyprland/     # Hyprland WM (Lua config)
    ├── hyprlock/     # Screen locker
    ├── kitty/        # Terminal emulator
    ├── nvim/         # Neovim
    └── waybar/       # Status bar
```

## Install

Clone the repo and run the install script:

```bash
git clone https://github.com/manuelmanriquez/dotfiles
cd dotfiles
bash install.sh
```

The script will:
- Install all required packages via `pacman` + `yay`
- Symlink each config folder into `~/.config/`
- Back up any existing configs as `.bak`
- Enable system services (NetworkManager, Pipewire)

## Keybinds

| Key | Action |
|-----|--------|
| `SUPER + Q` | Open terminal (kitty) |
| `SUPER + R` | App launcher |
| `SUPER + C` | Close window |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + L` | Lock screen |
| `SUPER + SHIFT + L` | Suspend |
| `SUPER + M` | Exit Hyprland |
| `SUPER + S` | Screenshot (region, clipboard) |
| `SUPER + SHIFT + S` | Screenshot (full, save to file) |
| `SUPER + D` | Show desktop |
| `SUPER + [1-5]` | Switch workspace |
| `SUPER + SHIFT + [1-3]` | Move window to workspace |
| `SUPER + CTRL + [1-5]` | Swap workspaces |
| `SUPER + arrows` | Move focus |
| `SUPER + SHIFT + arrows` | Move window |
| `SUPER + CTRL + arrows` | Resize window |
| `SUPER + ALT + arrows` | Move floating window |
| `SUPER + SHIFT + [ / ]` | Move workspace to monitor |
| `SUPER + LMB drag` | Drag floating window |
| `SUPER + RMB drag` | Resize floating window |
