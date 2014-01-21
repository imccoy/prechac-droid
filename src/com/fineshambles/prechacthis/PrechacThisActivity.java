package com.fineshambles.prechacthis;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
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
	
	private PatternParameters patternParameters;
	
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
        
        patternParameters = PatternParameters.fromBundle(savedInstanceState);
        
        initializeWithArray(numberPeople, patternParameters.getNumberJugglers(), 2, 3, 4, 5);
        numberPeople.setOnItemSelectedListener(new OnItemSelectedListener() {

			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int position, long id) {
				numberPeopleChanged((Integer)numberPeople.getItemAtPosition(position));
			}

			public void onNothingSelected(AdapterView<?> arg0) {
				numberPeople.setSelection(patternParameters.getNumberJugglers());
				
			}
		});
		
        initializeWithArray(numberObjects, patternParameters.getNumberObjects(), 2, 3, 4, 5, 6, 7, 8, 9, 10);
        numberObjects.setOnItemSelectedListener(new OnItemSelectedListener() {

			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int position, long id) {
				numberObjectsChanged((Integer)numberObjects.getItemAtPosition(position));
			}

			public void onNothingSelected(AdapterView<?> arg0) {
				numberObjects.setSelection(patternParameters.getNumberObjects());
			}
		});
		
        initializeWithArray(maxHeight, patternParameters.getMaxHeight(), 2, 3, 4, 5, 6, 7, 8);
        maxHeight.setOnItemSelectedListener(new OnItemSelectedListener() {

			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int position, long id) {
				maxHeightChanged((Integer)maxHeight.getItemAtPosition(position));
			}

			public void onNothingSelected(AdapterView<?> arg0) {
				maxHeight.setSelection(patternParameters.getMaxHeight());
			}
		});
        
        
        period.setOnItemSelectedListener(new OnItemSelectedListener() {

			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int position, long id) {
				periodChanged((Integer)period.getItemAtPosition(position));
				
			}

			public void onNothingSelected(AdapterView<?> arg0) {
				period.setSelection(patternParameters.getPeriod());
			}
        	
        });
        initializeWithArray(period, patternParameters.getPeriod(), 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

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
        minPasses.setProgress(patternParameters.getMinPasses());
        maxPasses.setProgress(patternParameters.getMaxPasses());
        
        goButton.setOnClickListener(this);
    }

	private <T> void initializeWithArray(Spinner spinner, T currentValue,
			T... options) {
    	spinner.setAdapter(arrayOptions(options));
		for (int i = 0; i < options.length; i++) {
			if (options[i].equals(currentValue)) {
				spinner.setSelection(i);
				break;
			}
		}
	}
	
    private <T> ArrayAdapter<T> arrayOptions( T... options) {
		return new ArrayAdapter<T>(this, R.layout.plain_text_view, options);
	}
    
	protected void numberPeopleChanged(int numberPeople) {
		patternParameters = patternParameters.withNumberJugglers(numberPeople);
		
	}

	protected void numberObjectsChanged(int numberObjects) {
		patternParameters = patternParameters.withNumberObjects(numberObjects);
	}
    
    protected void maxHeightChanged(int maxHeight) {
		patternParameters = patternParameters.withMaxHeight(maxHeight);
	}

	protected void minPassesChanged(int progress) {
		patternParameters = patternParameters.withMinPasses(progress);
		minPassesDisplay.setText("At least " + progress + " pass" + (progress != 1 ? "es" : ""));
	}

	protected void maxPassesChanged(int progress) {
		patternParameters = patternParameters.withMaxPasses(progress);
		maxPassesDisplay.setText("and at most " + progress + " pass" + (progress != 1 ? "es" : ""));
		minPasses.setMax(progress);
	}

	protected void periodChanged(Integer period) {
		maxPasses.setMax(period.intValue() + 1); // the +1 is because the seek bar doesn't let you
		                                         // seek to the end, but we want to allow every
		                                         // throw to be a pass
		patternParameters = patternParameters.withPeriod(period);
	}

	@Override
    protected void onSaveInstanceState(Bundle outState) {
    	super.onSaveInstanceState(outState);
    	patternParameters.toBundle(outState);
    }
	
	

	public void onClick(View v) {
		Intent intent = new Intent();
		intent.setClass(this, SearchActivity.class);
		intent.setAction("PRECHACTHIS_SEARCH");
		patternParameters.toIntent(intent);
		this.startActivity(intent);
	}
 
}
