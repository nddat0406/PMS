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
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, userId);
            ResultSet rs = pre.executeQuery();
            rs.next();
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
        } catch (SQLException e) {
            throw new SQLException("User not exis or not active");
        }
    }
// Phương thức đăng nhập người dùng

    public User getUserLogin(String username, String password) throws Exception {
        String query = "SELECT id, email, fullname, mobile, password, note, role, status, departmentId, image,gender, otp, otp_expiry "
                + "FROM pms.user WHERE user_name = ?";

        try {
            PreparedStatement ps = getConnection().prepareStatement(query);
            ps.setString(1, username);

            try (ResultSet resultSet = ps.executeQuery()) {
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
            }
        } catch (SQLException e) {
            throw new Exception("Lỗi khi đăng nhập: " + e.getMessage(), e);
        }

        return null; // Trả về null nếu không tìm thấy người dùng hoặc mật khẩu sai
    }

    // Phương thức đăng ký người dùng mới
    public String registerUser(String username, String pass, String email, String name, String phone) {
        String sql = "INSERT INTO pms.user (password, email, fullname, mobile, role, status) VALUES (?, ?, ?, ?, 1, 0)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            String hashedPassword = BaseService.hashPassword(pass);

            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            ps.setString(3, name);
            ps.setString(4, phone);

            ps.executeUpdate();

            // Tạo và gửi mã OTP
            String otp = BaseService.generateOTP(); // Tạo mã OTP
            BaseService.sendEmail(email, otp);

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
            return null;
        }
    }

    public boolean checkOldPassword(String email, String oldPassword) {
        String sql = "SELECT password FROM pms.user WHERE email = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
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
                             `email` = ?,
                             `fullname` = ?,
                             `mobile` = ?,
                             `image` = ?,
                             `address` = ?,
                             `gender` = ?,
                             `birthdate` =? ,
                             `image`= ?
                             WHERE `id` = ?;""";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setString(1, user.getEmail());
            pre.setString(2, user.getFullname());
            pre.setString(3, user.getMobile());
            pre.setString(4, user.getImage());
            pre.setString(5, user.getAddress());
            pre.setBoolean(6, user.isGender());
            pre.setDate(7, user.getBirthdate());
            pre.setString(8, user.getImage());
            pre.setInt(9, user.getId());
            pre.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public String getUserPassword(int id) throws SQLException {
        String str = "SELECT password FROM pms.user where id=? and status = 1";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();

            return rs.getString(1);
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM pms.user WHERE email = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Kiểm tra số lượng bản ghi trả về
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu không tìm thấy email
    }

    public boolean checkEmailChanged(String email, int id) throws Exception {
        String sql = "SELECT email FROM pms.user WHERE id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return !rs.getString(1).equals(email);
            }
        } catch (SQLException e) {
            return true;
        }
    }

    public boolean verifyOtp(String email, String enteredOtp) {
        String sql = "SELECT otp, otp_expiry FROM pms.user WHERE email = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String otp = rs.getString("otp");
                java.sql.Timestamp otpExpiry = rs.getTimestamp("otp_expiry");

                // Kiểm tra null trước khi so sánh OTP và thời gian hết hạn
                if (otp != null && otpExpiry != null) {
                    java.sql.Timestamp currentTime = new java.sql.Timestamp(System.currentTimeMillis());

                    // In ra để kiểm tra giá trị
                    System.out.println("OTP từ DB: " + otp);
                    System.out.println("OTP nhập vào: " + enteredOtp);
                    System.out.println("Thời gian hết hạn OTP: " + otpExpiry);
                    System.out.println("Thời gian hiện tại: " + currentTime);

                    // Kiểm tra nếu OTP khớp và chưa hết hạn
                    if (otp.equals(enteredOtp) && otpExpiry.after(currentTime)) {
                        return true; // OTP hợp lệ
                    } else {
                        System.out.println("OTP không hợp lệ hoặc đã hết hạn");
                    }
                } else {
                    System.out.println("OTP hoặc thời gian hết hạn bị null");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // OTP không hợp lệ
    }

    public void updateUserPassword(String newPass, int id) throws SQLException {
        String str = """
                             UPDATE `pms`.`user`
                             SET
                             `password` = ?
                              
                             WHERE `id` = ?;""";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setString(1, newPass);
            pre.setInt(2, id);
            pre.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean isUserExist(String username, String email) {
        String sql = "SELECT COUNT(*) FROM project_evaluation_system.user WHERE user_name = ? OR email = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // Nếu tồn tại tài khoản
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAll() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.user";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery(); // Đổi `execute()` thành `executeQuery()` vì đây là câu truy vấn trả về kết quả
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
            throw new SQLException(e);
        }
        return list;
    }

    public List<User> findByName(String keyword) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.user where fullname like ?;";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
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

                list.add(user); // Thêm user vào danh sách
            }
        } catch (SQLException e) {

            throw new SQLException(e);
        }

        return list;
    }

    public void Insert(User uNew) throws SQLException {
        String sql = "INSERT INTO pms.user (email,mobile, fullname, password, role, status, departmentId, address) VALUES (?,?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
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
        String sql = "DELETE FROM `pms`.`user`"
                + "WHERE id=?;";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);

            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public static void main(String[] args) throws SQLException {
        new UserDAO().deleteUser(15);
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pms.user WHERE email = ?";
        PreparedStatement statement = getConnection().prepareStatement(sql);
        statement.setString(1, email);
        try (ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0; // Nếu kết quả trả về lớn hơn 0, nghĩa là email tồn tại
            }
        }

        return false;
    }

    public void updateUserAccount(User user) throws SQLException {
        String sql = "UPDATE pms.user SET  role=?, status=?, departmentId=? WHERE id=?";
        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, user.getRole());
            stmt.setInt(2, user.getStatus());
            stmt.setInt(3, user.getDepartment().getId());  // Assuming department is not null
            stmt.setInt(4, user.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public User getUserById(int userId) throws SQLException {
        String str = "SELECT * FROM pms.user where id=?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, userId);
            ResultSet rs = pre.executeQuery();
            rs.next();
            User user = new User();
            user.setId(rs.getInt(1));
            user.setEmail(rs.getString(2));
            user.setNote(rs.getString(6));
            user.setRole(rs.getInt(7));
            user.setDepartment(new Group(gdao.getDeptNameById(rs.getInt(9))));

            return user;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Group> getAllDept() throws SQLException {
        List<Group> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.department;";
        try {
            Statement stmt = getConnection().createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Group dept = new Group();
                dept.setId(rs.getInt("id"));
                dept.setName(rs.getString("name"));
                list.add(dept);
            }
        } catch (SQLException e) {
            throw new SQLException(e);

        }
        return list;
    }

    public Group getDeptId(int id) throws SQLException {
        String sql = "SELECT * FROM pms.department where id=?;";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();
            Group group = new Group();
            group.setId(rs.getInt(1));

            return group;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public boolean verifyLogin(String email, String pass) throws SQLException {
        String sql = "SELECT password FROM pms.user where email=? and status =1";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery(); // Đổi `execute()` thành `executeQuery()` vì đây là câu truy vấn trả về kết quả
            rs.next();
            return BaseService.checkPassword(pass, rs.getString(1));
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String str = "SELECT * FROM pms.user where email=? and status = 1";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setString(1, email);
            ResultSet rs = pre.executeQuery();
            rs.next();
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
        } catch (SQLException e) {
            throw new SQLException("User not exis or not active");
        }
    }

    public boolean resetPassword(String email, String newPassword) {
        String sql = "UPDATE pms.user SET password = ? WHERE email = ?";

        try {
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setString(1, BaseService.hashPassword(newPassword));
            preparedStatement.setString(2, email);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveOTP(String email, String otp) {
        String sql = "UPDATE pms.user SET otp = ? WHERE email = ?";

        try {
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setString(1, otp);
            preparedStatement.setString(2, email);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createUser(String fullname, String email, String password) {
        String insertSQL = "INSERT INTO pms.user (fullname, email, password, status, role, departmentId) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(insertSQL);
            stmt.setString(1, fullname);
            stmt.setString(2, email);
            stmt.setString(3, BaseService.hashPassword(password));
            stmt.setInt(4, 1);
            stmt.setInt(5, 2);
            stmt.setInt(6, 1);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserStatus(int userId, int newStatus) throws SQLException {
        String query = "UPDATE pms.user SET status = ? WHERE id = ?";
        try ( PreparedStatement stmt = getConnection().prepareStatement(query)) {

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

        boolean exists = false;
        String sql = "SELECT COUNT(*) FROM pms.user WHERE email = ?";
        Connection conn = getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            exists = rs.getInt(1) > 0;
        }

        return exists;
    }

    public boolean checkMobileExists(String mobile) {
        String sql = "SELECT COUNT(*) FROM pms.user WHERE mobile = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, mobile);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Kiểm tra số lượng bản ghi trả về
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu không tìm thấy email
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
}
