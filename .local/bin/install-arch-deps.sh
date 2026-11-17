#!/bin/bash

# Audio
sudo pacman -S --needed ardour pipewire-jack a2jmidid aj-snapshot
paru -S --needed reaper

## Plugins
sudo pacman -S --needed \
    calf zam-plugins swh-plugins mda.lv2 guitarix geonkick \
    zynaddsubfx x42-plugins odin2-synthesizer drumgizmo
paru -S --needed sfizz
paru -S --needed distrho-ports 
paru -S --needed airwindows-consolidated-bin
paru -S --needed chowbyod-bin 
paru -S --needed chowcentaur-bin
paru -S --needed chowkick-bin 
paru -S --needed chowmatrix-bin
paru -S --needed chowphaser-bin 
paru -S --needed chowtapemodel-bin
paru -S --needed chowmultitool-bin 
paru -S --needed linuxsampler gigedit jsampler

# Games
paru -S --needed minecraft-launcher
