#!/bin/bash
mkdir /tmp/adobefont
cd /tmp/adobefont
wget http://www.downloads.sourceforge.net/project/sourcecodepro.adobe/SourceCodePro_FontsOnly-1.017.zip
unzip SourceCodePro_FontOnly-1.017.zip
mkdir -p ~/.fonts
cp SourceCodePro_FontsOnly-1.017/OTF/*.otf ~/.fonts
fc-cache -f -v
