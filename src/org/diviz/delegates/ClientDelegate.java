// LICENSE
package org.diviz.delegates;

import eu.telecom_bretagne.praxis.common.Configuration;
import eu.telecom_bretagne.praxis.common.Environment;
import eu.telecom_bretagne.praxis.common.PraxisPreferences;

/**
 * @author Sébastien Bigaret
 *
 */
public class ClientDelegate
    implements eu.telecom_bretagne.praxis.client.Client.ClientDelegate
{

	@Override
	public void authenticatedConnectionEstablished()
    {
    	String _url = Configuration.get("client_delegate.connected_url", "");
    	_url = _url.trim();
    	if ("".equals(_url))
    	{
    		return;
    	}
    	_url += "?id="+PraxisPreferences.get("client", Environment.getLooseCredentialsConfigurationName());

    	try
        {
	        java.net.URL url = new java.net.URL(_url);
	        java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
	        conn.connect();
	        java.io.BufferedReader rd = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream()));
	        while (rd.readLine() != null); /* ignore answer */
	        rd.close();
        }
        catch (Exception e)
        {
        	//e.printStackTrace();
        }
    }

}
