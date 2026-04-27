package com.ychat;

import java.io.File;

import org.apache.catalina.startup.Tomcat;

public class Main {
    public static void main(String[] args) throws Exception {
        // Railway-র জন্য পোর্ট ডিটেকশন
        String webPort = System.getenv("PORT");
        if (webPort == null || webPort.isEmpty()) {
            webPort = "8080";
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(webPort));
        
        // এটি 502 এরর দূর করতে সাহায্য করবে (Binding to all interfaces)
        tomcat.getConnector().setProperty("address", "0.0.0.0");

        // JSP এবং স্ট্যাটিক ফাইল পাথ ফিক্স
        String webappDirLocation = "src/main/webapp/";
        File webappDir = new File(webappDirLocation);
        
        if (!webappDir.exists()) {
            webappDirLocation = "."; // Railway-তে অনেক সময় রুটেই থাকে
        }

        tomcat.addWebapp("/", new File(webappDirLocation).getAbsolutePath());
        System.out.println("Starting Tomcat on port: " + webPort);

        tomcat.start();
        tomcat.getServer().await();
    }
}
