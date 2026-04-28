package com.ychat;

import java.io.File;

import org.apache.catalina.startup.Tomcat;

public class Main {
    public static void main(String[] args) throws Exception {

        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);

        tomcat.getConnector();

        // FIXED PATH (jar থেকে load হবে)
        String webappDir = new File("src/main/webapp").getAbsolutePath();

        tomcat.addWebapp("", webappDir);

        System.out.println("Tomcat started on port: " + port);

        tomcat.start();
        tomcat.getServer().await();
    }
}