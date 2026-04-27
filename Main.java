package com.ychat;

import org.apache.catalina.startup.Tomcat;

public class Main {
    public static void main(String[] args) throws Exception {

        String portEnv = System.getenv("PORT");
        int port = (portEnv != null) ? Integer.parseInt(portEnv) : 8080;

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);

        tomcat.getConnector();

        tomcat.addWebapp("", new java.io.File("src/main/webapp").getAbsolutePath());

        System.out.println("Tomcat started on port: " + port);

        tomcat.start();
        tomcat.getServer().await();
    }
}