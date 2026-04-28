package com.ychat;

import java.io.File;

import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;

public class Main {
    public static void main(String[] args) throws Exception {

        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector();

        // temp directory
        File baseDir = new File(System.getProperty("java.io.tmpdir"));

        // context create
        Context context = tomcat.addContext("", baseDir.getAbsolutePath());

        System.out.println("Tomcat started on port: " + port);

        tomcat.start();
        tomcat.getServer().await();
    }
}