#!/bin/bash
scrcpyRunning=true

while $scrcpyRunning; do
  echo "\n🔮 Scrcpy"
  source $adbHelperRoot/lib/device.sh
  getDeviceOrReturn

  if [ -z $DEVICE ]; then # needed because getDeviceOrReturn will call the loop again
    scrcpyRunning=false
    return
  fi

  if [ "$USER_CHOICE" == "q" ]; then
    scrcpyRunning=false
    return
  fi
  trap '{ scrcpyRunning=false; return; }' INT
  echo "isDeviceTV: $(isDeviceTV)"
  if [ $(isDeviceTV) == true ]; then
    width=712
  else
    width=380
  fi
  scrcpy -s $DEVICE --window-x 0 --window-y 0 --window-width $width
done
