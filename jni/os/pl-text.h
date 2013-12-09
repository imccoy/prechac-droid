/*  $Id$

    Part of SWI-Prolog

    Author:        Jan Wielemaker and Anjo Anjewierden
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

#ifndef PL_TEXT_H_INCLUDED
#define PL_TEXT_H_INCLUDED

typedef enum
{ PL_CHARS_MALLOC,			/* malloced data */
  PL_CHARS_RING,			/* stored in the buffer ring */
  PL_CHARS_HEAP,			/* stored in program area (atoms) */
  PL_CHARS_STACK,			/* stored on the global stack */
  PL_CHARS_LOCAL			/* stored in in-line buffer */
} PL_chars_alloc_t;


typedef struct
{ union
  { char *t;				/* tranditional 8-bit char* */
    pl_wchar_t *w;			/* wide character string */
  } text;
  size_t length;
					/* private stuff */
  IOENC encoding;			/* how it is encoded */
  PL_chars_alloc_t storage;		/* how it is stored */
  int canonical;			/* TRUE: ENC_ISO_LATIN_1 or ENC_WCHAR */
  char buf[100];			/* buffer for simple stuff */
} PL_chars_t;

#define PL_init_text(txt) \
	{ (txt)->text.t    = NULL; \
	  (txt)->encoding  = ENC_UNKNOWN; \
	  (txt)->storage   = PL_CHARS_LOCAL; \
	  (txt)->canonical = FALSE; \
	}

int	PL_unify_text(term_t term, term_t tail, PL_chars_t *text, int type);
int	PL_unify_text_range(term_t term, PL_chars_t *text,
			    size_t from, size_t len, int type);

int	PL_promote_text(PL_chars_t *text);
int	PL_demote_text(PL_chars_t *text);
int	PL_mb_text(PL_chars_t *text, int flags);
int	PL_canonicalise_text(PL_chars_t *text);

int	PL_cmp_text(PL_chars_t *t1, size_t o1, PL_chars_t *t2, size_t o2,
		    size_t len);
int	PL_concat_text(int n, PL_chars_t **text, PL_chars_t *result);

void	PL_free_text(PL_chars_t *text);
void	PL_save_text(PL_chars_t *text, int flags);

COMMON(int)		PL_get_text__LD(term_t l, PL_chars_t *text, int flags ARG_LD);
COMMON(atom_t)		textToAtom(PL_chars_t *text);

COMMON(IOSTREAM *)	Sopen_text(PL_chars_t *text, const char *mode);
COMMON(void)		PL_text_recode(PL_chars_t *text, IOENC encoding);

					/* pl-fli.c */
COMMON(int)		get_atom_ptr_text(Atom atom, PL_chars_t *text);
COMMON(int)		get_atom_text(atom_t atom, PL_chars_t *text);
COMMON(int)		get_string_text(atom_t atom, PL_chars_t *text ARG_LD);

static inline int
text_get_char(const PL_chars_t *t, size_t i)
{ assert(t->canonical);
  return t->encoding == ENC_ISO_LATIN_1 ? t->text.t[i]&0xff
					: t->text.w[i];
}

#endif /*PL_TEXT_H_INCLUDED*/
