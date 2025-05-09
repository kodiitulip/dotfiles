#!/bin/bash
updates_pacman=$(checkupdates | wc -l)
updates_aur=$(yay -Qua | grep -c "\[ignored\]")
updates=$((updates_pacman + updates_aur))
printf '{"text": "%s", "alt": "%s", "tooltip": "%s updates"}' "$updates" "$updates" "$updates"
