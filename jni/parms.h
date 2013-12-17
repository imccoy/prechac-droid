#ifndef PLHOME
#define PLHOME       "/usr/local/lib/swipl-32-6.6.0"
#endif
#ifndef DEFSTARTUP
#define DEFSTARTUP   ".plrc"
#endif
#define PLVERSION 60600
#ifndef PLARCH
#define PLARCH	    "i386-none"
#endif
#define C_LIBS	    "-lncurses -lm -ldl "
#define C_PLLIB	    "-lswipl"
#define C_LIBPLSO    "-lswipl"
#ifndef C_CC
#define C_CC	    "gcc"
#endif
#ifndef C_CFLAGS
#define C_CFLAGS	    "-fno-strict-aliasing -pthread -march=i386 -m32"
#endif
#ifndef C_LDFLAGS
#define C_LDFLAGS    "-rdynamic -m32 -pthread "
#endif
