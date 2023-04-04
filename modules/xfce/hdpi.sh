#!/usr/bin/env bash

echo "Enabling High-DPI settings ..."

# use a high-dpi friendly window manager theme
xfconf-query -c xfwm4 -p /general/theme -s Default-hdpi

# Scale mouse cursor: 24 -> 48 pixels (> Mouse > Theme).
xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s 48

# Scale window titles.
xfconf-query -c xfwm4 -p /general/title_font -s "Sans Bold 8"
# Scale system fonts.
xfconf-query -c xsettings -p /Gtk/FontName -s "Noto Sans 9"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "DejaVu Sans Mono 9"

# Scale up fonts with custom DPI: 96 -> 192 (> Appearance > Fonts). Needed
# e.g. to get larger font-size in web browser and chat clients
# (slack/mattermost).
xfconf-query -c xsettings -p /Xft/DPI -s 192

# Set the height in pixels of the top panel row.
xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 20

export GDK_DPI_SCALE=0.5

xfce4-panel --restart