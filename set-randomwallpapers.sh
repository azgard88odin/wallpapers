#!/usr/bin/env bash

base_dir="$HOME/Documents/wallpapers"
desktop_images="$base_dir/Desktop"
lockscreen_images="$base_dir/LockScreen"
lockscreen_image_path="$base_dir/lockscreen.jpg"

random_desktop_image=$(ls "$desktop_images" | shuf -n 1)
random_lock_image=$(ls "$lockscreen_images" | shuf -n 1)

cp "$lockscreen_images/$random_lock_image" "$lockscreen_image_path"

gsettings set org.gnome.desktop.background picture-uri-dark "file://$desktop_images/$random_desktop_image"
dconf write /org/gnome/shell/extensions/unlock-dialog-background/picture-uri-dark "'file://$lockscreen_image_path'"
