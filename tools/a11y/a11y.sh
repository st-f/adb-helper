#!/bin/bash
echo "\n♿️ Accessibility"
echo "\n1. 🎧 TalkBack"
echo "2. 🅰️  Font scale"
echo "3. 🟧 Colors"
echo "4. 👇 Touches"
trap '{ return; }' INT
read -n 1 -s CHOICE
if [[ $CHOICE == 1 ]]; then
  source $adbHelperRoot/tools/a11y/talkback.sh
elif [[ $CHOICE == 2 ]]; then
  source $adbHelperRoot/tools/a11y/fontscale.sh
elif [[ $CHOICE == 3 ]]; then
  source $adbHelperRoot/tools/a11y/colors.sh
elif [[ $CHOICE == 4 ]]; then
  source $adbHelperRoot/tools/a11y/touches.sh
elif [[ $CHOICE == "q" ]]; then
  echo "\nExiting... Bye bye! 👋"
  return
else
  echo "\n🤷‍ Incorrect choice. Choose between 1 and 3, or \"q\" to exit."
fi
source $adbHelperRoot/tools/a11y/a11y.sh
