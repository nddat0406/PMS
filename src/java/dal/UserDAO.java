/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.security.Timestamp;
import service.BaseService;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import model.Group;
import model.User;

/**
 *
 * @author HP
 */
public class UserDAO extends BaseDAO {

    private GroupDAO gdao = new GroupDAO();

    public User getActiveUserById(int userId) throws SQLException {
        String str = "SELECT * FROM pms.user where id=? and status = 1";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, userId);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt(1));
                    user.setEmail(rs.getString(2));
                    user.setFullname(rs.getString(3));
                    user.setMobile(rs.getString(4));
                    user.setRole(rs.getInt(7));
                    user.setDepartment(new Group(gdao.getDeptNameById(rs.getInt(9))));
                    user.setImage(rs.getString(10));
                    user.setAddress(rs.getString(11));
                    user.setGender(rs.getBoolean(12));
                    user.setBirthdate(rs.getDate(13));
                    return user;
                }
            }
        } catch (SQLException e) {
            throw new SQLException("User not exists or not active", e);
        }
        return null;
    }

    public User getActiveUserByIdNull(int userId) throws SQLException {
        String str = "SELECT * FROM pms.user where id=? and status = 1";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, userId);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt(1));
                    user.setEmail(rs.getString(2));
                    user.setFullname(rs.getString(3));
                    user.setMobile(rs.getString(4));
                    user.setRole(rs.getInt(7));
                    user.setDepartment(new Group(rs.getInt(9), gdao.getDeptNameById(rs.getInt(9))));
                    user.setImage(rs.getString(10));
                    user.setAddress(rs.getString(11));
                    user.setGender(rs.getBoolean(12));
                    user.setBirthdate(rs.getDate(13));
                    return user;
                }
            }
        } catch (SQLException e) {
            return null;
        }
        return null;
    }

    public User getUserFullById(int userId) throws SQLException {
        String str = "SELECT * FROM pms.user where id=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, userId);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt(1));
                    user.setEmail(rs.getString(2));
                    user.setFullname(rs.getString(3));
                    user.setMobile(rs.getString(4));
                    user.setRole(rs.getInt(7));
                    user.setStatus(rs.getInt(8));
                    user.setDepartment(new Group(gdao.getDeptNameById(rs.getInt(9))));
                    user.setImage(rs.getString(10));
                    user.setAddress(rs.getString(11));
                    user.setGender(rs.getBoolean(12));
                    user.setBirthdate(rs.getDate(13));
                    return user;
                }
            }
        } catch (SQLException e) {
            return null;
        }
        return null;
    }

// Phương thức đăng nhập người dùng
    public User getUserLogin(String username, String password) throws Exception {
        String query = "SELECT id, email, fullname, mobile, password, note, role, status, departmentId, image,gender, otp, otp_expiry "
                + "FROM pms.user WHERE user_name = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, username);

            ResultSet resultSet = ps.executeQuery();
            // Kiểm tra xem có người dùng nào được tìm thấy không
            if (resultSet.next()) {
                String hashedPassword = resultSet.getString("password");
                User user = new User();
                user.setId(resultSet.getInt("id"));
                user.setPassword(resultSet.getString("password"));
                user.setEmail(resultSet.getString("email"));
                user.setFullname(resultSet.getString("full_name"));
                user.setMobile(resultSet.getString("mobile"));
                user.setStatus(resultSet.getInt("status")); // Trạng thái
                user.setRole(resultSet.getInt("role")); // role_id
                user.setDepartment(new Group(gdao.getDeptNameById(resultSet.getInt("department"))));
                user.setNote(resultSet.getString("notes")); // 
                user.setImage(resultSet.getString("image")); // 
                user.setOtp(resultSet.getString("otp")); // OTP
//                    user.setOtp_expiry(resultSet.getTimestamp("otp_expiry")); // Thời gian hết hạn OTP

                // Kiểm tra mật khẩu
                if (BaseService.checkPassword(password, hashedPassword)) {
                    user.setId(resultSet.getInt("id"));
                    user.setEmail(resultSet.getString("email"));
                    user.setFullname(resultSet.getString("full_name"));
                    user.setMobile(resultSet.getString("mobile"));
                    user.setStatus(resultSet.getInt("status")); // Trạng thái
                    user.setRole(resultSet.getInt("role")); // role_id
                    user.setDepartment(new Group(gdao.getDeptNameById(resultSet.getInt("department"))));
                    user.setNote(resultSet.getString("notes")); // 
                    user.setImage(resultSet.getString("image")); // 
                    user.setOtp(resultSet.getString("otp")); // OTP
//                        user.setOtp_expiry(resultSet.getTimestamp("otp_expiry")); // Thời gian hết hạn OTP
                    return user;
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi đăng nhập: " + e.getMessage(), e);
        }

        return null; // Trả về null nếu không tìm thấy người dùng hoặc mật khẩu sai
    }

    // Phương thức đăng ký người dùng mới
    public String registerUser(String username, String pass, String email, String name, String phone) {
        String sql = "INSERT INTO pms.user (password, email, fullname, mobile, role, status) VALUES (?, ?, ?, ?, 1, 0)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            String hashedPassword = BaseService.hashPassword(pass);
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            ps.setString(3, name);
            ps.setString(4, phone);
            ps.executeUpdate();
            // Tạo và gửi mã OTP
            String otp = BaseService.generateOTP(); // Tạo mã OTP
            boolean result = BaseService.sendEmail(email, "Forgot password OTP", "Here is OTP to reset your password: " + otp);

            // Lưu mã OTP vào cơ sở dữ liệu
            String updateOtpSql = "UPDATE pms.user SET otp = ?, otp_expiry = ? WHERE email = ?";
            Date otpExpiry = new Date(System.currentTimeMillis() + (5 * 60 * 1000)); // 5 phút
            PreparedStatement otpPs = getConnection().prepareStatement(updateOtpSql);
            otpPs.setString(1, otp);
            otpPs.setTimestamp(2, new java.sql.Timestamp(otpExpiry.getTime()));
            otpPs.setString(3, email);
            otpPs.executeUpdate();
            return email; // Trả về email để sử dụng trong xác thực OTP
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (MessagingException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean checkOldPassword(String email, String oldPassword) {
        String sql = "SELECT password FROM pms.user WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    return BaseService.checkPassword(oldPassword, hashedPassword);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateUserProfile(User user) throws SQLException {
        String str = """
                    UPDATE `pms`.`user`
                    SET
                    `fullname` = ?,
                    `mobile` = ?,
                    `image` = ?,
                    `address` = ?,
                    `gender` = ?,
                    `birthdate` =? ,
                    `image`= ?
                    WHERE `id` = ?;""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setString(1, user.getFullname());
            pre.setString(2, user.getMobile());
            pre.setString(3, user.getImage());
            pre.setString(4, user.getAddress());
            pre.setBoolean(5, user.isGender());
            pre.setDate(6, user.getBirthdate());
            pre.setString(7, user.getImage());
            pre.setInt(8, user.getId());
            pre.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public String getUserPassword(int id) throws SQLException {
        String str = "SELECT password FROM pms.user where id=? and status = 1";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return null;
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM pms.user WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkEmailChanged(String email, int id) {
        String sql = "SELECT email FROM pms.user WHERE id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return !rs.getString(1).equals(email);
                }
            }
        } catch (SQLException e) {
            return true;
        }
        return false;
    }

    public boolean verifyOtp(String email, String enteredOtp) {
        String sql = "SELECT otp, otp_expiry FROM pms.user WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String otp = rs.getString("otp");
                    java.sql.Timestamp otpExpiry = rs.getTimestamp("otp_expiry");

                    if (otp != null && otpExpiry != null) {
                        java.sql.Timestamp currentTime = new java.sql.Timestamp(System.currentTimeMillis());

                        // Check if OTP matches and has not expired
                        if (otp.equals(enteredOtp) && otpExpiry.after(currentTime)) {
                            return true;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateUserPassword(String newPass, int id) throws SQLException {
        String str = """
                     UPDATE `pms`.`user`
                     SET
                     `password` = ?
                     WHERE `id` = ?;""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setString(1, newPass);
            pre.setInt(2, id);
            pre.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean isUserExist(String username, String email) {
        String sql = "SELECT COUNT(*) FROM project_evaluation_system.user WHERE user_name = ? OR email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // If the account exists
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAll() throws SQLException {

        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.user";

        try (PreparedStatement st = getConnection().prepareStatement(sql); ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setFullname(rs.getString("fullname"));
                user.setMobile(rs.getString("mobile"));
                user.setPassword(rs.getString("password"));
                user.setNote(rs.getString("note"));
                user.setRole(rs.getInt("role"));
                user.setStatus(rs.getInt("status"));

                // Department Handling with debug
                int deptId = rs.getInt("departmentId");
                String deptName = gdao.getDeptNameById(deptId);
                if (deptName == null) {
                    System.out.println("Warning: Department ID " + deptId + " not found.");

                }
                user.setDepartment(new Group(deptName));

                user.setImage(rs.getString("image"));
                user.setAddress(rs.getString("address"));
                user.setGender(rs.getBoolean("gender"));
                user.setBirthdate(rs.getDate("birthdate"));
                user.setOtp(rs.getString("otp"));
                user.setOtp_expiry(rs.getDate("otp_expiry"));

                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log full exception stack trace
            throw new SQLException("Error retrieving all users from the database", e);
        }
        return list;
    }

    public static void main(String[] args) throws SQLException {
        System.out.println(new UserDAO().getAll());
    }

    public List<User> findByName(String keyword) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.user where fullname like ?;";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setString(1, "%" + keyword + "%");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt(1));
                    user.setEmail(rs.getString(2));
                    user.setFullname(rs.getString(3));
                    user.setMobile(rs.getString(4));
                    user.setPassword(rs.getString(5));
                    user.setNote(rs.getString(6));
                    user.setRole(rs.getInt(7));
                    user.setStatus(rs.getInt(8));
                    user.setDepartment(new Group(gdao.getDeptNameById(rs.getInt(9))));
                    user.setImage(rs.getString(10));
                    user.setAddress(rs.getString(11));
                    user.setGender(rs.getBoolean(12));
                    user.setBirthdate(rs.getDate(13));
                    list.add(user);
                }
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return list;
    }

    public void Insert(User uNew) throws SQLException {
        String sql = "INSERT INTO pms.user (email,mobile, fullname, password, role, status, departmentId, address) VALUES (?,?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setString(1, uNew.getEmail());
            st.setString(2, uNew.getMobile());
            st.setString(3, uNew.getFullname());
            st.setString(4, uNew.getPassword());
            st.setInt(5, uNew.getRole());
            st.setInt(6, uNew.getStatus());
            st.setInt(7, uNew.getDepartment().getId());
            st.setString(8, uNew.getAddress());
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error inserting user: " + e.getMessage());
        }
    }

    public void deleteUser(int id) throws SQLException {
        String sql = "DELETE FROM `pms`.`user` WHERE id=?;";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pms.user WHERE email = ?";
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0; // If count > 0, email exists
            }
        }
    }

    public void updateUserAccount(User user) throws SQLException {
        String sql = "UPDATE pms.user SET role=?, status=?, departmentId=? WHERE id=?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, user.getRole());
            stmt.setInt(2, user.getStatus());
            stmt.setInt(3, user.getDepartment().getId());
            stmt.setInt(4, user.getId());
            stmt.executeUpdate();
        }
    }

    public User getUserById(int userId) throws SQLException {
        String str = "SELECT * FROM pms.user WHERE id=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, userId);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt(1));
                    user.setEmail(rs.getString(2));
                    user.setFullname(rs.getString(3));
                    user.setMobile(rs.getString(4));
                    user.setRole(rs.getInt(7));
                    user.setDepartment(new Group(gdao.getDeptNameById(rs.getInt(9))));
                    user.setImage(rs.getString(10));
                    user.setAddress(rs.getString(11));
                    user.setGender(rs.getBoolean(12));
                    user.setBirthdate(rs.getDate(13));
                    user.setOtp(rs.getString(14));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean verifyLogin(String email, String pass) throws SQLException {
        String sql = "SELECT password FROM pms.user WHERE email=? AND status=1";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setString(1, email);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() && BaseService.checkPassword(pass, rs.getString(1));
            }
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String str = "SELECT * FROM pms.user WHERE email=? AND status=1";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setString(1, email);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt(1));
                    user.setEmail(rs.getString(2));
                    user.setFullname(rs.getString(3));
                    user.setMobile(rs.getString(4));
                    user.setRole(rs.getInt(7));
                    user.setDepartment(new Group(gdao.getDeptNameById(rs.getInt(9))));
                    user.setImage(rs.getString(10));
                    user.setAddress(rs.getString(11));
                    user.setGender(rs.getBoolean(12));
                    user.setBirthdate(rs.getDate(13));
                    user.setOtp(rs.getString(14));
                    return user;
                }
            }
        }
        throw new SQLException("User does not exist or is not active");
    }

    public boolean resetPassword(String email, String newPassword) {
        String sql = "UPDATE pms.user SET password = ? WHERE email = ?";
        try (PreparedStatement preparedStatement = getConnection().prepareStatement(sql)) {
            preparedStatement.setString(1, BaseService.hashPassword(newPassword));
            preparedStatement.setString(2, email);
            return preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveOTP(String email, String otp) {
        String sql = "UPDATE pms.user SET otp = ? WHERE email = ?";
        try (PreparedStatement preparedStatement = getConnection().prepareStatement(sql)) {
            preparedStatement.setString(1, otp);
            preparedStatement.setString(2, email);
            return preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createUser(String fullname, String email, String password) {
        String insertSQL = "INSERT INTO pms.user (fullname, email, password, status, role, departmentId) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = getConnection().prepareStatement(insertSQL)) {
            stmt.setString(1, fullname);
            stmt.setString(2, email);
            stmt.setString(3, BaseService.hashPassword(password));
            stmt.setInt(4, 1);
            stmt.setInt(5, 2);
            stmt.setInt(6, 1);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserStatus(int userId, int newStatus) throws SQLException {
        String query = "UPDATE pms.user SET status = ? WHERE id = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(query)) {
            stmt.setInt(1, newStatus);
            stmt.setInt(2, userId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error updating user status: " + e.getMessage());
        }
    }

    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pms.user WHERE email = ?";
        try (PreparedStatement pstmt = getConnection().prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public boolean checkMobileExists(String mobile) {
        String sql = "SELECT COUNT(*) FROM pms.user WHERE mobile = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, mobile);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> searchFilter(List<User> list, Integer departmentId, Integer status, String keyword) {
        List<User> filteredList = new ArrayList<>();

        for (User user : list) {
            boolean matchesDepartment = (departmentId == null || departmentId == 0 || user.getDepartment().getId() == departmentId);
            boolean matchesStatus = (status == null || status == 0 || user.getStatus() == status);
            boolean matchesKeyword = (keyword == null || keyword.isBlank() || user.getFullname().toLowerCase().contains(keyword.toLowerCase()));

            if (matchesDepartment && matchesStatus && matchesKeyword) {
                filteredList.add(user);
            }
        }

        return filteredList;
    }

    public void saveOTPId(int id, String otp) throws SQLException {
        String sql = "UPDATE pms.user SET otp = ? WHERE id = ?";
        try (PreparedStatement preparedStatement = getConnection().prepareStatement(sql)) {
            preparedStatement.setString(1, otp);
            preparedStatement.setInt(2, id);
            preparedStatement.executeUpdate();
        }
    }

    public void updateEmail(String email, int id) throws SQLException {
        String sql = "UPDATE pms.user SET email = ? WHERE id = ?";
        try (PreparedStatement preparedStatement = getConnection().prepareStatement(sql)) {
            preparedStatement.setString(1, email);
            preparedStatement.setInt(2, id);
            preparedStatement.executeUpdate();
        }
    }

    public boolean isOTP_Expired(int id) throws SQLException {
        String sql = """
                 SELECT
                     CASE 
                         WHEN otp_expiry < NOW() THEN 'Expired'
                         ELSE 'Valid'
                     END AS otp_status
                 FROM 
                     pms.user WHERE id = ?""";
        try (PreparedStatement pstmt = getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && "Expired".equals(rs.getString(1));
            }
        }
    }

    public boolean validateOTP(String otp, int id) throws SQLException {
        String sql = "SELECT otp FROM pms.user WHERE id = ?";
        try (PreparedStatement pstmt = getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && otp.equals(rs.getString(1));
            }
        }
    }

    public int countAssignedReq(int id) throws SQLException {
        String sql = "SELECT count(*) FROM pms.requirement WHERE userId = ?";
        try (PreparedStatement pstmt = getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public int countAssignedIssue(int id) throws SQLException {
        String sql = "SELECT count(*) FROM pms.issue WHERE assignee_id = ?";
        try (PreparedStatement pstmt = getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<User> getUsersByProjectId(int projectId) {
        String sql = "select u.* \n"
                + //
                "from \n"
                + //
                "\tallocation a,\n"
                + //
                "    project p,\n"
                + //
                "    user u\n"
                + //
                "where\n"
                + //
                "\tp.id = a.projectId \n"
                + //
                "    AND a.userId = u.id\n"
                + //
                "    AND p.id = ?";
        List<User> list = new ArrayList<>();
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, projectId);
            ResultSet rs = pre.executeQuery();
            UserDAO userDao = new UserDAO();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt(1));
                user.setEmail(rs.getString(2));
                user.setFullname(rs.getString(3));
                user.setMobile(rs.getString(4));
                user.setPassword(rs.getString(5));
                user.setNote(rs.getString(6));
                user.setRole(rs.getInt(7));
                user.setStatus(rs.getInt(8));
                user.setDepartment(new Group(gdao.getDeptNameById(rs.getInt(9))));
                user.setImage(rs.getString(10));
                user.setAddress(rs.getString(11));
                user.setGender(rs.getBoolean(12));
                user.setBirthdate(rs.getDate(13));

                list.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error:  " + e);
        }

        return list;
    }

}
