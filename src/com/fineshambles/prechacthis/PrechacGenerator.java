package com.fineshambles.prechacthis;

import java.util.ArrayList;
import java.util.Hashtable;

import jpl.Query;
import jpl.Term;
import jpl.Util;
import jpl.Variable;

import android.app.AlertDialog;
import android.app.IntentService;
import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

public class PrechacGenerator extends Service {

	public static final String ACTION_PATTERN_GENERATED = "PATTERN_GENERATED";
	private int numberJugglers = -1;
	private int numberObjects = -1;
	private int maxHeight = -1;
	private int period = -1;
	private int maxPasses = -1;
	private int minPasses = -1;
	
	private ArrayList<Pattern> cache = new ArrayList<Pattern>();
	
	private Prolog prolog;
	
	private LocalBroadcastManager localBroadcastManager;

	public PrechacGenerator() {
		localBroadcastManager = LocalBroadcastManager.getInstance(this);
		prolog = new Prolog(this);
	}
	
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		int numberJugglers = intent.getIntExtra("NUMBER_JUGGLERS", 2);
		int numberObjects = intent.getIntExtra("NUMBER_OBJECTS", 4);
		int maxHeight = intent.getIntExtra("MAX_HEIGHT", 4);
		int period = intent.getIntExtra("PERIOD", 4);
		int maxPasses = intent.getIntExtra("MAX_PASSES", Math.max(1, period - 1));
		int minPasses = intent.getIntExtra("MIN_PASSES", 1);
		
		if (this.numberJugglers == numberJugglers &&
				this.numberObjects == numberObjects &&
				this.maxHeight == maxHeight &&
				this.period == period &&
				this.maxPasses == maxPasses &&
				this.minPasses == minPasses) {
			existingRequest();
		} else {
			this.numberJugglers = numberJugglers;
			this.numberObjects = numberObjects;
			this.maxHeight = maxHeight;
			this.period = period;
			this.maxPasses = maxPasses;
			this.minPasses = minPasses;
			new Thread(new Generator()).start();
		}
		return START_NOT_STICKY;
	}

	private class Generator implements Runnable {
		public void run() {
			if (!prolog.init()) {
				new AlertDialog.Builder(PrechacGenerator.this)
						.setMessage("My world is falling apart. Sorry")
						.setCancelable(false).show();
				return;
			}
			final Variable siteswapList = new Variable("SiteswapList");
			Term emptyList = Util.textToTerm("[]");
			final Query query = new Query("siteswap", new Term[] { siteswapList,
					new jpl.Integer(numberJugglers), // jugglers
					new jpl.Integer(numberObjects), // objects
					new jpl.Integer(period), // length
					new jpl.Integer(maxHeight), // max height
					new jpl.Integer(minPasses), // min passes
					new jpl.Integer(maxPasses), // max passes
					emptyList, // contain
					emptyList, // don't contain
					emptyList, // club does
					emptyList, // react
					emptyList, // sync
					emptyList, // just
					new jpl.Integer(0), // contain magic
			});
			generateAllSolutions(query, siteswapList);
		}
			
	    private void generateAllSolutions(final Query query, final Variable siteswapList) {
			while (cache.size() < 3000 && query.hasMoreSolutions()) {
				generateOneSolution(query, siteswapList);
			}
		}
	
		private void generateOneSolution(Query query, Variable siteswapList) {
			@SuppressWarnings("rawtypes")
			Hashtable solution = query.nextSolution();
			if (solution.size() == 0)
				return;
			Term binding = (Term) solution.get(siteswapList.name);
			Term[] bindings = Util.listToTermArray(binding);
			Pattern p = new Pattern(bindings);
			cache.add(p);
			broadcastPattern(p);
		}
	}

	private void broadcastPattern(Pattern p) {
		Intent intent = new Intent(ACTION_PATTERN_GENERATED);
		intent.putExtra("pattern", p);
		localBroadcastManager.sendBroadcast(intent);
	}

	private void existingRequest() {
		for (Pattern p : cache) {
			broadcastPattern(p);
		}
	}

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}
}
