#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for waybar layout or configs

set -euo pipefail
IFS=$'\n\t'

# Define directories
waybar_configs="$HOME/.config/waybar"
waybar_config="$HOME/.config/waybar/config"
waybar_styles="$HOME/.config/waybar"
waybar_style="$HOME/.config/waybar/style.css"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
rofi_config="$HOME/.config/rofi/config-waybar-layout.rasi"

# Define directories
# Function to display menu options
menu() {
    options=()
    target={"wallust"}  # 要去除的文件名
    while IFS= read -r dir; do
        basename_folder=$(basename "$dir")
        if [[ "$basename_folder" != "$target" ]]; then
          options+=("$basename_folder")
        fi
    done < <(find "$waybar_configs" -maxdepth 1 -type d -exec basename {} \; | sort)

    printf '%s\n' "${options[@]}"
}


# Apply selected configuration
apply_config() {
    ln -sf "$waybar_configs/$1/config" "$waybar_config"
    #restart_waybar_if_needed
    # "${SCRIPTSDIR}/Refresh.sh" &
}

# Apply selected style
apply_style() {
    ln -sf "$waybar_styles/$1/style.css" "$waybar_style"
}
# Main function
main() {
    choice=$(menu | rofi -i -dmenu -config "$rofi_config")

    if [[ -z "$choice" ]]; then
        echo "No option selected. Exiting."
        exit 0
    fi

    case $choice in
        "no panel")
            pgrep -x "waybar" && pkill waybar || true
            ;;
        *)
            apply_config "$choice"
            apply_style "$choice"
            "${SCRIPTSDIR}/Refresh.sh" &
            ;;
    esac
}

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
    exit 0
fi

main
