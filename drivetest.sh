#!/bin/bash

# Set the email recipient
recipient="mrnetlex@gmail.com"

# List of drives to check (replace with your own)
drives=("sda" "sdc" "sdd")

# Get the current date and time for logging
log_date=$(date "+%Y-%m-%d %H:%M:%S")

# Loop through the drives and run smartctl in the background
for drive in "${drives[@]}"
do
  # Start a short test on the drive in the background
  smartctl -t short "/dev/$drive" &>/dev/null &
done

# Wait for all tests to complete
wait

# Initialize the output with the header
output="SMART short test and attribute check results on $log_date:\n"

# Loop through the drives again to get the test results and drive information
for drive in "${drives[@]}"
do
  # Get the device model name
  device_model=$(smartctl -i "/dev/$drive" | awk -F': ' '/Device Model/{print $2}')

  # Get the test results and drive information
  test_output=$(smartctl -l selftest "/dev/$drive")
  drive_info=$(smartctl -A "/dev/$drive")

  # Check if the test passed or failed and if there are any errors in the SMART attributes
  if [[ $test_output == *"Completed without error"* ]] && [[ $(echo "$drive_info" | awk '/^5/ || /^197/ || /^198/ { if ($10 != "0") {print "error"} }') != "error" ]]; then
    test_result="PASSED ✅"
  else
    test_result="FAILED 🔴"
  fi

  # Build the output for this drive
  output="$output\n- Drive name: /dev/$drive"
  output="$output\n  Drive model: $device_model"
  output="$output\n  Short test: $test_result"
  output="$output\n  SMART attribute errors:"

  # Check for SMART attribute errors
  smart_errors=$(echo "$drive_info" | awk '/^5/ || /^197/ || /^198/ { if ($10 != "0") {print $0} }')
  if [[ -z $smart_errors ]]; then
    output="$output no important errors ✅\n"
  else
    output="$output important errors found 🔴\n"
    output="$output\n$drive_info\n"
  fi
done

# Log the output to a file with the current date and time
echo -e "$output" >> /home/netlex/drivetest.log

# Send an email with the test results and drive information
if [ "$test_result" = "PASSED ✅" ]; then
  echo -e "$output" | mail -s "💾 Smartctl Results: Everything is OK ✅" "$recipient"
else
  echo -e "$output" | mail -s "💾 Smartctl Results: There's Something Wrong 🔴" "$recipient"
fi
