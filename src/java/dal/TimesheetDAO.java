package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Project;
import model.Timesheet;
import model.User;
import model.Requirement;
import static service.BaseService.*;

public class TimesheetDAO extends BaseDAO {

    public List<Timesheet> getTimesheetsByUserId(int userId, String searchKeyword, Integer status, Integer projectId, int offset, int limit) {
        List<Timesheet> timesheetList = new ArrayList<>();
        StringBuilder query = new StringBuilder("""
            SELECT 
                t.id,
                u1.fullname AS reporter,
                u2.fullname AS reviewer,
                p.id AS projectId, 
                p.name AS project_name,
                r.title AS requirement_title,
                t.timeCreate,
                t.timeComplete,
                t.status
            FROM 
                timesheet t
            LEFT JOIN 
                user u1 ON t.reporter = u1.id
            LEFT JOIN 
                user u2 ON t.reviewer = u2.id
            JOIN 
                project p ON t.projectId = p.id
            LEFT JOIN 
                requirement r ON t.requirementId = r.id
            WHERE 
                (t.reporter = ? OR t.reviewer = ?)
        """);

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            query.append("AND (u1.fullname LIKE ? OR u2.fullname LIKE ?) ");
        }

        if (projectId != null) {
            query.append("AND p.id = ? ");
        }

        if (status != null) {
            query.append("AND t.status = ? ");
        }

        query.append("ORDER BY t.id LIMIT ? OFFSET ?");

        try {
            PreparedStatement pre = getConnection().prepareStatement(query.toString());
            int index = 1;
            pre.setInt(index++, userId);
            pre.setInt(index++, userId);

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                pre.setString(index++, "%" + searchKeyword.trim() + "%");
                pre.setString(index++, "%" + searchKeyword.trim() + "%");
            }

            if (projectId != null) {
                pre.setInt(index++, projectId);
            }

            if (status != null) {
                pre.setInt(index++, status);
            }

            pre.setInt(index++, limit);
            pre.setInt(index, offset);

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Timesheet timesheet = new Timesheet();
                    timesheet.setId(rs.getInt("id"));

                    User reporter = new User();
                    reporter.setFullname(rs.getString("reporter"));
                    timesheet.setReporter(reporter);

                    User reviewer = new User();
                    reviewer.setFullname(rs.getString("reviewer"));
                    timesheet.setReviewer(reviewer);

                    Project project = new Project();
                    project.setId(rs.getInt("projectId"));
                    project.setName(rs.getString("project_name"));
                    timesheet.setProject(project);

                    Requirement requirement = new Requirement();
                    requirement.setTitle(rs.getString("requirement_title"));
                    timesheet.setRequirement(requirement);

                    timesheet.setTimeCreated(rs.getDate("timeCreate"));
                    timesheet.setTimeCompleted(rs.getDate("timeComplete"));
                    timesheet.setStatus(rs.getInt("status"));

                    timesheetList.add(timesheet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return timesheetList;
    }

    public List<Timesheet> getAllTimesheets(String searchKeyword, Integer status, Integer projectId, int offset, int limit) {
        List<Timesheet> timesheetList = new ArrayList<>();
        StringBuilder query = new StringBuilder("""
            SELECT 
                t.id,
                u1.fullname AS reporter,
                u2.fullname AS reviewer,
                p.id AS projectId, 
                p.name AS project_name,
                r.title AS requirement_title,
                t.timeCreate,
                t.timeComplete,
                t.status
            FROM 
                timesheet t
            LEFT JOIN 
                 user u1 ON t.reporter = u1.id
             LEFT JOIN 
                 user u2 ON t.reviewer = u2.id
            JOIN 
                project p ON t.projectId = p.id
            LEFT JOIN 
                requirement r ON t.requirementId = r.id
            WHERE 1=1
        """);

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            query.append("AND (u1.fullname LIKE ? OR u2.fullname LIKE ?) ");
        }

        if (projectId != null) {
            query.append("AND p.id = ? ");
        }

        if (status != null) {
            query.append("AND t.status = ? ");
        }

        query.append("ORDER BY t.id LIMIT ? OFFSET ?");

        try {
            PreparedStatement pre = getConnection().prepareStatement(query.toString());
            int index = 1;

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                pre.setString(index++, "%" + searchKeyword.trim() + "%");
                pre.setString(index++, "%" + searchKeyword.trim() + "%");
            }

            if (projectId != null) {
                pre.setInt(index++, projectId);
            }

            if (status != null) {
                pre.setInt(index++, status);
            }

            pre.setInt(index++, limit);
            pre.setInt(index, offset);

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Timesheet timesheet = new Timesheet();
                    timesheet.setId(rs.getInt("id"));

                    User reporter = new User();
                    reporter.setFullname(rs.getString("reporter"));
                    timesheet.setReporter(reporter);

                    User reviewer = new User();
                    reviewer.setFullname(rs.getString("reviewer"));
                    timesheet.setReviewer(reviewer);

                    Project project = new Project();
                    project.setId(rs.getInt("projectId"));
                    project.setName(rs.getString("project_name"));
                    timesheet.setProject(project);

                    Requirement requirement = new Requirement();
                    requirement.setTitle(rs.getString("requirement_title"));
                    timesheet.setRequirement(requirement);

                    timesheet.setTimeCreated(rs.getDate("timeCreate"));
                    timesheet.setTimeCompleted(rs.getDate("timeComplete"));
                    timesheet.setStatus(rs.getInt("status"));

                    timesheetList.add(timesheet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return timesheetList;
    }

    public int getTotalTimesheets(String searchKeyword, Integer status, Integer projectId) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM timesheet t
            LEFT JOIN 
                            user u1 ON t.reporter = u1.id
                        LEFT JOIN 
                            user u2 ON t.reviewer = u2.id
            JOIN project p ON t.projectId = p.id
            WHERE 1=1
        """);

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (u1.fullname LIKE ? OR u2.fullname LIKE ?)");
        }
        if (projectId != null) {
            sql.append(" AND p.id = ?");
        }
        if (status != null) {
            sql.append(" AND t.status = ?");
        }

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql.toString());
            int index = 1;

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                pre.setString(index++, "%" + searchKeyword.trim() + "%");
                pre.setString(index++, "%" + searchKeyword.trim() + "%");
            }
            if (projectId != null) {
                pre.setInt(index++, projectId);
            }
            if (status != null) {
                pre.setInt(index++, status);
            }

            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalTimesheetsByUserId(int userId, String searchKeyword, Integer status, Integer projectId) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM timesheet t
            LEFT JOIN 
                            user u1 ON t.reporter = u1.id
                        LEFT JOIN 
                            user u2 ON t.reviewer = u2.id
            JOIN project p ON t.projectId = p.id
            WHERE (t.reporter = ? OR t.reviewer = ?)
        """);

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (u1.fullname LIKE ? OR u2.fullname LIKE ?)");
        }
        if (projectId != null) {
            sql.append(" AND p.id = ?");
        }
        if (status != null) {
            sql.append(" AND t.status = ?");
        }

        try {
            PreparedStatement pre = getConnection().prepareStatement(sql.toString());
            int index = 1;
            pre.setInt(index++, userId);
            pre.setInt(index++, userId);

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                pre.setString(index++, "%" + searchKeyword.trim() + "%");
                pre.setString(index++, "%" + searchKeyword.trim() + "%");
            }
            if (projectId != null) {
                pre.setInt(index++, projectId);
            }
            if (status != null) {
                pre.setInt(index++, status);
            }

            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean deleteTimesheet(int timesheetId) {
        String sql = "DELETE FROM timesheet WHERE id = ?;";

        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            pre.setInt(1, timesheetId);

            int rowsAffected = pre.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Timesheet> getAllTimesheets(int userId, int role) {
        List<Timesheet> timesheetList = new ArrayList<>();
        StringBuilder query = new StringBuilder("""
        SELECT 
            t.id,
            u1.fullname AS reporter,
            u2.fullname AS reviewer,
            p.name AS project_name,
            r.title AS requirement_title,
            t.timeCreate,
            t.timeComplete,
            t.status
        FROM 
            timesheet t
        LEFT JOIN 
            user u1 ON t.reporter = u1.id
        EFT JOIN 
            user u2 ON t.reviewer = u2.id
        JOIN 
            project p ON t.projectId = p.id
        LEFT JOIN 
            requirement r ON t.requirementId = r.id
    """);

        // Thêm điều kiện nếu người dùng là Member (không phải Admin)
        if (role == MEMBER_ROLE) { // Giả sử role = 1 là Admin
            query.append("WHERE t.reporter = ? OR t.reviewer = ?  ");
        }

        try {
            PreparedStatement pre = getConnection().prepareStatement(query.toString());
            if (role == MEMBER_ROLE) {
                pre.setInt(1, userId);
                pre.setInt(2, userId);
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Timesheet timesheet = new Timesheet();
                    timesheet.setId(rs.getInt("id"));

                    User reporter = new User();
                    reporter.setFullname(rs.getString("reporter"));
                    timesheet.setReporter(reporter);

                    User reviewer = new User();
                    reviewer.setFullname(rs.getString("reviewer"));
                    timesheet.setReviewer(reviewer);

                    Project project = new Project();
                    project.setName(rs.getString("project_name"));
                    timesheet.setProject(project);

                    Requirement requirement = new Requirement();
                    requirement.setTitle(rs.getString("requirement_title"));
                    timesheet.setRequirement(requirement);

                    timesheet.setTimeCreated(rs.getDate("timeCreate"));
                    timesheet.setTimeCompleted(rs.getDate("timeComplete"));
                    timesheet.setStatus(rs.getInt("status"));

                    timesheetList.add(timesheet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return timesheetList;
    }

    public Timesheet getTimesheetById(int timesheetId) {
        Timesheet timesheet = null;
        String query = """
        SELECT 
            t.id,
            u1.fullname AS reporter,
            u2.fullname AS reviewer,
            p.id AS projectId,
            p.name AS project_name,
            r.title AS requirement_title,
            t.timeCreate,
            t.timeComplete,
            t.status
        FROM 
            timesheet t
        JOIN 
            user u1 ON t.reporter = u1.id
        LEFT JOIN 
            user u2 ON t.reviewer = u2.id
        JOIN 
            project p ON t.projectId = p.id
        LEFT JOIN 
            requirement r ON t.requirementId = r.id
        WHERE 
            t.id = ?
    """;

        try {
            PreparedStatement pre = getConnection().prepareStatement(query);
            pre.setInt(1, timesheetId);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    timesheet = new Timesheet();
                    timesheet.setId(rs.getInt("id"));

                    User reporter = new User();
                    reporter.setFullname(rs.getString("reporter"));
                    timesheet.setReporter(reporter);

                    User reviewer = new User();
                    reviewer.setFullname(rs.getString("reviewer"));
                    timesheet.setReviewer(reviewer);

                    Project project = new Project();
                    project.setId(rs.getInt("projectId"));
                    project.setName(rs.getString("project_name"));
                    timesheet.setProject(project);

                    Requirement requirement = new Requirement();
                    requirement.setTitle(rs.getString("requirement_title"));
                    timesheet.setRequirement(requirement);

                    timesheet.setTimeCreated(rs.getDate("timeCreate"));
                    timesheet.setTimeCompleted(rs.getDate("timeComplete"));
                    timesheet.setStatus(rs.getInt("status"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return timesheet;
    }

    public boolean updateTimesheet(Timesheet timesheet) {
        String query = """
        UPDATE timesheet
        SET reporter = ?, reviewer = ?, projectId = ?, requirementId = ?, 
            timeCreate = ?, timeComplete = ?, status = ?
        WHERE id = ?
    """;

        try {
            PreparedStatement pre = getConnection().prepareStatement(query);
            pre.setInt(1, timesheet.getReporter().getId());
            pre.setInt(2, timesheet.getReviewer() != null ? timesheet.getReviewer().getId() : null);
            pre.setInt(3, timesheet.getProject().getId());
            pre.setInt(4, timesheet.getRequirement().getId());
            pre.setDate(5, new java.sql.Date(timesheet.getTimeCreated().getTime()));
            pre.setDate(6, timesheet.getTimeCompleted() != null ? new java.sql.Date(timesheet.getTimeCompleted().getTime()) : null);
            pre.setInt(7, timesheet.getStatus());
            pre.setInt(8, timesheet.getId());

            int rowsUpdated = pre.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Project> getProjectsByUserId(int userId, int role) {
        List<Project> projects = new ArrayList<>();
        String query;
        if (role == ADMIN_ROLE) {
            query = "SELECT id, name FROM project";
        } else {
            query = """
            SELECT DISTINCT p.id, p.name
            FROM project p
            JOIN timesheet t ON p.id = t.projectId
            WHERE t.reporter = ? OR t.reviewer = ?
        """;
        }

        try {
            PreparedStatement pre = getConnection().prepareStatement(query);
            if (role != ADMIN_ROLE) {
                pre.setInt(1, userId);
                pre.setInt(2, userId);
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Project project = new Project();
                    project.setId(rs.getInt("id"));
                    project.setName(rs.getString("name"));
                    projects.add(project);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return projects;
    }

    // Hàm lấy danh sách tất cả các reporter
    public List<User> getAllReporters() {
        List<User> reporters = new ArrayList<>();
        String query = "SELECT DISTINCT u.id, u.fullname FROM user u JOIN timesheet t ON u.id = t.reporter";

        try (PreparedStatement pre = getConnection().prepareStatement(query); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullname(rs.getString("fullname"));
                reporters.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reporters;
    }

    // Hàm lấy danh sách tất cả các reviewer
    public List<User> getAllReviewers() {
        List<User> reviewers = new ArrayList<>();
        String query = "SELECT DISTINCT u.id, u.fullname FROM user u JOIN timesheet t ON u.id = t.reviewer";

        try (PreparedStatement pre = getConnection().prepareStatement(query); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullname(rs.getString("fullname"));
                reviewers.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviewers;
    }

    public List<Requirement> getAllRequirements(int userId, int role) {
        List<Requirement> requirements = new ArrayList<>();
        String query;

        if (role == ADMIN_ROLE) { // Giả sử role = 1 là Admin
            query = "SELECT id, title FROM requirement";
        } else {
            query = """
            SELECT DISTINCT r.id, r.title
            FROM requirement r
            JOIN project p ON r.projectId = p.id
            JOIN timesheet t ON p.id = t.projectId
            WHERE (t.reporter = ? OR t.reviewer = ?)
        """;
        }

        try {
            PreparedStatement pre = getConnection().prepareStatement(query);
            if (role != ADMIN_ROLE) {
                pre.setInt(1, userId);
                pre.setInt(2, userId);
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Requirement requirement = new Requirement();
                    requirement.setId(rs.getInt("id"));
                    requirement.setTitle(rs.getString("title"));
                    requirements.add(requirement);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return requirements;
    }

    public boolean insertTimesheet(Timesheet timesheet) {
        String query = """
        INSERT INTO timesheet (reporter, reviewer, projectId, requirementId, timeCreate, timeComplete, status)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement stmt = getConnection().prepareStatement(query)) {
            stmt.setInt(1, timesheet.getReporter().getId());
            stmt.setInt(2, timesheet.getReviewer().getId());
            stmt.setInt(3, timesheet.getProject().getId());
            stmt.setInt(4, timesheet.getRequirement().getId());
            stmt.setDate(5, timesheet.getTimeCreated());
            stmt.setDate(6, timesheet.getTimeCompleted());
            stmt.setInt(7, timesheet.getStatus());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTimesheetStatus(int timesheetId, int newStatus) {
        String query = "UPDATE timesheet SET status = ? WHERE id = ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(query);
            pre.setInt(1, newStatus);
            pre.setInt(2, timesheetId);

            int rowsUpdated = pre.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
