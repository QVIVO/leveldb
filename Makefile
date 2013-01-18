# Copyright (c) 2011 The LevelDB Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file. See the AUTHORS file for names of contributors.

PROJ=leveldb

ifeq ($(IOS), 1)
	ARCH=armv7
	DEVICE=OS
	CC_FLAGS=-arch $(ARCH)
	CFLAGS_FLAGS=-mcpu=cortex-a8 -marm
else
ifeq ($(IOS), 2)
	ARCH=armv7s
	DEVICE=OS
	CC_FLAGS=-arch $(ARCH)
	CFLAGS_FLAGS=-mcpu=cortex-a8 -marm
else
	ARCH=i386
	DEVICE=Simulator
	CC_FLAGS=-arch $(ARCH)
endif
endif

# Uncomment one of the following to switch between debug and opt mode
#OPT = -O2 -DNDEBUG
OPT = -g2

SDK=6.0
DEVROOT=`xcode-select -print-path`/Platforms/iPhone$(DEVICE).platform/Developer
SDKROOT=${DEVROOT}/SDKs/iPhone$(DEVICE)$(SDK).sdk

CC=$(DEVROOT)/usr/bin/g++ $(CC_FLAGS)
LD=$(CC)
CFLAGS=-isysroot ${SDKROOT} -c -DLEVELDB_PLATFORM_OSX -I. -I./include $(CFLAGS_FLAGS) -fvisibility=hidden $(OPT)
LDFLAGS=-isysroot ${SDKROOT}

#LDFLAGS=-isysroot ${SDKROOT} -W1, -syslibroot ${SDKROOT}

#### OSX #####

#CFLAGS = -c -DLEVELDB_PLATFORM_OSX -I. -I./include $(OPT)
#LDFLAGS=-lpthread
#CC = g++

##############

# Replace port_posix.o with port_osx.o below to build on
# OS X.

LIBOBJECTS = \
	./db/builder.o \
	./db/db_impl.o \
	./db/db_iter.o \
	./db/filename.o \
	./db/dbformat.o \
	./db/log_reader.o \
	./db/log_writer.o \
	./db/memtable.o \
	./db/repair.o \
	./db/table_cache.o \
	./db/version_edit.o \
	./db/version_set.o \
	./db/write_batch.o \
	./port/port_osx.o \
	./table/block.o \
	./table/block_builder.o \
	./table/format.o \
	./table/iterator.o \
	./table/merger.o \
	./table/table.o \
	./table/table_builder.o \
	./table/two_level_iterator.o \
	./util/arena.o \
	./util/cache.o \
	./util/coding.o \
	./util/comparator.o \
	./util/crc32c.o \
	./util/env.o \
	./util/env_posix.o \
	./util/hash.o \
	./util/histogram.o \
	./util/logging.o \
	./util/options.o \
	./util/status.o

TESTUTIL = ./util/testutil.o
TESTHARNESS = ./util/testharness.o $(TESTUTIL)

TESTS = \
	arena_test \
	cache_test \
	coding_test \
	corruption_test \
	crc32c_test \
	db_test \
	dbformat_test \
	env_test \
	filename_test \
	log_test \
	skiplist_test \
	table_test \
	version_edit_test \
	write_batch_test

PROGRAMS = db_bench $(TESTS)

all: $(PROGRAMS)

check: $(TESTS)
	for t in $(TESTS); do echo "***** Running $$t"; ./$$t || exit 1; done

clean:
	rm -f $(PROGRAMS) */*.o

db_bench: db/db_bench.o $(LIBOBJECTS) $(TESTUTIL)
	$(CC) $(LDFLAGS) db/db_bench.o $(LIBOBJECTS) $(TESTUTIL) -o $@

arena_test: util/arena_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) util/arena_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

cache_test: util/cache_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) util/cache_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

coding_test: util/coding_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) util/coding_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

corruption_test: db/corruption_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) db/corruption_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

crc32c_test: util/crc32c_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) util/crc32c_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

db_test: db/db_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) db/db_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

dbformat_test: db/dbformat_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) db/dbformat_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

env_test: util/env_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) util/env_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

filename_test: db/filename_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) db/filename_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

log_test: db/log_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) db/log_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

table_test: table/table_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) table/table_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

skiplist_test: db/skiplist_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) db/skiplist_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

version_edit_test: db/version_edit_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) db/version_edit_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

write_batch_test: db/write_batch_test.o $(LIBOBJECTS) $(TESTHARNESS)
	$(CC) $(LDFLAGS) db/write_batch_test.o $(LIBOBJECTS) $(TESTHARNESS) -o $@

library: $(LIBOBJECTS) 
	ar rcs $(ARCH)-lib$(PROJ).a $(LIBOBJECTS)

lipo:
	lipo -create -arch armv7 armv7-lib$(PROJ).a -arch i386 i386-lib$(PROJ).a -arch armv7 armv7s-lib$(PROJ).a -output lib$(PROJ).a


.cc.o:
	$(CC) $(CFLAGS) $< -o $@

# TODO(gabor): dependencies for .o files
# TODO(gabor): Build library
