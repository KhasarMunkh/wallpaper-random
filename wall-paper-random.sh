#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/wallpapers"   # <- change if yours is elsewhere
MON="$(hyprctl monitors | awk '/Monitor/{print $2; exit}')"  # first (laptop) monitor

# what’s currently set on this monitor?
CURRENT="$(hyprctl hyprpaper listactive 2>/dev/null | awk -F', ' -v m="$MON" '$1==m{print $2}')"

# pick a random image (avoid CURRENT if possible)
pick() {
  find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' \) \
  | { if [ -n "${CURRENT:-}" ]; then grep -vF -- "$CURRENT"; else cat; fi; } \
  | shuf -n 1
}
IMG="$(pick || true)"
[ -n "${IMG:-}" ] || IMG="$(find "$DIR" -type f | shuf -n 1)"

# apply (preload to avoid flicker)
hyprctl hyprpaper preload "$IMG" >/dev/null
hyprctl hyprpaper wallpaper "$MON,$IMG" >/dev/null
