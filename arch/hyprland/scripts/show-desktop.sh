#!/bin/bash
STATE_FILE="/tmp/hyprland-desktop-state"

if [ -f "$STATE_FILE" ]; then
  # Restaurar: traer ventanas de vuelta del workspace 10
  while read -r addr ws; do
    hyprctl dispatch movetoworkspacesilent "$ws,address:$addr"
  done <"$STATE_FILE"
  rm "$STATE_FILE"
else
  # Mostrar escritorio: guardar estado y mover todas al workspace 10
  hyprctl clients -j | jq -r '.[] | "\(.address) \(.workspace.id)"' >"$STATE_FILE"
  hyprctl clients -j | jq -r '.[].address' | while read -r addr; do
    hyprctl dispatch movetoworkspacesilent "10,address:$addr"
  done
fi
