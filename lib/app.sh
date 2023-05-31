#!/bin/bash
# app related methods
source $adbHelperRoot/lib/strings.sh
declare -a installedPackages=()
packageIndex=0
packagesArray=()
packagesConfigFile=".idea/.adb_helper_packages_config"

function startApp {
  findPackage
  echo "\n🚀 Launching..."
  adb -s $DEVICE shell monkey -p $finalPackageName -c android.intent.category.LAUNCHER 2 > /dev/null 2>&1 # TODO we use "2" here to avoid starting LeakCanary - doesnt seem to work on TV?
  echo "💫 Launched $finalPackageName ($variant)!"
}

function stopApp {
  findPackage
  printf "\n⛔️ Stopping $finalPackageName... "
  adb -s $DEVICE shell am force-stop $finalPackageName > /dev/null 2>&1
}

function uninstallApp {
  findPackage
  printf "\n🧨 Uninstalling $finalPackageName... "
  adb -s $DEVICE uninstall "$finalPackageName"
}

function clearCache {
  findPackage
  printf "\n🗑  Clearing cache of $finalPackageName... "
  adb -s $DEVICE shell pm clear "$finalPackageName"
}

function findPackage {
    if [[ -z $finalPackageName ]] || [[ $previouslySelectedConfig != $selectedConfig ]]; then
      findPackagesInInstalledApps
      echo "\n📚 Enter the number of the package to launch for variant $variant.\nThis setting will be saved. To reset that choice, refresh variants."
      showPackagesChoices
      read -p "" PACKAGE_CHOICE
      packageIndex=$PACKAGE_CHOICE-1 # TODO memorise packageIndex in file
      finalPackageName="${installedPackages[$packageIndex]}"
    fi
}

function findPackagesInInstalledApps {
  installedPackages=()
  packagesRegexString=$(joinByString "|" "${packagesArray[@]}")
  apkRows=$(adb shell pm list packages -f | grep -E "$packagesRegexString")
  if [[ ! -z "$apkRows" ]]; then
     IFS=$'\n' read -rd '' -a apkRowsArray <<<"$apkRows"
     for row in "${apkRowsArray[@]}"; do
        IFS="="
        read -ra apkRowArray <<< "$row"
        installedPackageName=${apkRowArray[@]: -1}
        installedPackages+=($installedPackageName)
        unset IFS
     done
     unset IFS
  fi
}

function showPackagesChoices {
  index=0
  for input in "${installedPackages[@]}"; do
     ((index++))
     indexString=$(printf "%01d" $index)
     echo "[$indexString] $input"
  done
}

function findPackagesFromManifests {
  echo "\n🦄 Finding packages prefixes from manifests..."
  IFS=$'\n'
  manifests=($(find . -name "AndroidManifest.xml"))
  regex=package="(.*?)"
  for manifest in "${manifests[@]}"; do
      if [[ "$manifest" == *"$package"* ]]; then
        manifestText=$(cat $manifest)
        packageProperty=$(echo "$manifestText" | grep "package=" | tr -d ">" | tr -d "\"" | tr -d " ")
        if [[ ! -z "$packageProperty" ]]; then
          if [[ "$packageProperty" != *"<manifestpackage"* ]]; then
            packageName=${packageProperty#"package="}
            # split to get only domain part
            IFS='.' read -r -a packageNameArray <<< "$packageName"
            unset IFS
            packageName="${packageNameArray[0]}.${packageNameArray[1]}.${packageNameArray[2]}"
            if [[ ! "${packagesArray[*]}" =~ "$packageName" ]] &&
               [[ ! "$packageName" = "com.google.android" ]] &&
               [[ ! "$packageName" = "com.amazon.alexa" ]] &&
               [[ ! "$packageName" = "com.amazon.profiles" ]]
            then
              packagesArray+=($packageName)
            fi
          fi
        fi
      fi
  done
  unset IFS
  writePackagesConfigFile
}

function writePackagesConfigFile {
  printf "\n🦄 Writing packages prefixes to config file... "
  printf "%s\n" "${packagesArray[@]}" > $packagesConfigFile
  echo "Done."
}

function getPackagesFromConfigFile {
    packagesArray=()
    while IFS= read -r line; do
      packagesArray+=("$line") # Append line to the array
    done < $packagesConfigFile
    unset IFS
}
