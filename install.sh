#!/bin/bash
# =============================================================
# Dotfiles install script
# Installs packages and symlinks configs to ~/.config
# Usage: bash install.sh
# =============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/arch"
CONFIG_DIR="$HOME/.config"

# -------------------------------------------------------------
# Colors for output
# -------------------------------------------------------------
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

info() { echo -e "${GREEN}[✓]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
error() {
  echo -e "${RED}[✗]${RESET} $1"
  exit 1
}

# =============================================================
# 1. CHECK DEPENDENCIES
# =============================================================
command -v pacman &>/dev/null || error "pacman not found — is this Arch Linux?"

# Install yay if not present
if ! command -v yay &>/dev/null; then
  warn "yay not found, installing..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
  info "yay installed"
fi

# =============================================================
# 2. INSTALL PACKAGES
# =============================================================
info "Installing packages..."

PACKAGES=(
  # Window manager
  hyprland
  hyprlock
  xdg-desktop-portal-hyprland

  # Wayland essentials
  waybar
  wofi
  grim
  slurp
  wl-clipboard

  # Terminal
  kitty

  # Editor
  neovim

  # System utilities
  brightnessctl
  playerctl
  pipewire
  pipewire-pulse
  wireplumber
  networkmanager
  polkit-kde-agent

  # Fonts
  ttf-jetbrains-mono-nerd
  ttf-font-awesome
  ttf-nerd-fonts-symbols

  # Misc
  git
  curl
  wget
)

yay -S --needed --noconfirm "${PACKAGES[@]}"
info "All packages installed"

# =============================================================
# 3. SYMLINK CONFIGS
# =============================================================
info "Creating symlinks in $CONFIG_DIR..."

# List of config folders to symlink
# Format: "folder_in_dotfiles_repo:target_in_.config"
CONFIGS=(
  "hyprland:hypr"
  "hyprlock:hyprlock"
  "waybar:waybar"
  "nvim:nvim"
  "kitty:kitty"
)

mkdir -p "$CONFIG_DIR"

for entry in "${CONFIGS[@]}"; do
  src="${DOTFILES_DIR}/${entry%%:*}"
  dest="${CONFIG_DIR}/${entry##*:}"

  # Skip if source folder doesn't exist in repo
  if [ ! -d "$src" ]; then
    warn "Skipping $src — folder not found in dotfiles repo"
    continue
  fi

  # Remove existing config or symlink
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -d "$dest" ]; then
    warn "Backing up existing $dest to ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -s "$src" "$dest"
  info "Linked $src → $dest"
done

# =============================================================
# 4. ENABLE SERVICES
# =============================================================
info "Enabling system services..."

sudo systemctl enable --now NetworkManager
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# =============================================================
# DONE
# =============================================================
echo ""
info "Done! Log out and start a Hyprland session."
echo ""
