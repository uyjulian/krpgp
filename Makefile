#############################################
##                                         ##
##    Copyright (C) 2019-2019 Julian Uy    ##
##  https://sites.google.com/site/awertyb  ##
##                                         ##
##   See details of license at "LICENSE"   ##
##                                         ##
#############################################

CC = i686-w64-mingw32-gcc
CXX = i686-w64-mingw32-g++
WINDRES := i686-w64-mingw32-windres
GIT_TAG := $(shell git describe --abbrev=0 --tags)
INCFLAGS += -I. -I.. -I../ncbind -Iexternal/netpgpverify/files
ALLSRCFLAGS += $(INCFLAGS) -DGIT_TAG=\"$(GIT_TAG)\"
CFLAGS += -O2 -flto
CFLAGS += $(ALLSRCFLAGS) -Wall -Wno-unused-value -Wno-format -DNDEBUG -DWIN32 -D_WIN32 -D_WINDOWS 
CFLAGS += -D_USRDLL -DMINGW_HAS_SECURE_API -DUNICODE -D_UNICODE -DNO_STRICT -D_GNU_SOURCE
CXXFLAGS += $(CFLAGS) -fpermissive
WINDRESFLAGS += $(ALLSRCFLAGS) --codepage=65001
LDFLAGS += -static -static-libstdc++ -static-libgcc -shared -Wl,--kill-at
LDLIBS += -lws2_32

%.o: %.c
	@printf '\t%s %s\n' CC $<
	$(CC) -c $(CFLAGS) -o $@ $<

%.o: %.cpp
	@printf '\t%s %s\n' CXX $<
	$(CXX) -c $(CXXFLAGS) -o $@ $<

%.o: %.rc
	@printf '\t%s %s\n' WINDRES $<
	$(WINDRES) $(WINDRESFLAGS) $< $@

DLL_SOURCES := ../tp_stub.cpp ../ncbind/ncbind.cpp main.cpp krpgp.rc
NETPGPVERIFY_SOURCES := 
NETPGPVERIFY_SOURCES += external/netpgpverify/files/b64.c external/netpgpverify/files/bignum.c external/netpgpverify/files/bufgap.c external/netpgpverify/files/digest.c
NETPGPVERIFY_SOURCES += external/netpgpverify/files/libverify.c external/netpgpverify/files/misc.c
NETPGPVERIFY_SOURCES += external/netpgpverify/files/pgpsum.c external/netpgpverify/files/rsa.c
NETPGPVERIFY_SOURCES += external/netpgpverify/files/bzlib.c external/netpgpverify/files/zlib.c
NETPGPVERIFY_SOURCES += external/netpgpverify/files/sha1.c external/netpgpverify/files/sha2.c external/netpgpverify/files/md5c.c external/netpgpverify/files/rmd160.c

SOURCES := $(DLL_SOURCES) $(NETPGPVERIFY_SOURCES)
OBJECTS := $(SOURCES:.c=.o)
OBJECTS := $(OBJECTS:.cpp=.o)
OBJECTS := $(OBJECTS:.rc=.o)

BINARY ?= krpgp.dll
ARCHIVE ?= krpgp.$(GIT_TAG).7z

all: $(BINARY)

archive: $(ARCHIVE)

clean:
	rm -f $(OBJECTS) $(BINARY) $(ARCHIVE)

$(ARCHIVE): $(BINARY)
	rm -f $(ARCHIVE)
	7z a $@ $^

$(BINARY): $(OBJECTS) 
	@printf '\t%s %s\n' LNK $@
	$(CXX) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
