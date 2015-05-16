#!/bin/bash
mkdir /tmp/adobefont
cd /tmp/adobefont
wget http://download.damieng.com/fonts/redistributed/DroidFamily.zip
unzip DroidFamily.zip
mkdir -p ~/.fonts
cp DroidFonts/*.ttf ~/.fonts
fc-cache -f -v
