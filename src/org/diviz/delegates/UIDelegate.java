/**
 * 
 */
package org.diviz.delegates;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import eu.telecom_bretagne.praxis.client.ui.UI.UIDelegateAdapter;

/**
 * diviz' UIDelegate implements the logic to create an empty XMCDA file.
 * @author Sébastien Bigaret
 */
public class UIDelegate
    extends UIDelegateAdapter
{
	public static final String emptyXMCDA =
		"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
		+ "<xmcda:XMCDA xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
		+ "             xmlns:xmcda=\"http://www.decision-deck.org/2009/XMCDA-2.0.0\"\n"
		+ "             xsi:schemaLocation=\"http://www.decision-deck.org/2009/XMCDA-2.0.0 http://www.decision-deck.org/xmcda/_downloads/XMCDA-2.0.0.xsd\">\n"
		+ "</xmcda:XMCDA>\n";
	
	/**
	 * Creates the requested file and makes it an valid, empty XMCDA file.
	 * @return true if the empty XMCDA file was successfully created, false if the file already exists.
	 * @throws IOException
	 *             if the file could not be created, or if it could not be written. In the latter case, the methods
	 *             attempts to delete the newly created file.
	 */
	public boolean createEmptyFile(File file) throws IOException
	{
		if (!super.createEmptyFile(file))
			return false;
		try
		{
			FileWriter writer = new FileWriter(file);
			writer.write(emptyXMCDA);
			writer.close();
			return true;
		}
		catch (IOException ioe)
		{
			file.delete();
			throw ioe;
		}
	}
	
}
