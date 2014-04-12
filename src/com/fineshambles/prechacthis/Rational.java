package com.fineshambles.prechacthis;

import java.math.BigInteger;
import java.util.Locale;

public class Rational {

	private int num;
	private int den;

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
	
}
