#!/bin/bash
# device related methods
function getDeviceOrReturn {
  source $adbHelperRoot/lib/adb-wrapper.sh
  if [[ -z $DEVICE ]]; then
    return
  fi
}

function isDeviceTV {
  phoneProperty=$(adb -s $DEVICE shell getprop | grep "phone")
  if [ -z "$phoneProperty" ]; then
    echo true
  else
    echo false
  fi
}
