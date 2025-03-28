
NETPGPVERIFY_SOURCES += external/netpgpverify/files/b64.c external/netpgpverify/files/bignum.c external/netpgpverify/files/bufgap.c external/netpgpverify/files/digest.c
NETPGPVERIFY_SOURCES += external/netpgpverify/files/libverify.c external/netpgpverify/files/misc.c
NETPGPVERIFY_SOURCES += external/netpgpverify/files/pgpsum.c external/netpgpverify/files/rsa.c
NETPGPVERIFY_SOURCES += external/netpgpverify/files/bzlib.c external/netpgpverify/files/zlib.c
NETPGPVERIFY_SOURCES += external/netpgpverify/files/sha1.c external/netpgpverify/files/sha2.c external/netpgpverify/files/md5c.c external/netpgpverify/files/rmd160.c

SOURCES += main.cpp
SOURCES += $(NETPGPVERIFY_SOURCES)

INCFLAGS += -Iexternal/netpgpverify/files

LDLIBS += -lws2_32

PROJECT_BASENAME = krpgp

RC_DESC ?= PGP interface for TVP(KIRIKIRI) (2/Z)
RC_PRODUCTNAME ?= PGP interface for TVP(KIRIKIRI) (2/Z)
RC_LEGALCOPYRIGHT ?= Copyright (C) 2019-2019 Julian Uy; This product is licensed under the MIT license.

include external/ncbind/Rules.lib.make
