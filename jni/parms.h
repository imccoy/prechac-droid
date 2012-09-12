#ifndef PLHOME
#define PLHOME       "/usr/local/lib/swipl-6.2.1"
#endif
#ifndef DEFSTARTUP
#define DEFSTARTUP   ".plrc"
#endif
#define PLVERSION 60201
#ifndef PLARCH
#define PLARCH	    "i386-darwin10.8.0"
#endif
#define C_LIBS	    ""
#define C_PLLIB	    "-lswipl"
#define C_LIBPLSO    "-lswipl"
#ifndef C_CC
#define C_CC	    "gcc"
#endif
#ifndef C_CFLAGS
#define C_CFLAGS	    "-fno-strict-aliasing -no-cpp-precomp -pthread -fno-common "
#endif
#ifndef C_LDFLAGS
#define C_LDFLAGS    "-O2 -pthread  "
#endif
