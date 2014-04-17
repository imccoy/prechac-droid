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

	private ArrayList<Pattern> cache = new ArrayList<Pattern>();
	private Generator currentGenerator = null;
	
	private Prolog prolog;
	
	private LocalBroadcastManager localBroadcastManager;

	public PrechacGenerator() {
		localBroadcastManager = LocalBroadcastManager.getInstance(this);
		prolog = new Prolog(this);
	}
	
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		PatternParameters parameters = PatternParameters.fromIntent(intent);
		
		if (this.currentGenerator != null && this.currentGenerator.sameParameters(parameters)) {
			existingRequest(parameters);
		} else {
			startGenerator(new Generator(parameters));
		}
		return START_NOT_STICKY;
	}

	private void startGenerator(final Generator generator) {
		Runnable runnable = new Runnable() {
			public void run() {
				cache = new ArrayList<Pattern>();
				currentGenerator = generator;
				generator.run();
			}
		};
		if (currentGenerator == null) {
			new Thread(runnable).start();
		} else {
			currentGenerator.finishAnd(runnable);
		}
	}

	private class Generator implements Runnable {
		private Runnable finishCallback;
		private PatternParameters parameters;

		public Generator(PatternParameters parameters) {
			this.parameters = parameters;
		}

		public boolean sameParameters(PatternParameters parameters) {
			return this.parameters.equals(parameters);
		}

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
					new jpl.Integer(parameters.getNumberJugglers()), // jugglers
					new jpl.Integer(parameters.getNumberObjects()), // objects
					new jpl.Integer(parameters.getPeriod()), // length
					new jpl.Integer(parameters.getMaxHeight()), // max height
					new jpl.Integer(parameters.getMinPasses()), // min passes
					new jpl.Integer(parameters.getMaxPasses()), // max passes
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
			
	    public void finishAnd(Runnable finishCallback) {
	    	this.finishCallback = finishCallback;
		}

		private void generateAllSolutions(final Query query, final Variable siteswapList) {
			while (cache.size() < 3000 && query.hasMoreSolutions()) {
				if (finishCallback != null) {
					query.abort();
					finishCallback.run();
					return;
				}
				generateOneSolution(query, siteswapList);
			}
			currentGenerator = null; // race condition: what if finishCallback has only just been set?
		}
	
		private void generateOneSolution(Query query, Variable siteswapList) {
			@SuppressWarnings("rawtypes")
			Hashtable solution = query.nextSolution();
			if (solution.size() == 0)
				return;
			Term binding = (Term) solution.get(siteswapList.name);
			Term[] bindings = Util.listToTermArray(binding);
			Pattern p = new Pattern(parameters.getNumberJugglers(), bindings);
			if (!cache.contains(p)) {
				cache.add(p);
				broadcastPattern(p, parameters);
			}
		}
	}

	private void broadcastPattern(Pattern p, PatternParameters parameters) {
		Intent intent = new Intent(ACTION_PATTERN_GENERATED);
		intent.putExtra("pattern", p);
		parameters.toIntent(intent);
		localBroadcastManager.sendBroadcast(intent);
	}

	private void existingRequest(PatternParameters parameters) {
		for (Pattern p : cache) {
			broadcastPattern(p, parameters);
		}
	}

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}
}
