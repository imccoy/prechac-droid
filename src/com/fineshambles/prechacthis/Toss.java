package com.fineshambles.prechacthis;

import java.util.Locale;

public class Toss {

	private double height;
	private int pass;

	public Toss(double height, int pass) {
		this.height = height;
		this.pass = pass;
	}
	
	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Toss))
			return false;
		Toss t = (Toss)o;
		return (t.height == height && t.pass == pass);
	}
	
	public String toString() {
		double fpart = height - Math.floor(height);
		String heightString = String.format(Locale.US, fpart < .01 ? "%.0f" : "%.1f", height);
		String pString = pass == 0 ? "" : "p";
		return heightString + pString;
	}
	
	public double getHeight() {
		return height;
	}

	public int getPass() {
		return pass;
	}

}
