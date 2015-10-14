#!/bin/sh

adb=“/User/EandN/Android/adb”

directory="/Users/EandN/Desktop/Android Photos"
mkdir -p "$directory"
cd "$directory"

adb pull /sdcard/DCIM/Camera
adb pull /sdcard/viber/media/Viber\ Images
adb pull /sdcard/viber/media/Viber\ Videos

clear
echo FINISHED PULLING PHOTOS
echo You can now close this window.