package dal;

import dal.BaseDAO;
import java.util.ArrayList;
import java.util.List;
import model.Issue;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class IssueDAO extends BaseDAO {

    private Issue mapIssue(ResultSet rs) throws SQLException {
        return Issue.builder()
                .id(rs.getInt("id"))
                .requirementId(rs.getInt("requirementId"))
                .projectId(rs.getInt("projectId"))
                .title(rs.getString("title"))
                .description(rs.getString("description"))
                .type(rs.getString("type"))
                .assignee_id(rs.getInt("assignee_id"))
                .due_date(rs.getDate("due_date"))
                .end_date(rs.getDate("end_date"))
                .status(rs.getInt("status"))
                .build();
    }

    public Issue getIssueById(int id) throws SQLException {
        String sql = "SELECT * FROM pms.issue WHERE id=?";
        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return mapIssue(rs);
            }
            return null;
        }
    }

    public List<Issue> getAllByProjectId(int projectId) throws SQLException {
        String sql = "SELECT * FROM pms.issue WHERE projectId=?";
        List<Issue> list = new ArrayList<>();
        PreparedStatement pre = getConnection().prepareStatement(sql);
        pre.setInt(1, projectId);
        ResultSet rs = pre.executeQuery();
        while (rs.next()) {
            list.add(mapIssue(rs));
        }
        return list;
    }

    public void updateIssue(Issue issue) throws SQLException {
        String sql = "UPDATE pms.issue SET title=?, description=?, type=?, "
                + "assignee_id=?, status=?, due_date=?, end_date=? WHERE id=?";
        PreparedStatement ps = getConnection().prepareStatement(sql);
        ps.setString(1, issue.getTitle());
        ps.setString(2, issue.getDescription());
        ps.setString(3, issue.getType());
        ps.setInt(4, issue.getAssignee_id());
        ps.setInt(5, issue.getStatus());
        ps.setDate(6, issue.getDue_date());
        ps.setDate(7, issue.getEnd_date());
        ps.setInt(8, issue.getId());
        ps.executeUpdate();

    }

    public void insertIssue(Issue issue) throws SQLException {
        String sql = "INSERT INTO pms.issue (requirementId, projectId, title, description, type, "
                + "assignee_id, status, due_date, end_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, issue.getRequirementId());
        ps.setInt(2, issue.getProjectId());
        ps.setString(3, issue.getTitle());
        ps.setString(4, issue.getDescription());
        ps.setString(5, issue.getType());
        ps.setInt(6, issue.getAssignee_id());
        ps.setInt(7, issue.getStatus());
        ps.setDate(8, issue.getDue_date());
        ps.setDate(9, issue.getEnd_date());
        ps.executeUpdate();

        try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                issue.setId(generatedKeys.getInt(1));
            }

        }
    }

    public List<Issue> searchIssues(String searchKey, Integer projectId, Integer status) throws SQLException {
        List<Issue> result = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM pms.issue WHERE 1=1");
        ArrayList<Object> params = new ArrayList<>();

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
            String searchPattern = "%" + searchKey.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (projectId != null && projectId != 0) {
            sql.append(" AND projectId = ?");
            params.add(projectId);
        }

        if (status != null && status != 0) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        PreparedStatement ps = getConnection().prepareStatement(sql.toString());
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            result.add(mapIssue(rs));
        }

        return result;
    }

    public List<Issue> getAll() throws SQLException {
        String sql = "SELECT * FROM pms.issue";
        List<Issue> list = new ArrayList<>();
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapIssue(rs));
            }
        }
        return list;
    }

    // Additional helpful methods
    public List<Issue> getIssuesByAssignee(int assigneeId) throws SQLException {
        String sql = "SELECT * FROM pms.issue WHERE assignee_id=?";
        List<Issue> list = new ArrayList<>();
        PreparedStatement pre = getConnection().prepareStatement(sql);
        pre.setInt(1, assigneeId);
        ResultSet rs = pre.executeQuery();
        while (rs.next()) {
            list.add(mapIssue(rs));
        }
        return list;

    }

    public List<Issue> getIssuesByType(String type) throws SQLException {
        String sql = "SELECT * FROM pms.issue WHERE type=?";
        List<Issue> list = new ArrayList<>();
        PreparedStatement pre = getConnection().prepareStatement(sql);
        pre.setString(1, type);
        ResultSet rs = pre.executeQuery();
        while (rs.next()) {
            list.add(mapIssue(rs));
        }
        return list;

    }

    public List<Issue> searchAdvanced(String searchKey, Integer projectId, String type,
            Integer assigneeId, Integer status, Date startDate, Date endDate) throws SQLException {
        List<Issue> result = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM pms.issue WHERE 1=1");
        ArrayList<Object> params = new ArrayList<>();

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
            String searchPattern = "%" + searchKey.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (projectId != null && projectId != 0) {
            sql.append(" AND projectId = ?");
            params.add(projectId);
        }

        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
            params.add(type);
        }

        if (assigneeId != null && assigneeId != 0) {
            sql.append(" AND assignee_id = ?");
            params.add(assigneeId);
        }

        if (status != null && status != 0) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        if (startDate != null) {
            sql.append(" AND due_date >= ?");
            params.add(startDate);
        }

        if (endDate != null) {
            sql.append(" AND due_date <= ?");
            params.add(endDate);
        }
        PreparedStatement ps = getConnection().prepareStatement(sql.toString());
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            result.add(mapIssue(rs));
        }

        return result;
    }

    public List<Issue> getIssuesByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM pms.issue WHERE assignee_id = ?";
        List<Issue> list = new ArrayList<>();
        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            pre.setInt(1, userId);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                list.add(mapIssue(rs));
            }
            return list;
        }
    }

    public List<Issue> searchAdvancedForUser(
            String searchKey,
            Integer projectId,
            String type,
            Integer status,
            int userId) throws SQLException {
        List<Issue> result = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM pms.issue WHERE assignee_id = ?");
        ArrayList<Object> params = new ArrayList<>();
        params.add(userId);

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
            String searchPattern = "%" + searchKey.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (projectId != null && projectId != 0) {
            sql.append(" AND projectId = ?");
            params.add(projectId);
        }

        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
            params.add(type);
        }

        if (status != null && status != 0) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        PreparedStatement ps = getConnection().prepareStatement(sql.toString());
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            result.add(mapIssue(rs));
        }

        return result;
    }

}
