#!/bin/bash
source $adbHelperRoot/lib/device.sh
source $adbHelperRoot/lib/app.sh
declare -a configArray=()
declare -a configStringArray=()
declare selectedConfig=-1
declare previouslySelectedConfig=-2
declare variant=""
configsFile=".idea/.adb_helper_configs"
configsStringsFile=".idea/.adb_helper_configs_strings"
variantEmojisStringsFile=".idea/.adb_helper_variants_emojis"
emojisHelpComment="# Use this file to add emojis to variants.
# For example: 📱=mobile will add 📱 before the variant name if it's name contains \"mobile\".
# More than one emoji can be used, if the variant matches multiple strings.
# You can leave this comment or remove it."

function getConfigsFromFiles {
  configStringArray=()
  while IFS= read -r line; do
    configStringArray+=("$line") # Append line to the array
  done < $configsStringsFile
  configArray=()
  while IFS= read -r line; do
    configArray+=("$line") # Append line to the array
  done < $configsFile
}

function getSourcesSets {
  index=0
  echo "⏳ Retrieving build variants..." # TODO filter to only keep config prefixed with "install" - much easier
  variants=$(./gradlew tasks --all |
    grep "install" |
    grep -v "uninstall" |
    grep -v "AndroidTest" |
    grep -Eo '^[^ ]+'
  )
  echo
  while read -r line ; do
    variant=$line
    ((index++))
    indexString=$(printf "%02d" $index)
    configArray+=("$variant")
    configStringArray+=("$variant")
    #echo "[$indexString] $variant"
  done<<<"$variants"
}

function echoVariants {
  getVariantEmojisStringsFromFile
  echo "\nChoose a variant:\n"
  index=0
  for config in "${configStringArray[@]}"; do
     ((index++))
     indexString=$(printf "%02d" $index)
     configWithEmojis=$(applyEmojisToVariants $config)
     echo "[$indexString] $configWithEmojis"
  done
}

function initEmojiFile {
  if [ ! -f $variantEmojisStringsFile ]
  then
    printf "$emojisHelpComment" > $variantEmojisStringsFile
  fi
}

function applyEmojisToVariants {
  ret=$1
  for emojiDefinition in "${variantEmojisStringsArray[@]}"; do
    arrIN=(${emojiDefinition//=/ })
    emoji=${arrIN[0]}
    substitution=$(echo "${arrIN[1]}" | tr -d '"' )
    if [[ "$ret" == *"$substitution"* ]]; then
      emojisString+="$emoji  "
    fi
  done
  ret="$emojisString$1"
  echo "$ret"
}

function getVariantEmojisStringsFromFile {
  #echo "🦄 Getting emojis from config file..."
  variantEmojisStringsArray=()
  while IFS= read -r line; do
    if [[ $line != \#* ]] # * is used for pattern matching to detect comments
    then
      variantEmojisStringsArray+=("$line")
    fi
  done < $variantEmojisStringsFile
}

function runGradle {
  if [ ${selectedConfig: -1} == "c" ]; then
    clean="clean"
    selectedConfig=${selectedConfig:0:$((${#selectedConfig} - 0 - 1))} # remove last char
  else
    clean=""
  fi
  variant="${configArray[$selectedConfig]}"
  installCommand=$(echo $variant | cut -d ":" -f 2)
  echo "\n⚙️  $clean $installCommand\n" # on $DEVICE\n
  ./gradlew $clean $installCommand #-d $DEVICE # TODO this command install on ALL connected devices! Why?
}

echo "\n🤖 Compile & install"
# exit if no Android project
if [ ! -f "gradlew" ]; then
  echo "🤷‍ No Android project found in $(pwd), exiting."
  return
fi

source $adbHelperRoot/lib/adb-wrapper.sh
if [[ -z $DEVICE ]]; then
  return
fi
export ANDROID_DEVICE=$DEVICE # change default device for gradle - TODO not working!
initEmojiFile

while true; do
  if [ -f "$configsFile" ] && [ -f "$configsStringsFile" ] && [ -f "$packagesConfigFile" ] &&
     [ -s "$configsFile" ] && [ -s "$configsStringsFile" ] && [ -s "$packagesConfigFile" ]; then
    getConfigsFromFiles
    getPackagesFromConfigFile
    echoVariants
  else
    getSourcesSets
    findPackagesFromManifests
    echoVariants
    printf "%s\n" "${configArray[@]}" > $configsFile
    printf "%s\n" "${configStringArray[@]}" > $configsStringsFile
  fi
  if [ $selectedConfig != -1 ]; then
    configString=${configStringArray[$selectedConfig]}
    echo "⌨️  Press Enter to rerun: $configString"
    echo "\n\"s\"= start app, \"t\"= stop, \"u\"= uninstall, \"c\"= clear data"
  else
    echo
  fi
  echo "\"r\"= refresh variants, \"e\"= edit emojis config, \"q\"= quit"
  trap '{ echo "\n🤝 Compile & install sesh finished."; return; }' INT
  read -p "⌨️  Enter variant number then enter. Type \"c\" after the variant name to clean first: " COMPILE_CHOICE
  if [ -z $COMPILE_CHOICE ]; then
    if [ $selectedConfig != -1 ]; then
      runGradle
      startApp
    else
      echo "🤷‍ Incorrect choice. Type a number or letter, or \"q\" to exit."
    fi
  elif [ $COMPILE_CHOICE == "q" ]; then
    return
  elif [ $COMPILE_CHOICE == "s" ]; then
    startApp
  elif [ $COMPILE_CHOICE == "t" ]; then
    stopApp
  elif [ $COMPILE_CHOICE == "c" ]; then
    clearCache
  elif [ $COMPILE_CHOICE == "u" ]; then
    uninstallApp
  elif [ $COMPILE_CHOICE == "r" ]; then
    rm $configsFile
    rm $configsStringsFile
    rm $packagesConfigFile
    source $adbHelperRoot/tools/compile.sh
  elif [ $COMPILE_CHOICE == "e" ]; then
    vi $variantEmojisStringsFile
  else
    if [[ $COMPILE_CHOICE =~ ^[0-9]+$ ]]; then
      selectedConfig=$COMPILE_CHOICE-1
      runGradle
      startApp
      previouslySelectedConfig=$selectedConfig
    else
      echo "🤷‍ Incorrect choice. Type a number or letter, or \"q\" to exit."
    fi
  fi
done
