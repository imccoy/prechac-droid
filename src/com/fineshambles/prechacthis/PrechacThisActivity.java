package com.fineshambles.prechacthis;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.DragEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnDragListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.Spinner;
import android.widget.TextView;

public class PrechacThisActivity extends Activity implements OnClickListener
{
	private Spinner numberObjects;
	private Spinner numberPeople;
	private Button goButton;
	private Spinner maxHeight;
	private Spinner period;
	private SeekBar minPasses;
	private SeekBar maxPasses;
	private TextView minPassesDisplay;
	private TextView maxPassesDisplay;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
		this.numberObjects = (Spinner)findViewById(R.id.number_objects);
        this.numberPeople = (Spinner)findViewById(R.id.number_people);
        this.maxHeight = (Spinner)findViewById(R.id.max_height);
        this.period = (Spinner)findViewById(R.id.period);
        this.goButton = (Button)findViewById(R.id.go);
        this.minPasses = (SeekBar)findViewById(R.id.min_passes);
        this.maxPasses = (SeekBar)findViewById(R.id.max_passes);
        this.minPassesDisplay = (TextView)findViewById(R.id.min_passes_display);
        this.maxPassesDisplay = (TextView)findViewById(R.id.max_passes_display);
        
        final int PERIOD_DEFAULT_INDEX = 3;
        
        numberPeople.setAdapter(this.<Integer>arrayOptions(2, 3, 4, 5));
        numberPeople.setSelection(getStateInt(savedInstanceState, "NUMBER_PEOPLE", 0));
        
        numberObjects.setAdapter(this.<Integer>arrayOptions(2, 3, 4, 5, 6, 7, 8, 9, 10));
        numberObjects.setSelection(getStateInt(savedInstanceState, "NUMBER_OBJECTS", 2));
        
        maxHeight.setAdapter(this.<Integer>arrayOptions(2, 3, 4, 5, 6, 7, 8));
        maxHeight.setSelection(getStateInt(savedInstanceState, "MAX_HEIGHT", 3));
        
        period.setOnItemSelectedListener(new OnItemSelectedListener() {

			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int position, long id) {
				periodChanged((Integer)period.getItemAtPosition(position));
				
			}

			public void onNothingSelected(AdapterView<?> arg0) {
				period.setSelection(PERIOD_DEFAULT_INDEX);
			}
        	
        });
        period.setAdapter(this.<Integer>arrayOptions(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
        period.setSelection(getStateInt(savedInstanceState, "PERIOD", PERIOD_DEFAULT_INDEX));

        maxPasses.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			public void onProgressChanged(SeekBar arg0, int progress, boolean fromUser) {
				maxPassesChanged(progress);
			}

			public void onStartTrackingTouch(SeekBar arg0) {}

			public void onStopTrackingTouch(SeekBar seekBar) {}
        });
        minPasses.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			public void onProgressChanged(SeekBar arg0, int progress, boolean fromUser) {
				minPassesChanged(progress);
			}

			public void onStartTrackingTouch(SeekBar arg0) {}

			public void onStopTrackingTouch(SeekBar seekBar) {}
        });
        maxPasses.setProgress(getStateInt(savedInstanceState, "MAX_PASSES", PERIOD_DEFAULT_INDEX));
        minPasses.setProgress(getStateInt(savedInstanceState, "MIN_PASSES", 1));

        
        goButton.setOnClickListener(this);
    }
    
    private int getStateInt(Bundle savedInstanceState, String key, int def) {
    	if (savedInstanceState == null)
    		return def;
    	return savedInstanceState.getInt(key, def);
	}

	protected void minPassesChanged(int progress) {
		minPassesDisplay.setText("At least " + progress + " pass" + (progress != 1 ? "es" : ""));
	}

	protected void maxPassesChanged(int progress) {
		maxPassesDisplay.setText("and at most " + progress + " pass" + (progress != 1 ? "es" : ""));
		minPasses.setMax(progress);
	}

	protected void periodChanged(Integer period) {
		maxPasses.setMax(period.intValue() + 1); // the +1 is because the seek bar doesn't let you
		                                         // seek to the end, but we want to allow every
		                                         // throw to be a pass
	}

	@Override
    protected void onSaveInstanceState(Bundle outState) {
    	super.onSaveInstanceState(outState);
    	outState.putInt("NUMBER_OBJECTS", (Integer)this.numberObjects.getSelectedItem());
		outState.putInt("NUMBER_PEOPLE", (Integer)this.numberPeople.getSelectedItem());
		outState.putInt("MAX_HEIGHT", (Integer)this.maxHeight.getSelectedItem());
		outState.putInt("PERIOD", (Integer)this.period.getSelectedItem());
		outState.putInt("MAX_PASSES", this.maxPasses.getProgress());
		outState.putInt("MIN_PASSES", this.minPasses.getProgress());
    }

	private <T> ArrayAdapter<T> arrayOptions( T... options) {
		return new ArrayAdapter<T>(this, R.layout.plain_text_view, options);
	}
	
	

	public void onClick(View v) {
		Intent intent = new Intent();
		intent.setClass(this, SearchActivity.class);
		intent.setAction("PRECHACTHIS_SEARCH");
		intent.putExtra("NUMBER_OBJECTS", (Integer)this.numberObjects.getSelectedItem());
		intent.putExtra("NUMBER_PEOPLE", (Integer)this.numberPeople.getSelectedItem());
		intent.putExtra("MAX_HEIGHT", (Integer)this.maxHeight.getSelectedItem());
		intent.putExtra("PERIOD", (Integer)this.period.getSelectedItem());
		intent.putExtra("MAX_PASSES", this.maxPasses.getProgress());
		intent.putExtra("MIN_PASSES", this.minPasses.getProgress());
		this.startActivity(intent);
	}
 
}
