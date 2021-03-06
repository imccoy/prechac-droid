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
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

public class SearchActivity extends Activity {
	private ListView patterns;
	private ArrayAdapter<Pattern> patternsAdapter;
	private LocalBroadcastManager localBroadcastManager;
	private PatternParameters parameters;
	
	private BroadcastReceiver patternReceiver = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			PatternParameters patternParameters = PatternParameters.fromIntent(intent);
			if (patternParameters.equals(SearchActivity.this.parameters)) {
				Pattern p = intent.getExtras().getParcelable("pattern");
				patternsAdapter.add(p);
			}
		}
	};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		Intent intent = this.getIntent();
		this.parameters = PatternParameters.fromIntent(intent);
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_search);
		localBroadcastManager = LocalBroadcastManager.getInstance(this);
		
		patterns = (ListView)findViewById(R.id.patterns);
		patternsAdapter = new ArrayAdapter<Pattern>(this, R.layout.siteswap_row) {
			@Override
			public View getView(int position, View convertView, ViewGroup parent) {
				LinearLayout row = (LinearLayout)convertView;
				Pattern pattern = this.getItem(position);
				LayoutInflater inflater = getLayoutInflater();
				
		        if(row == null) {
		            row = (LinearLayout) inflater.inflate(R.layout.siteswap_row, parent, false);
		        }
		        PatternRenderer renderer = new PatternRenderer(pattern);
		        renderer.render(inflater, row);
	            
		       
		        return row;
			}
		};
		patterns.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> adapterView, View viewClicked, int position,
					long id) {
				Pattern pattern = patternsAdapter.getItem(position);
				Intent intent = new Intent();
				intent.setClass(SearchActivity.this, DetailActivity.class);
				intent.setAction("PRECHACTHIS_DETAILS");
				intent.putExtra("pattern", pattern);
				SearchActivity.this.startActivity(intent);
			}
		});
		patterns.setAdapter(patternsAdapter);
		
		Intent serviceIntent = new Intent(this, PrechacGenerator.class);
		parameters.toIntent(serviceIntent);
		startService(serviceIntent);
		
		localBroadcastManager.registerReceiver(patternReceiver , new IntentFilter(PrechacGenerator.ACTION_PATTERN_GENERATED));
	}

}
