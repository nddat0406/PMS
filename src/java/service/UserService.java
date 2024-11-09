/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.GroupDAO;
import dal.UserDAO;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.IntSummaryStatistics;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import model.Allocation;
import model.User;
import model.Group;
import static service.BaseService.*;

/**
 *
 * @author HP
 */
public class UserService {

    private UserDAO udao = new UserDAO();
    private GroupDAO gdao = new GroupDAO();
    private BaseService baseService = new BaseService();

    public User getUserProfile(int userId) throws SQLException {
        try {
            return udao.getActiveUserById(userId);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public Map<String, String> validateUpdateProfile(User user, Part part) throws Exception {
        Map<String, String> errorMessages = new HashMap<>();
        boolean isValid = true;
        // Validate Mobile
        if (!user.getMobile().matches(MOBILE_PATTERN)) {
            errorMessages.put("mobile", "Mobile phone is not correct!");
            isValid = false;
        }

        // Validate Image
        if (part != null && part.getSize() != 0) {
            if (part.getSize() > 10485760) { // 10MB limit
                errorMessages.put("image", "Image size exceeds 10MB!");
                isValid = false;
            }
            if (!part.getContentType().equals("image/jpeg")
                    && !part.getContentType().equals("image/png")
                    && !part.getContentType().equals("image/jpg")) {
                errorMessages.put("image", "Image type not right! Please use .jpg, .png, or .jpeg only");
                isValid = false;
            }
        }

        // If there are validation errors, return them to the servlet
        if (!isValid) {
            return errorMessages;
        }
        // Return empty map if no errors
        return errorMessages;
    }

    public void updateProfile(User user, Part part) throws Exception {
        try {
            // Handle image upload if no errors
            if (part != null && part.getSize() > 0) {
                Properties props = new Properties();
                ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
                InputStream inputStream = classLoader.getResourceAsStream("app.properties");
                props.load(inputStream);

                // Define new and old image paths
                String path = props.getProperty("image.user.path") + File.separator + user.getId() + "_" + part.getSubmittedFileName();
                String[] temp = udao.getActiveUserById(user.getId()).getImage().split("/");
                String oldImageName = temp[temp.length - 1];
                String oldPath = props.getProperty("image.user.path") + File.separator + oldImageName;

                // Delete the old file and upload the new one
                baseService.deleteFile(oldPath);
                InputStream is = part.getInputStream();
                baseService.uploadFile(is, path);
            } else {
                user.setImage(udao.getActiveUserById(user.getId()).getImage());
            }

            // Update user profile in database
            udao.updateUserProfile(user);
        } catch (SQLException e) {
            throw new SQLException("Database error occurred while updating profile: " + e.getMessage());
        }
    }

    public void updatePassword(String oldPass, String newPass, int id) throws SQLException {
        if (BaseService.checkPassword(oldPass, udao.getUserPassword(id))) {
            if (!BaseService.checkPassword(newPass, udao.getUserPassword(id))) {
                udao.updateUserPassword(BaseService.hashPassword(newPass), id);
            } else {
                throw new SQLException("New password is duplicated with old password");
            }
        } else {
            throw new SQLException("Current password not right");

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
            return udao.verifyLogin(email, pass);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        return udao.getUserByEmail(email);
    }

    public void addUser(User user) throws SQLException {
        user.setPassword(BaseService.hashPassword(user.getPassword()));
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
        udao.deleteUser(id);

    }

    public void updateUser(User user) throws SQLException {
        try {
            udao.updateUserAccount(user);
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Group> getAllDepartments() throws SQLException {
        return gdao.getAllDepartment();
    }

    public Group getDepartmentById(int deptId) throws SQLException {
        Group group = gdao.getDepartmentDetail(deptId);
        return group;
    }

    public boolean resetPassword(String email, String newPassword) {
        return udao.resetPassword(email, newPassword);
    }

    public boolean saveOtp(String email, String otp) {
        return udao.saveOTP(email, otp);
    }

    public boolean createUser(String fullname, String email, String password) {
        return udao.createUser(fullname, email, BaseService.hashPassword(password));
    }

    public boolean isEmailExists(String email) {
        return udao.checkEmailExists(email);
    }

    public boolean isMobileExistss(String mobile) {
        return udao.checkMobileExists(mobile);
    }

    public <T> List<T> getListByPages(List<T> list, int start, int end) {
        // Kiểm tra xem start và end có nằm trong phạm vi hợp lệ không
        List<T> arr = new ArrayList<>();
        if (start >= 0 && start < list.size() && end > start) {
            for (int i = start; i < end && i < list.size(); i++) {
                arr.add(list.get(i));
            }
        }
        return arr;
    }

    public boolean updateUserStatus(int id, int status) throws SQLException {
        return udao.updateUserStatus(id, status);
    }

    public List<User> findUsersByFilters(String keyword, Integer departmentId, Integer status) throws SQLException {
        List<User> allUsers = udao.getAll(); // Get all users from the database
        return udao.searchFilter(allUsers, departmentId, status, keyword); // Filter users
    }

    public boolean isChangedEmail(String email, int id) {
        return udao.checkEmailChanged(email, id);
    }

    public boolean validateEmail(String email, int id) throws SQLException {

        // Validate Email
        if (!email.matches(EMAIL_PATTERN)) {
            throw new SQLException("Email pattern is not correct!");
        } else {
            if (udao.checkEmailChanged(email, id)) {
                if (udao.checkEmailExists(email)) {
                    throw new SQLException("Email is already taken!");
                }
            } else {
                throw new SQLException("Email not changed!");
            }
        }
        return true;

    }

    public void saveOtpId(int id, String otp) throws SQLException {
        udao.saveOTPId(id, otp);
    }

    public String verifyOTP(String otp, int id) throws SQLException {
        String error = null;

        if (udao.isOTP_Expired(id)) {
            error = "OTP is expired! Try send another request.";
        } else {
            if (!udao.validateOTP(otp, id)) {
                error = "OTP is not correct!";
            }
        }
        return error;
    }

    public void updateEmail(String email, int id) throws SQLException {
        udao.updateEmail(email, id);
    }

    public int countAssignedReq(int id) throws SQLException {
        return udao.countAssignedReq(id);
    }

    public int countAssignedIssue(int id) throws SQLException {
        return udao.countAssignedIssue(id);
    }

    public double getAvgEffort(List<Allocation> list) {
        IntSummaryStatistics stats = list
                .stream()
                .mapToInt(Allocation::getEffortRate)
                .summaryStatistics();
        return stats.getAverage();
    }

    public List<User> getUsersByProjectId(int projectId) {

        return udao.getUsersByProjectId(projectId);

    }
}
