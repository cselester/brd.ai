package controller;

import dao.CommunicationDAO;
import service.AIService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GenerateBRDServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("generate-brd.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String projectName = request.getCharacterEncoding();
        projectName = request.getParameter("projectName");

        HttpSession session = request.getSession();

        if (projectName == null || projectName.trim().isEmpty()) {
            session.setAttribute("generateError", "Project name is required.");
            response.sendRedirect("generate-brd.jsp");
            return;
        }

        try {
            CommunicationDAO dao = new CommunicationDAO();
            String projectData = dao.getProjectCommunications(projectName.trim());

            if (projectData == null || projectData.trim().isEmpty()) {
                session.setAttribute("generateError",
                    "No data found for project: '" + projectName + "'. Please upload communications first.");
                response.sendRedirect("generate-brd.jsp");
                return;
            }

            AIService ai = new AIService();
            String brdContent = ai.generateBRD(projectData);

            // Store in session and redirect (Post-Redirect-Get pattern)
            session.setAttribute("generatedBRD", brdContent);
            session.setAttribute("brdProjectName", projectName.trim());
            response.sendRedirect("brd-result.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("generateError", "Error: " + e.getMessage());
            response.sendRedirect("generate-brd.jsp");
        }
    }
}
