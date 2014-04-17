package com.fineshambles.prechacthis;

import android.content.res.ColorStateList;
import android.graphics.Color;
import android.text.Html;
import android.view.LayoutInflater;
import android.widget.LinearLayout;
import android.widget.TextView;

public class PatternRenderer {

	private Pattern pattern;
	private static final int[] COLORS = new int[] { Color.RED, Color.BLUE, Color.GREEN, Color.CYAN, Color.YELLOW, Color.MAGENTA };

	public PatternRenderer(Pattern pattern) {
		this.pattern = pattern;
	}

	public void render(LayoutInflater inflater, LinearLayout row) {
		while (row.getChildCount() > pattern.length()) {
        	row.removeViewAt(0);
        }
        while (row.getChildCount() < pattern.length()) {
        	row.addView(inflater.inflate(R.layout.siteswap_row_cell, row, false));
        }
       
        for (int i = 0; i < pattern.length(); i++) {
        	TextView cell = (TextView)row.getChildAt(i);
        	Toss toss = pattern.getToss(i);
        	if (toss.getPass() >= 1 && toss.getPass() <= COLORS.length) {
        		cell.setTextColor(COLORS[toss.getPass() - 1]);
        	} else {
        		cell.setTextColor(Color.LTGRAY);
        	}
        	String label = toss.toString();
        	if (pattern.getNumberJugglers() > 2 && toss.getPass() > 0) {
        		label += "<sub><small>" + toss.getPass() + "</small></sub>";
        	}
			cell.setText(Html.fromHtml(label));
        }
	}

}
