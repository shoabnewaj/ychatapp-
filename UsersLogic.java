package ychatapp.model.bo;

import java.security.MessageDigest;
import java.util.Base64;

import jakarta.servlet.http.HttpServletRequest;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.UsersDAO;



public class UsersLogic {

    public static boolean userRegist(HttpServletRequest request, UsersBeans ub) {
        ub.setHashedPass(hashValue(ub.getPass()));
        return new UsersDAO().userRegist(ub);
    }

    public static UsersBeans login(UsersBeans ub) {
        return new UsersDAO().login(ub.getEmail(), hashValue(ub.getPass()));
    }

    public static boolean updateProfile(UsersBeans ub) {
        ub.setHashedPass(hashValue(ub.getPass()));
        return new UsersDAO().updateUser(ub);
    }

    private static String hashValue(String pass) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return Base64.getEncoder().encodeToString(md.digest(pass.getBytes()));
        } catch (Exception e) { return null; }
    }
}