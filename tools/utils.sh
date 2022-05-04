#!/bin/bash
source $adbHelperRoot/lib/device.sh
echo "\n🧰 Utils"
echo "\n1. 🔮 Scrcpy"
echo "2. ✏️  Text input"
echo "3. 📋 List devices"
#echo "4. 📲 Pair a device"
echo "4. 🔄 Restart ADB"
echo "5. 📱 Device info"
echo "6. ♿️ Accessibility"
echo "7. 🐈 Logcat"
#echo "8. 🐅 Better Logcat"
trap '{ return; }' INT
read -n 1 -s CHOICE
echo
if [ $CHOICE == 1 ]; then
  source $adbHelperRoot/tools/scrcpy.sh
elif [ $CHOICE == 2 ]; then
  source $adbHelperRoot/tools/textinput.sh
elif [ $CHOICE == 3 ]; then
  adb devices -l
#elif [ $CHOICE == 4 ]; then
#  source $adbHelperRoot/tools/pair.sh
elif [ $CHOICE == 4 ]; then
  adb disconnect; adb kill-server; adb start-server; adb devices -l
elif [ $CHOICE == 5 ]; then
  getDeviceOrReturn
  adb -s $DEVICE shell getprop | grep "model\|version.sdk\|manufacturer\|hardware\|platform\|revision\|serialno\|product.name\|brand"
elif [ $CHOICE == 6 ]; then
  source $adbHelperRoot/tools/a11y/a11y.sh
elif [ $CHOICE == 7 ]; then
  getDeviceOrReturn
  adb -s $DEVICE logcat -v color | grep $appIdentifier
# elif [ $CHOICE == 8 ]; then
#   getDeviceOrReturn
#   python $adbHelperRoot/lib/coloredlogcat.py
elif [ $CHOICE == "q" ]; then
  return
else
  echo "🤷‍ Incorrect choice. Choose between 1 and 6, or \"q\" to exit."
fi
source $adbHelperRoot/tools/utils.sh
