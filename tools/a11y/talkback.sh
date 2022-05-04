#!/bin/bash
echo "\n🎧 Accessibility - TalkBack\n"
# exit if no Android device
source $adbHelperRoot/lib/adb-wrapper.sh
if [[ -z $DEVICE ]]; then
  return 0
fi
export ANDROID_DEVICE=$DEVICE # change default device for gradle

function startTalkBack {
  echo "🟢 Talkback ON - might take a few seconds."
  adb -s $DEVICE shell settings put secure accessibility_enabled 1
  adb -s $DEVICE shell settings put secure enabled_accessibility_services com.google.android.marvin.talkback/com.google.android.marvin.talkback.TalkBackService
}

function stopTalkBack {
  echo "🔴 Talkback OFF"
  adb -s $DEVICE shell settings put secure accessibility_enabled 0
  adb -s $DEVICE shell settings put secure enabled_accessibility_services com.android.talkback/com.google.android.marvin.talkback.TalkBackService
}

while true; do
  echo "⌨️  Type \"s\" to start TalkBack, \"t\" to stop, or \"q\" to quit."
  trap '{ return; }' INT
  read -n 1 -s CHOICE
  if [[ $CHOICE == "s" ]]; then
    startTalkBack
  elif [[ $CHOICE == "t" ]]; then
    stopTalkBack
  elif [[ $CHOICE == "q" ]]; then
    return
  else
    echo "🤷‍ Incorrect choice. Choose between \"s\", \"t\", or \"q\" to exit."
  fi
done
