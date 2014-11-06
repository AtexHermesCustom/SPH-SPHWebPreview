<%@ page language="java" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="de.atex.h11.custom.sph.export.webapp.*"%>
<%@ page import="sg.com.atex.simplexslt.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.unisys.media.cr.adapter.ncm.model.data.datasource.NCMDataSource" %>
<%@ page import="com.unisys.media.cr.adapter.ncm.common.data.pk.NCMObjectPK" %>

<%
        	NCMDataSource ds = null;
        	String strUser = request.getParameter("user");
	        String strPasswd = request.getParameter("password");
	        String strSessionId = request.getParameter("sessionid");
	        String strObjId = request.getParameter("id");
        	String strNodeType = request.getParameter("nodetype");

			String propertiesPath = getServletContext().getRealPath("/") + "WEB-INF/webpreview.properties";

			//Load Properties
			Properties properties = new Properties();
			properties.load(new FileInputStream(propertiesPath));
			
			//Get Properties
			String path = properties.getProperty("path");
			String xslFile = properties.getProperty("xslFile");
			String encoding = properties.getProperty("encoding");
			
			int debug = 0;
			if (properties.getProperty("debug") != null) {
			    debug = Integer.parseInt(properties.getProperty("debug"));
			}

	
			if (!strNodeType.equals("ncm-object")) {
			    throw new IllegalArgumentException("Provided object is of wrong type!");
			}

			if ((strUser == null || strPasswd == null) && strSessionId == null)
			    throw new IllegalArgumentException("User credentials required!");

			try {
			    if (strSessionId != null)
				ds = (NCMDataSource) DataSource.newInstance(strSessionId);
			    else
				ds = (NCMDataSource) DataSource.newInstance(strUser, strPasswd);

			    String[] sa = strObjId.split(":");


			    if (sa[0] == "0") {
				throw new IllegalArgumentException("Object is not part of a package!");
			    }

				// just use the story package id
			    //NCMObjectPK objPK = new NCMObjectPK(Integer.parseInt(sa[0]),
				//   Integer.parseInt(sa[1]), NCMObjectPK.LAST_VERSION, NCMObjectPK.ACTIVE);
				NCMObjectPK objPK = new NCMObjectPK(Integer.parseInt(sa[0]));				

			    StoryPackageExport spExp = new StoryPackageExport(ds);
			    File file = new File(path + sa[0] + ".xml");

			    spExp.export(objPK, file);

			    //set saxon as transformer
				System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");

				SimpleXSLT sx = new SimpleXSLT();
				sx.setEncoding(encoding);
			
				// Transform
				out.println(sx.simpleTransform(path + sa[0] + ".xml", xslFile));

				//Delete file after output if debug mode is off
				if (debug == 0) {	
				    file.delete();
				}
								
			} catch (Exception e) {
			    log("", e);
			    response.sendError(response.SC_CONFLICT, e.toString());
			} finally { 
			    out.close();
			    if (ds != null) ds.logout();
		}		
%>

