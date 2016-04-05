#!/bin/bash

# Since we're dealing with dd, abort if any errors occur
set -e

TEST_FILE=${1:-dd_ibs_testfile}
[ -e "$TEST_FILE" ]; TEST_FILE_EXISTS=$?
TEST_FILE_SIZE=134217728

# Exit if file exists
if [ -e $TEST_FILE ]; then
  echo "Test file $TEST_FILE exists, aborting."
  exit 1
fi

# Create test file
echo 'Generating test file...'
BLOCK_SIZE=65536
COUNT=$(($TEST_FILE_SIZE / $BLOCK_SIZE))
dd if=/dev/urandom of=$TEST_FILE bs=$BLOCK_SIZE count=$COUNT > /dev/null 2>&1

# Header
PRINTF_FORMAT="%8s : %s\n"
printf "$PRINTF_FORMAT" 'block size' 'transfer rate'

# Block sizes of 512b 1K 2K 4K 8K 16K 32K 64K 128K 256K 512K 1M 2M 4M 8M 16M 32M 64M
for BLOCK_SIZE in 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 4194304 8388608 16777216 33554432 67108864
do
  # Read test file out to /dev/null with specified block size
  DD_RESULT=$(dd if=$TEST_FILE of=/dev/null bs=$BLOCK_SIZE 2>&1 1>/dev/null)

  # Extract transfer rate
  TRANSFER_RATE=$(echo $DD_RESULT | \grep --only-matching -E '[0-9.]+ ([MGk]?B|bytes)/s(ec)?')

  printf "$PRINTF_FORMAT" "$BLOCK_SIZE" "$TRANSFER_RATE"
done

# Clean up the test file if we created one
[ $TEST_FILE_EXISTS -ne 0 ] && rm $TEST_FILE
