package com.fineshambles.prechacthis;

import java.util.Locale;

public class Toss {

	private Rational height;
	private int pass;

	public Toss(Rational height, int pass) {
		this.height = height;
		this.pass = pass;
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

}
