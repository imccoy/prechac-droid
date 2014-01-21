package com.fineshambles.prechacthis;

import android.content.Intent;
import android.os.Bundle;

public class PatternParameters {
	private static final int DEFAULT_MIN_PASSES = 1;
	private static final int DEFAULT_MAX_HEIGHT = 4;
	private static final int DEFAULT_NUMBER_OBJECTS = 4;
	private static final int DEFAULT_NUMBER_JUGGLERS = 2;
	private static final int DEFAULT_PERIOD = 4;
	private int numberJugglers;
	private int numberObjects;
	private int maxHeight;
	private int period;
	private int maxPasses;
	private int minPasses;
	
	private PatternParameters() {
		this(DEFAULT_NUMBER_JUGGLERS, DEFAULT_NUMBER_OBJECTS, DEFAULT_MAX_HEIGHT, DEFAULT_PERIOD, DEFAULT_MIN_PASSES, defaultMaxPasses(DEFAULT_MIN_PASSES, DEFAULT_PERIOD));
	}
	
	private static int defaultMaxPasses(int minPasses, int period) {
		return Math.max(minPasses, period - minPasses);
	}

	private PatternParameters(int numberJugglers, int numberObjects, int maxHeight, int period, int minPasses, int maxPasses) {
		this.numberJugglers = numberJugglers;
		this.numberObjects = numberObjects;
		this.maxHeight = maxHeight;
		this.period = period;
		this.maxPasses = maxPasses;
		this.minPasses = minPasses;
	}
	public static PatternParameters fromIntent(Intent intent) {
		final int period = intent.getIntExtra("PERIOD", DEFAULT_PERIOD);
		final int minPasses = intent.getIntExtra("MIN_PASSES", DEFAULT_MIN_PASSES);
		return new PatternParameters(intent.getIntExtra("NUMBER_JUGGLERS", DEFAULT_NUMBER_JUGGLERS),
			intent.getIntExtra("NUMBER_OBJECTS", DEFAULT_NUMBER_OBJECTS),
			intent.getIntExtra("MAX_HEIGHT", DEFAULT_MAX_HEIGHT),
			period,
			minPasses,
			intent.getIntExtra("MAX_PASSES", defaultMaxPasses(minPasses, period)));
	}
	public void toIntent(Intent intent) {
		intent.putExtra("NUMBER_OBJECTS", numberObjects);
		intent.putExtra("NUMBER_JUGGLERS", numberJugglers);
		intent.putExtra("MAX_HEIGHT", maxHeight);
		intent.putExtra("PERIOD", period);
		intent.putExtra("MAX_PASSES", maxPasses);
		intent.putExtra("MIN_PASSES", minPasses);
	}
	public static PatternParameters fromBundle(Bundle bundle) {
		if (bundle == null)
			return new PatternParameters();
		final int period = bundle.getInt("PERIOD", DEFAULT_PERIOD);
		final int minPasses = bundle.getInt("MIN_PASSES", DEFAULT_MIN_PASSES);
		return new PatternParameters(bundle.getInt("NUMBER_JUGGLERS", DEFAULT_NUMBER_JUGGLERS),
				bundle.getInt("NUMBER_OBJECTS", DEFAULT_NUMBER_OBJECTS),
				bundle.getInt("MAX_HEIGHT", DEFAULT_MAX_HEIGHT),
				period,
				minPasses,
				bundle.getInt("MAX_PASSES", defaultMaxPasses(minPasses, period)));
	}
	public void toBundle(Bundle bundle) {
		bundle.putInt("NUMBER_OBJECTS", numberObjects);
		bundle.putInt("NUMBER_JUGGLERS", numberJugglers);
		bundle.putInt("MAX_HEIGHT", maxHeight);
		bundle.putInt("PERIOD", period);
		bundle.putInt("MAX_PASSES", maxPasses);
		bundle.putInt("MIN_PASSES", minPasses);
	}

	public int getNumberObjects() {
		return numberObjects;
	}
	public int getNumberJugglers() {
		return numberJugglers;
	}
	public int getMaxHeight() {
		return maxHeight;
	}
	public int getPeriod() {
		return period;
	}
	public int getMaxPasses() {
		return maxPasses;
	}
	public int getMinPasses() {
		return minPasses;
	}
	
	public PatternParameters withNumberJugglers(int i) {
		return new PatternParameters(i, numberObjects, maxHeight, period, minPasses, maxPasses);
	}
	
	public PatternParameters withNumberObjects(int i) {
		return new PatternParameters(numberJugglers, i, maxHeight, period, minPasses, maxPasses);
	}
	
	public PatternParameters withMaxHeight(int i) {
		return new PatternParameters(numberJugglers, numberObjects, i, period, minPasses, maxPasses);
	}
	
	public PatternParameters withPeriod(int i) {
		return new PatternParameters(numberJugglers, numberObjects, maxHeight, i, minPasses, maxPasses);
	}

	public PatternParameters withMinPasses(int i) {
		return new PatternParameters(numberJugglers, numberObjects, maxHeight, period, i, maxPasses);
	}
	
	public PatternParameters withMaxPasses(int i) {
		return new PatternParameters(numberJugglers, numberObjects, maxHeight, period, minPasses, i);
	}
	
	@Override
	public boolean equals(Object o) {
		if (!(o instanceof PatternParameters))
			return false;
		PatternParameters p = (PatternParameters)o;
		return p.getNumberJugglers() == getNumberJugglers() &&
				p.getNumberObjects() == getNumberObjects() &&
				p.getMaxHeight() == getMaxHeight() &&
				p.getPeriod() == getPeriod() &&
				p.getMinPasses() == getMinPasses() &&
				p.getMaxPasses() == getMaxPasses();
	}
	
	@Override
	public String toString() {
		return String.format("% jugglers with % objects juggling a pattern of period % with no throws higher than % and % - % passes",
				numberJugglers, numberObjects, period, maxHeight, minPasses, maxPasses);
	}
}
