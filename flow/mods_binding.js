/*
Copyright 2005, 2007, 2008 University of Alberta Libraries  
    
This file is part of MODS Editor.

MODS Editor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MODS Editor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MODS Editor.  If not, see <http://www.gnu.org/licenses/>.
*/
cocoon.load("resource://org/apache/cocoon/forms/flow/javascript/Form.js");

function form2xml(form) {

	/*
	Get the documentURI parameter from the sitemap which contains the location of the file to be
	edited.
	*/
	var uuid = cocoon.parameters["uuid"];
	var documentURI = cocoon.parameters["documentURI"];
	var displayURI = cocoon.parameters["displayURI"];
	var successURI = cocoon.parameters["successURI"];
	var tag = cocoon.parameters["tag"];
	var fsk = cocoon.parameters["fsk"];
	var username = cocoon.parameters["username"];
	
	// set username in session for mods_bind.xml
	cocoon.session.setAttribute('username', username);
	
	// Parse the document to a DOM-tree
	// documentURI is in this form:  cocoon:/mods-data/mods/mods-empty.xml
	
	var document = loadDocument(documentURI);

	// Bind the document data to the form
	
	var lastSlash = documentURI.lastIndexOf('/')+1;
	var lastDot = documentURI.lastIndexOf('.');
	var fileName = documentURI.substring(lastSlash,lastDot);

	var directory = fileName.substring(2,5);
   
	form.load(document);

	// Show the form to the user until it is validated successfully
	form.showForm(displayURI, {document: document});

	// show the form to the user until it is validated successfully
cocoon.log.error("about to validate");
   if (form.isValid) {
cocoon.log.error("validation: isValid");

	// Bind the form's data to the document
	form.save(document);
   }
cocoon.log.error("finished validation");

   // if there is a "tag" param, use it as the file name to save to
	if (tag != '')
      fileName = tag;
	
	cocoon.sendPage(successURI, {document: document, documentURI: fileName, uuid: uuid, directory: directory, fsk: fsk});
}


function form2simpleXML(form) {

	/*
	Get the documentURI parameter from the sitemap which contains the location of the file
	to be edited.
	*/
	var documentURI = cocoon.parameters["documentURI"];

	// populate the form
	form.loadXML(documentURI);

	// save the content of the form to a file
	form.saveXML(makeTargetURI(documentURI));
   
	// show the XML generated from the form
	cocoon.sendPage("form2simpleXML-success-pipeline", form.getXML());
}


function loadDocument(uri){

	var parser = null;
	var source = null;
	var resolver = null;
	try
	{
		parser = cocoon.getComponent(Packages.org.apache.excalibur.xml.dom.DOMParser.ROLE);
		resolver = cocoon.getComponent(Packages.org.apache.cocoon.environment.SourceResolver.ROLE);
		source = resolver.resolveURI(uri);
		var is = new Packages.org.xml.sax.InputSource(source.getInputStream());
		is.setSystemId(source.getURI());
		return parser.parseDocument(is);
	}
	finally {
		if (source != null)
			resolver.release(source);
		cocoon.releaseComponent(parser);
		cocoon.releaseComponent(resolver);
		
	}
}

function saveDocument(document, uri) {

	var source = null;
	var resolver = null;
	var outputStream = null;

	try
	{
		resolver = cocoon.getComponent(Packages.org.apache.cocoon.environment.SourceResolver.ROLE);
		source = resolver.resolveURI(uri);

		var tf = Packages.javax.xml.transform.TransformerFactory.newInstance();

		if (source instanceof Packages.org.apache.excalibur.source.ModifiableSource && tf.getFeature(Packages.javax.xml.transform.sax.SAXTransformerFactory.FEATURE))
		{
			outputStream = source.getOutputStream();
			var transformerHandler = tf.newTransformerHandler();
			var transformer = transformerHandler.getTransformer();
			transformer.setOutputProperty(Packages.javax.xml.transform.OutputKeys.INDENT,"true");
			transformer.setOutputProperty(Packages.javax.xml.transform.OutputKeys.METHOD,"xml");
			transformerHandler.setResult(new Packages.javax.xml.transform.stream.StreamResult(outputStream));

			var streamer = new Packages.org.apache.cocoon.xml.dom.DOMStreamer(transformerHandler);
			streamer.stream(document);
		}
		else 
		{
			throw new Packages.org.apache.cocoon.ProcessingException("Cannot write to source " + uri);
		}
	}
	finally
	{
		if (source != null)
			resolver.release(source);
		cocoon.releaseComponent(resolver);
		if (outputStream != null)
		{
			try
			{
				outputStream.flush();
				outputStream.close();
			} 
			catch (error) {
				cocoon.log.error("Could not flush/close outputstream: " + error);
				
				}
			}
		}
	}
