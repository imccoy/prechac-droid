package com.fineshambles.prechacthis;

import android.os.Parcel;
import android.os.Parcelable;
import jpl.Compound;
import jpl.Term;

public class Pattern implements Parcelable {
	private final Toss[] tosses;
	private int numberJugglers;
	
	private Pattern(int numberJugglers, int length) {
		this.numberJugglers = numberJugglers;
		this.tosses = new Toss[length];
	}
	
	public Pattern(int numberJugglers, Term[] bindings) {
		this(numberJugglers, bindings.length);
		for (int i = 0; i < tosses.length; i++) {
			// bindings are p(a, b, c). a is the throw height
			//                          b is 1 if it's a pass (what about >2 jugglers?)
			//                          c is the beat the throw is going to
			// accesses into compound terms seem to be one-based.
			Compound pTerm = (Compound) bindings[i];
			Term heightTerm = pTerm.arg(1);
			Rational height = (heightTerm instanceof jpl.Integer) ?
					new Rational(integer(heightTerm),1) :
					rdiv(heightTerm);
			tosses[i] = new Toss(height, integer(pTerm.arg(2)));
		}
	}

	private int integer(Term heightTerm) {
		return ((jpl.Integer)heightTerm).intValue();
	}
	
	private Rational rdiv(Term term) {
		Compound hTerm = (Compound)term;
		return new Rational(integer(hTerm.arg(1)), integer(hTerm.arg(2)));
	}

	public Toss getToss(int i) {
		return this.tosses[i];
	}
	
	public int getNumberJugglers() {
		return numberJugglers;
	}
	
	public int length() {
		return tosses.length;
	}
	
	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Pattern)) {
			return false;
		}
		Pattern p = (Pattern)o;
		if (p.tosses.length != tosses.length)
			return false;
		for (int i = 0; i < tosses.length; i++) {
			if (!p.tosses[i].equals(tosses[i]))
				return false;
		}
		return true;
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < tosses.length; i++) {
			sb.append(tosses[i]);
		}
		return sb.toString();
		
	}

	public int describeContents() {
		return 0;
	}

	public void writeToParcel(Parcel parcel, int arg1) {
		parcel.writeInt(numberJugglers);
		parcel.writeInt(tosses.length);
		for (int i = 0; i < tosses.length; i++) {
			parcel.writeInt(tosses[i].getHeight().getNumerator());
			parcel.writeInt(tosses[i].getHeight().getDenominator());
			parcel.writeInt(tosses[i].getPass());
		}
	}
	
	public static final Parcelable.Creator<Pattern> CREATOR
	  = new Parcelable.Creator<Pattern>() {

		public Pattern createFromParcel(Parcel source) {
			int numberJugglers = source.readInt();
			int length = source.readInt();
			Pattern p = new Pattern(numberJugglers, length);
			for (int i = 0; i < length; i++) {
				int heightNum = source.readInt();
				int heightDen = source.readInt();
				int pass = source.readInt();
				p.tosses[i] = new Toss(new Rational(heightNum, heightDen), pass);
			}
			return p;
		}

		public Pattern[] newArray(int size) {
			return new Pattern[size];
		}
	};

}
