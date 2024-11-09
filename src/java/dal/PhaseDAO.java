package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Criteria;
import model.ProjectPhase;
import model.Group;
import model.Project;

public class PhaseDAO extends BaseDAO {

    public List<ProjectPhase> getAll() throws SQLException {
        List<ProjectPhase> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.projectphase";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ProjectPhase phase = new ProjectPhase();
                phase.setId(rs.getInt("id"));
                phase.setName(rs.getString("name"));
                phase.setPriority(rs.getInt("priority"));
                phase.setDetails(rs.getString("details"));
                phase.setFinalPhase(rs.getBoolean("finalPhase"));
                phase.setCompleteRate(rs.getInt("completeRate"));
                phase.setStatus(rs.getBoolean("status"));
                // Set domain
                Group domain = new Group();
                domain.setId(rs.getInt("domainId"));
                phase.setDomain(domain);
                list.add(phase);
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return list;
    }
    public ProjectPhase getPhaseById(int id) throws SQLException {
        String sql = "SELECT * FROM pms.projectphase WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                ProjectPhase phase = new ProjectPhase();
                phase.setId(rs.getInt("id"));
                phase.setName(rs.getString("name"));
                phase.setPriority(rs.getInt("priority"));
                phase.setDetails(rs.getString("details"));
                phase.setFinalPhase(rs.getBoolean("finalPhase"));
                phase.setCompleteRate(rs.getInt("completeRate"));
                phase.setStatus(rs.getBoolean("status"));
                Group domain = new Group();
                domain.setId(rs.getInt("domainId"));
                phase.setDomain(domain);
                return phase;
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return null;
    }

    public List<ProjectPhase> searchFilter(List<ProjectPhase> list, Integer domainId, Boolean status, String keyword) {
        List<ProjectPhase> filteredList = new ArrayList<>();

        for (ProjectPhase phase : list) {
            boolean matchesDomain = (domainId == null || domainId == 0 || phase.getDomain().getId() == domainId);
            boolean matchesStatus = (status == null || phase.isStatus() == status);
            boolean matchesKeyword = (keyword == null || keyword.isBlank()
                    || phase.getName().toLowerCase().contains(keyword.toLowerCase()));

            if (matchesDomain && matchesStatus && matchesKeyword) {
                filteredList.add(phase);
            }
        }
        return filteredList;
    }

    public void insert(ProjectPhase phase) throws SQLException {
        String sql = "INSERT INTO pms.projectphase (name, priority, details, finalPhase, completeRate, status, domainId) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, phase.getName());
            st.setInt(2, phase.getPriority());
            st.setString(3, phase.getDetails());
            st.setBoolean(4, phase.isFinalPhase());
            st.setInt(5, phase.getCompleteRate());
            st.setBoolean(6, phase.isStatus());
            st.setInt(7, phase.getDomain().getId());
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error inserting phase: " + e.getMessage());
        }
    }

    public void updatePhase(ProjectPhase phase) throws SQLException {
        String sql = "UPDATE pms.projectphase SET name=?, priority=?, details=?, finalPhase=?, "
                + "completeRate=?, status=?, domainId=? WHERE id=?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, phase.getName());
            st.setInt(2, phase.getPriority());
            st.setString(3, phase.getDetails());
            st.setBoolean(4, phase.isFinalPhase());
            st.setInt(5, phase.getCompleteRate());
            st.setBoolean(6, phase.isStatus());
            st.setInt(7, phase.getDomain().getId());
            st.setInt(8, phase.getId());
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error updating phase: " + e.getMessage());
        }
    }
//public ProjectPhase getModalItem(int modalItemID) throws SQLException {
//        String str = "SELECT * FROM pms.allocation where id=?";
//        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
//            pre.setInt(1, modalItemID);
//
//            try (ResultSet rs = pre.executeQuery()) {
//                ProjectPhase temp = new ProjectPhase();
//
//                if (rs.next()) {
//                    temp.setId(rs.getInt(7));
//                    temp.setUser(udao.getUserById(rs.getInt(1))); // Assuming udao is properly instantiated
//                    Project p = pdao.getById(rs.getInt(2)); // Assuming pdao is properly instantiated
//                    p.setListRole(pdao.getListRole(rs.getInt(2))); // Assuming getListRole() is implemented in pdao
//                    temp.setProject(p);
//                    temp.setStartDate(rs.getDate(3));
//                    temp.setEndDate(rs.getDate(4));
//                    temp.setEffortRate(rs.getInt(5));
//                    temp.setStatus(rs.getBoolean(6));
//                    temp.setRole(this.getRoleNameOfAllocation(rs.getInt(7)));
//                }
//                return temp;
//            }
//        }
//    }
    public boolean updateStatus(int phaseId, boolean newStatus) throws SQLException {
        String sql = "UPDATE pms.projectphase SET status = ? WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setBoolean(1, newStatus);
            st.setInt(2, phaseId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new SQLException("Error updating phase status: " + e.getMessage());
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM pms.projectphase WHERE id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error deleting phase: " + e.getMessage());
        }
    }
    public List<ProjectPhase> getProjectPhaseByDomainId(Integer dID) throws SQLException {
        List<ProjectPhase> list = new ArrayList<>();
        String sql = "SELECT * FROM pms.projectphase where domainId = ? ";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setObject(1, dID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ProjectPhase phase = new ProjectPhase();
                phase.setId(rs.getInt("id"));
                phase.setName(rs.getString("name"));
                phase.setPriority(rs.getInt("priority"));
                phase.setDetails(rs.getString("details"));
                phase.setFinalPhase(rs.getBoolean("finalPhase"));
                phase.setCompleteRate(rs.getInt("completeRate"));
                phase.setStatus(rs.getBoolean("status"));
                // Set domain
                Group domain = new Group();
                domain.setId(rs.getInt("domainId"));
                phase.setDomain(domain);
                list.add(phase);
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return list;
    }
}
