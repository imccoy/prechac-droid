package com.fineshambles.prechacthis;

import android.os.Parcel;
import android.os.Parcelable;
import jpl.Compound;
import jpl.Term;

public class Pattern implements Parcelable {
	private final Toss[] tosses;

	public Pattern(Term[] bindings) {
		this(bindings.length);
		for (int i = 0; i < tosses.length; i++) {
			// bindings are p(a, b, c). a is the throw height
			//                          b is 1 if it's a pass (what about >2 jugglers?)
			//                          c is the beat the throw is going to
			// accesses into compound terms seem to be one-based.
			Compound pTerm = (Compound) bindings[i];
			tosses[i] = new Toss(((jpl.Float)pTerm.arg(1)).doubleValue(),
					             ((jpl.Integer)pTerm.arg(2)).intValue());
		}
	}
	
	private Pattern(int length) {
		this.tosses = new Toss[length];
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
		parcel.writeInt(tosses.length);
		for (int i = 0; i < tosses.length; i++) {
			parcel.writeDouble(tosses[i].getHeight());
			parcel.writeInt(tosses[i].getPass());
		}
	}
	
	public static final Parcelable.Creator<Pattern> CREATOR
	  = new Parcelable.Creator<Pattern>() {

		public Pattern createFromParcel(Parcel source) {
			int length = source.readInt();
			Pattern p = new Pattern(length);
			for (int i = 0; i < length; i++) {
				double height = source.readDouble();
				int pass = source.readInt();
				p.tosses[i] = new Toss(height, pass);
			}
			return p;
		}

		public Pattern[] newArray(int size) {
			return new Pattern[size];
		}
	};

}
