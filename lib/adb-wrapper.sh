#!/bin/bash
# This is a wrapper for adb.  If there are multiple devices / emulators, this script will prompt for which device to use
# Then it'll pass whatever commands to that specific device or emulator.
# Run adb devices once, in event adb hasn't been started yet
echo "⏳ Searching for Android devices.."
BLAH=$(adb devices)
# Grab the IDs of all the connected devices / emulators
IDS=($(adb devices | sed '1,1d' | sed '$d' | cut -f 1 | sort)) # TODO change to avoid using sed
NUMIDS=${#IDS[@]}
# Check for number of connected devices / emulators
if [[ 0 -eq "$NUMIDS" ]]; then
	echo "🤷‍♂️ No emulators or devices detected."
	return
fi
# Grab the manufacturer for each device / emulator
declare -a MANUFACTURER_VERSIONS
for (( x=0; x < $NUMIDS; x++ )); do
	manufacturer=$(adb -s ${IDS[$x]} shell getprop ro.product.manufacturer)
	MANUFACTURER_VERSIONS[x]=$(echo $manufacturer | cut -c1 | tr a-z A-Z)$(echo $manufacturer | cut -c2-)
done
# Grab the model name for each device / emulator
declare -a PRODUCTS_NAMES
for (( x=0; x < $NUMIDS; x++ )); do
	PRODUCTS_NAMES[x]=$(adb -s ${IDS[$x]} shell getprop ro.product.model)
done
# Grab the platform version for each device / emulator
declare -a SDK_VERSIONS
for (( x=0; x < $NUMIDS; x++ )); do
	SDK_VERSIONS[x]=$(adb -s ${IDS[$x]} shell getprop ro.build.version.sdk)
done
if [[ 1 -eq "$NUMIDS" ]]; then
	DEVICE=$IDS
	echo $DEVICE > ~/BashScripts/.adbe
	x=0
	DEVICE_NAME="${MANUFACTURER_VERSIONS[x]} ${PRODUCTS_NAMES[x]} (SDK ${SDK_VERSIONS[x]})"
	echo "🤖 Device detected: $DEVICE_NAME"
else
	N=1
	echo "🤖🤖🤖 Multiple devices detected, please select one:\n"
	for (( x=0; x < $NUMIDS; x++ )); do
		DEVICE_NAME=${PRODUCTS_NAMES[x]}
		ID=${IDS[x]}
		echo "$N. ${MANUFACTURER_VERSIONS[x]} ${PRODUCTS_NAMES[x]} (SDK ${SDK_VERSIONS[x]})"
		let N=$N+1
	done
	echo
	trap "{ return; }" INT
	read -n 1 -r -s USER_CHOICE
	# Validate user entered a number
	if [[ $USER_CHOICE =~ ^[0-9]+$ ]]; then
		DEVICE=${IDS[$USER_CHOICE-1]}
		DEVICE_NAME="${MANUFACTURER_VERSIONS[$USER_CHOICE-1]} ${PRODUCTS_NAMES[$USER_CHOICE-1]} (SDK ${SDK_VERSIONS[$USER_CHOICE-1]})"
		echo $DEVICE_NAME
	elif [[ $USER_CHOICE == "q" ]]; then
		return
	else
		echo "You must enter a number"
	fi
fi
