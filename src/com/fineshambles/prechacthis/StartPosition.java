package com.fineshambles.prechacthis;

import android.util.Log;
import android.util.Pair;

public class StartPosition {
	int[] trues;
	int[] falses;

	public StartPosition(int numberJugglers, Pair<ClubPosition[], int[]> clubPositions) {
		trues = new int[numberJugglers];
		falses = new int[numberJugglers];
		for (ClubPosition p : clubPositions.first) {
			Pair<Integer, Boolean> endPlace = p.getEndPlace();
			Log.e("StartPosition", p + ": " + endPlace.first + " " + endPlace.second);
			if (endPlace.second)
				trues[endPlace.first] += 1;
			else
				falses[endPlace.first] += 1;
		}
	}
	
}
