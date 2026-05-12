#!/bin/bash

# Waybar theme switcher script
# Usage: ./waybar-theme-switcher.sh [theme_name]

CONFIG_DIR="$HOME/.config/waybar"
STYLE_FILE="$CONFIG_DIR/style.css"
BACKUP_DIR="$CONFIG_DIR/themes-backup"
THEMES_DIR="$CONFIG_DIR/themes"

# Create directories if they don't exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$THEMES_DIR"

# Available themes
declare -A THEMES=(
    ["black"]="#000000"
    ["dark"]="#1a1a1a"
    ["github"]="#0d1117"
    ["nord"]="#2E3440"
    ["gruvbox"]="#282828"
    ["dracula"]="#1e1e2e"
    ["catppuccin"]="#24273a"
    ["solarized"]="#002b36"
    ["one-dark"]="#1e1e1e"
    ["material"]="#121212"
)

# Current theme tracking
CURRENT_THEME_FILE="$HOME/.cache/waybar-current-theme"

# Function to get current theme
get_current_theme() {
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "black"
    fi
}

# Function to save current theme
save_current_theme() {
    echo "$1" > "$CURRENT_THEME_FILE"
}

# Function to backup current style
backup_current_style() {
    cp "$STYLE_FILE" "$BACKUP_DIR/style-$(date +%Y%m%d-%H%M%S).css"
}

# Function to create theme style
create_theme_style() {
    local theme_name="$1"
    local bg_color="$2"
    
    cat > "$THEMES_DIR/${theme_name}.css" << EOF
* {
  background-color: $bg_color;
  color: #c6d0f5;
  border: none;
  border-radius: 0;

  min-height: 0;
  font-family: 'Iosevka Term';
  font-size: 12px;
}

/* ---------------- WAYBAR ---------------- */

#waybar {
  min-height: 34px;   /* 🔥 thicker bar */
  padding: 6px 0;     /* 🔥 real weight */
}

/* ---------------- MODULE CONTAINERS ---------------- */

.modules-left {
  margin-left: 8px;
}

.modules-right {
  margin-right: 8px;
}

/* ---------------- WORKSPACES ---------------- */

#workspaces button {
  all: initial;
  padding: 4px 10px;  /* taller workspace buttons */
  margin: 0 2px;
  min-width: 9px;
  color: #babbf1;
}

#workspaces button.active {
  color: #99d1db;
}

#workspaces button.empty {
  opacity: 0.5;
}

/* ---------------- SPOTIFY ---------------- */

#custom-spotify {
  color: #8caaee;
  margin: 0 7.5px;
  padding: 4px 8px;
}

/* ---------------- RIGHT MODULES ---------------- */

/* ✅ REAL unified spacing */
#custom-uptime,
#backlight,
#battery,
#pulseaudio,
#custom-network,
#bluetooth,
#cpu,
#memory,
#tray,
#custom-lock,
#custom-omarchy,
#custom-screenrecording-indicator,
#custom-update,
#clock,
#custom-voxtype {
  min-width: 12px;
  margin: 0 6px;
  padding: 4px 8px;   /* 🔥 height comes from padding */
}

/* ---------------- SPECIAL MODULES ---------------- */

#custom-update {
  font-size: 10px;
}

#custom-screenrecording-indicator {
  font-size: 10px;
}

#custom-screenrecording-indicator.active {
  color: #a55555;
}

#custom-voxtype.recording {
  color: #a55555;
}

/* ---------------- COLORS ---------------- */

#custom-uptime { color: #f2d5cf; }
#backlight { color: #e0c090; }
#battery { color: #99d1db; }
#pulseaudio { color: #ea999c; }
#custom-network { color: #ffffff; }
#bluetooth { color: #6ab0f3; }
#cpu { color: #e5c890; }
#memory { color: #a6d189; }
#custom-lock { color: #babbf1; }
#custom-omarchy { color: #8caaee; }
#clock { color: #8caaee; }
#custom-spotify { color: #8caaee; }
#custom-update { color: #8caaee; }
#custom-screenrecording-indicator { color: #8caaee; }
#custom-voxtype { color: #8caaee; }

/* ---------------- TOOLTIP ---------------- */

tooltip {
  padding: 6px;
  background: $bg_color;
}

tooltip label {
  color: #c6d0f5;
  font-size: 12px;
}

/* ---------------- STATES ---------------- */

#battery.charging { color: #a6d189; }
#battery.full { color: #99d1db; }
#battery.critical { color: #ea999c; }

#custom-network.disconnected { color: #737994; }
#bluetooth.disabled { color: #737994; }

.hidden {
  opacity: 0;
}
EOF
}

# Function to apply theme
apply_theme() {
    local theme_name="$1"
    local bg_color="${THEMES[$theme_name]}"

    if [[ -z "$bg_color" ]]; then
        echo "Theme '$theme_name' not found"
        exit 1
    fi

    # Apply theme colors ONLY
    cp "$THEMES_DIR/${theme_name}.css" "$CONFIG_DIR/theme.css"

    save_current_theme "$theme_name"

    killall waybar 2>/dev/null
    sleep 0.5
    waybar &
}

# Function to cycle through themes
cycle_themes() {
    local current=$(get_current_theme)
    local themes_array=("${!THEMES[@]}")
    local current_index=-1
    
    # Find current theme index
    for i in "${!themes_array[@]}"; do
        if [[ "${themes_array[$i]}" == "$current" ]]; then
            current_index=$i
            break
        fi
    done
    
    # Get next theme
    local next_index=$(( (current_index + 1) % ${#themes_array[@]} ))
    local next_theme="${themes_array[$next_index]}"
    
    apply_theme "$next_theme"
}

# Function to list available themes
list_themes() {
    echo "Available themes:"
    for theme in "${!THEMES[@]}"; do
        local current=$(get_current_theme)
        if [[ "$theme" == "$current" ]]; then
            echo "  * $theme (current)"
        else
            echo "    $theme"
        fi
    done
}

# Function to show current theme
show_current() {
    local current=$(get_current_theme)
    echo "Current theme: $current"
    echo "Background color: ${THEMES[$current]}"
}

# Main script logic
case "${1:-cycle}" in
    "cycle")
        cycle_themes
        ;;
    "list")
        list_themes
        ;;
    "current")
        show_current
        ;;
    "apply")
        if [[ -z "$2" ]]; then
            echo "Usage: $0 apply <theme_name>"
            exit 1
        fi
        apply_theme "$2"
        ;;
    "help"|"-h"|"--help")
        echo "Waybar Theme Switcher"
        echo ""
        echo "Usage: $0 [COMMAND] [THEME_NAME]"
        echo ""
        echo "Commands:"
        echo "  cycle              Cycle to next theme (default)"
        echo "  list               List all available themes"
        echo "  current            Show current theme"
        echo "  apply <theme>      Apply specific theme"
        echo "  help               Show this help"
        echo ""
        echo "Available themes:"
        for theme in "${!THEMES[@]}"; do
            echo "  - $theme"
        done
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac
