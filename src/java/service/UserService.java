/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.UserDAO;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import java.util.zip.DataFormatException;
import model.Group;
import static service.BaseService.*;

/**
 *
 * @author HP
 */
public class UserService {

    private UserDAO udao = new UserDAO();

    private BaseService baseService = new BaseService();

    public User getUserProfile(int userId) throws SQLException {
        try {
            User user = udao.getActiveUserById(userId);
            return user;
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }


    public void updateProfile(User user, Part part) throws Exception {
        boolean isValid = true;

        String errorMess = "";
        try {
            if (!user.getEmail().matches(EMAIL_PATTERN)) {
                errorMess += "Email pattern is not correct!";
                isValid = false;
            } 
            else if (udao.checkEmailChanged(user.getEmail(), user.getId())) {
                if (udao.checkEmailExists(user.getEmail())) {
                    errorMess += "Email is already taken!";
                    isValid = false;
                }
            }
            if (!user.getMobile().matches(MOBILE_PATTERN)) {
                errorMess += "/Mobile phone is not correct!";
                isValid = false;
            }
            if (part != null) {
                if (part.getSize() > 10485760) {
                    errorMess += "/Image size exceed 10MB!";
                    isValid = false;
                }
                if (!part.getContentType().equals("image/jpeg")
                        && part.getContentType().equals("image/png")
                        && part.getContentType().equals("image/jpg")) {
                    errorMess += "/Image type not right! Please use .jpg, .png and .jpg only";
                    isValid = false;
                }
            }
            if (!isValid) {
                throw new DataFormatException(errorMess);
            }

            if (part != null && part.getSize() > 0) {
                Properties props = new Properties();
                ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
                InputStream inputStream = classLoader.getResourceAsStream("app.properties");
                props.load(inputStream);
                String path = props.getProperty("image.user.path") + File.separator + part.getSubmittedFileName();
                String[] temp = udao.getActiveUserById(user.getId()).getImage().split("/");
                String oldImageName = temp[temp.length - 1];
                String oldPath = props.getProperty("image.user.path") + File.separator + oldImageName;
                baseService.deleteFile(oldPath);
                InputStream is = part.getInputStream();
                baseService.uploadFile(is, path);
            } else {
                user.setImage(udao.getActiveUserById(user.getId()).getImage());
            }
            udao.updateUserProfile(user);
        } catch (SQLException | DataFormatException e) {
            throw new Exception(e.getMessage());
        }
    }

    public void updatePassword(String oldPass, String newPass, int id) throws SQLException {
        if (BaseService.checkPassword(oldPass, udao.getUserPassword(id))) {
            udao.updateUserPassword(BaseService.hashPassword(newPass), id);
        } else {
            throw new SQLException("Password not right");
        }
    }

    public List<User> getAll() throws SQLException {
        try {
            List<User> user = udao.getAll();
            return user;
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public List<User> findByName(String keyword) throws SQLException {
        try {
            List<User> u = udao.findByName(keyword);
            return u;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }
    public boolean verifyLogin(String email, String pass) throws SQLException {
        try {
            return udao.verifyLogin(email,pass);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        return udao.getUserByEmail(email);
    }


    public void addUser(User user) throws SQLException {
        if (validateUser(user)) {
            udao.Insert(user);
        } else {
            throw new IllegalArgumentException("Invalid user data");
        }
    }

    private boolean validateUser(User user) throws SQLException {
        // Add any additional validation logic if necessary
        if (user.getFullname() == null || user.getFullname().isEmpty()) {
            return false;
        }
        if (user.getDepartment() == null || user.getDepartment().getId() <= 0) {
            return false;
        }
        if (user.getEmail() == null || user.getEmail().isEmpty()) {
            return false;
        }
        if (udao.emailExists(user.getEmail())) {
            return false; //email ton tai
        }
        return true;
    }

    public User getUserById(int id) throws SQLException {
        User user = udao.getUserById(id);
        return user;

    }


    public void deleteUser(int id) throws SQLException {
        try {
            udao.deleteUser(id);
        } catch (SQLException e) {
            System.out.println("err");
        }
    }

    public void updateUser(User user) throws SQLException {
        try {
            udao.updateUserAccount(user);
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Group> getAllDepartments() throws SQLException {
        return udao.getAllDept();
    }

    public Group getDepartmentById(int deptId) throws SQLException {
            Group group = udao.getDeptId(deptId);
            return group;
    }
    public boolean resetPassword(String email, String newPassword){
        return udao.resetPassword(email, newPassword);
    }
    public boolean saveOtp(String email, String otp){
        return udao.saveOTP(email, otp);
    }
    public boolean createUser(String fullname, String email, String password){
        return udao.createUser(fullname, email, password);
    }
    public boolean isEmailExists(String email){
        return udao.checkEmailExists(email);
    }
}

