package sg.com.atex.simplexslt;

import java.io.File;
import java.io.StringWriter;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.OutputKeys;

public class SimpleXSLT {

	String encoding = "UTF-8";
	
	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	public String simpleTransform(String source, String xslt) {
		TransformerFactory tFactory = TransformerFactory.newInstance();
		StringWriter xmlOutWriter = new StringWriter();
			
		try {
			Transformer transformer = tFactory.newTransformer(new StreamSource(new File(xslt)));
			transformer.setOutputProperty(OutputKeys.ENCODING, this.encoding);
			transformer.transform(new StreamSource(new File(source)), new StreamResult(xmlOutWriter));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return xmlOutWriter.toString();		
	}

	public void simpleTransformToFile(String source, String xslt, String dest) {
       	TransformerFactory tFactory = TransformerFactory.newInstance();

	    try {
       	    Transformer transformer = tFactory.newTransformer(new StreamSource(new File(xslt)));
			transformer.setOutputProperty(OutputKeys.ENCODING, this.encoding);
	        transformer.transform(new StreamSource(new File(source)), new StreamResult(new File(dest)));

	    } catch (Exception e) {
			e.printStackTrace();
	    }
    }

}