//tabstop=4
//*****************************************************************************/
// Project: jpl
//
// File:    $Id$
// Date:    $Date$
// Author:  Fred Dushin <fadushin@syr.edu>
//          
//
// Description:
//    
//
// -------------------------------------------------------------------------
// Copyright (c) 2004 Paul Singleton
// Copyright (c) 1998 Fred Dushin
//                    All rights reserved.
// 
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Library Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Library Public License for more details.
//*****************************************************************************/
package jpl;

import java.util.Map;
import jpl.fli.Int64Holder;
import jpl.fli.Prolog;
import jpl.fli.term_t;

//----------------------------------------------------------------------/
// Integer
/**
 * Integer is a specialised Term with a long field, representing a Prolog integer value.
 * <pre>
 * Integer i = new Integer(1024);
 * </pre>
 * Once constructed, the value of an Integer instance cannot be altered.
 * An Integer can be used (and re-used) as an argument of Compounds.
 * Beware confusing jpl.Integer with java.lang.Integer.
 * 
 * <hr><i>
 * Copyright (C) 2004  Paul Singleton<p>
 * Copyright (C) 1998  Fred Dushin<p>
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.<p>
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library Public License for more details.<p>
 * </i><hr>
 * @author  Fred Dushin <fadushin@syr.edu>
 * @version $Revision$
 * @see jpl.Term
 * @see jpl.Compound
 */
public class Integer extends Term {

	//==================================================================/
	//  Attributes
	//==================================================================/

	/**
	 * the Integer's immutable long value
	 */
	protected final long value;

	//==================================================================/
	//  Constructors
	//==================================================================/

	/**
	 * @param   value  This Integer's (long) value
	 */
	public Integer(long value) {
		this.value = value;
	}

	//==================================================================/
	//  Methods (common)
	//==================================================================/

	/**
	 * The (nonexistent) ano-th arg of this Integer
	 * 
	 * @return the (nonexistent) ano-th arg of this Integer
	 */
	public Term arg(int ano) {
		throw new JPLException("jpl." + this.typeName() + ".arg() is undefined");
	}

	/**
	 * The (nonexistent) args of this Integer
	 * 
	 * @return the (nonexistent) args of this Integer
	 */
	public Term[] args() {
		return new Term[] {
		};
	}

	/**
	 * Tests whether this Integer's functor has (int) 'name' and 'arity' (c.f. functor/3)
	 * 
	 * @return whether this Integer's functor has (int) 'name' and 'arity'
	 */
	public final boolean hasFunctor(int val, int arity) {
		return val == this.value && arity == 0;
	}

	/**
	 * Tests whether this Integer's functor has (String) 'name' and 'arity' (c.f. functor/3)
	 * 
	 * @return whether this Integer's functor has (String) 'name' and 'arity'
	 */
	public boolean hasFunctor(String name, int arity) {
		return false;
	}

	/**
	 * Tests whether this Integer's functor has (double) 'name' and 'arity' (c.f. functor/3)
	 * 
	 * @return whether this Integer's functor has (double) 'name' and 'arity'
	 */
	public boolean hasFunctor(double value, int arity) {
		return false;
	}

	/**
	 * throws a JPLException (name() is defined only for Compound, Atom and Variable)
	 * 
	 * @return the name of this Integer (never)
	 */
	public final String name() {
		throw new JPLException("jpl.Integer#name() is undefined");
	}

	/**
	 * Returns the arity (0) of this jpl.Integer (c.f. functor/3)
	 * 
	 * @return the arity (0) of this jpl.Integer
	 */
	public final int arity() {
		return 0;
	}

	/**
	 * Returns the value of this Integer as an int if possible, else throws a JPLException
	 * 
	 * @throws JPLException if the value of this Integer is too great to be represented as a Java int
	 * @return the int value of this Integer
	 */
	public final int intValue() {
		if (value < java.lang.Integer.MIN_VALUE || value > java.lang.Integer.MAX_VALUE) {
			throw new JPLException("cannot represent Integer value as an int");
		} else {
			return (int) value;
		}
	}

	/**
	 * Returns the value of this Integer as a long
	 * 
	 * @return the value of this Integer as a long
	 */
	public final long longValue() {
		return value;
	}

	/**
	 * Returns the value of this Integer converted to a float
	 * 
	 * @return the value of this Integer converted to a float
	 */
	public final float floatValue() {
		return (new java.lang.Long(value)).floatValue(); // safe but inefficient...
	}

	/**
	 * Returns the value of this Integer converted to a double
	 * 
	 * @return the value of this Integer converted to a double
	 */
	public final double doubleValue() {
		return (new java.lang.Long(value)).doubleValue(); // safe but inefficient...
	}

	public final int type() {
		return Prolog.INTEGER;
	}

	public String typeName(){
		return "Integer";
	}
	
	/**
	 * Returns a Prolog source text representation of this Integer's value
	 * 
	 * @return  a Prolog source text representation of this Integer's value
	 */
	public String toString() {
		return "" + value; // hopefully invokes Integer.toString() or equivalent
	}

	/**
	 * Two Integer instances are equal if they are the same object, or if their values are equal
	 * 
	 * @param   obj  The Object to compare (not necessarily an Integer)
	 * @return  true if the Object satisfies the above condition
	 */
	public final boolean equals(Object obj) {
		return this == obj || (obj instanceof Integer && value == ((Integer) obj).value);
	}

	//==================================================================/
	//  Methods (deprecated)
	//==================================================================/

	/**
	 * Returns the int value of this jpl.Integer
	 * 
	 * @return the Integer's value
	 * @deprecated
	 */
	public final int value() {
		return (int) value;
	}

	/**
	 * Returns a debug-friendly representation of this Integer's value
	 * 
	 * @return  a debug-friendly representation of this Integer's value
	 * @deprecated
	 */
	public String debugString() {
		return "(Integer " + toString() + ")";
	}

	//==================================================================/
	//  Converting JPL Terms to Prolog terms
	//==================================================================/

	/**
	 * To convert an Integer into a Prolog term, we put its value into the term_t.
	 * 
	 * @param   varnames_to_vars  A Map from variable names to Prolog variables.
	 * @param   term              A (previously created) term_t which is to be
	 *                            set to a Prolog integer
	 */
	protected final void put(Map varnames_to_vars, term_t term) {
		Prolog.put_integer(term, value);
	}

	//==================================================================/
	//  Converting Prolog terms to JPL Terms
	//==================================================================/

	/**
	 * Converts a Prolog term (known to be an integer) to a new Integer instance.
	 *
	 * @param   vars_to_Vars  A Map from Prolog variables to JPL Variables
	 * @param   term          The Prolog term (an integer) which is to be converted
	 * @return                A new Integer instance
	 */
	protected static Term getTerm1(Map vars_to_Vars, term_t term) {
		Int64Holder int64_holder = new Int64Holder();

		Prolog.get_integer(term, int64_holder); // assume it succeeds...
		return new jpl.Integer(int64_holder.value);
	}

	//==================================================================/
	//  Computing Substitutions
	//==================================================================/

	/**
	 * Nothing needs to be done if the Term is an Atom, Integer or Float
	 * 
	 * @param   varnames_to_Terms  A Map from variable names to Terms.
	 * @param   vars_to_Vars       A Map from Prolog variables to JPL Variables.
	 */
	protected final void getSubst(Map varnames_to_Terms, Map vars_to_Vars) {
	}

	public Object jrefToObject() {
		throw new JPLException("Integer.jrefToObject(): term is not a jref");
	}

}

//345678901234567890123456789012346578901234567890123456789012345678901234567890
