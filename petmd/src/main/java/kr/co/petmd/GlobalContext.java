package kr.co.petmd;

import java.io.InputStream;
import java.net.URL;
import java.util.Properties;

public class GlobalContext {
	
	static Properties properties;
	
	public static URL getResourceURL(String path) throws ClassNotFoundException{
		return  Thread.currentThread().getContextClassLoader().getResource(path);
	}
	
	public static Class loadClass(String className) throws ClassNotFoundException {
		return  Thread.currentThread().getContextClassLoader().loadClass(className);
	}
	
	public static ClassLoader getClassLoader() throws ClassNotFoundException{
		return Thread.currentThread().getContextClassLoader();
	}
		
	public static Properties getProperties() {
		if(properties==null){
			try {
				URL url = null;
								
				url = getResourceURL("kr/co/petmd/allpet.properties");

				if (url != null) {
					InputStream is = url.openStream();
					properties = new Properties();
					properties.load(is);
					is.close();
					
					if(properties.containsKey("content.reference.url")){
						String realFileURL = (String) properties.get("content.reference.url");
						is = new URL(realFileURL).openStream();
						properties.load(is);
						is.close();
					}

					System.out.println("Loading " + url);
				}
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}

		return properties;
	}
		
	public static String getPropertyString(String key, String defaultValue){
		Properties sysProp = getProperties();
			
		if(sysProp!=null)
			return sysProp.getProperty(key, defaultValue);
				
		return defaultValue;
	}
	
	public static String getPropertyString(String key){
		return getPropertyString(key, null);
	}

}
