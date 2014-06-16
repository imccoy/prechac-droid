package com.fineshambles.prechacthis;

import java.util.Iterator;

public class IntegerIterable implements Iterable<Integer> {

	int min, max, inc;
	public IntegerIterable(int min, int max, int inc) {
		this.min = min;
		this.max = max;
		this.inc = inc;
	}
	public IntegerIterable(int min, int max) {
		this(min, max, 1);
	}
	
	@Override
	public Iterator<Integer> iterator() {
		
		return new Iterator<Integer>() {
			int current = min - inc;

			@Override
			public boolean hasNext() {
				return current + inc < max;
			}

			@Override
			public Integer next() {
				current += inc;
				return current;
			}

			@Override
			public void remove() {
				throw new UnsupportedOperationException();
			}
			
		};
	}

}
