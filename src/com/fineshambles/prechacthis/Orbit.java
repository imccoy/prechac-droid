package com.fineshambles.prechacthis;

import java.util.ArrayList;
import java.util.Iterator;

import android.util.Log;
import android.util.Pair;

public class Orbit {
	private Pair<Integer, Toss>[] tossesAtTimes;
	private int period;
	private int numberOfJugglers;

	public Orbit(Pair<Integer, Toss>[] tossesAtTimes, int period, int numberOfJugglers) {
		this.tossesAtTimes = tossesAtTimes;
		this.period = period;
		this.numberOfJugglers = numberOfJugglers;
	}
	
	public int numberOfObjects() {
		Rational sum = Rational.ZERO;
		for (int i = 0; i < tossesAtTimes.length; i++) {
			Toss t = tossesAtTimes[i].second;
			sum = sum.plus(t.getHeight());
		}
		return sum.times(new Rational(numberOfJugglers, period)).truncate();
	}

	public static Orbit[] getOrbits(Pattern pattern) {
		ArrayList<Orbit> orbits = new ArrayList<Orbit>();
		boolean taken[] = new boolean[pattern.length()];
		int startIdx;
		while ((startIdx = firstNotTaken(taken)) != -1) {
			Log.d("Orbit", "START Orbit at " + startIdx);
			int idx = startIdx;
			ArrayList<Pair<Integer, Toss>> tossesAtTimes = new ArrayList<Pair<Integer, Toss>>();
			do {
				taken[idx] = true;
				Toss toss = pattern.getToss(idx);
				tossesAtTimes.add(new Pair<Integer, Toss>(idx, toss));
				Log.d("Orbit", "Orbit continues from " + idx + "(" + toss.getHeight().toString() + ", " + toss.getPass() + ", " + toss.getSiteswap()  + ")");
				idx = (idx + toss.getSiteswap()) % pattern.length();
				Log.d("Orbit", "Orbit continues to " + idx + " by " + toss.getSiteswap());
			} while (idx != startIdx);
			@SuppressWarnings("unchecked")
			Orbit orbit = new Orbit(tossesAtTimes.toArray(new Pair[0]), pattern.length(), pattern.getNumberJugglers());
			orbits.add(orbit);
		}
		return orbits.toArray(new Orbit[0]);
	}

	private static int firstNotTaken(boolean[] taken) {
		for (int i = 0; i < taken.length; i++) {
			if (!taken[i])
				return i;
		}
		return -1;
	}
	
	public Iterable<Integer> getIndexIterable() {
		return new Iterable<Integer>() {

			@Override
			public Iterator<Integer> iterator() {
				return new Iterator<Integer>() {
					int i = -1;

					@Override
					public boolean hasNext() {
						return i + 1 < tossesAtTimes.length;
					}

					@Override
					public Integer next() {
						return tossesAtTimes[++i].first;
					}

					@Override
					public void remove() {
						throw new UnsupportedOperationException();
					}
					
				};
			}
			
		};
		
	}

}
