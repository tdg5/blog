#!/bin/bash

# Since we're dealing with dd, abort if any errors occur
set -e

TEST_FILE=${1:-dd_ibs_testfile}
if [ -e "$TEST_FILE" ]; then TEST_FILE_EXISTS=$?; fi
TEST_FILE_SIZE=134217728

# Exit if file exists
if [ -e $TEST_FILE ]; then
  echo "Test file $TEST_FILE exists, aborting."
  exit 1
fi
TEST_FILE_EXISTS=1

if [ $EUID -ne 0 ]; then
  echo "NOTE: Kernel cache will not be cleared between tests without sudo. This will likely cause inaccurate results." 1>&2
fi

# Create test file
echo 'Generating test file...'
BLOCK_SIZE=65536
COUNT=$(($TEST_FILE_SIZE / $BLOCK_SIZE))
dd if=/dev/urandom of=$TEST_FILE bs=$BLOCK_SIZE count=$COUNT conv=fsync > /dev/null 2>&1

# Header
PRINTF_FORMAT="%8s : %s\n"
printf "$PRINTF_FORMAT" 'block size' 'transfer rate'

# Block sizes of 512b 1K 2K 4K 8K 16K 32K 64K 128K 256K 512K 1M 2M 4M 8M 16M 32M 64M
for BLOCK_SIZE in 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 4194304 8388608 16777216 33554432 67108864
do
  # Clear kernel cache to ensure more accurate test
  [ $EUID -eq 0 ] && [ -e /proc/sys/vm/drop_caches ] && echo 3 > /proc/sys/vm/drop_caches

  # Read test file out to /dev/null with specified block size
  DD_RESULT=$(dd if=$TEST_FILE of=/dev/null bs=$BLOCK_SIZE 2>&1 1>/dev/null)

  # Extract transfer rate
  TRANSFER_RATE=$(echo $DD_RESULT | \grep --only-matching -E '[0-9.]+ ([MGk]?B|bytes)/s(ec)?')

  printf "$PRINTF_FORMAT" "$BLOCK_SIZE" "$TRANSFER_RATE"
done

# Clean up the test file if we created one
if [ $TEST_FILE_EXISTS -ne 0 ]; then rm $TEST_FILE; fi
