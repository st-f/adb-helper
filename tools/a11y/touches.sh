#!/bin/bash
echo "\n👇 Accessibility - Touches\n"
# exit if no Android device
source $adbHelperRoot/lib/adb-wrapper.sh
if [[ -z $DEVICE ]]; then
  return 0
fi
export ANDROID_DEVICE=$DEVICE # change default device for gradle

function changeTouch {
  echo "👇 $1"
  if [ $1 != "Enabled" ]; then
    adb -s $DEVICE shell settings put system show_touches 1
  else
    adb -s $DEVICE shell settings put system show_touches 0
  fi
}

while true; do
  echo "1. Enable"
  echo "2. Disable"
  trap '{ echo "\nExiting...  Bye bye! 👋"; return; }' INT
  read -n 1 -s CHOICE
  if [[ $CHOICE == 1 ]]; then
    changeTouch "Enable"
  elif [[ $CHOICE == 2 ]]; then
    changeTouch "Disable"
  elif [[ $CHOICE == "q" ]]; then
    echo "\nExiting... Bye bye! 👋"
    return
  else
    echo "\n🤷‍ Incorrect choice. Choose between 1 and 2, or \"q\" to exit."
  fi
done
