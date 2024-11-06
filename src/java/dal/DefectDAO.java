// DefectDAO.java
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Defect;
import model.Requirement;
import model.Milestone;
import model.Setting;

public class DefectDAO extends BaseDAO {
    
    private final RequirementDAO requirementDAO = new RequirementDAO();
    private final MilestoneDAO milestoneDAO = new MilestoneDAO();
    private final SettingDAO settingDAO = new SettingDAO();
    
    public List<Defect> getAll() throws SQLException {
        List<Defect> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.defect";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDefect(rs));
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return list;
    }
    
    public Defect getById(int id) throws SQLException {
        String sql = "SELECT * FROM pms.defect WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToDefect(rs);
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return null;
    }
    
    public void insert(Defect defect) throws SQLException {
        String sql = "INSERT INTO pms.defect (requirementId, milestoneId, serverityId, title, " +
                    "leakage, details, duedate, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            setDefectParameters(st, defect);
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error inserting defect: " + e.getMessage());
        }
    }
    
    public void update(Defect defect) throws SQLException {
        String sql = "UPDATE pms.defect SET requirementId=?, milestoneId=?, serverityId=?, " +
                    "title=?, leakage=?, details=?, duedate=?, status=? WHERE id=?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            setDefectParameters(st, defect);
            st.setInt(9, defect.getId());
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error updating defect: " + e.getMessage());
        }
    }
    
    public void updateStatus(int id, int status) throws SQLException {
        String sql = "UPDATE pms.defect SET status = ? WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, id);
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error updating defect status: " + e.getMessage());
        }
    }
    
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM pms.defect WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error deleting defect: " + e.getMessage());
        }
    }
    
    public List<Defect> searchFilter(List<Defect> list, Integer requirementId, Integer milestoneId, 
                                   Integer serverityId, Integer status, String keyword) {
        List<Defect> filteredList = new ArrayList<>();
        
        for (Defect defect : list) {
            boolean matchesRequirement = (requirementId == null || 
                                       requirementId == 0 || 
                                       defect.getRequirement().getId() == requirementId);
            boolean matchesMilestone = (milestoneId == null || 
                                     milestoneId == 0 || 
                                     defect.getMilestone().getId() == milestoneId);
            boolean matchesServerity = (serverityId == null || 
                                     serverityId == 0 || 
                                     defect.getServerity().getId() == serverityId);
            boolean matchesStatus = (status == null || 
                                  status == -1 || 
                                  defect.getStatus() == status);
            boolean matchesKeyword = (keyword == null || 
                                   keyword.isBlank() || 
                                   defect.getTitle().toLowerCase().contains(keyword.toLowerCase()) ||
                                   defect.getDetails().toLowerCase().contains(keyword.toLowerCase()));
            
            if (matchesRequirement && matchesMilestone && matchesServerity && 
                matchesStatus && matchesKeyword) {
                filteredList.add(defect);
            }
        }
        return filteredList;
    }
    
    private Defect mapResultSetToDefect(ResultSet rs) throws SQLException {
        Defect defect = new Defect();
        defect.setId(rs.getInt("id"));
        defect.setRequirement(requirementDAO.getRequirementById(rs.getInt("requirementId")));
        defect.setMilestone(milestoneDAO.getMilestoneById(rs.getInt("milestoneId")));
        defect.setServerity(settingDAO.getSettingById(rs.getInt("serverityId")));
        defect.setTitle(rs.getString("title"));
        defect.setLeakage(rs.getBoolean("leakage"));
        defect.setDetails(rs.getString("details"));
        defect.setDuedate(rs.getDate("duedate"));
        defect.setStatus(rs.getInt("status"));
        return defect;
    }
    
    private void setDefectParameters(PreparedStatement st, Defect defect) throws SQLException {
        st.setInt(1, defect.getRequirement().getId());
        st.setInt(2, defect.getMilestone().getId());
        st.setInt(3, defect.getServerity().getId());
        st.setString(4, defect.getTitle());
        st.setBoolean(5, defect.isLeakage());
        st.setString(6, defect.getDetails());
        st.setDate(7, defect.getDuedate());
        st.setInt(8, defect.getStatus());
    }
}