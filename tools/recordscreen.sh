#!/bin/bash
source $adbHelperRoot/lib/stopwatch.sh
debugSelection=false
echo "\n📹 ADB Screen recorder tool 🎥"
trap '{ echo "\n🤝 Screen record sesh finished."; return; }' INT
source $adbHelperRoot/lib/device.sh
getDeviceOrReturn

bugreport="--bugreport"
if [[ $debugSelection == true ]]; then
    read -n 1 -r -p "🔎 Add bug report layer? Type 'n' or enter to continue. " BUG
    if [[ $BUG == "n" ]]; then
        echo "\nDon't show bug report layer."
        bugreport=""
    fi
fi
recording=true
while $recording; do
    trap '{ echo "\\n🤝 Screen recording sesh finished."; recording=false; return; }' INT
    read -n 1 -r -s -p "⌨️  Type any key to start recording, \"q\" or ctrl-C to exit." KEY
    echo
    if [[ $KEY == "q" ]]; then
        recording=false
        break
    fi
    now=$(date +%d-%m-%Y-%H.%M.%S)
    file=record_$now.mp4
    deviceFile=/sdcard/$file
    localFile=$adbHelperDownloadRoot/$file
    trap '{ echo; echo '"📦 And that\'s a wrap. Downloading..."'; }' INT
    adb -s $DEVICE shell screenrecord $bugreport $deviceFile &
    stopwatch "🔴✨ Recording: %02d:%02d:%02d - press any key to finish."
    kill $!
    wait $! 2>/dev/null # hides kill output
    echo "\n🌧  Downloading..."
    sleep 2 # that's a weird thing but doesn't work without
    adb -s $DEVICE pull $deviceFile $localFile
    adb -s $DEVICE shell rm $deviceFile
    open -R $localFile
done
