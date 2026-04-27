package com.ychat;

import org.apache.catalina.startup.Tomcat;

public class Main {
    public static void main(String[] args) throws Exception {

        int port = 8080;
        if (System.getenv("PORT") != null) {
            port = Integer.parseInt(System.getenv("PORT"));
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);

        tomcat.getConnector();

        String webappDir = new java.io.File("src/main/webapp").getAbsolutePath();
        tomcat.addWebapp("", webappDir);

        tomcat.start();
        tomcat.getServer().await();
    }
}