package com.fineshambles.prechacthis;

import java.math.BigInteger;
import java.util.Comparator;
import java.util.Locale;

public class Rational {

	private int num;
	private int den;
	
	public static final Comparator<Rational> COMPARATOR = new Comparator<Rational>() {

		@Override
		public int compare(Rational lhs, Rational rhs) {
			int a = lhs.num * rhs.den;
			int b = rhs.num * lhs.den;
			if (a < b) return -1;
			if (a > b) return 1;
			else return 0;
		}
	};
	public static final Rational ZERO = new Rational(0, 1);
	public static final Rational ONE = new Rational(1,1);

	public Rational(int num, int den) {
		this.num = num;
		this.den = den;
	}
	
	@Override
	public boolean equals(Object o) {
		
		if (!(o instanceof Rational))
			return false;
		
		Rational r = ((Rational)o).simplify();
		Rational a = simplify();
		return (r.num == a.num && r.den == a.den);
	}

	private Rational simplify() {
		BigInteger a = BigInteger.valueOf(num);
		BigInteger b = BigInteger.valueOf(den);
		int gcd = a.gcd(b).intValue();
		return new Rational(num / gcd, den / gcd);
	}
	
	@Override
	public String toString() {
		Rational simple = simplify();
		if (simple.den == 1)
			return "" + simple.num;
		String s = String.format(Locale.US, "%.2f", Math.floor((float)simple.num / (float)simple.den * 100) / 100);
		char lastDigit = s.charAt(s.length() - 1);
		if (lastDigit == '0')
			return s.substring(0,s.length() - 1); // drop the last digit
		else
			return s;
	}

	public int getNumerator() {
		return num;
	}

	public int getDenominator() {
		return den;
	}

	public Rational times(int num) {
		return this.times(new Rational(num, 1));
	}

	public Rational times(Rational r) {
		return (new Rational(r.num * num, r.den * den)).simplify();
	}
	
	public Rational plus(int num) {
		return this.plus(new Rational(num, 1));
	}
	
	public Rational plus(Rational r) {
		return  (new Rational(r.num * den + num * r.den, den * r.den)).simplify();
	}

	public Rational fractionalPart() {
		return new Rational(num % den, den);
	}

	public int truncate() {
		return num / den;
	}

	public Rational minus(int r) {
		return this.plus(-r);
	}
	
	public Rational minus(Rational r) {
		return this.plus(negate(r));
	}

	private Rational negate(Rational r) {
		return new Rational(-r.num, r.den);
	}

	public Rational mod(int n) {
		// what does modulus even mean for rational numbers?
		Rational current = this;
		Rational next = null;
		Rational zero = new Rational(0,1);
		while (true) {
			next = current.minus(n);
			if (COMPARATOR.compare(next, zero) < 0) {
				return current;
			}
		}
	}

	public boolean isZero() {
		return num == 0;
	}
	
}
