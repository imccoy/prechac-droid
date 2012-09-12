/*  $Id$

    Part of SWI-Prolog

    Author:        Jan Wielemaker
    E-mail:        jan@swi.psy.uva.nl
    WWW:           http://www.swi-prolog.org
    Copyright (C): 1985-2002, University of Amsterdam

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
This little module is included into   pl-save.c if FORCED_MALLOC_BASE is
defined. It requires the GNU implementation   of malloc() and friends, a
mmap() that handles MAP_ANON  (can  be  changed)   and  can  map  at the
addresses normally used at the target machine.  I think this module will
only work if you run Linux :-)  It   is  implemented to debug the win32s
version, allocating from 0x80000000L.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>
extern int getpagesize(void);		/* no prototype */

#if 0					/* include if not defined (old libc) */
extern void * (*__morecore)(intptr_t size);
#endif

static void *base;			/* base */
static void *top;			/* external top */
static void *atop;			/* allocated top */
static int  pagsize;

#ifndef roundup
#define roundup(p, n) (((p)+(n)-1 / (n)) * (n))
#endif

#if !defined(MAP_ANON) && defined(MAP_ANONYMOUS)
#define MAP_ANON MAP_ANONYMOUS
#endif

#define get_map_fd() (-1)
#define STACK_MAP_TYPE MAP_ANON|MAP_PRIVATE|MAP_FIXED

void *
mycore(intptr_t size)			/* similar to sbrk() */
{ void *mem = top;

  if ( top + size >= atop )
  { void *ntop = (void *)roundup((uintptr_t) top + size, pagsize);
    if ( mmap(atop, ntop - atop,
	      PROT_READ|PROT_WRITE, STACK_MAP_TYPE, -1, 0L) != atop )
    { fprintf(stderr, "mycore(): %s\n", strerror(errno));
      return NULL;
    }

    atop = ntop;
  }

  top = top + size;

  return mem;
}


void
start_memory(void * address)
{ pagsize    = getpagesize();

  base       = (void *)roundup((uintptr_t) address, pagsize);
  top	     = base;
  atop	     = base;
  __morecore = mycore;
}

#ifdef TEST

#ifndef HAVE_STRTOUL
uintptr_t
strtoul(const char *s, char **eptr, int base)
{ static unsigned char xmap[256];
  static int xmap_initialised = 0;
  uintptr_t val;

  if ( !xmap_initialised )
  { int n;

    xmap_initialised++;
    for(n=0; n<256; n++)
      xmap[n] = 0xff;
    for(n='0'; n<='9'; n++)
      xmap[n] = n - '0';
    for(n='a'; n<='z'; n++)
      xmap[n] = n - 'a' + 10;
    for(n='A'; n<='Z'; n++)
      xmap[n] = n - 'A' + 10;
  }

  if ( s[0] == '0' && (s[1] == 'x' || s[1] == 'X') )
    s += 2;

  for(val = 0; *s; s++)
  { uintptr_t dval = xmap[*s];

    if ( dval < (unsigned) base )
      val = val * base + dval;
    else
    { if ( eptr )
	*eptr = (char *)s;
    }
  }

  return val;
}
#endif


main(int argc, char **argv)
{ static int testvals[] = { 1, 1000, 10000, 100000, -1 };
  int *tv = testvals;
  uintptr_t base = 0x40000000L;

  if ( argc == 2 )
    base = strtoul(argv[1], NULL, 16);

  start_memory((void *)base);

  for(; *tv != -1; tv++)
  { char *rval = malloc(*tv);

    printf("malloc(%-6d) --> 0x%08x\n", *tv, rval);
    memset(rval, 0xbf, *tv);
  }

  return 0;
}

#endif
