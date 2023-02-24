#!/bin/bash

# Set the email recipient
recipient="example@mail.com"

# List of drive IDs to check (replace with your own)
drive_ids=("ata-TOSHIBA_MQ04ABD200_21ONP02WT" "ata-Hitachi_HUS724040ALE641_PCH8YKDB" "ata-Hitachi_HUS724040ALE641_PBKB7MRS")
# Note: the above is just an example ID, you'll need to replace it with the correct one for your drives

# Get the current date and time for logging
log_date=$(date "+%Y-%m-%d %H:%M:%S")

# Loop through the drives and run smartctl in the background
for drive_id in "${drive_ids[@]}"
do
  # Start a short test on the drive in the background
  smartctl -t short "/dev/disk/by-id/$drive_id" &>/dev/null &
done

# Wait for all tests to complete
wait

# Initialize the output with the header
output="SMART short test and attribute check results on $log_date:\n"

# Loop through the drives again to get the test results and drive information
for drive_id in "${drive_ids[@]}"
do
  # Get the device model name
  device_model=$(smartctl -i "/dev/disk/by-id/$drive_id" | awk -F': ' '/Device Model/{print $2}')

  # Get the test results and drive information
  test_output=$(smartctl -l selftest "/dev/disk/by-id/$drive_id")
  drive_info=$(smartctl -A "/dev/disk/by-id/$drive_id")

  # Check if the test passed or failed and if there are any errors in the SMART attributes
  if [[ $test_output == *"Completed without error"* ]] && [[ $(echo "$drive_info" | awk '/^5/ || /^197/ || /^198/ { if ($10 != "0") {print "error"} }') != "error" ]]; then
    test_result="PASSED ✅"
  else
    test_result="FAILED 🔴"
  fi

  # Build the output for this drive
  output="$output\n- Drive name: /dev/disk/by-id/$drive_id"
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
