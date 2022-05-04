#!/bin/bash
textInputHistoryArray=()
textInputHistoryFile="$adbHelperRoot/.textInputHistory" # TODO: per project file? in .idea?

echo "\n✏️  Text input"
source $adbHelperRoot/lib/device.sh
getDeviceOrReturn

function getStringsFromFile {
  textInputHistoryArray=()
  while IFS= read -r line; do
    textInputHistoryArray+=("$line") # Append line to the array
  done < $textInputHistoryFile
}

function echoInputHistory {
  index=0
  for input in "${textInputHistoryArray[@]}"; do
     ((index++))
     indexString=$(printf "%01d" $index)
     echo "[$indexString] $input"
  done
}

function writeStringsToFile {
  printf "%s\n" "${textInputHistoryArray[@]}" > $textInputHistoryFile
}

function addString {
  arrayLength=${#textInputHistoryArray[@]}
  if [ "$arrayLength" -gt 8 ]; then
    textInputHistoryArray=("${textInputHistoryArray[@]:1}") # removes the first element
  fi
  textInputHistoryArray+=("$1") # append to array
}

while true; do
  echo
  if [ -f "$textInputHistoryFile" ] && [ -s "$textInputHistoryFile" ]; then
    getStringsFromFile
    echoInputHistory
  else
    echo "No input history yet."
  fi
  trap '{ echo; return; }' INT
  echo
  read -s -n 1 -p "⌨️  Type a number from the history or press Enter to type text: " TEXT_INPUT
  maxLength=${#textInputHistoryArray[@]}
  if [[ $TEXT_INPUT =~ ^[0-9]+$ ]] && [[ "$TEXT_INPUT" -le "$maxLength" ]]; then
    TEXT="${textInputHistoryArray[$TEXT_INPUT-1]}"
  else
    read -p "Enter text: " TEXT
    if [ -n "$TEXT" ]; then
      addString $TEXT
      writeStringsToFile
    fi
  fi
  if [ -n "$TEXT" ]; then
    adb -s $DEVICE shell input text $TEXT
  fi
done
