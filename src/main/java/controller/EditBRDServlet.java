package controller;

import service.AIService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class EditBRDServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String existingBRD   = request.getParameter("existingBRD");
        String userInstruction = request.getParameter("userInstruction");
        String projectName   = request.getParameter("projectName");

        HttpSession session = request.getSession();

        if (existingBRD == null || existingBRD.trim().isEmpty()) {
            session.setAttribute("generateError", "No BRD content found to edit.");
            response.sendRedirect("generate-brd.jsp");
            return;
        }

        if (userInstruction == null || userInstruction.trim().isEmpty()) {
            // No instruction given — put the BRD back and show error
            session.setAttribute("generatedBRD", existingBRD);
            session.setAttribute("brdProjectName", projectName);
            session.setAttribute("editError", "Please enter an instruction before applying.");
            response.sendRedirect("brd-result.jsp");
            return;
        }

        try {
            AIService ai = new AIService();
            String updatedBRD = ai.editBRD(existingBRD, userInstruction.trim());

            session.setAttribute("generatedBRD", updatedBRD);
            session.setAttribute("brdProjectName", projectName);
            session.setAttribute("editSuccess", "BRD updated: \"" + userInstruction.trim() + "\"");
            response.sendRedirect("brd-result.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("generatedBRD", existingBRD);
            session.setAttribute("brdProjectName", projectName);
            session.setAttribute("editError", "Edit failed: " + e.getMessage());
            response.sendRedirect("brd-result.jsp");
        }
    }
}
