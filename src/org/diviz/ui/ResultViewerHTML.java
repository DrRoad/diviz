package org.diviz.ui;

import java.awt.BorderLayout;
import java.awt.Desktop;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JEditorPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.border.EtchedBorder;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;
import org.lobobrowser.html.UserAgentContext;
import org.lobobrowser.html.gui.HtmlPanel;
import org.lobobrowser.html.test.SimpleHtmlRendererContext;
import org.lobobrowser.html.test.SimpleUserAgentContext;
import org.xml.sax.SAXException;

import eu.telecom_bretagne.praxis.client.ui.Common;
import eu.telecom_bretagne.praxis.client.ui.results.viewers.FileFormat;
import eu.telecom_bretagne.praxis.client.ui.results.viewers.FileViewer;
import eu.telecom_bretagne.praxis.common.Base64Coder;
import eu.telecom_bretagne.praxis.common.FileResources;
import eu.telecom_bretagne.praxis.common.I18N;
import eu.telecom_bretagne.praxis.common.Log;
import eu.telecom_bretagne.praxis.common.PraxisPreferences;
import eu.telecom_bretagne.praxis.common.Utile;
import eu.telecom_bretagne.praxis.common.FileResources.ResourceNotFoundException;

/**
 * This is the viewer dedicated to the diviz project. It displays XMCDA results in a browser, after extracting from
 * XMCDA files the base-64 encoded images.
 * @implementation For performance reason, the (lobo)browser is shared by all tabs; its content is refreshed when
 *                 needed (when navigating through tabs or when the XML/HTML View button is pressed. Two methods cache
 *                 their results in a dedicated directory: {@link #extractImages()} and {@link #displayXMCDAContent()}
 *                 cache respectively the images extracted from XMCDA files and the generated html.
 */
public class ResultViewerHTML
    extends JPanel
{
	private static final long                serialVersionUID         = -1902400106618074400L;
	
	private static HtmlPanel                 htmlPanel;
	
	// Cobra renderer
	private static UserAgentContext          uContext;
	
	private static SimpleHtmlRendererContext rContext;
	
	private static Transformer               transformer              = null;
	
	private static String                    css                      = null;
	
	// GUI components
	private JPanel                           panelAction              = null;
	
	private JComboBox                        comboBoxViewersSelection = null;
	
	private JPanel                           jPanel                   = null;
	
	private JScrollPane                      jScrollPane              = null;
	
	private JEditorPane                      viewFilePane             = null;
	
	private JButton                          switchXmlHtmlViewButton  = null;
	
	private JButton                          openExternalBrowserButton = null;

	private boolean                          htmlView                  = true;
	
	// File
	private File                             resultFile               = null;
	
	private File                             imagesDir                = null;
	
	private java.text.DecimalFormat          format                   = new java.text.DecimalFormat("00");
	
	transient String                         htmlContent_cache        = null;
	
	/**
	 * The date before which the cached results should be reset and re-calculated, because the xsl has been modified.
	 * It is parsed when the class is initialized and stored in {@link #updateResultsBeforeDate}.
	 */
	static private final String              updateResultsBeforeDateString = "2010-04-04T00:00:00.000+0200";

	/**
	 * @see #updateResultsBeforeDateString
	 */
	static private Date                     updateResultsBeforeDate;

	static
	{
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
		try
        {
			updateResultsBeforeDate = dateFormat.parse(updateResultsBeforeDateString);
        }
        catch (ParseException e1)
        {
        	// will not happen
	        e1.printStackTrace();
        }
        
		// Don't display logs from cobra renderer (lobo)
		Logger.getLogger("org.lobobrowser").setLevel(Level.OFF);
		
		// XSLT
		TransformerFactory tFactory = TransformerFactory.newInstance();
		try
		{
			StreamSource xslt = new StreamSource(FileResources
			        .inputStreamForResource("configuration/client/XMCDA_viewer/xmcdaXSL.xsl"));
			transformer = tFactory.newTransformer(xslt);
		}
		catch (TransformerConfigurationException e)
		{
			e.printStackTrace();
		}
		catch (ResourceNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// CSS
		try
		{
			css = Utile.getContentOfTextStream(FileResources
			        .inputStreamForResource("configuration/client/XMCDA_viewer/cssStyle.css"));
			String backgroundURL = "";/*
									   * "file:///" + System.getProperty("user.dir") +
									   * "/configuration/client/XMCDA_viewer/divizLogoBackground.png"; backgroundURL =
									   * backgroundURL.replaceAll("\\\\", "/");
									   */
			css = css.replaceAll("BACKGROUND_URL", backgroundURL);
		}
		catch (ResourceNotFoundException e)
		{
			// TODO Auto-generated catch block
			Log.log.log(Level.WARNING, "The CSS file wasn't found!", e);
			css = "";
		}
		initRendering();
	}
	
	/**
	 * This method initializes
	 * @throws JDOMException
	 * @throws IOException
	 * @throws SAXException
	 * @throws TransformerException
	 * @throws IOException
	 */
	public ResultViewerHTML(File resultFile)
	{
		super();
		this.resultFile = resultFile;
		try
		{
			initialize();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * This method initializes this
	 * @throws JDOMException
	 * @throws IOException
	 * @throws SAXException
	 * @throws TransformerException
	 * @throws IOException
	 */
	private void initialize()
	{
		// GUI initialization
		this.setLayout(new BorderLayout());
		this.setSize(new java.awt.Dimension(566, 602));
		//this.add(getHTMLViewer(), BorderLayout.CENTER);
		this.add(getJPanel(), BorderLayout.NORTH);
		jScrollPane = getJScrollPane();
		// HTML viewer initialization
		initImagesDir();
		getHTMLViewer();
		displayXMCDAContent();
	}
	
	private boolean initImagesDir()
	{
		File parent = resultFile.getParentFile();
		imagesDir = new File(parent.getAbsolutePath(), "diviz_generated_images");
		if (!imagesDir.exists())
		{
			imagesDir.mkdir();
			return true;
		}
		return false;
	}
	
	private static void initRendering()
	{
		uContext = new SimpleUserAgentContext();
		rContext = new SimpleHtmlRendererContext(getHTMLViewer(), uContext);
	}
	
	private void disableSwitchButtonAndDisplayRawText()
	{
		getSwitchXmlHtmlViewButton().setVisible(false);
		htmlView = true;
		getSwitchXmlHtmlViewButton().doClick();
	}
	
	private void displayXMCDAContent()
	{
		boolean imagesFound;
		// Extracts images if exists
		try
		{
			imagesFound = extractImages();
		}
		catch (Exception e)
		{
			//e.printStackTrace();
			disableSwitchButtonAndDisplayRawText();
			return;
		}
		// If images inside the document, a modified document was generated.
		Source xml = null;
		
		// The url String must be supplied to HtmlPanel.setHtml() in order to load included images with its
		// relative paths
		String url = "file://" + imagesDir.getAbsolutePath()+"/";
		if (htmlContent_cache!=null)
		{
			// avoid a round-trip to the FS
			htmlPanel.setHtml(htmlContent_cache, url, rContext);
			return;
		}
		String HTMLFilename = resultFile.getName() + ".html";
		File HTMLFile = new File(imagesDir, HTMLFilename);

		if (HTMLFile.exists())
		{
			// The url String must be set in order to load included images with its
			// relative paths
			htmlPanel.setHtml(Utile.getContentOfTextFile(HTMLFile), url, rContext);
			return;
		}
		if (imagesFound)
		{
			String filename = resultFile.getName();
			xml = new StreamSource(new File(imagesDir, filename + ".modified.xml"));
		}
		else
			xml = new StreamSource(resultFile);
		
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		Result html = new StreamResult(outStream);
		
		// XSLT transformation
		String currentHtmlSource;
		try
		{
			transformer.transform(xml, html);
			currentHtmlSource = outStream.toString("UTF-8");
		}
		catch (TransformerException e)
		{
			disableSwitchButtonAndDisplayRawText();
			return;
		}
		catch (UnsupportedEncodingException e)
		{
			disableSwitchButtonAndDisplayRawText();
			return;
		}
		currentHtmlSource = currentHtmlSource.replaceAll("CSS_STYLES", "<!--\n" + css + "\n-->");
		
		BufferedOutputStream htmlOS;
		try
		{
			htmlOS = new BufferedOutputStream(new FileOutputStream(HTMLFile));
			htmlOS.write(currentHtmlSource.getBytes());
			htmlOS.flush();
			htmlOS.close();
		}
		catch (IOException e)
		{
			Log.log.log(Level.WARNING, "Unable to cache HTML source for file " + HTMLFilename, e);
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		htmlPanel.setHtml(currentHtmlSource, url, rContext);
	}
	
	static File lastResult = null;
	
	/**
	 * Overrides the default repaint() method so that the HTML view is refreshed when needed, i.e.: when switching
	 * from one tab to another, and when the XML/HTML View button is pressed.
	 */
	@Override
	public void repaint()
	{
		if (isVisible() && resultFile != null) // make sure it's initialized
		{
			if (htmlView && (lastResult == null || lastResult != resultFile))
			{
				// reset the content of the internal browser
				displayXMCDAContent();
				lastResult = resultFile;
			}
			if (htmlView)
			{
				remove(jScrollPane);
				remove(htmlPanel);
				add(htmlPanel, BorderLayout.CENTER);
			}
			else
			{
				remove(htmlPanel);
				remove(jScrollPane);
				add(jScrollPane, BorderLayout.CENTER);
			}
		}
		super.repaint();
		// htmlPanel.setEnabled(true);
	}
	@Override
	protected void paintComponent(Graphics g)
	{
		if(PraxisPreferences.getBoolean("display","antiAliasing"))
		{
			Graphics2D g2D = (Graphics2D) g;
			g2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
			                     RenderingHints.VALUE_ANTIALIAS_ON);
		}
	    super.paintComponent(g);
	}
	
	/**
	 * Examines the (xml) result and copies it into a file suffixed with ".modified.xml". If the result file contains
	 * images, they are extracted and stored on the filesystem, and the base64-encoded images in the "modified" xml
	 * are replaced by images' references.
	 * @return {@code true} if the result file contains images, {@code false} otherwise.
	 * @throws JDOMException
	 * @throws IOException
	 */
	private boolean extractImages() throws JDOMException, IOException
	{
		String filename = resultFile.getName();
		File newXMLFile = new File(imagesDir, filename + ".modified.xml");
		if (newXMLFile.exists() && newXMLFile.lastModified()>updateResultsBeforeDate.getTime())
		{
			// the file .modified.xml exists and is recent enough, no need to (re)generate it
			return true;
		}
		else
		{
			// delete the file and the corresponding html
			newXMLFile.delete();
			new File(imagesDir, filename + ".html").delete();
		}
		
		SAXBuilder builder = new SAXBuilder();
		builder.setIgnoringElementContentWhitespace(true);
		org.jdom.Document document = builder.build(resultFile);
		
		// Search for all images in the XML document
		XPath xpath = XPath.newInstance("//image");
		@SuppressWarnings("unchecked")
		java.util.List<Element> imageElements = xpath.selectNodes(document);
		
		for (int i = 0; i < imageElements.size(); i++)
		{
			// Test whether the file exists
			String number = format.format(i + 1);
			String imageFilename = filename + "_img_" + number + ".png";
			Element imageElement = imageElements.get(i);

			if (!new File(imagesDir.getAbsolutePath() + File.separator + imageFilename).exists())
			{
				// Decode content
				String imageBase64 = imageElement.getText();
				byte[] decodedImage = Base64Coder.decode(imageBase64);
				
				// Write the image on disk
				BufferedOutputStream out;
				out = new BufferedOutputStream(new FileOutputStream(imagesDir.getAbsolutePath() + File.separator
				                                                    + imageFilename));
				out.write(decodedImage);
				out.flush();
			}
			// Replace the content by the reference to the image stored on the disk
			Element parentElement = imageElement.getParentElement();
			parentElement.removeChild("image");
			Element imageRefElement = new Element("imageRef");
			imageRefElement.setText("./"+imageFilename);
			parentElement.addContent(imageRefElement);
		}
		
		// Write on the disk the modified XML file: name = xxx.modified.xml
		
		Format fmt = Format.getPrettyFormat();
		fmt.setIndent("  ");
		fmt.setTextMode(Format.TextMode.NORMALIZE);
		XMLOutputter xmlOut = new XMLOutputter(fmt);
		BufferedWriter outFile;
		outFile = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(newXMLFile.getPath()),
		                                                    java.nio.charset.Charset.forName("UTF-8")));
		xmlOut.output(document, outFile);
		outFile.close();
		if (imageElements.size() == 0)
			return false;
		

		return true;
	}
	
	/**
	 * This method initializes panelAction
	 * @return javax.swing.JPanel
	 * @throws IOException
	 */
	private JPanel getPanelAction()
	{
		if (panelAction == null)
		{
			BorderLayout bl = new BorderLayout();
			bl.setHgap(10);
			panelAction = new JPanel(bl);
			if (Common.RESULTS_EXTERNAL_VIEWER_COLOR_BG != null)
				jPanel.setBackground(Common.RESULTS_EXTERNAL_VIEWER_COLOR_BG);
			panelAction.add(getOpenExternalBrowserButton(), BorderLayout.WEST);
			panelAction.add(getSwitchXmlHtmlViewButton(), BorderLayout.CENTER);
			panelAction.add(getComboBoxViewersSelection(), BorderLayout.EAST);
			panelAction.revalidate();
		}
		return panelAction;
	}
	
	private static HtmlPanel getHTMLViewer()
	{
		if (htmlPanel == null)
		{
			htmlPanel = new HtmlPanel();
			htmlPanel.setBorder(BorderFactory.createEtchedBorder(EtchedBorder.LOWERED));
		}
		return htmlPanel;
	}
	
	/**
	 * This method initializes jScrollPane
	 * @return javax.swing.JScrollPane
	 */
	private JScrollPane getJScrollPane()
	{
		if (jScrollPane == null)
		{
			jScrollPane = new JScrollPane();
			jScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
			jScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
			try
			{
				jScrollPane.setViewportView(getViewFilePane());
			}
			catch (Exception e)
			{
				jScrollPane.setViewportView(new javax.swing.JLabel(e.getMessage()));
			}
		}
		return jScrollPane;
	}
	
	/**
	 * This method initializes viewFilePane
	 * @return javax.swing.JEditorPane
	 * @throws IOException
	 * @throws MalformedURLException
	 */
	private JEditorPane getViewFilePane() throws MalformedURLException, IOException
	{
		if (viewFilePane == null)
		{
			viewFilePane = new JEditorPane();
			// L'utilisation de "setPage(resultFile.toURI().toURL())" empêche (certaines
			// fois...) de supprimer le résultat (descripteur de fichier qui reste ouvert).
			// La méthode "getContentOfTextFile" lit le fichier, le referme puis renvoie
			// le contenu sous la forme d'une String qui est ensuite affectée au JEditorPane.
			// viewFilePane.setPage(resultFile.toURI().toURL());
			viewFilePane.setText(Utile.getContentOfTextFile(resultFile));
			
			viewFilePane.setEditable(false);
			viewFilePane.setFont(new java.awt.Font("Monospaced", java.awt.Font.PLAIN, 12));
			if (Common.BACKGROUND_COLOR != null)
				viewFilePane.setBackground(Common.BACKGROUND_COLOR);
			if (Common.BACKGROUND_SELECTION_COLOR != null)
				viewFilePane.setSelectionColor(Common.BACKGROUND_SELECTION_COLOR);
			if (Common.SELECTED_TEXT_COLOR != null)
				viewFilePane.setSelectedTextColor(Common.SELECTED_TEXT_COLOR);
			viewFilePane.setCaretPosition(0);
		}
		return viewFilePane;
	}
	
	/**
	 * This method initializes comboBoxVierversSelection
	 * @return javax.swing.JComboBox
	 */
	private JComboBox getComboBoxViewersSelection()
	{
		if (comboBoxViewersSelection == null)
		{
			String fileType = null;
			try
			{
				fileType = FileFormat.getFileType(resultFile);
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
			java.util.ArrayList<FileViewer> viewers = FileViewer.getAvailableViewers(fileType);
			viewers.add(0, new FileViewer("Select an external viewer...", null, (String[])null, null, null));

			comboBoxViewersSelection = new JComboBox(viewers.toArray(new FileViewer[viewers.size()]));
			comboBoxViewersSelection.addActionListener(new java.awt.event.ActionListener() {
				public void actionPerformed(java.awt.event.ActionEvent e)
				{
					FileViewer visio = (FileViewer) comboBoxViewersSelection.getSelectedItem();
					visio.execute(resultFile.getAbsolutePath());
				}
			});
		}
		return comboBoxViewersSelection;
	}
	
	/**
	 * This method initializes jPanel
	 * @return javax.swing.JPanel
	 */
	private JPanel getJPanel()
	{
		if (jPanel == null)
		{
			jPanel = new JPanel();
			jPanel.setLayout(new BorderLayout());
			jPanel.setBorder(BorderFactory.createEtchedBorder(EtchedBorder.LOWERED));
			if (Common.RESULTS_EXTERNAL_VIEWER_COLOR_BG != null)
				jPanel.setBackground(Common.RESULTS_EXTERNAL_VIEWER_COLOR_BG);
			jPanel.add(getPanelAction(), BorderLayout.EAST);
		}
		return jPanel;
	}
	
	/**
	 * This method initializes switchXmlHtmlViewButton
	 * @return javax.swing.JButton
	 */
	private JButton getSwitchXmlHtmlViewButton()
	{
		final JPanel _this = this;
		if (switchXmlHtmlViewButton == null)
		{
			switchXmlHtmlViewButton = new JButton();
			switchXmlHtmlViewButton.setText("XML view");
			switchXmlHtmlViewButton.addActionListener(new java.awt.event.ActionListener() {
				public void actionPerformed(java.awt.event.ActionEvent e)
				{
					if (htmlView)
					{
						switchXmlHtmlViewButton.setText("HTML view");
						htmlView = false;
						_this.repaint();
					}
					else
					{
						switchXmlHtmlViewButton.setText("XML view");
						htmlView = true;
						_this.repaint();
					}
				}
			});
		}
		return switchXmlHtmlViewButton;
	}

	private JButton getOpenExternalBrowserButton()
	{
		if (openExternalBrowserButton == null)
		{
			openExternalBrowserButton = new JButton();
			openExternalBrowserButton.setText(I18N.s("UI.results.open_in_external_browser"));
			openExternalBrowserButton.addActionListener(new java.awt.event.ActionListener() {
				public void actionPerformed(java.awt.event.ActionEvent e)
				{
					try
                    {
						Desktop.getDesktop().browse(new File(imagesDir, resultFile.getName() + ".html").toURI());
                    }
                    catch (IOException e1)
                    {
	                    e1.printStackTrace();
                    }
				}
			});
			openExternalBrowserButton.setEnabled(Desktop.isDesktopSupported()
			                       && Desktop.getDesktop().isSupported(Desktop.Action.BROWSE));
		}
		return openExternalBrowserButton;
	}

}
