package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Group;

public class DepartmentDAO extends BaseDAO {

    public List<Group> getAllDepartment() throws SQLException {
        List<Group> listD = new ArrayList<>();
        String sql = "SELECT * FROM department";
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

    // Lấy tên phòng ban theo ID
    public String getDeptNameById(int id) throws SQLException {
        String sql = "SELECT name FROM department WHERE id = ?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return null;
    }

    // Xóa phòng ban theo ID
    public int Delete(int departmentID) {
        int n = 0;
        String sql = "DELETE FROM department WHERE id = ?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, departmentID);
            n = pre.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
        return n;
    }

    // Lấy tất cả phòng ban
    public List<Group> Read() throws SQLException {
        List<Group> listD = new ArrayList<>();
        String sql = "SELECT * FROM department";

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

    // Lấy phòng ban cha theo ID
    public Group getParentDepartmentById(int id) {
        String sql = "SELECT * FROM department WHERE id = ?";
        Group department = null;

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();

            if (rs.next()) {
                department = new Group(); // Khởi tạo đối tượng Group để đại diện cho parent department
                department.setId(rs.getInt("id"));
                department.setCode(rs.getString("code"));
                department.setName(rs.getString("name"));
                department.setDetails(rs.getString("details"));
                department.setStatus(rs.getInt("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return department; // Trả về đối tượng Group đại diện cho parent
    }

    // Đọc danh sách phòng ban với phân trang
    public List<Group> readDepartments(int pageNumber, int pageSize) {
        List<Group> listD = new ArrayList<>();

        // Tính toán offset dựa trên số trang và số bản ghi trên mỗi trang
        int offset = (pageNumber - 1) * pageSize;

        // Câu truy vấn với limit và offset để phân trang
        String sql = "SELECT * FROM department LIMIT ? OFFSET ?";

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
        String sql = "INSERT INTO department (code, name, details, status" + (parent != null ? ", parent" : "") + ") VALUES (?, ?, ?, ?" + (parent != null ? ", ?" : "") + ")";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
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
        String sql = "UPDATE department SET code = ?, name = ?, details = ?, parent = ?, status = ? WHERE id = ?";

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
        String sql = "SELECT * FROM department WHERE id = ?";
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
    public List<Group> filter(int pageNumber, int pageSize, String code, String name, Integer status) {
        List<Group> departments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM department WHERE 1=1");

        // Append các điều kiện filter
        if (code != null && !code.isEmpty()) {
            sql.append(" AND code LIKE ?");
        }
        if (name != null && !name.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (status != null) {
            sql.append(" AND status = ?");
        }
        sql.append(" LIMIT ?, ?");

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql.toString());

            // Set giá trị cho các điều kiện filter
            int paramIndex = 1;
            if (code != null && !code.isEmpty()) {
                pre.setString(paramIndex++, "%" + code + "%");
            }
            if (name != null && !name.isEmpty()) {
                pre.setString(paramIndex++, "%" + name + "%");
            }
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
        String sql = "SELECT * FROM department WHERE code LIKE ? OR name LIKE ? OR details LIKE ?";

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
    String query = "SELECT COUNT(*) FROM department  WHERE code = ?";
    try (PreparedStatement ps = getConnection().prepareStatement(query)) {
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
    String query = "SELECT COUNT(*) FROM department  WHERE name = ?";
    try (PreparedStatement ps = getConnection().prepareStatement(query)) {
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

}
