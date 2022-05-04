#!/bin/bash
echo "\n🟧 Accessibility - Colors\n"
# exit if no Android device
source $adbHelperRoot/lib/adb-wrapper.sh
if [[ -z $DEVICE ]]; then
  return 0
fi
export ANDROID_DEVICE=$DEVICE # change default device for gradle

function changeColors {
  echo "🟧 $1"
  if [ $1 != "Default" ]; then
    adb -s $DEVICE shell settings put secure accessibility_display_daltonizer_enabled 1
  fi
  if [ $1 != "Inverse" ]; then
    adb -s $DEVICE shell settings put secure accessibility_display_inversion_enabled 0
  else
    adb -s $DEVICE shell settings put secure accessibility_display_inversion_enabled 1
  fi
  if [ $1 == "Default" ]; then
    adb -s $DEVICE shell settings put secure accessibility_display_daltonizer_enabled 0
  elif [ $1 == "Monochromatic" ]; then
    adb -s $DEVICE shell settings put secure accessibility_display_daltonizer 0
  elif [ $1 == "Deuteranomaly" ]; then
    adb -s $DEVICE shell settings put secure accessibility_display_daltonizer 11
  elif [ $1 == "Protanomaly" ]; then
    adb -s $DEVICE shell settings put secure accessibility_display_daltonizer 12
  elif [ $1 == "Tritanomaly" ]; then
    adb -s $DEVICE shell settings put secure accessibility_display_daltonizer 13
  fi
}

while true; do
  echo "1. Default"
  echo "2. Inverse"
  echo "3. Monochromatic"
  echo "4. Deuteranomaly (red-green)"
  echo "5. Protanomaly (red-green)"
  echo "6. Tritanomaly (blue-yellow)"
  trap '{ echo "\nExiting...  Bye bye! 👋"; return; }' INT
  read -n 1 -s CHOICE
  if [[ $CHOICE == 1 ]]; then
    changeColors "Default"
  elif [[ $CHOICE == 2 ]]; then
    changeColors "Inverse"
  elif [[ $CHOICE == 3 ]]; then
    changeColors "Monochromatic"
  elif [[ $CHOICE == 4 ]]; then
    changeColors "Deuteranomaly"
  elif [[ $CHOICE == 5 ]]; then
    changeColors "Protanomaly"
  elif [[ $CHOICE == 6 ]]; then
    changeColors "Tritanomaly"
  elif [[ $CHOICE == "q" ]]; then
    echo "\nExiting... Bye bye! 👋"
    return
  else
    echo "\n🤷‍ Incorrect choice. Choose between 1 and 5, or \"q\" to exit."
  fi
done
