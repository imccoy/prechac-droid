/*  $Id$

    Part of SWI-Prolog

    Author:        Jan Wielemaker
    E-mail:        wielemak@science.uva.nl
    WWW:           http://www.swi-prolog.org
    Copyright (C): 1985-2006, University of Amsterdam

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

#include "pl-incl.h"
#include "os/pl-ctype.h"

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Strings are supposed to be meant identical iff one of the  following  is
the case:

  - They ARE identical
  - One character is different			(spy == spu)
  - One character is inserted/deleted/added	(debug == deug)
  - Two adjecent characters are transposed	(trace == tarce)
  - `Sub-words' have been separated wrong	(aB == a_b == ab)
  - Two `Sub-words' have been transposed	(exists_file == file_exists)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

static bool
oneTypo(const char *s1, const char *s2)
{ if (s1[1] == EOS || streq(&s1[1], &s2[1]) )
    succeed;
  fail;
}

static bool
twoTransposed(const char *s1, const char *s2)
{ if (s1[1] != EOS && s1[0] == s2[1] && s1[1] == s2[0] &&
       (s1[2] == EOS || streq(&s1[2], &s2[2])))
    succeed;
  fail;
}

static bool
oneInserted(const char *s1, const char *s2)
{ if (streq(s1, &s2[1]) )
    succeed;
  fail;
}

static bool
differentSeparated(const char *s1, const char *s2)
{ int c1, c2;

  if ( *s1 != *s2 || *s1 == EOS )
    fail;

  c1 = *++s1, c2 = *++s2;
  while(c1 && c1 == c2)
  { if ((c1 = *++s1) == '_')
    { c1 = *++s1;
    } else
    { if (isLower(s1[-1]) && isUpper(c1))
        c1 = makeLower(c1);
    }
    if ((c2 = *++s2) == '_')
    { c2 = *++s2;
    } else
    { if (isLower(s2[-1]) && isUpper(c2))
	c2 = makeLower(c2);
    }
  }
  if (c1 == EOS && c2 == EOS)
    succeed;
  fail;
}

static const char *
subWord(const char *s, char *store)
{ *store++ = makeLower(*s);
  s++;

  for(;;)
  { if (*s == EOS)
    { *store = EOS;
      return s;
    }
    if (*s == '_')
    { *store = EOS;
      return ++s;
    }
    if (isLower(s[-1]) && isUpper(s[0]) )
    { *store = EOS;
      return s;
    }
    *store++ = *s++;
  }
}

static bool
subwordsTransposed(const char *s1, const char *s2)
{ char sw1a[1024], sw1b[1024];
  char sw2a[1024], sw2b[1024];

  while(*s1 && *s2)
  { s1 = subWord(s1, sw1a);
    s2 = subWord(s2, sw2a);
    if (!streq(sw1a, sw2a) )
    { if (*s1 == EOS || *s2 == EOS)
	fail;
      s1 = subWord(s1, sw1b);
      s2 = subWord(s2, sw2b);
      if (!streq(sw1a, sw2b) || !streq(sw1b, sw2a) )
	fail;
    }
  }
  if (*s1 == EOS && *s2 == EOS)
    succeed;
  fail;
}


static atom_t
dwimMatch(const char *str1, const char *str2)
{ int cl=0, l1, l2;
  const char *s1 = str1;
  const char *s2 = str2;

  while(*s1 && *s1 == *s2)			/* delete common part */
    s1++, s2++, cl++;
  l2 = (int) strlen(s2);
  l1 = (int) strlen(s1);

  if (abs(l1-l2) > 5)				/* speed up a bit */
    fail;

  if ( l1 == 0 && l2 == 0 )			return ATOM_equal;
  if ( cl + l1 < 3 || cl + l2 < 3 )
    fail;
  if ( l1 == l2 && oneTypo(s1, s2) )		return ATOM_mismatched_char;
  if ( l1 == l2 && twoTransposed(s1, s2) )	return ATOM_transposed_char;
  if ( (l2 == l1 + 1 && oneInserted(s1, s2)) ||
       (l1 == l2 + 1 && oneInserted(s2, s1)) )	return ATOM_inserted_char;
  if ( differentSeparated(str1, str2) )		return ATOM_separated;
  if ( subwordsTransposed(str1, str2) )		return ATOM_transposed_word;

  fail;
}


		/********************************
		*       PROLOG CONNECTION       *
		*********************************/

word
pl_dwim_match(term_t a1, term_t a2, term_t mm)
{ GET_LD
  char *s1, *s2;
  atom_t type;

  if ( PL_get_chars(a1, &s1, CVT_ALL|BUF_RING) &&
       PL_get_chars(a2, &s2, CVT_ALL|BUF_RING) &&
       (type = dwimMatch(s1, s2)) &&
       PL_unify_atom(mm, type) )
    succeed;

  fail;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$dwim_predicate(+Term, -Dwim) successively returns all predicates of the
specified module or context module  that  match  in  a  DWIM  sence  the
predicate head.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

word
pl_dwim_predicate(term_t pred, term_t dwim, control_t h)
{ GET_LD
  functor_t fdef;
  Module module = (Module) NULL;
  Procedure proc;
  Symbol symb;
  term_t head = PL_new_term_ref();
  TableEnum e;

  if ( ForeignControl(h) == FRG_CUTTED )
  { e = ForeignContextPtr(h);
    freeTableEnum(e);
    succeed;
  }

  if ( !PL_strip_module(pred, &module, head) )
    fail;
  if ( !PL_get_functor(head, &fdef) )
    fail;				/* silent: leave errors for later */

  if ( ForeignControl(h) == FRG_FIRST_CALL )
    e = newTableEnum(module->procedures);
  else
    e = ForeignContextPtr(h);

  while( (symb = advanceTableEnum(e)) )
  { Definition def;
    char *name;

    proc = symb->value;
    def  = proc->definition;
    name = stringAtom(def->functor->name);

    if ( dwimMatch(stringAtom(nameFunctor(fdef)), name) &&
         isDefinedProcedure(proc) &&
         (name[0] != '$' || SYSTEM_MODE) )
    { if ( !PL_unify_functor(dwim, def->functor->functor) )
	continue;

      ForeignRedoPtr(e);
    }
  }

  freeTableEnum(e);
  fail;
}
