/* License: please refer to the file README.license located at the root directory of the project */
/**
 * 
 */
package org.diviz.delegates;

import eu.telecom_bretagne.praxis.client.Client;
import eu.telecom_bretagne.praxis.client.ui.UI;
import eu.telecom_bretagne.praxis.core.workflow.Program;

/**
 * The "root" delegate, it is responsible for registering the delegates for project diviz.
 * @author Sébastien Bigaret
 */
public class InitialisationDelegate
    extends eu.telecom_bretagne.praxis.common.Launcher.InitialisationDelegate
{   
	/**
	 * Registers:
	 * <ul>
	 * <li> {@link ProgramDelegate}
	 * <ul>
	 */
	@Override
	public void initialize(boolean client, boolean server, boolean platform)
	{
		Program.delegate = new ProgramDelegate();
		if (client)
		{
			UI.setDelegate(new UIDelegate());
			Client.uiClient.setDelegate(new ClientDelegate());
		}
	}
}
