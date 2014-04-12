package com.fineshambles.prechacthis;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import jpl.Atom;
import jpl.Compound;
import jpl.JPL;
import jpl.Query;
import jpl.Term;
import android.content.Context;
import android.util.Log;

public class Prolog {
	private Context context;
	private static Boolean initialisationSucceeded;

	public Prolog(Context context) {
		this.context = context;
	}

	public boolean init() {
		if (initialisationSucceeded != null) {
			return initialisationSucceeded.booleanValue();
		}
		System.loadLibrary("gmp");
		initialisationSucceeded = initProlog() && initPrechacThis();
		return initialisationSucceeded;
	}

	private boolean initProlog() {
		try {
			// path must be the filename of a 32-bit boot.prc.
			// There are two possible approaches. First, compile swipl somthing
			// like:
			// export CFLAGS="-march=i686 -m32"
			// export LDFLAGS="-m32"
			// ./configure --host=i386 --build=i386 --disable-readline
			// --without-readline --without-gmp --disable-gmp
			// make
			// then nab swipl-32.prc

			// or put swi-pl's /boot directory in /sdcard/swi-boot, then cause
			// this code to run:
			// JPL.setNativeLibraryName("swipl");
			// JPL.init(new String[] { "swipl", "-O", "-o",
			// "/sdcard/boot32.prc", "-b", "/sdcard/swi-boot/init.pl" });
			// and grab /sdcard/boot32.prc afterwards.
			// You'll need to make sure your rc/build.c's rc_save_archive says
			// sprintf(tmp, "/sdcard/__tmp%d.prc", (int)getpid());
			// and not
			// sprintf(tmp, "__tmp%d.prc", (int)getpid());
			// JPL.init will exit the process once the boot file is built, so
			// don't freak out when that happens.

			String path = extractBootFile();
			JPL.setNativeLibraryName("swipl");
			JPL.init(makeArgs(path));
			//
		} catch (FileNotFoundException e) {
			Log.e(this.getClass().getName(), "trouble extracting boot file", e);
			return false;
		} catch (IOException e) {
			Log.e(this.getClass().getName(), "trouble extracting boot file", e);
			return false;
		}
		return true;
	}

	private String[] makeArgs(String path) {
		String[] defaultArgs = JPL.getDefaultInitArgs();
		String[] args = new String[defaultArgs.length];
		args[0] = path;
		for (int i = 1; i < defaultArgs.length; i++) {
			args[i] = defaultArgs[i];
		}
		return args;
	}

	private boolean initPrechacThis() {
		try {
			String filename = extractPlFile();

			Query query = new Query("load_files", new Term[] {
					new Atom(filename),
					new Compound(".", new Term[] {
							new Compound("imports", new Term[] { new Compound(
									".", new Term[] { new Atom("siteswap"),
											new Atom("[]") }) }),
							new Atom("[]") }) });
			query.hasSolution();
		} catch (FileNotFoundException e) {
			Log.e(this.getClass().getName(), "trouble extracting pl file", e);
			return false;
		} catch (IOException e) {
			Log.e(this.getClass().getName(), "trouble extracting pl file", e);
			return false;
		}
		return true;
	}

	private String extractBootFile() throws FileNotFoundException, IOException {
		return extractResourceToContextDir("boot", "boot32.prc", R.raw.boot32);
	}

	private String extractPlFile() throws FileNotFoundException, IOException {
		return extractResourceToContextDir("pl", "prechacthis.pl",
				R.raw.prechacthis);
	}

	private String extractResourceToContextDir(String contextDir,
			String fileName, int resourceId) throws FileNotFoundException,
			IOException {
		File bootFileDir = context.getDir(contextDir, 0);
		File bootFile = new File(bootFileDir, fileName);
		extractRawResource(bootFile, resourceId);
		return bootFile.getAbsolutePath();
	}

	private void extractRawResource(File bootFile, int id)
			throws FileNotFoundException, IOException {
		final int BUF_SIZE = 1024 * 8;
		BufferedInputStream assetInS = new BufferedInputStream(context
				.getResources().openRawResource(id));
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
