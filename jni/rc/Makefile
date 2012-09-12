################################################################
# Makefile for the SWI-Prolog resource database
#
# Author: Jan Wielemaker
# E-mail: J.Wielemaker@cs.vu.nl
#
# Copying: LGPL-2
#
# Copyright (c) 1996-2010, University of Amsterdam
# ###############################################################

prefix=/usr/local
exec_prefix=${prefix}
srcdir=.
vpath %.c .
bindir=$(exec_prefix)/bin
PLBASE=${exec_prefix}/lib/swipl-$(PLVERSION)
man_prefix=$(prefix)/man
mansec=1
lmansec=3
mandir=$(man_prefix)/man$(mansec)
lmandir=$(man_prefix)/man$(lmansec)
plmandir=$(PLBASE)/man

CC=gcc
EXEEXT = 
AR=ar
RANLIB=ranlib
PLARCH=i386-darwin10.8.0
COFLAGS=-O2
CWFLAGS=-Wall
CIFLAGS=
CMFLAGS=-fno-strict-aliasing -no-cpp-precomp -pthread -fno-common
CPFLAGS=
LDFLAGS=-O2 $(CPFLAGS)
CFLAGS=	$(CWFLAGS) $(COFLAGS) $(CIFLAGS) $(CMFLAGS) $(CPFLAGS)

INSTALL=/usr/bin/install -c
INSTALL_PROGRAM=${INSTALL}
INSTALL_DATA=${INSTALL} -m 644

MINGW=false
ifeq ($(MINGW),true)
UXNTLIB=../../lib/$(PLARCH)/libuxnt.a
else
UXNTLIB=
endif

LIBOBJ=	html.o access.o build.o util.o

all:	swipl-rc$(EXEEXT)

swipl-rc$(EXEEXT):	librc.a rc.o
	$(CC) $(LDFLAGS) -o $@ rc.o $(UXNTLIB) -L. -lrc

librc.a:	$(LIBOBJ)
	rm -f $@
	$(AR) cq $@ $(LIBOBJ)
	$(RANLIB) $@

.c.o:
	$(CC) -c -I.. $(CFLAGS) $< -o $@

################################################################
# Documentation
################################################################

html:	rc.tex
	latex2html rc

dvi:	rc.dvi

rc.dvi:	rc.tex
	./latex_if_needed rc

rc.tex:	rc.doc
	../xpce/bin/doc2tex rc.doc > rc.tex

################################################################
# Cleanup
################################################################

clean:
	rm -f *% *~ $(LIBOBJ) rc.o

profclean:
	rm -f *.gcda

distclean: clean profclean
	rm -f Makefile
	rm -f swipl-rc librc.a

