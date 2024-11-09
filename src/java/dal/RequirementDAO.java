package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Requirement;

public class RequirementDAO extends BaseDAO {

    private Requirement mapRequirement(ResultSet rs) throws SQLException {
        return Requirement.builder()
                .id(rs.getInt("id"))
                .projectId(rs.getInt("projectId"))
                .userId(rs.getInt("userId"))
                .title(rs.getString("title"))
                .details(rs.getString("details"))
                .complexity(rs.getString("complexity"))
                .status(rs.getInt("status"))
                .estimatedEffort(rs.getInt("estimateEffort"))
                .build();
    }

    public Requirement getRequirementById(int id) throws SQLException {
        String sql = "SELECT * FROM pms.requirement WHERE id=?";
        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {

            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return mapRequirement(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Requirement> getAllByProjectId(int projectId) throws SQLException {
        String sql = "SELECT * FROM pms.requirement WHERE projectId=?";
        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            List<Requirement> list = new ArrayList<>();

            pre.setInt(1, projectId);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                list.add(mapRequirement(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public void updateRequirement(Requirement requirement) throws SQLException {
        String sql = "UPDATE pms.requirement SET title=?, details=?, complexity=?, status=?, estimateEffort=?, userId=? WHERE id=?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

            ps.setString(1, requirement.getTitle());
            ps.setString(2, requirement.getDetails());
            ps.setString(3, requirement.getComplexity());
            ps.setInt(4, requirement.getStatus());
            ps.setInt(5, requirement.getEstimatedEffort());
            ps.setInt(6, requirement.getUserId());
            ps.setInt(7, requirement.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public void insertRequirement(Requirement requirement) throws SQLException {
        String sql = "INSERT INTO pms.requirement (projectId, userId, title, details, complexity, status, estimateEffort) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, requirement.getProjectId());
            ps.setInt(2, requirement.getUserId());
            ps.setString(3, requirement.getTitle());
            ps.setString(4, requirement.getDetails());
            ps.setString(5, requirement.getComplexity());
            ps.setInt(6, requirement.getStatus());
            ps.setInt(7, requirement.getEstimatedEffort());
            ps.executeUpdate();

            // Get and set the generated ID
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    requirement.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Failed to get generated ID for requirement");
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error inserting requirement: " + e.getMessage());
        }
    }

    public List<Requirement> searchRequirements(String searchKey, String complexity, Integer status) throws SQLException {
        List<Requirement> result = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM pms.requirement WHERE 1=1");
        ArrayList<Object> params = new ArrayList<>();

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR details LIKE ?)");
            String searchPattern = "%" + searchKey.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (complexity != null && !complexity.equals("0")) {
            sql.append(" AND complexity = ?");
            params.add(complexity);
        }

        if (status != null && status != 0) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                result.add(mapRequirement(rs));
            }
        }
        return result;
    }

    public List<Requirement> getAll() throws SQLException {
        String sql = "SELECT * FROM pms.requirement";
        List<Requirement> list = new ArrayList<>();

        PreparedStatement ps = getConnection().prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapRequirement(rs));
        }

        return list;
    }

    public void insertRequirementMilestone(int requirementId, int milestoneId) throws SQLException {
        String sql = "INSERT INTO requirement_milestone (requirementId, milestoneId) VALUES (?, ?)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, requirementId);
            ps.setInt(2, milestoneId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error linking requirement to milestone: " + e.getMessage());
        }
    }

    public void updateRequirementMilestone(int requirementId, Integer milestoneId) throws SQLException {
        // First delete existing milestone association
        String deleteSql = "DELETE FROM requirement_milestone WHERE requirementId = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(deleteSql)) {
            ps.setInt(1, requirementId);
            ps.executeUpdate();
        }

        // If a new milestoneId is provided, insert it
        if (milestoneId != null && milestoneId > 0) {
            insertRequirementMilestone(requirementId, milestoneId);
        }
    }

    public Integer getMilestoneIdForRequirement(int requirementId) throws SQLException {
        String sql = "SELECT milestoneId FROM requirement_milestone WHERE requirementId = ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, requirementId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("milestoneId");
            }
            return null;
        }
    }

}
