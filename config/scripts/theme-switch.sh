#!/usr/bin/env bash
THEME_DIR="$(cd "$(dirname "$0")/../theme" && pwd)"
COLORS_DIR="$THEME_DIR/colors"
WALLPAPERS_DIR="$THEME_DIR/wallpapers"
EQUIBOP_DIR="$THEME_DIR/equibop"
ALACRITTY_DIR="$THEME_DIR/alacritty"
SELECTED_DIR="$THEME_DIR/selected"
STATE_FILE="$THEME_DIR/.theme-state"
THEMES=(gruvbox tokyo-night rose-pine)
mkdir -p "$SELECTED_DIR"
[ -f "$STATE_FILE" ] || echo "0" > "$STATE_FILE"
NUMBER=$(( ($(cat "$STATE_FILE") + 1) % ${#THEMES[@]} ))
echo "$NUMBER" > "$STATE_FILE"
THEME="${THEMES[$NUMBER]}"
echo "Theme: $THEME"
ln -sf "$COLORS_DIR/$THEME.css" "$SELECTED_DIR/selected-color.css"
ln -sf "$WALLPAPERS_DIR/$THEME/$THEME.png" "$SELECTED_DIR/selected-wallpaper.png"
ln -sf "$ALACRITTY_DIR/$THEME-alacritty.toml" "$SELECTED_DIR/selected-alacritty.toml"
ln -sf "$EQUIBOP_DIR/$THEME.css" "$SELECTED_DIR/selected-equibop.css"
echo "$THEME" > "$SELECTED_DIR/selected-theme"
pkill waybar; waybar &
pkill swaybg; swaybg -i "$SELECTED_DIR/selected-wallpaper.png" -m fill &

cp "$SELECTED_DIR/selected-equibop.css" "/home/dylan/nixos-dotfiles/config/equibop/settings/quickCss.css"

for sock in ~/.cache/nvim-sockets/*.sock; do
  [ -e "$sock" ] || continue
  nvim --server "$sock" --remote-send ":ReloadTheme<CR>" 2>/dev/null
done
