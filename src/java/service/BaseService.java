/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.UserDAO;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author HP
 */
public class BaseService {

    public static final String EMAIL_PATTERN = "[^@\\s]+@[^@\\s]+\\.[^@\\s]+";
    public static final String MOBILE_PATTERN = "[0]{1}[0-9]{9}";

    public static final int ADMIN_ROLE = 1;
    public static final int MEMBER_ROLE = 2;



    public static String generateOTP() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public static void sendEmail(String email, String your_OTP_Code, String string) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private UserDAO udao = new UserDAO();

    public <T> List<T> getListByPage(List<T> list,
            int start, int end) {
        List<T> arr = new ArrayList<>();
        for (int i = start; i < end; i++) {
            arr.add(list.get(i));
        }
        return arr;
    }

    public Integer TryParseInt(String someText) {
        try {
            return Integer.parseInt(someText);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    public void uploadFile(InputStream is, String path) throws IOException {
        try {
            byte[] byt = new byte[is.available()];
            is.read(byt);
            try (FileOutputStream fops = new FileOutputStream(path)) {
                fops.write(byt);
                fops.flush();
            }
        } catch (IOException ex) {
            throw new IOException(ex);
        }
    }

    public void deleteFile(String path) {
        File myObj = new File(path);
        if (myObj.exists()) {
            myObj.delete();
        }
    }

    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean checkPassword(String password, String hashed) {
        return BCrypt.checkpw(password, hashed);
    }
}
