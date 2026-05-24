package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class AIService {

    // Load API key from environment variable (never hardcode secrets)
    private static final String API_KEY =
        System.getenv("GROQ_API_KEY") != null
            ? System.getenv("GROQ_API_KEY")
            : "";

    private static final String API_URL =
        "https://api.groq.com/openai/v1/chat/completions";

    // Valid Groq model (fixed from invalid "openai/gpt-oss-120b")
    private static final String MODEL = "llama-3.3-70b-versatile";

    // =========================================
    // GENERATE BRD
    // =========================================

    public String generateBRD(String communicationText) {

        if (communicationText == null || communicationText.trim().isEmpty()) {
            return "<p>No communication data found for this project.</p>";
        }

        String prompt =
            "You are a professional Business Analyst. " +
            "Analyze ONLY the provided project communications. " +
            "Generate a clean and professional Business Requirements Document (BRD). " +
            "Do NOT invent data, names, dates, or metrics unless explicitly mentioned. " +
            "If information is missing, write: 'Not specified in provided communications.' " +
            "Use ONLY these sections: " +
            "1. Executive Summary " +
            "2. Functional Requirements " +
            "3. Non-Functional Requirements " +
            "4. Stakeholders " +
            "5. Timeline " +
            "6. Risks " +
            "7. Assumptions " +
            "8. Success Metrics " +
            "9. Recommendations " +
            "Formatting Rules: " +
            "- Use <h2> for section titles. " +
            "- Use <ul><li> for lists. " +
            "- Do NOT use markdown. " +
            "- Do NOT use tables or code blocks. " +
            "Communication Data: " + communicationText;

        return callAPI(prompt);
    }

    // =========================================
    // EDIT BRD
    // =========================================

    public String editBRD(String existingBRD, String userInstruction) {

        if (existingBRD == null || existingBRD.trim().isEmpty()) {
            return "<p>No BRD content provided to edit.</p>";
        }

        if (userInstruction == null || userInstruction.trim().isEmpty()) {
            return existingBRD;
        }

        String prompt =
            "You are a BRD Editor AI. " +
            "Update the provided Business Requirements Document based ONLY on the user instruction. " +
            "Keep professional formatting intact. " +
            "Do not remove existing sections unless instructed. " +
            "Do not invent random information. " +
            "Return ONLY clean HTML. " +
            "Existing BRD: " + existingBRD +
            " User Instruction: " + userInstruction;

        return callAPI(prompt);
    }

    // =========================================
    // COMMON API CALL
    // =========================================

    private String callAPI(String prompt) {

        if (API_KEY.isEmpty()) {
            return "<p><strong>Error:</strong> GROQ_API_KEY environment variable is not set.</p>";
        }

        try {
            String requestBody =
                "{" +
                "\"model\":\"" + MODEL + "\"," +
                "\"messages\":[{" +
                "\"role\":\"user\"," +
                "\"content\":\"" + escapeJson(prompt) + "\"" +
                "}]" +
                "}";

            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(60000);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(requestBody.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();

            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(
                    responseCode == 200 ? conn.getInputStream() : conn.getErrorStream(), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            if (responseCode != 200) {
                return "<p><strong>API Error (" + responseCode + "):</strong> " +
                       escapeHtml(response.toString()) + "</p>";
            }

            return extractContent(response.toString());

        } catch (Exception e) {
            e.printStackTrace();
            return "<p><strong>API call failed:</strong> " + e.getMessage() + "</p>";
        }
    }

    // =========================================
    // EXTRACT AI CONTENT FROM JSON
    // =========================================

    public String extractContent(String jsonResponse) {

        try {
            String marker = "\"content\":\"";
            int start = jsonResponse.indexOf(marker);

            if (start == -1) {
                return "<p>No AI response content found. Response: " +
                       escapeHtml(jsonResponse.substring(0, Math.min(200, jsonResponse.length()))) + "</p>";
            }

            start += marker.length();

            // Find end: look for next field after content
            int end = jsonResponse.indexOf("\",\"refusal\"", start);
            if (end == -1) end = jsonResponse.indexOf("\",\"role\"", start);
            if (end == -1) end = jsonResponse.indexOf("\"}", start);
            if (end == -1) return "<p>Failed to parse AI response.</p>";

            String content = jsonResponse.substring(start, end);

            // Clean escaped characters
            content = content
                .replace("\\n", "\n")
                .replace("\\\"", "\"")
                .replace("\\/", "/")
                .replace("\\u003c", "<")
                .replace("\\u003e", ">")
                .replace("\\r", "")
                .replace("```html", "")
                .replace("```", "")
                .replace("###", "")
                .replace("##", "")
                .replace("**", "")
                .trim();

            return content;

        } catch (Exception e) {
            e.printStackTrace();
            return "<p>Content parsing failed: " + e.getMessage() + "</p>";
        }
    }

    // =========================================
    // HELPERS
    // =========================================

    private String escapeJson(String text) {
        if (text == null) return "";
        return text
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "")
            .replace("\t", "\\t");
    }

    private String escapeHtml(String text) {
        if (text == null) return "";
        return text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;");
    }
}
