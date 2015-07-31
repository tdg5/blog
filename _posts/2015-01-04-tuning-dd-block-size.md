---
author: Danny Guinther
categories: [dev/bash, dev/Linux, dev/Unix]
featured_image:
  alt_text: Tuning dd block size
  title: Tuning dd block size
  url: https://s3.amazonaws.com/tdg5/blog/wp-content/uploads/2015/01/04153244/block_sizes.jpg
layout: post
permalink: /tuning-dd-block-size
tags: [bash, cli, command line, dd, knoppix, linux, shell, terminal, unix]
title: Tuning dd block size
---
Though I wouldn't call myself a dd expert, I have had my fair share of occasions
to yield the might that is dd. From my first job after college using
[KNOPPIX][KNOPPIX] and dd to rescue NFL game footage from dying HDDs on behalf
of NFL video coordinators, to using dd this past summer to move [my
girlfriend's][alilallovertheplace.com] OSX installation over to a faster SSD, dd
has been an invaluable tool in my Unix arsenal for almost 10 years.

Maybe it's because everyone focuses on getting the **of** (output file) argument
right, or maybe there's more to it, but in my time with dd, one aspect of dd's
usage that I've found often overlooked relates to dd's three block size
arguments, **ibs** (input block size), **obs** (output block size), and the all
encompassing **bs** (input and output block size). Don't get me wrong, making
sure you've determined the correct **of** argument is of paramount importance,
but once you've got that nailed down, there's more to be done than breathe a
giant sigh of relief. The various block size arguments that dd takes will be the
deciding factor between whether the copy completes in a day or in two hours.

## A little background on block size

A **block** in terms of dd as explained by Wikipedia:

> A block is a unit measuring the number of bytes that are read, written, or
> converted at one time.[^1]

As such, the various block size arguments tell dd how many sectors should be
copied at once, whether for input, output, or both. By default, most versions of
dd will use a block size 512 bytes for both input and output.[^2] This may have
been fine pre-1999 when most hard drives had a sector size of 512 bytes, but
in recent years most hard drives have a sector size of at least 4KB (4096
bytes). This change may seem inconsequential but can lead to enormous
inefficiencies when combined with the fact that these days many typical consumer
hard drives have more than a terabyte of capacity. When dealing with a terabyte
or more of data, you **really** want to make sure you choose an optimal block
size.

There's a useful, though pretty dated, [message in the archive of the Eugene,
Oregon Linux User's Group (Eug-Lug) that offers some perspective on optimal
block sizes for dd][Eug-Lug] that can be useful as a jumping off point for your
own tests or in those situations where testing different block sizes isn't
feasible.  The findings presented in the message show that for the author's
particular hardware, a block size of about 64K was pretty close to optimal.

That's nice advice, but without more context it's somewhat meaningless, so let's
perform a few experiments.

## Science!

As an example of the impact that an inefficient/optimal block size can have,
I've run a few tests for your consideration. These results are all specific to
my hardware, and though they may offer a rule-of-thumb for similar situations,
it's important to keep in mind that there is no universally correct block size;
what is optimal for one situation may be terribly inefficient for another.  To
that end, the tests below are meant to provide a simple example of the benefits
of optimizing the block size used by dd; they are not intended to accurately
replicate real world copy scenarios.

For simplicity, we will be reading data from */dev/zero*, which should be able
to churn out zeros at a much, much faster rate than we can actually write them, which,
in turn, means that these examples are actually testing optimal output block
sizes and are, more or less, ignoring input block size entirely. Optimizing input
block sizing is left as an exercise for the reader and should be easy enough to
achieve by reading data from the desired disk and writing it out to */dev/null*.

On with the experiments!

Let's start off with a few tests writing out to a HDD:

- Reading from */dev/zero* and writing out to a HDD with the default block size
  of 512 bytes yields a throughput of 10.9 MB/s. At that rate, writing 1TB of
  data would take about 96,200 seconds or just north of 26 hours.

- Reading from */dev/zero* and writing out to a HDD with the Eug-Lug suggested
  block size of 64K yields a throughput of 108 MB/s. At that rate, writing 1TB
  of data would take 9,709 seconds or about 2.7 hours to complete.  This is a
  huge improvement, nearly an order of magnitude, over the default block size of
  512 bytes.

- Reading from */dev/zero* and writing out to a HDD with a more
  optimal block size of 512K yields a throughput of 131 MB/s. At that rate,
  writing 1TB of data would take about 8,004 seconds or about 2.2 hours. Though
  not as pronounced a difference, this is even faster than the Eug-Lug
  suggestion and is more than a full order of magnitude faster than the default
  block size of 512 bytes.

Let's switch gears and try a couple of experiments writing out to a SSD:

- Reading from */dev/zero* and writing out to a SSD with the default block size
  of 512 bytes yields a throughput of 39.6 MB/s. At that rate writing 1TB of
  data would take about 26,479 seconds or about 7.4 hours.

- Reading from */dev/zero* and writing out to a SSD with the Eug-Lug suggested
  block size of 64K yields a throughput of 266 MB/s. At that rate, writing 1TB
  of data would take about 3,942 seconds or about 1.1 hours.  Once again, this
  is a huge improvement, nearly an order of magnitude faster than the default
  block size of 512 bytes.

- Reading from */dev/zero* and writing out to a SSD with a more
  optimal block size of 256K yields a throughput of 280 MB/s. At that rate,
  writing 1TB of data would take about 3,744 seconds or about 1 hour.  Once
  again this is faster than both the Eug-Lug suggestion and the default, though
  not as much of an improvement as in the HDD case.

Let's switch gears one last time and try a few experiments writing out to RAM:

- Reading from */dev/zero* and writing out to RAM with the default block size
  of 512 bytes yields a throughput of 221 MB/s. At that rate, writing 1TB of
  data would take about 4,745 seconds or about 1.3 hours.

- Reading from */dev/zero* and writing out to RAM with the Eug-Lug suggested
  block size of 64K yields a throughput of 1,433 MB/s. At that rate, writing 1TB
  of data would take about 731 seconds or about 12 minutes to complete the
  transfer. Once again, this is a huge improvement, nearly an order of
  magnitude faster than the default block size.

- Reading from */dev/zero* and writing out to RAM with a more
  optimal block size of 256K yields a throughput of 1,536 MB/s. At that rate,
  writing 1TB of data would take about 682 seconds or about 11 minutes.  This is
  once again faster than the default and the Eug-Lug suggestion, but once
  again, pretty comparable to the Eug-Lug suggestion.

These experiments should help illustrate that depending on the type,
manufacturer, and state of the source and destination media, optimal block sizes
can vary wildly. This should also help demonstrate that on modern hardware the
default block size of 512 bytes tends to be horribly inefficient. That said,
though not always the most optimal, the Eug-Lug suggested block size of 64K can
be a somewhat reliable option for a more modern default.

## A pair of scripts to find more optimal block sizes

Because of the wild variance in optimal block sizing, I've written a couple of
scripts to test a range of different input and output block size options for use
prior to starting any large copies with dd. However, before we discuss the
scripts, **be warned that this both scripts use dd behind the scenes, so it's
important to use caution when running either script so as to avoid summoning
dd's alter ego, disk destroyer.**[^3] The scripts are short enough that I
encourage you to read both scripts before using either one of them so you have a
better understanding of what is going on behind the scenes.  That said, first
we'll look at a script for determining an optimal output block size.

### dd_obs_test.sh

Let's just jump straight into the script:

```bash
#!/bin/bash

# Since we're dealing with dd, abort if any errors occur
set -e

TEST_FILE=${1:-dd_obs_testfile}
[ -e "$TEST_FILE" ]; TEST_FILE_EXISTS=$?
TEST_FILE_SIZE=134217728

# Header
PRINTF_FORMAT="%8s : %s\n"
printf "$PRINTF_FORMAT" 'block size' 'transfer rate'

# Block sizes of 512b 1K 2K 4K 8K 16K 32K 64K 128K 256K 512K 1M 2M 4M 8M 16M 32M 64M
for BLOCK_SIZE in 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 4194304 8388608 16777216 33554432 67108864
do
  # Calculate number of segments required to copy
  COUNT=$(($TEST_FILE_SIZE / $BLOCK_SIZE))

  if [ $COUNT -le 0 ]; then
    echo "Block size of $BLOCK_SIZE estimated to require $COUNT blocks, aborting further tests."
    break
  fi

  # Create a test file with the specified block size
  DD_RESULT=$(dd if=/dev/zero of=$TEST_FILE bs=$BLOCK_SIZE count=$COUNT 2>&1 1>/dev/null)

  # Extract the transfer rate from dd's STDERR output
  TRANSFER_RATE=$(echo $DD_RESULT | \grep --only-matching -E '[0-9.]+ ([MGk]?B|bytes)/s(ec)?')

  # Clean up the test file if we created one
  [ $TEST_FILE_EXISTS -ne 0 ] && rm $TEST_FILE

  # Output the result
  printf "$PRINTF_FORMAT" "$BLOCK_SIZE" "$TRANSFER_RATE"
done
```

[View on GitHub][GitHub - dd_obs_test.sh]

As you can see, the script is a pretty basic for-loop that uses dd to create a
test file of 128MB using a variety of block sizes, from the default of 512
bytes, all the way up to 64M. There are a few extra arguments to the dd command
to make writing out a 128M file easy and there's also some grepping to pull out
the transfer rate, but otherwise, that's pretty much all there is to it.

By default the command will create a test file named *dd_obs_testfile* in the
current directory. Alternatively, you can provide a path to a custom test file
by providing a path after the script name:

```bash
$ ./dd_obs_test.sh /path/to/disk/or/test_file
```

The output of the script is a list of the tested block sizes and their respective transfer
rates like so:

```bash
$ ./dd_obs_test.sh /dev/null
512: 1.4 GB/s
1K: 2.6 GB/s
2K: 4.3 GB/s
4K: 6.5 GB/s
8K: 7.8 GB/s
16K: 9.0 GB/s
32K: 8.1 GB/s
64K: 7.6 GB/s
128K: 9.8 GB/s
256K: 7.9 GB/s
512K: 9.7 GB/s
1M: 12.8 GB/s
2M: 8.8 GB/s
4M: 7.2 GB/s
8M: 7.3 GB/s
16M: 5.5 GB/s
32M: 6.4 GB/s
64M: 4.0 GB/s
```

Wow, I guess [*/dev/null* really is web-scale.][YouTube - Mongo DB Is Web Scale]

### dd_ibs_test.sh
Now let's look at a similar script for determining an optimal input block size.
We can follow pretty much the same pattern expect for a couple of key
differences: instead of reading from */dev/zero* and writing out the test
file, this script reads from */dev/urandom* to create a test file of random bits
and then uses dd to copy that test file to */dev/null* using a variety of
different block sizes. Since this script creates the test file at the path you
specify, you will want to be careful not to accidentally overwrite an existing
file by pointing the script at an existing path.

Here's the script:

```bash
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
```

[View on GitHub][GitHub - dd_ibs_test.sh]

Similar to the *dd_obs_test.sh* script, this script will create a default test
file named *dd_ibs_testfile* but you you can also provide the script with a path
argument to test input block sizes on different devices:

```bash
$ ./dd_ibs_test.sh /path/to/disk/test_file
```

Again, it is important to remember that the script will try to overwrite the
test file and later will remove the file after it has been written, so use
extreme caution to avoid blowing away something you didn't mean to destroy. It
is likely that you will need to tweak this script to meet your particular use
case.

Also like *dd_obs_test.sh*, the output of this script is a list of the tested
block sizes and their respective transfer rates like so:

```bash
$ ./dd_ibs_test.sh
512: 1.1 GB/s
1K: 1.8 GB/s
2K: 3.0 GB/s
4K: 4.2 GB/s
8K: 5.1 GB/s
16K: 5.7 GB/s
32K: 5.4 GB/s
64K: 5.8 GB/s
128K: 6.3 GB/s
256K: 5.4 GB/s
512K: 5.8 GB/s
1M: 5.8 GB/s
2M: 5.3 GB/s
4M: 5.0 GB/s
8M: 4.9 GB/s
16M: 4.5 GB/s
32M: 4.4 GB/s
64M: 3.5 GB/s
```

In the above example it can be seen that an input block size of 128K is optimal
for my particular setup.

## The end

I hope this post has given you some insight into tuning dd's block size
arguments and maybe even saved you a day spent transferring blocks 512 bytes at
a time.

Thanks for reading!

[^1]: ["A block is a unit measuring the number of bytes that are read, written, or converted at one time."][Wikipedia - dd - Block Size]
[^2]: [**dd's** ibs (input block size) and obs (output block size) arguments both default to 512 bytes][Manpage - dd]
[^3]: ["Some people believe dd means "Destroy Disk" or "Delete Data" because if it is misused, a partition or output file can be trashed very quickly."][TipsForLinux - How and when to use the dd command?]

[alilallovertheplace.com]: http://alilallovertheplace.com/ "A Lil All Over The Place"
[TipsForLinux - How and when to use the dd command?]: http://www.codecoffee.com/tipsforlinux/articles/036.html "TipsForLinux - How and when to use the dd command?"
[Eug-Lug]: http://www.mail-archive.com/eug-lug@efn.org/msg12073.html "Eugene, OR Linux Users Group"
[GitHub - dd_obs_test.sh]: https://github.com/tdg5/blog_snippets/blob/master/lib/blog_snippets/articles/tuning_dd_block_size/dd_obs_test.sh "GitHub.com - dd_obs_test.sh"
[GitHub - dd_ibs_test.sh]: https://github.com/tdg5/blog_snippets/blob/master/lib/blog_snippets/articles/tuning_dd_block_size/dd_ibs_test.sh "GitHub.com - dd_ibs_test.sh"
[KNOPPIX]: http://www.knopper.net/knoppix/index-en.html "KNOPPIX"
[Manpage - dd]: (http://man7.org/linux/man-pages/man1/dd.1.html) "Manpage - dd"
[Tuning dd block size]: {{ page.featured_image.url }} {{ page.featured_image.title }}
[Wikipedia - dd - Block Size]: https://en.wikipedia.org/wiki/Dd_(Unix)#Block_size "Wikipedia - dd - Block Size"
[YouTube - Mongo DB Is Web Scale]: https://www.youtube.com/watch?v=b2F-DItXtZs&t=1m42s "YouTube - Mongo DB Is Web Scale"
