package com.fineshambles.prechacthis;

import java.util.ArrayList;

import android.util.Log;
import android.util.Pair;

public class ClubPosition {
	
	private Pair<Integer, Boolean> startPlace;
	private Rational startTime;
	private Pair<Integer, Boolean> endPlace;
	private Rational endTime;
	private boolean alive;

	private ClubPosition(Pair<Integer, Boolean> startPlace, Rational startTime, Pair<Integer, Boolean> endPlace, Rational endTime) {
		this.startPlace = startPlace;
		this.startTime = startTime;
		this.endPlace = endPlace;
		this.endTime = endTime;
		this.alive = true;
	}

	public static ClubPosition[] getClubPositions(Pattern pattern) {
		ArrayList<ClubPosition> clubPositions = new ArrayList<ClubPosition>();
		int numberOfClubs = pattern.getNumberOfClubs();
		int currentJuggler = 0;
		int place = 0;
		Rational currentTime = Rational.ZERO;
		Rational timeStep = new Rational(1, pattern.getNumberJugglers());
		Rational minuend = new Rational(pattern.length(), pattern.getNumberJugglers());
		while (numberOfClubs > 0) {
			// consider the pattern 123. We want the second juggler to be halfway through
			// their pattern when the first is starting, and vice versa. That is, we want
			// the 2 to line up with the gap between the 3 and the 1, which yields this
			// pattern
			//   0    1    2    0    1    2
			//     2     0    1    2    0
			// so if the first juggler starts with beat 0 at time 0,
			// the second juggler must do beat 0 at time 1.5. This means
			// they start 0.5 beats later than the first juggler, with beat 2.
			
			// with three jugglers and four beats:
			//   0      1      2     3      0     1     2      3
			//     3      0      1     2      3     0     1      2
			//       2      3      0      1     2     3      0     3 
			// which is to say, the second juggler does their beat 0 at time 1.33 and
			// the third juggler does their beat 0 at time 2.66.
			//
			// So there's this number, the length of the pattern divided by the number of
			// jugglers, and we'll call it the minuend. You can use it to calculate when
			// a juggler n does the 0th beat: they do it at minuend * n. Subtract that from
			// how far along you are, and you get the offset of the beat that juggler n
			// is doing then.
			
			int currentTossIndex = (place - minuend.times(currentJuggler).truncate()) % pattern.length();
			while (currentTossIndex < 0)
				currentTossIndex += pattern.length();
			Toss currentToss = pattern.getToss(currentTossIndex);
			Log.e("ClubPosition", "at time " + currentTime + " Juggler " + currentJuggler + " does " + currentToss + " (from " + currentTossIndex + ", " + place + ", " + minuend.times(currentJuggler) + ")");
			if (!currentToss.getHeight().equals(Rational.ZERO)) {
				if (!markedLandingAtAsDead(currentTime, clubPositions)) {
					numberOfClubs -= 1;
				}
				int destinationJuggler = (currentJuggler + currentToss.getPass()) % pattern.getNumberJugglers();
				Rational landingTime = currentTime.plus(currentToss.getHeight());
				clubPositions.add(new ClubPosition(new Pair<Integer, Boolean>(currentJuggler, currentTossIndex % 2 == 0),
						currentTime,
						new Pair<Integer, Boolean>(destinationJuggler, (currentTossIndex + currentToss.getSiteswap() % 2) == 0),
						landingTime));
			}	
			currentTime = currentTime.plus(timeStep);
			currentJuggler += 1;
			if (currentJuggler >= pattern.getNumberJugglers()){
				currentJuggler = 0;
				place += 1;
				if (place >= pattern.length())
					place = 0;
			}
		}
		
		return clubPositions.toArray(new ClubPosition[0]);
	}

	private static boolean markedLandingAtAsDead(Rational currentTime, ArrayList<ClubPosition> clubPositions) {
		for (ClubPosition p : clubPositions) {
			if (p.endTime.equals(currentTime)) {
				Log.e("ClubPosition", "existing club");
				p.alive = false;
				return true;
			}
		}
		Log.e("ClubPosition", "new club");
		return false;
	}

}
