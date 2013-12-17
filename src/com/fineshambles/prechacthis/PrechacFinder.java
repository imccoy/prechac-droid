package com.fineshambles.prechacthis;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Hashtable;

import jpl.Atom;
import jpl.Compound;
import jpl.JPL;
import jpl.Query;
import jpl.Term;
import jpl.Util;
import jpl.Variable;
import android.app.AlertDialog;
import android.content.Context;
import android.util.Log;

public class PrechacFinder {

	public interface PatternGenerated {

		void gotPattern(Term[] bindings);

	}

	private Context context;
	private Prolog prolog;

	public PrechacFinder(Context context) {
		this.context = context;
		prolog = new Prolog(context);
	}

	public void generatePatterns(int numberJugglers, int numberObjects,
			int maxHeight, int period, int minPasses, int maxPasses, PatternGenerated patternGeneratedHandler) {
		if (!prolog.init()) {
			new AlertDialog.Builder(context)
					.setMessage("My world is falling apart. Sorry")
					.setCancelable(false).show();
			return;
		}
		

		// find_siteswaps(SiteswapList, 2, 4, 6, 3, 2, 2,
		// [],[],[],[],[],[],0,R),[Flag,Time,Objects,Length,X] = SiteswapList.

		Variable siteswapList = new Variable("SiteswapList");
		Term emptyList = Util.textToTerm("[]");
		Query query = new Query("siteswap", new Term[] { siteswapList,
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
		int n = 0;
		while (query.hasMoreSolutions() && n < 3000) {
			Hashtable solution = query.nextSolution();
			if (solution.size() == 0)
				continue;
			Term binding = (Term) solution.get(siteswapList.name);
			Term[] bindings = Util.listToTermArray(binding);
			patternGeneratedHandler.gotPattern(bindings);
			n++;
		}	
	}



}
