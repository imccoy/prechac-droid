package com.fineshambles.prechacthis;

import java.util.Locale;

import jpl.Compound;
import jpl.Term;

import com.fineshambles.prechacthis.PrechacFinder.PatternGenerated;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class SearchActivity extends Activity implements PatternGenerated {
	private PrechacFinder prechacFinder;
	private ListView patterns;
	private ArrayAdapter<String> patternsAdapter; 
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_search);
		
		patterns = (ListView)findViewById(R.id.patterns);
		patternsAdapter = new ArrayAdapter<String>(this, R.layout.plain_text_view);
		patterns.setAdapter(patternsAdapter);
		
		Intent intent = this.getIntent();
		int numberJugglers = intent.getIntExtra("NUMBER_JUGGLERS", 2);
		int numberObjects = intent.getIntExtra("NUMBER_OBJECTS", 4);
		int maxHeight = intent.getIntExtra("MAX_HEIGHT", 4);
		int period = intent.getIntExtra("PERIOD", 4);
		int maxPasses = intent.getIntExtra("MAX_PASSES", Math.max(1, period - 1));
		int minPasses = intent.getIntExtra("MIN_PASSES", 1);
		prechacFinder = new PrechacFinder(this);
        prechacFinder.generatePatterns(numberJugglers, numberObjects, maxHeight, period, minPasses, maxPasses, this);
	}

	public void gotPattern(Term[] bindings) {
		String pattern = "";
		for (Term binding : bindings) {
			// binding is a p(a, b, c). a is the throw height
			//                          b is 1 if it's a pass (what about >2 jugglers?)
			//                          c is the beat the throw is going to
			// accesses into compound terms seem to be one-based.
			Compound pTerm = (Compound) binding;
			double height = ((jpl.Float)pTerm.arg(1)).doubleValue();
			double fpart = height - Math.floor(height);
			String heightString = String.format(Locale.US, fpart < .01 ? "%.0f" : "%.1f", height);
			int p = ((jpl.Integer)pTerm.arg(2)).intValue();
			String pString = p == 0 ? "" : "p";
			pattern += heightString + pString;
		}
		patternsAdapter.add(pattern);
		
	}


}
