#!/bin/bash
echo "📲 Pair a device"
echo "💡 Tip: devices already connected on that network"
echo "will automatically reconnect if adb is running.\n"
trap '{ echo; return; }' INT
adb devices
localIP=$(ipconfig getifaddr en0)
ipArray=(${localIP//./ })
ipBaseLastIndex=${#ipArray[@]}
((ipBaseLastIndex-=2)) # removes the last item and 1 for index
ipBase=""
for index in $(eval echo "{0..$ipBaseLastIndex}"); do
  ipBase+="${ipArray[$index]}."
done
echo "Local IP: $local"
read -n 1 -s -p "Local base IP: $ipBase - press enter to continue or \"n\" to change" BASE
echo
if [[ $BASE == "n" ]]; then
  echo "⌨️  Enter base IP, for example \"192.168.1.\""
  read -p "(must end with a point): " IP
  ipBase=$IP
fi
read -p "⌨️  Enter IP: $ipBase" IP # TODO get root IP of computer
read -p "⌨️  Enter Port: " PORT
adb pair "$ipBase.$IP:$PORT"
