package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Requirement;
import model.Project;
import model.User;
import model.Setting;

public class RequirementDAO extends BaseDAO {
    
    private final ProjectDAO projectDAO = new ProjectDAO();
    private final UserDAO userDAO = new UserDAO();
    private final SettingDAO settingDAO = new SettingDAO();
    
    public List<Requirement> getAll() throws SQLException {
        List<Requirement> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.requirement";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRequirement(rs));
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return list;
    }
    
    public Requirement getById(int id) throws SQLException {
        String sql = "SELECT * FROM pms.requirement WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToRequirement(rs);
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return null;
    }
    
    public void insert(Requirement requirement) throws SQLException {
        String sql = "INSERT INTO pms.requirement (projectId, ownerId, title, details, " +
                    "complexity, statusId, estimatedEffort) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            setRequirementParameters(st, requirement);
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error inserting requirement: " + e.getMessage());
        }
    }
    
    public void update(Requirement requirement) throws SQLException {
        String sql = "UPDATE pms.requirement SET projectId=?, ownerId=?, title=?, " +
                    "details=?, complexity=?, statusId=?, estimatedEffort=? WHERE id=?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            setRequirementParameters(st, requirement);
            st.setInt(8, requirement.getId());
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error updating requirement: " + e.getMessage());
        }
    }
    
    public void updateStatus(int id, int statusId) throws SQLException {
        String sql = "UPDATE pms.requirement SET statusId = ? WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, statusId);
            st.setInt(2, id);
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error updating requirement status: " + e.getMessage());
        }
    }
    
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM pms.requirement WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error deleting requirement: " + e.getMessage());
        }
    }
    
    public List<Requirement> getByProject(int projectId) throws SQLException {
        List<Requirement> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.requirement WHERE projectId = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, projectId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRequirement(rs));
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return list;
    }
    
    public List<Requirement> getByOwner(int ownerId) throws SQLException {
        List<Requirement> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.requirement WHERE ownerId = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, ownerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRequirement(rs));
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return list;
    }
    
    public List<Requirement> searchFilter(List<Requirement> list, Integer projectId, 
                                        Integer ownerId, Integer statusId, String complexity, 
                                        String keyword) {
        List<Requirement> filteredList = new ArrayList<>();
        
        for (Requirement req : list) {
            boolean matchesProject = (projectId == null || 
                                    projectId == 0 || 
                                    req.getProject().getId() == projectId);
            boolean matchesOwner = (ownerId == null || 
                                  ownerId == 0 || 
                                  req.getOwner().getId() == ownerId);
            boolean matchesStatus = (statusId == null || 
                                   statusId == 0 || 
                                   req.getStatus().getId() == statusId);
            boolean matchesComplexity = (complexity == null || 
                                       complexity.isEmpty() || 
                                       req.getComplexity().equals(complexity));
            boolean matchesKeyword = (keyword == null || 
                                    keyword.isBlank() || 
                                    req.getTitle().toLowerCase().contains(keyword.toLowerCase()) ||
                                    req.getDetails().toLowerCase().contains(keyword.toLowerCase()));
            
            if (matchesProject && matchesOwner && matchesStatus && 
                matchesComplexity && matchesKeyword) {
                filteredList.add(req);
            }
        }
        
        return filteredList;
    }
    
    private Requirement mapResultSetToRequirement(ResultSet rs) throws SQLException {
        Requirement requirement = new Requirement();
        requirement.setId(rs.getInt("id"));
        requirement.setProject(projectDAO.getProjectById(rs.getInt("projectId")));
        requirement.setOwner(userDAO.getUserById(rs.getInt("userId")));
        requirement.setTitle(rs.getString("title"));
        requirement.setDetails(rs.getString("details"));
        requirement.setComplexity(rs.getString("complexity"));
        requirement.setStatus(settingDAO.getSettingById(rs.getInt("status")));
        requirement.setEstimatedEffort(rs.getInt("estimateEffort"));
        return requirement;
    }
    
    private void setRequirementParameters(PreparedStatement st, Requirement requirement) 
            throws SQLException {
        st.setInt(1, requirement.getProject().getId());
        st.setInt(2, requirement.getOwner().getId());
        st.setString(3, requirement.getTitle());
        st.setString(4, requirement.getDetails());
        st.setString(5, requirement.getComplexity());
        st.setInt(6, requirement.getStatus().getId());
        st.setInt(7, requirement.getEstimatedEffort());
    }
}