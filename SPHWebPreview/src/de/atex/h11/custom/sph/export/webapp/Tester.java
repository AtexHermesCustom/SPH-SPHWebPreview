package de.atex.h11.custom.sph.export.webapp;

import java.io.*;
import de.atex.h11.custom.sph.export.webapp.DataSource;
import com.unisys.media.cr.adapter.ncm.model.data.datasource.NCMDataSource;
import com.unisys.media.cr.adapter.ncm.common.data.pk.NCMObjectPK;

public class Tester {
    private static NCMDataSource ds = null;

    //private static final String HERMES_USER = "MARIANOJP";
    //private static final String HERMES_PASSWD = "j";
    private static final String HERMES_USER = "BATCH";
    private static final String HERMES_PASSWD = "BATCH";
    
    //story package id
    //test ids: 9850, 9921
    private static final int SPID = 25751;

    /*
     note: jndi.properties and auth.conf files are in the class path
	 app ran with this argument:
	   -Djava.security.auth.login.config=auth.conf
	*/
    
    public static void main(String[] args) {
        try {
        	System.out.println("Ready... Set... Go!");
        	
        	// connect
        	ds = DataSource.newInstance(HERMES_USER, HERMES_PASSWD);
        	
        	// find story pkg
			NCMObjectPK objPK = new NCMObjectPK(SPID);		

			// export to file
		    File file = new File("work/" + SPID + "-out.xml");
		    StoryPackageExport spExp = new StoryPackageExport(ds);
		    spExp.export(objPK, file); 	
        	
        	System.out.println("I'm done! Success!");
        
        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(1);
        }
    }
}
