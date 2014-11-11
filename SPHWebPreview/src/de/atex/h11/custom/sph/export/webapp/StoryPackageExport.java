/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.atex.h11.custom.sph.export.webapp;

import java.io.File;
import java.io.IOException;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Vector;

import com.unisys.media.cr.adapter.ncm.model.data.datasource.NCMDataSource;
import com.unisys.media.cr.adapter.ncm.model.data.values.NCMObjectValueClient;
import com.unisys.media.extension.common.serialize.xml.XMLSerializeWriter;
import com.unisys.media.extension.common.serialize.xml.XMLSerializeWriterException;
import com.unisys.media.cr.adapter.ncm.common.data.pk.NCMObjectPK;
import com.unisys.media.cr.adapter.ncm.common.data.values.NCMObjectBuildProperties;

/**
 *
 * @author tstuehler
 */
public class StoryPackageExport {

    public StoryPackageExport (NCMDataSource ds) {
        this.ds = ds;
    }
    
    public void export (NCMObjectPK objPK, File file) 
            throws UnsupportedEncodingException, IOException,
                   XMLSerializeWriterException {
        NCMObjectBuildProperties objProps = new NCMObjectBuildProperties();
        objProps.setGetByObjId(true);
        objProps.setIncludeObjContent(true);
        objProps.setIncludeSpChild(true);
        objProps.setIncludeVariants(true);
        objProps.setIncludeLinkedObject(true);
        objProps.setTextFormat("text/unisys");
        objProps.setIncludeMetadataGroups(new Vector<String>());
        objProps.setIncludeMetadataChild(true);
        objProps.setIncludeAttachments(true);        
        objProps.setIncludeIPTC(true); //to include dispatcher for images
        //objProps.setIncludeConvertTo("Neutral");
        objProps.setIncludeConvertTo("Xhtml"); //converted format
        objProps.setXhtmlNestedAsXml(true); //important to nest resulting xhtml as xml
        /*
        objProps.setIncludeLayContent(true);
        objProps.setIncludeLay(true);     
        objProps.setIncludeLayObjContent(true);
        objProps.setIncludeCaption(true);
        objProps.setIncludeCreditBox(true);
        objProps.setIncludeTextPreview(true);
        objProps.setXhtmlNestedAsXml(true);
        */
        NCMObjectValueClient objVC = (NCMObjectValueClient) ds.getNode(objPK, objProps);
        if (objVC.getType() != 17) {
            throw new IllegalArgumentException("Provided object is not a story package!");
        }
        //output
        XMLSerializeWriter w = new XMLSerializeWriter(new FileOutputStream(file));
        w.writeObject(objVC, objProps);
        w.close();
    }

    private NCMDataSource ds = null;

}
