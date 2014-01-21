package com.fineshambles.prechacthis;

import java.util.Locale;

import jpl.Compound;
import jpl.Term;


import android.os.Bundle;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;
import android.view.Menu;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class SearchActivity extends Activity {
	private ListView patterns;
	private ArrayAdapter<String> patternsAdapter;
	private LocalBroadcastManager localBroadcastManager;
	private BroadcastReceiver patternReceiver = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			Pattern p = intent.getExtras().getParcelable("pattern");
			patternsAdapter.add(p.toString());
		}
	};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_search);
		localBroadcastManager = LocalBroadcastManager.getInstance(this);
		
		patterns = (ListView)findViewById(R.id.patterns);
		patternsAdapter = new ArrayAdapter<String>(this, R.layout.plain_text_view);
		patterns.setAdapter(patternsAdapter);
		
		Intent intent = this.getIntent();
		PatternParameters patternParameters = PatternParameters.fromIntent(intent);
		Intent serviceIntent = new Intent(this, PrechacGenerator.class);
		patternParameters.toIntent(serviceIntent);
		startService(serviceIntent);
		
		localBroadcastManager.registerReceiver(patternReceiver , new IntentFilter(PrechacGenerator.ACTION_PATTERN_GENERATED));
	}

}
