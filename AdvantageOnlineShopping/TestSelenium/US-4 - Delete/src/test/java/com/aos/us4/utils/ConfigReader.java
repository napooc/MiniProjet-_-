package com.aos.us4.utils;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public final class ConfigReader {

    private static final String CONFIG_PATH = "src/test/resources/config.properties";
    private static final Properties props = new Properties();

    static {
        try (FileInputStream fis = new FileInputStream(CONFIG_PATH)) {
            props.load(fis);
        } catch (IOException e) {
            throw new RuntimeException("Failed to load " + CONFIG_PATH, e);
        }
    }

    private ConfigReader() {}

    public static String get(String key) {
        String value = props.getProperty(key);
        if (value == null || value.isBlank()) {
            throw new RuntimeException("Missing property: " + key);
        }
        return value.trim();
    }

    public static int getInt(String key) {
        return Integer.parseInt(get(key));
    }

    public static boolean getBoolean(String key) {
        return Boolean.parseBoolean(get(key));
    }
}
