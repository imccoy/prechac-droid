package com.fineshambles.prechacthis;

import java.util.List;

import com.fineshambles.prechacthis.details.ClubDistribution;
import com.fineshambles.prechacthis.details.Orbit;
import com.fineshambles.prechacthis.details.PointInTime;

import android.app.Activity;
import android.os.Bundle;
import android.widget.LinearLayout;

public class DetailActivity extends Activity {
	private Pattern pattern;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_details);
		pattern = (Pattern)getIntent().getParcelableExtra("pattern");
		LinearLayout siteswapView = (LinearLayout)findViewById(R.id.details_siteswap);
		PatternRenderer renderer = new PatternRenderer(pattern);
		renderer.render(getLayoutInflater(), siteswapView);
		PointInTime[] pointsInTime = PointInTime.generateAll(pattern);
		int[] orbits = Orbit.generateAll(pattern);
		ClubDistribution clubDistribution = new ClubDistribution(pattern, pointsInTime, orbits);
	}
}
