#!/bin/bash
echo "\n🅰️  Accessibility - Font scale\n"
# exit if no Android device
source $adbHelperRoot/lib/adb-wrapper.sh
if [[ -z $DEVICE ]]; then
  return 0
fi
export ANDROID_DEVICE=$DEVICE # change default device for gradle

function changeFontSize {
  echo "🅰️  $1"
  if [ $1 == "Small" ]; then
    adb -s $DEVICE shell settings put system font_scale 0.85
  elif [ $1 == "Default" ]; then
    adb -s $DEVICE shell settings put system font_scale 1.0
  elif [ $1 == "Large" ]; then
    adb -s $DEVICE shell settings put system font_scale 1.15
  elif [ $1 == "Largest" ]; then
    adb -s $DEVICE shell settings put system font_scale 1.30
  elif [ $1 == "Ridiculous" ]; then
    adb -s $DEVICE shell settings put system font_scale 2.0
  fi
}

while true; do
  echo "1. Small"
  echo "2. Default"
  echo "3. Large"
  echo "4. Largest"
  echo "5. Ridiculous"
  trap '{ echo "\nExiting...  Bye bye! 👋"; return; }' INT
  read -n 1 -s CHOICE
  if [[ $CHOICE == 1 ]]; then
    changeFontSize "Small"
  elif [[ $CHOICE == 2 ]]; then
    changeFontSize "Default"
  elif [[ $CHOICE == 3 ]]; then
    changeFontSize "Large"
  elif [[ $CHOICE == 4 ]]; then
    changeFontSize "Largest"
  elif [[ $CHOICE == 5 ]]; then
    changeFontSize "Ridiculous"
  elif [[ $CHOICE == "q" ]]; then
    echo "\nExiting... Bye bye! 👋"
    return
  else
    echo "\n🤷‍ Incorrect choice. Choose between 1 and 5, or \"q\" to exit."
  fi
done
