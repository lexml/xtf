package org.cdlib.xtf.util;

import java.io.File;

/**
 * File para arquivos de configuração relativos a um diretório base.
 * 
 * @author fragomeni
 */
@SuppressWarnings("serial")
public class ConfigFile extends File {
	
	private static File BASE_DIR;
	
	public ConfigFile(String path) {
		super(BASE_DIR, path);
	}
	
	public static void setBaseDir(File baseDir) {
		ConfigFile.BASE_DIR = baseDir; 
	}

}
