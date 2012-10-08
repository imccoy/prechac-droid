package com.fineshambles.prechacthis;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Hashtable;

import jpl.JPL;
import jpl.Query;
import jpl.Term;
import jpl.Util;
import jpl.Variable;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

public class PrechacThisActivity extends Activity
{
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
		initProlog();
		Variable result = new Variable("Result");
		Query query = new Query("length", new Term[] { Util.textToTerm("[1,2]"), result });
		Hashtable[] solutions = query.allSolutions();
		for (Hashtable solution : solutions) {
			Term binding = (Term)solution.get("Result");
			Log.e(this.getClass().getName(), "RESULT" + binding);
		}
    }

	private void initProlog() {
		try {
			  // path must be the filename of a 32-bit boot.prc. I made one                  
			  // by:                                                                                      
			  //   export CFLAGS="-march=i686 -m32"                                                       
			  //   export LDFLAGS="-m32"                                                                  
			  //   ./configure --host=i386 --build=i386 --disable-readline --without-readline --without-gmp --disable-gmp
			  //   make                                                                                   
			  // then nabbing swipl-32.prc 
			String path = extractBootFile();
			JPL.setNativeLibraryName("swipl");
			JPL.init(makeArgs(path));
		} catch (FileNotFoundException e) {
			Log.e(this.getClass().getName(), "trouble extracting boot file", e);
		} catch (IOException e) {
			Log.e(this.getClass().getName(), "trouble extracting boot file", e);
		}
	}

	private String[] makeArgs(String path) {
		String[] defaultArgs = JPL.getDefaultInitArgs();
		String[] args = new String[defaultArgs.length + 2];
		args[0] = path;
		for (int i = 1; i < defaultArgs.length; i++) {
			args[i] = defaultArgs[i];
		}
		args[defaultArgs.length] = "-f";
		args[defaultArgs.length + 1] = "thing";
		return args;
	}

	private String extractBootFile() throws FileNotFoundException, IOException {
		Context context = this;
        File bootFileDir = context.getDir("boot", 0);
		File bootFile = new File(bootFileDir, "boot32.prc");
		extractRawResource(bootFile, R.raw.boot32);
        return bootFile.getAbsolutePath();
	}

	private void extractRawResource(File bootFile, int id)
			throws FileNotFoundException, IOException {
		final int BUF_SIZE = 1024 * 8;
        BufferedInputStream assetInS = new BufferedInputStream(
            getResources().openRawResource(id));
        BufferedOutputStream assetOutS = new BufferedOutputStream(
            new FileOutputStream(bootFile));
        int n = 0;
        byte[] b = new byte[BUF_SIZE];
        while ((n = assetInS.read(b, 0, b.length)) != -1) {
            assetOutS.write(b, 0, n);
        }
        assetInS.close();
        assetOutS.close();
	}
}
