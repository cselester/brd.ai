package dao;

import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CommunicationDAO {

    public void saveCommunication(
            String sourceType,
            String senderName,
            String projectName,
            String content) throws Exception {

        // Validate inputs
        if (projectName == null || projectName.trim().isEmpty()) {
            throw new IllegalArgumentException("Project name cannot be empty");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Content cannot be empty");
        }

        String sql = "INSERT INTO communications(source_type, sender_name, project_name, content, uploaded_at) VALUES (?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sourceType != null ? sourceType : "Unknown");
            ps.setString(2, senderName != null ? senderName.trim() : "Unknown");
            ps.setString(3, projectName.trim());
            ps.setString(4, content);
            ps.executeUpdate();
        }
    }

    public String getProjectCommunications(String projectName) throws Exception {

        if (projectName == null || projectName.trim().isEmpty()) {
            throw new IllegalArgumentException("Project name cannot be empty");
        }

        String sql = "SELECT source_type, sender_name, content FROM communications WHERE project_name = ? ORDER BY uploaded_at ASC";

        StringBuilder allData = new StringBuilder();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, projectName.trim());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    allData.append("SOURCE: ").append(rs.getString("source_type")).append("\n");
                    allData.append("SENDER: ").append(rs.getString("sender_name")).append("\n");
                    allData.append("CONTENT: ").append(rs.getString("content")).append("\n\n");
                }
            }
        }

        return allData.toString();
    }

    public int getProjectEntryCount(String projectName) throws Exception {
        String sql = "SELECT COUNT(*) FROM communications WHERE project_name = ?"; // uploaded_at exists

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, projectName.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
}
