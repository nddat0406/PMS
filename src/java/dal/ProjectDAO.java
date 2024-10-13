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
import model.Allocation;
import model.Group;
import model.Milestone;
import model.Project;
import model.ProjectPhase;

/**
 *
 * @author HP
 */
public class ProjectDAO extends BaseDAO {

    private GroupDAO gdao = new GroupDAO();
    private UserDAO udao = new UserDAO();
    private MilestoneDAO mdao = new MilestoneDAO();

    public List<Allocation> getAllInAllocation() throws SQLException {
        String str = "select * from project";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            ResultSet rs = pre.executeQuery();
            List<Allocation> projectList = new ArrayList<>();
            while (rs.next()) {
                Allocation temp = new Allocation();
                temp.setProject(setProjectInfor(rs));
                projectList.add(temp);
            }
            return projectList;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Project> getAllByUser(int id) throws SQLException {
        String str = "select p.* from allocation a join project p on p.id = a.projectId where userId = ?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();

            List<Project> projectList = new ArrayList<>();
            while (rs.next()) {
                projectList.add(setProjectInfor(rs));
            }
            return projectList;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Allocation> getAllocation(int id) throws SQLException {
        String str = "select * from allocation where userId = ? and status = 1";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            List<Allocation> AllocateList = new ArrayList<>();
            while (rs.next()) {
                AllocateList.add(setAllocationInfor(rs));
            }
            return AllocateList;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    private Project setProjectInfor(ResultSet rs) throws SQLException {
        try {
            Project temp = new Project();
            temp.setId(rs.getInt(1));
            temp.setBizTerm(getBizTerm(rs.getInt(2)));
            temp.setCode(rs.getString(3));
            temp.setName(rs.getString(4));
            temp.setDetails(rs.getString(5));
            temp.setStartDate(rs.getDate(6));
            temp.setStatus(rs.getInt(7));
            Group gr = new Group();
            gr.setId(rs.getInt(8));
            gr.setName(gdao.getDeptNameById(rs.getInt(8)));
            temp.setDepartment(gr);
            Group gr2 = new Group();
            gr2.setId(rs.getInt(9));
            gr2.setName(gdao.getDomainName(rs.getInt(9)));
            temp.setDomain(gr2);
            return temp;
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    private Allocation setAllocationInfor(ResultSet rs) throws SQLException {
        try {
            Allocation temp = new Allocation();
            temp.setId(rs.getInt(8));
            temp.setUser(udao.getActiveUserByIdNull(rs.getInt(1)));
            temp.setProject(getById(rs.getInt(2)));
            temp.setStartDate(rs.getDate(3));
            temp.setEndDate(rs.getDate(4));
            temp.setProjectRole(rs.getString(5));
            temp.setEffortRate(rs.getInt(6));
            temp.setStatus(rs.getBoolean(7));
            return temp;
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    private String getBizTerm(int id) throws SQLException {
        String str = "select name from setting where id=? and type=1 and status = 1";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();
            return rs.getString(1);
        } catch (SQLException e) {
            return null;
        }
    }

    public Project getById(int id) throws SQLException {
        String str = "select * from project where id=?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();
            return (Project) setProjectInfor(rs);
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Allocation> getAllMember(int id) throws SQLException {
        String str = "select a.* from allocation a join user u on u.id = a.userId where a.projectId = ?";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, id);
        ResultSet rs = pre.executeQuery();

        List<Allocation> userList = new ArrayList<>();
        while (rs.next()) {
            Allocation user = setAllocationInfor(rs);
            if (user.getUser() != null) {
                userList.add(user);
            }
        }
        return userList;

    }

    public void flipStatusMemberOfPrj(int id) throws SQLException {
        String sql = """
                     UPDATE `pms`.`allocation`
                     SET
                     `status` = status ^ 1
                     WHERE `id` = ?""";
        PreparedStatement st = getConnection().prepareStatement(sql);
        st.setInt(1, id);
        st.executeUpdate();
    }

    //  ------------------  project list vs project detail -----------------------------
    //list prj
    public List<Project> listProjects(int userId, int page, int pageSize, String keyword, Integer status) {
        List<Project> projects = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT p.id, p.bizTerm, p.code, p.name, p.details, p.startDate, p.status, "
                + "g1.id AS domainId, g1.name AS domainName, "
                + "g2.id AS departmentId, g2.name AS departmentName "
                + "FROM project p "
                + "JOIN allocation a ON p.id = a.projectId "
                + "JOIN `group` g1 ON p.domainId = g1.id AND g1.type = 1 " // Join với group để lấy thông tin domain (type = 1)
                + "JOIN `group` g2 ON p.departmentId = g2.id AND g2.type = 0 " // Join với group để lấy thông tin department (type = 0)
                + "WHERE a.userId = ? "); // Điều kiện để chỉ lấy các dự án của người dùng

        // Thêm điều kiện tìm kiếm theo keyword nếu có
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append("AND (p.name LIKE ? OR p.code LIKE ?) ");
        }

        // Thêm điều kiện lọc theo trạng thái nếu có
        if (status != null) {
            query.append("AND p.status = ? ");
        }

        query.append("LIMIT ? OFFSET ?");
        int offset = (page - 1) * pageSize;

        try (PreparedStatement pre = getConnection().prepareStatement(query.toString())) {
            int index = 1;

            // Thiết lập tham số userId
            pre.setInt(index++, userId);

            // Thiết lập tham số tìm kiếm
            if (keyword != null && !keyword.trim().isEmpty()) {
                pre.setString(index++, "%" + keyword.trim() + "%");
                pre.setString(index++, "%" + keyword.trim() + "%");
            }

            // Thiết lập tham số lọc theo trạng thái
            if (status != null) {
                pre.setInt(index++, status);
            }

            // Thiết lập tham số phân trang
            pre.setInt(index++, pageSize);
            pre.setInt(index, offset);

            ResultSet resultSet = pre.executeQuery();

            while (resultSet.next()) {
                Project project = new Project();
                project.setId(resultSet.getInt("id"));
                project.setBizTerm(resultSet.getString("bizTerm"));
                project.setCode(resultSet.getString("code"));
                project.setName(resultSet.getString("name"));
                project.setDetails(resultSet.getString("details"));
                project.setStartDate(resultSet.getDate("startDate"));
                project.setStatus(resultSet.getInt("status"));

                // Lấy thông tin domain
                Group domain = new Group();
                domain.setId(resultSet.getInt("domainId"));
                domain.setName(resultSet.getString("domainName"));
                project.setDomain(domain);

                // Lấy thông tin department
                Group department = new Group();
                department.setId(resultSet.getInt("departmentId"));
                department.setName(resultSet.getString("departmentName"));
                project.setDepartment(department);

                projects.add(project);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Thay thế bằng log lỗi nếu cần thiết
        }

        return projects;
    }

    public int getTotalProjects(int userId, String keyword, Integer status) {
        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM project p "
                + "JOIN allocation a ON p.id = a.projectId "
                + "WHERE a.userId = ? "); // Điều kiện để chỉ đếm các dự án của người dùng

        // Thêm điều kiện tìm kiếm theo keyword nếu có
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append("AND (p.name LIKE ? OR p.code LIKE ?) ");
        }

        // Thêm điều kiện lọc theo trạng thái nếu có
        if (status != null) {
            query.append("AND p.status = ? ");
        }

        try (PreparedStatement pre = getConnection().prepareStatement(query.toString())) {
            int index = 1;

            // Thiết lập tham số userId
            pre.setInt(index++, userId);

            // Thiết lập tham số tìm kiếm
            if (keyword != null && !keyword.trim().isEmpty()) {
                pre.setString(index++, "%" + keyword.trim() + "%");
                pre.setString(index++, "%" + keyword.trim() + "%");
            }

            // Thiết lập tham số lọc theo trạng thái
            if (status != null) {
                pre.setInt(index++, status);
            }

            ResultSet resultSet = pre.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Thay thế bằng log lỗi nếu cần thiết
        }

        return 0;
    }

    //lấy detail
    public Project getProjectById(int id) {
        Project project = null;
        String query = "SELECT p.id, p.bizTerm, p.code, p.name, p.details, p.startDate, p.status, "
                + "g1.id AS domainId, g1.name AS domainName, "
                + "g2.id AS departmentId, g2.name AS departmentName "
                + "FROM project p "
                + "JOIN `group` g1 ON p.domainId = g1.id AND g1.type = 1 " // Lấy thông tin domain từ group (type = 1)
                + "JOIN `group` g2 ON p.departmentId = g2.id AND g2.type = 0 " // Lấy thông tin department từ group (type = 0)
                + "WHERE p.id = ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(query);
            pre.setInt(1, id);
            ResultSet resultSet = pre.executeQuery();

            if (resultSet.next()) {
                project = new Project();
                project.setId(resultSet.getInt("id"));
                project.setBizTerm(resultSet.getString("bizTerm"));
                project.setCode(resultSet.getString("code"));
                project.setName(resultSet.getString("name"));
                project.setDetails(resultSet.getString("details"));
                project.setStartDate(resultSet.getDate("startDate"));
                project.setStatus(resultSet.getInt("status"));

                // Lấy thông tin domain
                Group domain = new Group();
                domain.setId(resultSet.getInt("domainId"));
                domain.setName(resultSet.getString("domainName"));
                project.setDomain(domain);

                // Lấy thông tin department
                Group department = new Group();
                department.setId(resultSet.getInt("departmentId"));
                department.setName(resultSet.getString("departmentName"));
                project.setDepartment(department);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return project;
    }

    //thêm prj mới 
    public int addProject(Project project) throws SQLException {
        String sql = "INSERT INTO project (bizTerm, code, name, details, startDate, status, departmentId, domainId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            // Sử dụng Statement.RETURN_GENERATED_KEYS để yêu cầu các khóa tự động sinh
            PreparedStatement statement = getConnection().prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            statement.setString(1, project.getBizTerm());
            statement.setString(2, project.getCode());
            statement.setString(3, project.getName());
            statement.setString(4, project.getDetails());
            statement.setDate(5, new java.sql.Date(project.getStartDate().getTime()));
            statement.setInt(6, project.getStatus());
            statement.setInt(7, project.getDepartmentId());
            statement.setInt(8, project.getDomainId());
            statement.executeUpdate();

            // Lấy khóa tự động sinh (ID) vừa được tạo
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Trả về projectId vừa được tạo
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu không thành công
    }

// Lấy danh sách các giai đoạn dựa trên domainId từ bảng 'projectphase'
    public List<ProjectPhase> getPhasesByDomainId(int domainId) throws SQLException {
        List<ProjectPhase> phases = new ArrayList<>();
        String sql = "SELECT id, name, priority FROM projectphase WHERE domainId = ?";
        try {
            PreparedStatement statement = getConnection().prepareStatement(sql);
            statement.setInt(1, domainId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ProjectPhase phase = new ProjectPhase();
                    phase.setId(resultSet.getInt("id"));
                    phase.setName(resultSet.getString("name"));
                    phase.setPriority(resultSet.getInt("priority"));
                    phases.add(phase);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return phases;
    }

    // Thêm một milestone vào bảng 'milestone'
    public void addMilestone(Milestone milestone) throws SQLException {
        String sql = "INSERT INTO milestone (name, priority, details, endDate, status, deliver, projectId, phaseId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement statement = getConnection().prepareStatement(sql);
            statement.setString(1, milestone.getName());
            statement.setInt(2, milestone.getPriority());
            statement.setString(3, milestone.getDetails());
            statement.setDate(4, milestone.getEndDate());
            statement.setBoolean(5, milestone.isStatus());
            statement.setString(6, milestone.getDeliver());
            statement.setInt(7, milestone.getProject().getId());
            statement.setInt(8, milestone.getPhase().getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // lấy role để phân quyền 
    public String getRoleByUserAndProject(int userId, int projectId) {
        String role = null;

        try {
            // Truy vấn SQL để lấy projectRole từ bảng allocation
            String query = "SELECT projectRole FROM allocation WHERE userId = ? AND projectId = ? LIMIT 1";

            PreparedStatement statement = getConnection().prepareStatement(query);
            statement.setInt(1, userId);
            statement.setInt(2, projectId);

            ResultSet resultSet = statement.executeQuery();

            // Nếu có kết quả, lấy giá trị của projectRole
            if (resultSet.next()) {
                role = resultSet.getString("projectRole");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Trả về role (nếu không có kết quả sẽ là null)
        return role;
    }

    // Phương thức cập nhật trạng thái dự án
    public void updateProjectStatus(int projectId, int status) throws SQLException {
        String query = "UPDATE project SET status = ? WHERE id = ?";

        try {
            PreparedStatement preparedStatement = getConnection().prepareStatement(query);
            // Gán giá trị cho các tham số
            preparedStatement.setInt(1, status); // Trạng thái mới
            preparedStatement.setInt(2, projectId); // ID của dự án

            // Thực thi truy vấn
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Không thể cập nhật trạng thái dự án");
        }
    }
    // Hàm main để chạy thử

    public static void main(String[] args) {
        ProjectDAO manager = new ProjectDAO();

        // Test với userId = 1, page = 1, pageSize = 10, keyword là "Test", và status là 1
        int userId = 4;
        int page = 1;
        int pageSize = 10;
        String keyword = null;
        Integer status = 1;

        List<Project> projects = manager.listProjects(userId, page, pageSize, keyword, status);

        // In ra kết quả
        for (Project project : projects) {
            System.out.println("Project ID: " + project.getId());
            System.out.println("Project Name: " + project.getName());
            System.out.println("Project Code: " + project.getCode());
            System.out.println("Project Domain: " + project.getDomain().getName());
            System.out.println("Project Department: " + project.getDepartment().getName());
            System.out.println("-------------------------------------");
        }
    }
}
