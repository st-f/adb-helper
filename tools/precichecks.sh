#!/bin/bash
echo "\n⚗️  Pre-CI checks"
configsFile=".idea/.adb_helper_pre_ci_checks"
if [ ! -f $configsFile ]
then
  printf "./gradlew clean detekt" > $configsFile
fi
while true; do
  echo "\nWill execute the following commands:"
  cat $configsFile
  trap '{ echo "\n🤝 Pre-CI checks sesh finished."; return; }' INT
  echo "\n\nType \"e\" to edit checks list (enter full commands, line by line), or \"q\" or ctrl-C to exit."
  read -n 1 -r -s -p "⌨️  or type Enter key to run checks: " CI_CHECKS_CHOICE
  echo $CI_CHECKS_CHOICE
  if [[ $CI_CHECKS_CHOICE == "e" ]]; then
    nano $configsFile
  elif [[ $CI_CHECKS_CHOICE == "q" ]]; then
      break
  else
    echo "\nRunning..."
    bash $configsFile
  fi
done
