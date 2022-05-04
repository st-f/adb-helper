#!/bin/bash
echo "\n📷 ADB Screenshot tool 📸"
trap '{ echo "\n🤝 Screenshot sesh finished."; return; }' INT
source $adbHelperRoot/lib/device.sh
getDeviceOrReturn

read -p "📏 Resize? Enter width in px or press enter to skip: " WIDTH
while true; do
  now=$(date +%d-%m-%Y-%H.%M.%S)
  file=$adbHelperDownloadRoot/screenshot_$now.png
  read -n 1 -r -s -p "⌨️  Press any key to screenshot, \"q\" or ctrl-C to exit." KEY
  if [[ $KEY == "q" ]]; then
      echo
      break
  fi
  echo "\n📷✨ Smile!"
  adb -s $DEVICE exec-out screencap -p > $file
  echo "🏞  Done! screenshot_$now.png saved."
  if [[ -n "$WIDTH" ]]; then
    convert $file -resize "${WIDTH}x"\> $file
    echo "🖼  Done! screenshot_$now.png resized to width: ${WIDTH}px."
  fi
  open -R $file
done
