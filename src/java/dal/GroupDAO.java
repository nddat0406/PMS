
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Group;

/**
 *
 * @author ASUS TUF
 */
public class GroupDAO extends BaseDAO {

    public String getDeptNameById(int id) throws SQLException {
        String str = "SELECT name FROM pms.group  where type=0 and id=? ";
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

    public String getDomainName(int id) throws SQLException {
        String str = "SELECT name FROM pms.group  where type=1 and id=? ";
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
//list all domai

    public List<Group> Read(int pageNumber, int pageSize) {
        List<Group> listD = new ArrayList<>();

        int offset = (pageNumber - 1) * pageSize;

        String sql = "SELECT * FROM pms.group  where type=1  LIMIT ? OFFSET ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);

            pre.setInt(1, pageSize);
            pre.setInt(2, offset);

            ResultSet rs = pre.executeQuery();

            while (rs.next()) {
                Group domain = new Group();

                domain.setId(rs.getInt("id"));
                domain.setCode(rs.getString("code"));
                domain.setName(rs.getString("name"));
                domain.setDetails(rs.getString("details"));
                domain.setStatus(rs.getInt("status"));

                listD.add(domain);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listD;
    }

// Thêm domain mới 
    public int Add(String code, String name, String details, int status) {
        int n = 0;
        String sql = "INSERT INTO pms.group (code, name, details, status,type) VALUES (?, ?, ?, ?, 1)";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);

            pre.setString(1, code);
            pre.setString(2, name);
            pre.setString(3, details);
            pre.setInt(4, status);

            n = pre.executeUpdate();

        } catch (SQLException e) {
            System.out.println(e);
        }
        return n;
    }

    // update Domain 
    public int Update(int domainID, String code, String name, String details, int status) {
        int n = 0;
        String sql = "UPDATE pms.group SET code = ?, name = ?, details = ?, status = ? WHERE id = ?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);

            pre.setString(1, code);
            pre.setString(2, name);
            pre.setString(3, details);
            pre.setInt(4, status);

            //  id của domain cần cập nhật
            pre.setInt(5, domainID);

            n = pre.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
        return n;
    }

// Lấy thông tin chi tiết của domain theo ID
    public Group Detail(int domainID) {
        Group domain = null;
        String sql = "SELECT * FROM pms.group  where type=1 and id = ?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, domainID);
            ResultSet rs = pre.executeQuery();

            if (rs.next()) {
                domain = new Group();
                domain.setId(rs.getInt("id"));
                domain.setCode(rs.getString("code"));
                domain.setName(rs.getString("name"));
                domain.setDetails(rs.getString("details"));
                domain.setStatus(rs.getInt("status"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return domain;
    }

    public List<Group> Search(String keyword) {
        List<Group> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.group  where type=1 and code LIKE ? OR name LIKE ? OR details LIKE ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);

            // Sử dụng ký tự % để tìm kiếm với từ khóa
            String searchKeyword = "%" + keyword + "%";

            pre.setString(1, searchKeyword);
            pre.setString(2, searchKeyword);
            pre.setString(3, searchKeyword);

            ResultSet rs = pre.executeQuery();

            while (rs.next()) {
                Group domain = new Group();
                domain.setId(rs.getInt("id"));
                domain.setCode(rs.getString("code"));
                domain.setName(rs.getString("name"));
                domain.setDetails(rs.getString("details"));
                domain.setStatus(rs.getInt("status"));

                list.add(domain);
            }

        } catch (SQLException e) {
            System.out.println(e);
        }

        return list;
    }

    public boolean isCodeExist(String code) {
        String query = "SELECT COUNT(*) FROM pms.group  where type=1 and code = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(query);
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isNameExist(String name) {
        String query = "SELECT COUNT(*) FROM pms.group  where type=1 and name = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(query);
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Group> filterGroups(int pageNumber, int pageSize, Integer status) {
        List<Group> groups = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM pms.group  where type=1 and 1=1");

        // Append các điều kiện filter
        if (status != null) {
            sql.append(" AND status = ?");
        }

        sql.append(" LIMIT ?, ?");

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql.toString());

            // Set giá trị cho các điều kiện filter
            int paramIndex = 1;
            if (status != null) {
                pre.setInt(paramIndex++, status);
            }

            // Set giá trị cho LIMIT
            pre.setInt(paramIndex++, (pageNumber - 1) * pageSize);
            pre.setInt(paramIndex++, pageSize);

            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                Group group = new Group();
                group.setId(rs.getInt("id"));
                group.setCode(rs.getString("code"));
                group.setName(rs.getString("name"));
                group.setDetails(rs.getString("details"));
                group.setStatus(rs.getInt("status"));
                groups.add(group);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return groups;
    }

    public List<Group> getAllDomain() throws SQLException {
        List<Group> listD = new ArrayList<>();
        String sql = "SELECT * FROM pms.group  where type=1";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            ResultSet rs = pre.executeQuery();

            while (rs.next()) {
                Group domain = new Group();

                domain.setId(rs.getInt("id"));
                domain.setCode(rs.getString("code"));
                domain.setName(rs.getString("name"));
                domain.setDetails(rs.getString("details"));
                domain.setStatus(rs.getInt("status"));

                listD.add(domain);
            }

        } catch (SQLException e) {
            throw new SQLException(e);
        }

        return listD;
    }

    public List<Group> getDomainUser() {
        List<Group> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.domain_user";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            UserDAO userDao = new UserDAO();
            while (rs.next()) {
                Group domain = new Group();
                domain.setId(rs.getInt("id"));
                domain.setStatus(rs.getInt("status"));
                domain.setUser(userDao.getActiveUserById(rs.getInt("userId")));
                domain.setParent(new Group(getDeptNameById(rs.getInt("domainId"))));
                list.add(domain);
            }
        } catch (SQLException e) {
            System.out.println("Error:  " + e);
        }

        return list;
    }

    public List<Group> getDomainUserByDomainId(String domainId) {
        List<Group> list = new ArrayList<>();
        String sql = "select du.* \n"
                + "from pms.group as g,\n"
                + "pms.domain_user as du\n"
                + "where du.domainId = g.id\n"
                + "and g.type = 1 AND domainId = ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setObject(1, domainId);
            ResultSet rs = pre.executeQuery();
            UserDAO userDao = new UserDAO();
            while (rs.next()) {
                Group domain = new Group();
                domain.setId(rs.getInt("id"));
                domain.setStatus(rs.getInt("status"));
                domain.setUser(userDao.getActiveUserById(rs.getInt("userId")));
//                domain.setParent(new Group(getDeptNameById(rs.getInt("domainId"))));
                list.add(domain);
            }
        } catch (SQLException e) {
            System.out.println("Error:  " + e);
        }

        return list;
    }

    public List<Group> getAllDepartment() throws SQLException {
        List<Group> listD = new ArrayList<>();
        String sql = "SELECT * FROM pms.group  where type=0";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                Group department = new Group();

                department.setId(rs.getInt("id"));
                department.setCode(rs.getString("code"));
                department.setName(rs.getString("name"));
                department.setDetails(rs.getString("details"));

                // Lấy phòng ban cha, xử lý nếu 'parent' có thể null 
                int parentId = rs.getInt("parent");
                if (!rs.wasNull()) {
                    Group parentDepartment = getParentDepartmentById(parentId);
                    department.setParent(parentDepartment);
                } else {
                    department.setParent(null);
                }

                department.setStatus(rs.getInt("status"));

                listD.add(department);
            }

        } catch (SQLException e) {
            throw new SQLException(e);
        }

        return listD;
    }

    public Group getParentDepartmentById(int id) {
        String sql = "SELECT * FROM pms.group  where type=0 and id = ?";
        Group department = null;
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                department = new Group();
                department.setId(rs.getInt("id"));
                department.setCode(rs.getString("code"));
                department.setName(rs.getString("name"));
                department.setDetails(rs.getString("details"));
                department.setStatus(rs.getInt("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return department;
    }

    // Lấy tất cả phòng ban
    public List<Group> Read() throws SQLException {
        List<Group> listD = new ArrayList<>();
        String sql = "SELECT * FROM pms.group  where type=0";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            ResultSet rs = pre.executeQuery();

            while (rs.next()) {
                Group department = new Group(); // 'Group' là đại diện cho phòng ban

                department.setId(rs.getInt("id"));
                department.setCode(rs.getString("code"));
                department.setName(rs.getString("name"));
                department.setDetails(rs.getString("details"));

                // Lấy phòng ban cha, xử lý nếu 'parent' có thể null
                int parentId = rs.getInt("parent");
                if (!rs.wasNull()) {
                    Group parentDepartment = getParentDepartmentById(parentId);
                    department.setParent(parentDepartment); // Set parent là một đối tượng Group
                } else {
                    department.setParent(null); // Nếu không có parent, set null
                }

                department.setStatus(rs.getInt("status"));
                listD.add(department);
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }

        return listD;
    }

    // Đọc danh sách phòng ban với phân trang
    public List<Group> readDepartments(int pageNumber, int pageSize) {
        List<Group> listD = new ArrayList<>();

        // Tính toán offset dựa trên số trang và số bản ghi trên mỗi trang
        int offset = (pageNumber - 1) * pageSize;

        // Câu truy vấn với limit và offset để phân trang
        String sql = "SELECT * FROM pms.group  where type=0 LIMIT ? OFFSET ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);

            // Đặt giá trị limit (số bản ghi cần lấy) và offset (vị trí bắt đầu)
            pre.setInt(1, pageSize);  // Số lượng bản ghi trên mỗi trang
            pre.setInt(2, offset);    // Vị trí bắt đầu

            ResultSet rs = pre.executeQuery();

            while (rs.next()) {
                Group department = new Group();

                department.setId(rs.getInt("id"));
                department.setCode(rs.getString("code"));
                department.setName(rs.getString("name"));
                department.setDetails(rs.getString("details"));
                department.setStatus(rs.getInt("status"));

                // Xử lý lấy phòng ban cha nếu có
                int parentId = rs.getInt("parent");
                if (!rs.wasNull()) {
                    Group parentDepartment = getParentDepartmentById(parentId);
                    department.setParent(parentDepartment);
                } else {
                    department.setParent(null);
                }

                listD.add(department);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listD;
    }

    // Thêm phòng ban mới
    public int Add(String code, String name, String details, Integer parent, int status) {
        String sql = "INSERT INTO pms.group (code, name, details, status, type" + (parent != null ? ", parent" : "") + ") VALUES (?, ?, ?, ?, 0" + (parent != null ? ", ?" : "") + ")";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, code);
            ps.setString(2, name);
            ps.setString(3, details);
            ps.setInt(4, status);
            if (parent != null) {
                ps.setInt(5, parent);
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0; // Hoặc ném ngoại lệ tùy thuộc vào logic của bạn
        }
    }

    // Cập nhật thông tin phòng ban
    public int Update(int departmentID, String code, String name, String details, Integer parent, int status) {
        int n = 0;
        String sql = "UPDATE pms.group SET code = ?, name = ?, details = ?, parent = ?, status = ? WHERE id = ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setString(1, code);
            pre.setString(2, name);
            pre.setString(3, details);

            // Kiểm tra xem parent có null không
            if (parent != null) {
                pre.setInt(4, parent);
            } else {
                pre.setNull(4, java.sql.Types.INTEGER); // Set null nếu không có parent
            }

            pre.setInt(5, status);
            pre.setInt(6, departmentID);

            n = pre.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
        return n;
    }

    // Lấy thông tin chi tiết của phòng ban theo ID
    public Group getDepartmentDetail(int departmentID) {
        Group department = null;
        String sql = "SELECT * FROM pms.group  where type=0 and id = ?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, departmentID);
            ResultSet rs = pre.executeQuery();

            if (rs.next()) {
                department = new Group();
                department.setId(rs.getInt("id"));
                department.setCode(rs.getString("code"));
                department.setName(rs.getString("name"));
                department.setDetails(rs.getString("details"));
                department.setStatus(rs.getInt("status"));

                // Xử lý lấy phòng ban cha nếu có
                int parentId = rs.getInt("parent");
                if (!rs.wasNull()) {
                    Group parentDepartment = getParentDepartmentById(parentId);
                    department.setParent(parentDepartment);
                } else {
                    department.setParent(null);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return department; // Trả về đối tượng department
    }

    // Phương thức lọc phòng ban theo mã, tên, phòng ban cha và trạng thái
    public List<Group> filter(int pageNumber, int pageSize, Integer status) {
        List<Group> departments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM pms.group  where type=0 and 1=1");

        // Append các điều kiện filter
        if (status != null) {
            sql.append(" AND status = ?");
        }
        sql.append(" LIMIT ?, ?");

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql.toString());

            // Set giá trị cho các điều kiện filter
            int paramIndex = 1;
            if (status != null) {
                pre.setInt(paramIndex++, status);
            }

            // Set giá trị cho LIMIT
            pre.setInt(paramIndex++, (pageNumber - 1) * pageSize);
            pre.setInt(paramIndex++, pageSize);

            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                Group department = new Group();
                department.setId(rs.getInt("id"));
                department.setCode(rs.getString("code"));
                department.setName(rs.getString("name"));
                department.setDetails(rs.getString("details"));
                department.setStatus(rs.getInt("status"));

                // Lấy phòng ban cha, xử lý nếu 'parent' có thể null
                int parentID = rs.getInt("parent");
                if (!rs.wasNull()) {
                    Group parentDepartment = getParentDepartmentById(parentID);
                    department.setParent(parentDepartment); // Set parent là một đối tượng Group
                } else {
                    department.setParent(null); // Nếu không có parent, set null
                }
                departments.add(department);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return departments;
    }

    // Tìm kiếm phòng ban theo từ khóa
    public List<Group> searchDepartments(String keyword) {
        List<Group> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.group  where type=0 and code LIKE ? OR name LIKE ? OR details LIKE ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);

            // Sử dụng ký tự % để tìm kiếm với từ khóa
            String searchKeyword = "%" + keyword + "%";

            pre.setString(1, searchKeyword);
            pre.setString(2, searchKeyword);
            pre.setString(3, searchKeyword);

            ResultSet rs = pre.executeQuery();

            while (rs.next()) {
                Group department = new Group();
                department.setId(rs.getInt("id"));
                department.setCode(rs.getString("code"));
                department.setName(rs.getString("name"));
                department.setDetails(rs.getString("details"));
                department.setStatus(rs.getInt("status"));

                // Xử lý lấy phòng ban cha nếu có
                int parentId = rs.getInt("parent");
                if (!rs.wasNull()) {
                    Group parentDepartment = getParentDepartmentById(parentId);
                    department.setParent(parentDepartment);
                } else {
                    department.setParent(null);
                }

                list.add(department);
            }

        } catch (SQLException e) {
            System.out.println(e);
        }

        return list;
    }

    // validation code va name 
    public boolean isCodeExists(String code) {
        String query = "SELECT COUNT(*) FROM pms.group  where type=0 and code = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(query);
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isNameExists(String name) {
        String query = "SELECT COUNT(*) FROM pms.group  where type=0 and name = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(query);
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Group> getAllUserDomain() {
        List<Group> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.domain_user JOIN pms.user ON domain_user.userId = user.id JOIN pms.domain ON domain_user.domainId = domain.id;";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String id = String.valueOf(rs.getInt(1));
                String status = String.valueOf(rs.getInt(4));
                String email = rs.getString(5);
                String fullname = rs.getString(7);

                String mobile = rs.getString(8);
                String domainName = rs.getString(21);
                Group d = new Group();
                list.add(d);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public void addDomainUser(Group user) throws SQLException {

        String sql = "INSERT INTO domain_user (id, userId, domainId, status) VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement pstmt = getConnection().prepareStatement(sql);
            pstmt.setInt(1, user.getId());
            pstmt.setString(2, user.getUser().getId() + "");
            pstmt.setInt(3, user.getParent().getId());
            pstmt.setInt(4, user.getStatus());
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    public List<Group> getDomainUsersWithPagination(int page, int pageSize) {
        List<Group> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.domain_user LIMIT ? OFFSET ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            int offset = (page - 1) * pageSize;

            pre.setInt(1, pageSize);  // Limit the number of records per page
            pre.setInt(2, offset);    // Skip records based on the page

            ResultSet rs = pre.executeQuery();
            UserDAO userDao = new UserDAO();

            while (rs.next()) {
                Group domain = new Group();
                domain.setId(rs.getInt("id"));
                domain.setStatus(rs.getInt("status"));
                domain.setUser(userDao.getActiveUserById(rs.getInt("userId")));
                domain.setParent(new Group(getDeptNameById(rs.getInt("domainId"))));
                list.add(domain);
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }

        return list;
    }

    public int getDomainUserCount() {
        int count = 0;
        try {
            String query = "SELECT COUNT(*) FROM pms.domain_user";
            PreparedStatement ps = getConnection().prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public void updateStatusDomain(String status, int id) throws SQLException {
        String sql = "UPDATE domain_user SET status = ? WHERE id = ?";

        try {
            PreparedStatement pstmt = getConnection().prepareStatement(sql);

            pstmt.setInt(1, status.equals("active") ? 1 : 0);
            pstmt.setInt(2, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    public void deleteDomainUser(int id) throws SQLException {
        String sql = "DELETE FROM domain_user WHERE id = ?";

        try {
            PreparedStatement pstmt = getConnection().prepareStatement(sql);

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    public Group getDomainUserById(int id) throws SQLException {
        String sql = "SELECT * FROM domain_user WHERE id = ?";

        try {
            PreparedStatement pstmt = getConnection().prepareStatement(sql);
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            UserDAO userDao = new UserDAO();
            if (rs.next()) {
                Group domain = new Group();
                domain.setId(rs.getInt("id"));
                domain.setStatus(rs.getInt("status"));
                domain.setUser(userDao.getUserById(rs.getInt("userId")));
                domain.setParent(new Group(getDomainName(rs.getInt("domainId"))));
                return domain;
            }
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }

        return null;
    }

    public int getLatestId() throws SQLException {
        String sql = "SELECT MAX(id) FROM domain_user";
        int latestId = 0;

        try {
            PreparedStatement pstmt = getConnection().prepareStatement(sql);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                latestId = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }

        return latestId + 1;
    }

    public void updateDomainUser(Group user) throws SQLException {
        String sql = "UPDATE domain_user SET userId = ?, domainId = ?, status = ? WHERE id = ?";

        try {
            PreparedStatement pstmt = getConnection().prepareStatement(sql);

            pstmt.setString(1, user.getUser().getId() + "");
            pstmt.setInt(2, user.getParent().getId());
            pstmt.setInt(3, user.getStatus());
            pstmt.setInt(4, user.getId());
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

}
