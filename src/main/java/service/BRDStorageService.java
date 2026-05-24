package service;

import java.io.File;
import java.io.FileWriter;
import java.nio.file.Files;
import java.nio.file.Paths;

public class BRDStorageService {

    // Use a relative path that works on any OS (not hardcoded Windows path)
    private static final String FOLDER;

    static {
        String base = System.getProperty("catalina.home");
        if (base == null) base = System.getProperty("user.home");
        FOLDER = base + File.separator + "brd_storage" + File.separator;
    }

    public void saveBRD(String projectName, String brdContent) {
        try {
            File folder = new File(FOLDER);
            if (!folder.exists()) {
                folder.mkdirs();
            }

            String safeName = sanitizeName(projectName);

            try (FileWriter writer = new FileWriter(FOLDER + safeName + ".json")) {
                String json = "{\n"
                    + "\"projectName\":\"" + projectName.replace("\"", "\\\"") + "\",\n"
                    + "\"brdContent\":\"" + brdContent.replace("\"", "\\\"").replace("\n", "\\n") + "\"\n"
                    + "}";
                writer.write(json);
            }

            System.out.println("BRD saved: " + FOLDER + safeName + ".json");

        } catch (Exception e) {
            System.err.println("Error saving BRD: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public String loadBRD(String projectName) {
        try {
            String safeName = sanitizeName(projectName);
            return new String(Files.readAllBytes(Paths.get(FOLDER + safeName + ".json")));
        } catch (Exception e) {
            return null;
        }
    }

    private String sanitizeName(String name) {
        if (name == null) return "unknown";
        return name.replaceAll("[^a-zA-Z0-9_-]", "_");
    }
}
