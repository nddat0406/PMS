/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import com.mysql.cj.protocol.Resultset;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Allocation;
import model.Criteria;
import model.Group;
import model.Milestone;
import model.Project;
import model.ProjectPhase;
import model.Setting;
import model.User;

/**
 *
 * @author HP
 */
public class ProjectDAO extends BaseDAO {

    private GroupDAO gdao = new GroupDAO();
    private UserDAO udao = new UserDAO();

    public List<Project> getAllByUser(int id) throws SQLException {
        String str = "SELECT p.* FROM allocation a JOIN project p ON p.id = a.projectId WHERE userId = ?";
        List<Project> projectList = new ArrayList<>();
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    projectList.add(setProjectInfor(rs));
                }
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return projectList;
    }

    public Project setProjectInfor(ResultSet rs) throws SQLException {
        Project temp = new Project();
        try {
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

        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
        return temp;
    }

    private String getBizTerm(int id) throws SQLException {
        String str = "SELECT name FROM setting WHERE id=? AND type=1 AND status = 1";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }
        } catch (SQLException e) {
            return null;
        }
        return null;
    }

    public Project getById(int id) throws SQLException {
        String str = "SELECT * FROM project WHERE id=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return setProjectInfor(rs);
                }
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return null;
    }

    public void flipStatusMemberOfPrj(int id) throws SQLException {
        String sql = "UPDATE `pms`.`allocation` SET `status` = status ^ 1 WHERE `id` = ?";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setInt(1, id);
            st.executeUpdate();
        }
    }

// listProjects method with try-with-resources
    public List<Project> listProjects(int userId, int page, int pageSize, String keyword, Integer status, Integer domainId, Integer departmentId) {
        List<Project> projects = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT p.id, p.bizTerm, p.code, p.name, p.details, p.startDate, p.status, "
                + "g1.id AS domainId, g1.name AS domainName, "
                + "g2.id AS departmentId, g2.name AS departmentName "
                + "FROM project p "
                + "JOIN allocation a ON p.id = a.projectId "
                + "JOIN `group` g1 ON p.domainId = g1.id AND g1.type = 1 "
                + "JOIN `group` g2 ON p.departmentId = g2.id AND g2.type = 0 "
                + "WHERE a.userId = ? and a.status=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append("AND (p.name LIKE ? OR p.code LIKE ?) ");
        }
        if (status != null) {
            query.append("AND p.status = ? ");
        }
        if (domainId != null) {
            query.append("AND g1.id = ? ");
        }
        if (departmentId != null) {
            query.append("AND g2.id = ? ");
        }
        query.append("LIMIT ? OFFSET ?");
        int offset = (page - 1) * pageSize;

        try (PreparedStatement pre = getConnection().prepareStatement(query.toString())) {
            int index = 1;
            pre.setInt(index++, userId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                pre.setString(index++, "%" + keyword.trim() + "%");
                pre.setString(index++, "%" + keyword.trim() + "%");
            }
            if (status != null) {
                pre.setInt(index++, status);
            }
            if (domainId != null) {
                pre.setInt(index++, domainId);
            }
            if (departmentId != null) {
                pre.setInt(index++, departmentId);
            }
            pre.setInt(index++, pageSize);
            pre.setInt(index, offset);

            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    Project project = new Project();
                    project.setId(resultSet.getInt("id"));
                    project.setBizTerm(resultSet.getString("bizTerm"));
                    project.setCode(resultSet.getString("code"));
                    project.setName(resultSet.getString("name"));
                    project.setDetails(resultSet.getString("details"));
                    project.setStartDate(resultSet.getDate("startDate"));
                    project.setStatus(resultSet.getInt("status"));

                    Group domain = new Group();
                    domain.setId(resultSet.getInt("domainId"));
                    domain.setName(resultSet.getString("domainName"));
                    project.setDomain(domain);

                    Group department = new Group();
                    department.setId(resultSet.getInt("departmentId"));
                    department.setName(resultSet.getString("departmentName"));
                    project.setDepartment(department);

                    projects.add(project);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return projects;
    }

    public int getTotalProjects(int userId, String keyword, Integer status) {
        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM project p "
                + "JOIN allocation a ON p.id = a.projectId "
                + "WHERE a.userId = ? ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append("AND (p.name LIKE ? OR p.code LIKE ?) ");
        }
        if (status != null) {
            query.append("AND p.status = ? ");
        }

        try (PreparedStatement pre = getConnection().prepareStatement(query.toString())) {
            int index = 1;
            pre.setInt(index++, userId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                pre.setString(index++, "%" + keyword.trim() + "%");
                pre.setString(index++, "%" + keyword.trim() + "%");
            }
            if (status != null) {
                pre.setInt(index++, status);
            }

            try (ResultSet resultSet = pre.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Project getProjectById(int id) {
        Project project = null;
        String query = "SELECT p.id, p.bizTerm, p.code, p.name, p.details, p.startDate, p.status, "
                + "g1.id AS domainId, g1.name AS domainName, "
                + "g2.id AS departmentId, g2.name AS departmentName "
                + "FROM project p "
                + "JOIN `group` g1 ON p.domainId = g1.id AND g1.type = 1 "
                + "JOIN `group` g2 ON p.departmentId = g2.id AND g2.type = 0 "
                + "WHERE p.id = ?";

        try (PreparedStatement pre = getConnection().prepareStatement(query)) {
            pre.setInt(1, id);
            try (ResultSet resultSet = pre.executeQuery()) {
                if (resultSet.next()) {
                    project = new Project();
                    project.setId(resultSet.getInt("id"));
                    project.setBizTerm(resultSet.getString("bizTerm"));
                    project.setCode(resultSet.getString("code"));
                    project.setName(resultSet.getString("name"));
                    project.setDetails(resultSet.getString("details"));
                    project.setStartDate(resultSet.getDate("startDate"));
                    project.setStatus(resultSet.getInt("status"));

                    Group domain = new Group();
                    domain.setId(resultSet.getInt("domainId"));
                    domain.setName(resultSet.getString("domainName"));
                    project.setDomain(domain);

                    Group department = new Group();
                    department.setId(resultSet.getInt("departmentId"));
                    department.setName(resultSet.getString("departmentName"));
                    project.setDepartment(department);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return project;
    }

    public int addProject(Project project) throws SQLException {
        String sql = "INSERT INTO project (bizTerm, code, name, details, startDate, status, departmentId, domainId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = getConnection().prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, project.getBizTerm());
            statement.setString(2, project.getCode());
            statement.setString(3, project.getName());
            statement.setString(4, project.getDetails());
            statement.setDate(5, new java.sql.Date(project.getStartDate().getTime()));
            statement.setInt(6, project.getStatus());
            statement.setInt(7, project.getDepartmentId());
            statement.setInt(8, project.getDomainId());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<ProjectPhase> getPhasesByDomainId(int domainId) throws SQLException {
        List<ProjectPhase> phases = new ArrayList<>();
        String sql = "SELECT id, name, priority FROM projectphase WHERE domainId = ?";
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
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
        }
        return phases;
    }

    public void addMilestone(Milestone milestone) throws SQLException {
        String sql = "INSERT INTO milestone (name, priority, details, endDate, status, deliver, projectId, phaseId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setString(1, milestone.getName());
            statement.setInt(2, milestone.getPriority());
            statement.setString(3, milestone.getDetails());
            statement.setDate(4, milestone.getEndDate());
            statement.setInt(5, milestone.getStatus());
            statement.setString(6, milestone.getDeliver());
            statement.setInt(7, milestone.getProject().getId());
            statement.setInt(8, milestone.getPhase().getId());
            statement.executeUpdate();
        }
    }

    public void addCriteria(Criteria criteria) throws SQLException {
        String sql = """
                     INSERT INTO `pms`.`project_criteria`
                     (
                     `name`,
                     `weight`,
                     `projectId`,
                     `description`,
                     `milestoneId`)
                     VALUES
                     (
                     ?,
                     ?,
                     ?,
                     ?,
                     ?)""";
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setString(1, criteria.getName());
            statement.setInt(2, criteria.getWeight());
            statement.setInt(3, criteria.getProject().getId()); // ensure phase object is set
            statement.setString(4, criteria.getDescription());
            statement.setInt(5, criteria.getMilestone().getId()); // assuming Group (domain) has an ID
            statement.executeUpdate();
        }
    }

    public List<Criteria> getCriteriaByPhaseId(int phaseId) throws SQLException {
        List<Criteria> criteriaList = new ArrayList<>();
        String sql = "SELECT id, name, weight, description, status FROM projectphase_criteria WHERE phaseId = ?";
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setInt(1, phaseId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Criteria criteria = new Criteria();
                    criteria.setId(resultSet.getInt("id"));
                    criteria.setName(resultSet.getString("name"));
                    criteria.setWeight(resultSet.getInt("weight"));
                    criteria.setDescription(resultSet.getString("description"));
                    criteria.setStatus(resultSet.getBoolean("status"));
                    criteriaList.add(criteria);
                }
            }
        }
        return criteriaList;
    }

    public boolean isCodeExists(String code) throws SQLException {
        String query = "SELECT COUNT(*) FROM project WHERE code = ?";
        try (PreparedStatement statement = getConnection().prepareStatement(query)) {
            statement.setString(1, code);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean isNameExists(String name) throws SQLException {
        String query = "SELECT COUNT(*) FROM project WHERE name = ?";
        try (PreparedStatement statement = getConnection().prepareStatement(query)) {
            statement.setString(1, name);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public String getRoleByUserAndProject(int userId, int projectId) throws SQLException {
        String role = null;
        String query = "SELECT projectRole FROM allocation WHERE userId = ? AND projectId = ? LIMIT 1";
        try (PreparedStatement statement = getConnection().prepareStatement(query)) {
            statement.setInt(1, userId);
            statement.setInt(2, projectId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    role = resultSet.getString("projectRole");
                }
            }
        }
        return role;
    }

    public void updateProjectStatus(int projectId, int status) throws SQLException {
        String query = "UPDATE project SET status = ? WHERE id = ?";
        try (PreparedStatement preparedStatement = getConnection().prepareStatement(query)) {
            preparedStatement.setInt(1, status);
            preparedStatement.setInt(2, projectId);
            preparedStatement.executeUpdate();
        }
    }

    public List<Project> getAllProjectPharse() throws SQLException {
        String str = "SELECT * FROM projectphase";
        List<Project> projectList = new ArrayList<>();
        try (PreparedStatement pre = getConnection().prepareStatement(str); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                Project project = new Project();
                project.setId(rs.getInt("id"));
                project.setName(rs.getString("name"));
                projectList.add(project);
            }
        }
        return projectList;
    }

    public Project getAllProjectPharseBYId(int id) throws SQLException {
        String str = "SELECT * FROM projectphase WHERE id = ?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    Project project = new Project();
                    project.setId(rs.getInt("id"));
                    project.setName(rs.getString("name"));
                    return project;
                }
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return null;
    }

// List all projects for admin
    public List<Project> listAllProjectsForAdmin(int page, int pageSize, String keyword, Integer status, Integer domainId, Integer departmentId) {
        List<Project> projects = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT p.id, p.bizTerm, p.code, p.name, p.details, p.startDate, p.status, "
                + "g1.id AS domainId, g1.name AS domainName, "
                + "g2.id AS departmentId, g2.name AS departmentName "
                + "FROM project p "
                + "JOIN `group` g1 ON p.domainId = g1.id AND g1.type = 1 "
                + "JOIN `group` g2 ON p.departmentId = g2.id AND g2.type = 0 ");

        boolean hasCondition = false;
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append("WHERE (p.name LIKE ? OR p.code LIKE ?) ");
            hasCondition = true;
        }
        if (status != null) {
            query.append(hasCondition ? "AND " : "WHERE ");
            query.append("p.status = ? ");
            hasCondition = true;
        }
        if (domainId != null) {
            query.append(hasCondition ? "AND " : "WHERE ");
            query.append("g1.id = ? ");
            hasCondition = true;
        }
        if (departmentId != null) {
            query.append(hasCondition ? "AND " : "WHERE ");
            query.append("g2.id = ? ");
        }
        query.append("LIMIT ? OFFSET ?");
        int offset = (page - 1) * pageSize;

        try (PreparedStatement pre = getConnection().prepareStatement(query.toString())) {
            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                pre.setString(index++, "%" + keyword.trim() + "%");
                pre.setString(index++, "%" + keyword.trim() + "%");
            }
            if (status != null) {
                pre.setInt(index++, status);
            }
            if (domainId != null) {
                pre.setInt(index++, domainId);
            }
            if (departmentId != null) {
                pre.setInt(index++, departmentId);
            }
            pre.setInt(index++, pageSize);
            pre.setInt(index, offset);

            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    Project project = new Project();
                    project.setId(resultSet.getInt("id"));
                    project.setBizTerm(resultSet.getString("bizTerm"));
                    project.setCode(resultSet.getString("code"));
                    project.setName(resultSet.getString("name"));
                    project.setDetails(resultSet.getString("details"));
                    project.setStartDate(resultSet.getDate("startDate"));
                    project.setStatus(resultSet.getInt("status"));

                    Group domain = new Group();
                    domain.setId(resultSet.getInt("domainId"));
                    domain.setName(resultSet.getString("domainName"));
                    project.setDomain(domain);

                    Group department = new Group();
                    department.setId(resultSet.getInt("departmentId"));
                    department.setName(resultSet.getString("departmentName"));
                    project.setDepartment(department);

                    projects.add(project);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return projects;
    }

    public List<Project> getAllProject() throws SQLException {
        String str = "SELECT * FROM project";
        List<Project> projectList = new ArrayList<>();
        try (PreparedStatement pre = getConnection().prepareStatement(str); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                Project project = new Project();
                project.setId(rs.getInt("id"));
                project.setName(rs.getString("name"));
                project.setCode(rs.getString("code"));
                projectList.add(project);
            }
        }
        return projectList;
    }

    public List<User> getProjectAllocationUser(Integer PID) throws SQLException {
        String str = """
                 SELECT 
                     u.id, 
                     u.email, 
                     u.fullname,
                     u.image
                 FROM 
                     user u
                 LEFT JOIN 
                     allocation a ON u.id = a.userId AND a.projectId = ?
                 WHERE 
                     a.id IS NULL and u.status=1""";
        List<User> userList = new ArrayList<>();
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, PID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    User temp = new User();
                    temp.setId(rs.getInt(1));
                    temp.setEmail(rs.getString(2));
                    temp.setFullname(rs.getString(3));
                    temp.setImage(rs.getString(4));
                    userList.add(temp);
                }
            }
        }
        return userList;
    }

    public List<Setting> getListRole(Integer PID) throws SQLException {
        String str = """
                 SELECT DISTINCT 
                 ds.id,
                     ds.name,
                     ds.priority
                 FROM 
                     allocation a
                 JOIN 
                     project p ON a.projectId = p.id
                 JOIN 
                     domain_setting ds ON ds.id = a.role
                 WHERE 
                     p.id = ? AND ds.type = 2""";
        List<Setting> settingList = new ArrayList<>();
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, PID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Setting temp = new Setting();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setPriority(rs.getInt(3));
                    settingList.add(temp);
                }
            }
        }
        return settingList;
    }

    public List<User> getProjectMembers(Integer pID) throws SQLException {
        String sql = "SELECT distinct u.id, u.fullname FROM pms.allocation a join pms.user u on u.id=a.userId where a.projectId=? and a.status=1";
        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            pre.setInt(1, pID);
            ResultSet rs = pre.executeQuery();
            List<User> list = new ArrayList<>();
            while (rs.next()) {
                User temp = new User();
                temp.setId(rs.getInt(1));
                temp.setFullname(rs.getString(2));
                list.add(temp);
            }
            return list;
        }
    }

    public int getMaxMileId() throws SQLException {
        String sql = "SELECT max(id) FROM pms.milestone";
        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            ResultSet rs = pre.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }
}
