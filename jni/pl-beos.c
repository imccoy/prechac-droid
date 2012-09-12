/*  $Id$

    Part of SWI-Prolog

    Author:        Alex D�rfler
    E-mail:        axeld@pinc-software.de
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
This module is  written  by   Alex  D�rfler,  axeld@pinc-software.de and
integrated into SWI-Prolog by Jan Wielemaker.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

#ifdef __BEOS__
#include "pl-incl.h"


		 /*******************************
		 *	DLOPEN AND FRIENDS	*
		 *******************************/

#ifdef EMULATE_DLOPEN

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
These functions emulate the bits from the ELF shared object interface we
need. They are used  by  pl-load.c,   which  defines  the  actual Prolog
interface.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

void *
dlopen(const char *file, int flags)
{ image_id image = load_add_on(file);

  if ( image < B_OK )
  { LD->os.dl_error = image;
    return NULL;
  }

  LD->os.dl_error = B_OK;
  return (void *)image;
}


const char *
dlerror()
{ return strerror(LD->os.dl_error);
}


void *
dlsym(void *handle, char *symbol)
{ void *address;

  LD->os.dl_error = get_image_symbol((image_id)handle,
				     symbol,
				     B_SYMBOL_TYPE_TEXT,
				     &address);
  if ( LD->os.dl_error == B_OK )
    return address;

  return NULL;
}


int
dlclose(void *handle)
{ return unload_add_on((image_id)handle);
}

#endif	/* EMULATE_DLOPEN */

#endif	/* __BEOS__ */
