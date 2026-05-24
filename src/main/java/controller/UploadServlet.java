package controller;

import dao.CommunicationDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class UploadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String sourceType  = request.getParameter("sourceType");
        String senderName  = request.getParameter("senderName");
        String projectName = request.getParameter("projectName");
        String content     = request.getParameter("content");

        HttpSession session = request.getSession();

        if (projectName == null || projectName.trim().isEmpty()) {
            session.setAttribute("uploadError", "Project name is required.");
            response.sendRedirect("index.jsp");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            session.setAttribute("uploadError", "Content cannot be empty.");
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            CommunicationDAO dao = new CommunicationDAO();
            dao.saveCommunication(sourceType, senderName, projectName, content);

            // Post-Redirect-Get: prevents duplicate form submissions on refresh
            session.setAttribute("uploadSuccess", projectName.trim());
            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("uploadError", "Database error: " + e.getMessage());
            response.sendRedirect("index.jsp");
        }
    }
}
