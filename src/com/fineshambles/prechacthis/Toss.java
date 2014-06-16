package com.fineshambles.prechacthis;

import java.util.Locale;

public class Toss {

	private Rational height;
	private int pass;
	private int siteswap;

	public Toss(Rational height, int pass, int siteswap) {
		this.height = height;
		this.pass = pass;
		this.siteswap = siteswap;
	}
	
	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Toss))
			return false;
		Toss t = (Toss)o;
		return (t.height.equals(height) && t.pass == pass);
	}
	
	public String toString() {
		String heightString = "" + height;
		String pString = pass == 0 ? "" : "p";
		return heightString + pString;
	}
	
	public Rational getHeight() {
		return height;
	}

	public int getPass() {
		return pass;
	}

	public int getSiteswap() {
		return siteswap;
	}

}
