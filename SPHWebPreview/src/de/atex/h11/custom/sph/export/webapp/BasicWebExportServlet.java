/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.atex.h11.custom.sph.export.webapp;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.File;
//import org.jboss.util.property.Property;
import com.unisys.media.cr.adapter.ncm.model.data.datasource.NCMDataSource;
import com.unisys.media.cr.adapter.ncm.common.data.pk.NCMObjectPK;

/**
 *
 * @author tstuehler
 */
public class BasicWebExportServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        NCMDataSource ds = null;

        String strUser = request.getParameter("user");
        String strPasswd = request.getParameter("password");
        String strSessionId = request.getParameter("sessionid");
        String strObjId = request.getParameter("id");
        String strNodeType = request.getParameter("nodetype");

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
            NCMObjectPK objPK = new NCMObjectPK(Integer.parseInt(sa[0]),
                    Integer.parseInt(sa[1]), NCMObjectPK.LAST_VERSION, NCMObjectPK.ACTIVE);

            StoryPackageExport spExp = new StoryPackageExport(ds);
            File file = new File("/hedata/export/web/" + sa[0] + ".xml");
            spExp.export(objPK, file);

            out.println("<html>");
            out.println("<head>");
            out.println("<title>BasicWebExportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>" + "Object " + strObjId
                    + " has been exported to " + file + "." + "</h1>");
            out.println("</body>");
            out.println("</html>");

        } catch (Exception e) {
            log("", e);
            response.sendError(response.SC_CONFLICT, e.toString());
        } finally { 
            out.close();
            if (ds != null) ds.logout();
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
