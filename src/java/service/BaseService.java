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
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
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
    public static final int PROJECT_QA_ROLE = 3;
    public static final int PROJECT_MANAGER_ROLE = 4;

    public static String generateOTP() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public static String getRandom() {
        Random random = new Random();
        int number = random.nextInt(999999);
        return String.format("%06d", number);
    }

    public static boolean sendEmail(String email, String OTP) {
        boolean result = false;

        String toEmail = email;
        String fromEmail = "nmnghia1702@gmail.com";
        String password = "suwv nrxz ypdg ajdp";

        try {
            Properties pr = new Properties();
            pr.setProperty("mail.smtp.host", "smtp.gmail.com");
            pr.setProperty("mail.smtp.port", "587");
            pr.setProperty("mail.smtp.auth", "true");
            pr.setProperty("mail.smtp.starttls.enable", "true");
            pr.put("mail.smtp.socketFactory.port", "587");
            pr.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

            //session
            Session session = Session.getInstance(pr, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Forgot password OTP");
            message.setText("Here is OTP to reset your password: " + OTP);
            Transport.send(message);
            result = true;
        } catch (MessagingException e) {
            e.printStackTrace();
        }
        return result;
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
            return Integer.valueOf(someText);
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

    public <T> void sortListByField(List<T> list, String fieldName, String order) {
        Collections.sort(list, new Comparator<T>() {
            @Override
            public int compare(T o1, T o2) {
                try {
                    // Handle nested fields (e.g., "user.userId")
                    String[] fieldNames = fieldName.split("\\.");

                    // Retrieve the field values using getter methods for each level
                    Object value1 = getNestedFieldValue(o1, fieldNames);
                    Object value2 = getNestedFieldValue(o2, fieldNames);

                    // Handle null values during comparison
//                    if (value1 == null && value2 == null) {
//                        return 0;
//                    }
//                    if (value1 == null) {
//                        return "desc".equalsIgnoreCase(order) ? 1 : -1;
//                    }
//                    if (value2 == null) {
//                        return "desc".equalsIgnoreCase(order) ? -1 : 1;
//                    }

                    // Cast to Comparable to allow comparison
                    Comparable comp1 = (Comparable) value1;
                    Comparable comp2 = (Comparable) value2;

                    // Compare the values and return based on the order
                    if ("desc".equalsIgnoreCase(order)) {
                        return comp2.compareTo(comp1);  // Descending order
                    } else {
                        return comp1.compareTo(comp2);  // Ascending order (default)
                    }
                } catch (Exception e) {
                    throw new RuntimeException("Error during sorting", e);
                }
            }
        });
    }

    // Helper method to get the value of nested fields
    private Object getNestedFieldValue(Object obj, String[] fieldNames) throws Exception {
        Object currentObject = obj;

        for (String fieldName : fieldNames) {
            // Convert fieldName to the corresponding getter method name
            String getterMethodName = "get" + fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);

            // Retrieve the getter method
            Method getter = currentObject.getClass().getMethod(getterMethodName);

            // Invoke the getter method to get the field value
            currentObject = getter.invoke(currentObject);

            // Stop if the current value is null
            if (currentObject == null) {
                break;
            }
        }

        return currentObject;
    }
}
