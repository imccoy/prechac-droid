package com.fineshambles.prechacthis;

import android.app.Activity;
import android.os.Bundle;
import android.util.Pair;
import android.view.LayoutInflater;
import android.widget.LinearLayout;
import android.widget.TextView;

public class DetailActivity extends Activity {
	private Pattern pattern;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_details);
		LayoutInflater layoutInflater = getLayoutInflater();
		
		pattern = (Pattern)getIntent().getParcelableExtra("pattern");
		LinearLayout siteswapView = (LinearLayout)findViewById(R.id.details_siteswap);
		PatternRenderer renderer = new PatternRenderer(pattern);
		
		renderer.render(layoutInflater, siteswapView);
		
		Orbit[] orbits = Orbit.getOrbits(pattern);
		renderOrbits(orbits, layoutInflater, renderer);
		
		
		Pair<ClubPosition[], int[]> clubPositions = ClubPosition.getClubPositions(pattern);
		StartPosition startPosition = new StartPosition(pattern.getNumberJugglers(), clubPositions);
		renderStartPosition(pattern, startPosition, clubPositions.second);
	}

	private void renderStartPosition(Pattern pattern, StartPosition startPosition, int[] progresses) {
		LinearLayout startsView = (LinearLayout)findViewById(R.id.details_starts);
		for (int i = 0; i < pattern.getNumberJugglers(); i++) {
			TextView textView = new TextView(this);
			String left = "L " + startPosition.falses[i];
			String right = "R " + startPosition.trues[i];
			String p = pattern.rotate(progresses[i]).toString();
			textView.setText(left + " " + right + " " + p);
			startsView.addView(textView);
		}
	}

	private void renderOrbits(Orbit[] orbits, LayoutInflater layoutInflater,
			PatternRenderer renderer) {
		
		LinearLayout orbitsView = (LinearLayout)findViewById(R.id.details_orbits);
		for (int i = 0; i < orbits.length; i++) {
			LinearLayout orbitView = new LinearLayout(this);
			orbitView.setOrientation(LinearLayout.HORIZONTAL);
			TextView intro = new TextView(this);
			int numberOfObjects = orbits[i].numberOfObjects();
			intro.setText(numberOfObjects == 1 ? "1 object is doing: " : numberOfObjects + " objects are doing: ");
			orbitsView.addView(intro);
			renderer.render(layoutInflater, orbitView, orbits[i].getIndexIterable());
			orbitsView.addView(orbitView);
		}
	}
}
