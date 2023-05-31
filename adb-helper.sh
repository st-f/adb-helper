#!/bin/bash
declare -a adbHelperRoot=~/Applications/adb-helper # root path of program
source $adbHelperRoot/config.sh
folder=$(basename "$PWD");
echo "\n🛎  ADB Helper 🛎 "
echo "You are in: $folder\n"
echo "1. 🤖 Compile & install"
echo "2. 📦 Install APK"
echo "3. ⚗️  Pre-CI checks"
echo "4. 📷 Screenshot"
echo "5. 📹 Screen record"
echo "6. 🧰 Utils"
trap '{ echo "\nExiting...  Bye bye! 👋"; exit; }' INT
read -n 1 -s CHOICE
if [[ $CHOICE == 1 ]]; then
  source $adbHelperRoot/tools/compile.sh
  #source $adbHelperRoot/tools/compile-discovery.sh
  #clear # TODO this prevents to show the no device error
elif [[ $CHOICE == 2 ]]; then
  source $adbHelperRoot/tools/install.sh
  clear
elif [[ $CHOICE == 3 ]]; then
  source $adbHelperRoot/tools/precichecks.sh
  clear
elif [[ $CHOICE == 4 ]]; then
  source $adbHelperRoot/tools/screenshot.sh
  clear
elif [[ $CHOICE == 5 ]]; then
  source $adbHelperRoot/tools/recordscreen.sh
  clear
elif [[ $CHOICE == 6 ]]; then
  source $adbHelperRoot/tools/utils.sh
  clear
elif [[ $CHOICE == "q" ]]; then
  echo "\nExiting... Bye bye! 👋"
  exit
else
  echo "\n🤷‍ Incorrect choice. Choose between 1 and 5, or \"q\" to exit."
fi
source $adbHelperRoot/adb-helper.sh
