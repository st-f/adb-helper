#!/bin/bash
echo "\n📦 Install APK"
source $adbHelperRoot/lib/device.sh
getDeviceOrReturn

while true; do
  echo "\nChoose a file:"
  filesArray=()
  i=0
  for file in $(ls ~/Downloads/*.apk); do
    filename=${file##*/}
    i=$((i+1))
    filesArray+=("$filename")
    echo "$i. $filename"
  done
  trap '{ echo "\n🤝 Install sesh finished."; return; }' INT
  echo "\nType \"u\" to uninstall, \"c\" to clear app data, \"r\" to refresh APKs list, or \"q\" or ctrl-C to exit."
  read -n 1 -r -s -p "⌨️  Or type a number to install: " INSTALL_CHOICE
  echo $INSTALL_CHOICE
  if [[ $INSTALL_CHOICE == "q" ]]; then
    return
  elif [[ $INSTALL_CHOICE == "u" ]]; then
    uninstallApp
  elif [[ $INSTALL_CHOICE == "c" ]]; then
    clearCache
  elif [[ $INSTALL_CHOICE == "r" ]]; then
    echo "Refreshing file list..."
  else
    file=$adbHelperDownloadRoot/${filesArray[$INSTALL_CHOICE-1]}
    echo "\n⚙️  Installing $file..."
    adb -s $DEVICE install $file
    startApp
  fi
done
