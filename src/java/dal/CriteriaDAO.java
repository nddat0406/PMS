/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import jakarta.servlet.ServletException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Criteria;
import model.Group;

/**
 *
 * @author HP
 */
public class CriteriaDAO extends BaseDAO {

    private ProjectDAO pdao = new ProjectDAO();
    private MilestoneDAO mdao = new MilestoneDAO();
    private PhaseDAO phdao = new PhaseDAO();

    public List<Criteria> getCriteriaByProject(int id) throws SQLException {
        String str = "SELECT * FROM pms.project_criteria WHERE projectId=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);

            try (ResultSet rs = pre.executeQuery()) {
                List<Criteria> list = new ArrayList<>();
                while (rs.next()) {
                    Criteria temp = new Criteria();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setWeight(rs.getInt(3));
                    temp.setProject(pdao.getById(rs.getInt(4))); // Assuming pdao is properly instantiated
                    temp.setStatus(rs.getBoolean(5));
                    temp.setDescription(rs.getString(6));
                    temp.setMilestone(mdao.getMilestoneById(rs.getInt(7))); // Assuming mdao is properly instantiated
                    list.add(temp);
                }
                return list;
            }
        }
    }

    public List<Criteria> getProjectPhaseCriteriaById(int id) throws SQLException {
        return getCriteriaByProject(id); // This method is identical to getCriteriaByProject
    }

    public void deleteCriteriaOfPrj(int id) throws SQLException {
        String sql = """
                     DELETE FROM `pms`.`project_criteria`
                     WHERE id=?""";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setInt(1, id);
            st.executeUpdate();
        }
    }

    public void flipStatusCriteriaOfPrj(int id) throws SQLException {
        String sql = """
                     UPDATE `pms`.`project_criteria`
                     SET
                     `status` = status ^ 1
                     WHERE `id` = ?""";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setInt(1, id);
            st.executeUpdate();
        }
    }

    public Criteria getCriteria(int modalItemID) throws SQLException {
        String str = "SELECT * FROM pms.project_criteria WHERE id=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, modalItemID);

            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    Criteria temp = new Criteria();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setWeight(rs.getInt(3));
                    temp.setProject(pdao.getById(rs.getInt(4))); // Assuming pdao is properly instantiated
                    temp.setStatus(rs.getBoolean(5));
                    temp.setDescription(rs.getString(6));
                    temp.setMilestone(mdao.getMilestoneById(rs.getInt(7))); // Assuming mdao is properly instantiated
                    return temp;
                }
            }
        }
        return null;
    }

    public void updateCriteriaProject(Criteria c) throws SQLException {
        String str = """
                     UPDATE `pms`.`project_criteria`
                     SET
                     `name` = ?,
                     `weight` = ?,
                     `projectId` =?,
                     `description` = ?,
                     `milestoneId` = ?
                     WHERE `id` =?;""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setString(1, c.getName());
            pre.setInt(2, c.getWeight());
            pre.setInt(3, c.getProject().getId());
            pre.setString(4, c.getDescription());
            pre.setInt(5, c.getMilestone().getId());
            pre.setInt(6, c.getId());
            pre.executeUpdate();
        }
    }

    public void addCriteriaProject(Criteria c) throws SQLException {
        String str = """
                     INSERT INTO `pms`.`project_criteria`
                     (`name`, `weight`, `projectId`, `description`, `milestoneId`)
                     VALUES (?, ?, ?, ?, ?);""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setString(1, c.getName());
            pre.setInt(2, c.getWeight());
            pre.setInt(3, c.getProject().getId());
            pre.setString(4, c.getDescription());
            pre.setInt(5, c.getMilestone().getId());
            pre.executeUpdate();
        }
    }

    public boolean isDuplicateInProject(Criteria c) throws SQLException {
        String str = "SELECT count(*) AS num FROM pms.project_criteria WHERE projectId=? AND milestoneId=? AND name=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, c.getProject().getId());
            pre.setInt(2, c.getMilestone().getId());
            pre.setString(3, c.getName());

            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) >= 1;
                }
            }
        }
        return false;
    }

    public List<Criteria> getAllCriteria(String name, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM pms.project_criteria");
        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        if (name != null && !name.isEmpty()) {
            conditions.add("name LIKE ?");
            params.add("%" + name + "%");
        }

        if (status != null && !status.isEmpty()) {
            conditions.add("status = ?");
            params.add(status);
        }

        if (!conditions.isEmpty()) {
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }

        List<Criteria> list = new ArrayList<>();
        try (PreparedStatement pre = getConnection().prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                if (params.get(i) instanceof String) {
                    pre.setString(i + 1, (String) params.get(i));
                } else if (params.get(i) instanceof Integer) {
                    pre.setInt(i + 1, (Integer) params.get(i));
                }
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Criteria temp = new Criteria();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setWeight(rs.getInt(3));
                    temp.setProject(pdao.getById(rs.getInt("projectId")));
                    temp.setStatus(rs.getBoolean(5));
                    temp.setDescription(rs.getString(6));
                    temp.setMilestone(mdao.getMilestoneById(rs.getInt(7)));
                    list.add(temp);
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error fetching criteria by project.", e);
        }

        return list;
    }

    public List<Criteria> getAllCriteriaPhase(String name, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM pms.projectphase_criteria");
        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        if (name != null && !name.isEmpty()) {
            conditions.add("name LIKE ?");
            params.add("%" + name + "%");
        }

        if (status != null && !status.isEmpty()) {
            conditions.add("status = ?");
            params.add(status);
        }

        if (!conditions.isEmpty()) {
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }

        List<Criteria> list = new ArrayList<>();
        try (PreparedStatement pre = getConnection().prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                if (params.get(i) instanceof String) {
                    pre.setString(i + 1, (String) params.get(i));
                } else if (params.get(i) instanceof Integer) {
                    pre.setInt(i + 1, (Integer) params.get(i));
                }
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Criteria temp = new Criteria();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setWeight(rs.getInt(3));
                    temp.setStatus(rs.getBoolean(4));
                    temp.setPhase(phdao.getPhaseById(rs.getInt("phaseId")));
                    temp.setDescription(rs.getString(6));
                    list.add(temp);
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error fetching criteria by phase.", e);
        }

        return list;
    }

    public void editStatusDomainEval(String status, int id) {
        String query = "UPDATE `projectphase_criteria` SET `status` = ? WHERE `id` = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setBoolean(1, status.equals("active"));
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error editing status: " + e.getMessage());
        }
    }

    public void deleteDomainEval(int id) {
        String query = "DELETE FROM `projectphase_criteria` WHERE `id` = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleting domain evaluation: " + e.getMessage());
        }
    }

    public Criteria getDomainEvalById(int id) throws SQLException {
        String sql = "SELECT * FROM pms.projectphase_criteria WHERE id = ?";
        Criteria criteria = null;

        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            pre.setInt(1, id);

            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    criteria = new Criteria();
                    criteria.setId(rs.getInt(1));
                    criteria.setName(rs.getString(2));
                    criteria.setWeight(rs.getInt(3));
                    criteria.setStatus(rs.getBoolean(4));
                    criteria.setPhase(phdao.getPhaseById(rs.getInt("phaseId")));
                    criteria.setDescription(rs.getString(6));
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error fetching domain evaluation by ID.", e);
        }

        return criteria;
    }

    public void addDomainEval(Criteria criteria) throws SQLException {
        String query = "INSERT INTO `projectphase_criteria` (`name`, `weight`, `status`, `phaseId`, `description`, `domainId`, `id`) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, criteria.getName());
            ps.setDouble(2, criteria.getWeight());
            ps.setBoolean(3, criteria.isStatus());
            ps.setInt(4, criteria.getPhase().getId());
            ps.setString(5, criteria.getDescription());
            ps.setInt(6, criteria.getDomain().getId());
            ps.setInt(7, this.getLastId() + 1);
            ps.executeUpdate();
        }
    }

    public void editDomainEval(Criteria criteria) throws Exception {
        String query = "UPDATE `projectphase_criteria` SET `name` = ?, `weight` = ?, `status` = ?, `phaseId` = ?, `description` = ? WHERE `id` = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(query);
            ps.setString(1, criteria.getName());
            ps.setDouble(2, criteria.getWeight());
            ps.setBoolean(3, criteria.isStatus());
            ps.setInt(4, criteria.getPhase().getId());
            ps.setString(5, criteria.getDescription());
            ps.setInt(6, criteria.getId());
            Group g=new Group();
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    public int getLastId() throws SQLException {
        String query = "SELECT MAX(id) FROM `projectphase_criteria`";
        int lastId = -1;

        try (PreparedStatement ps = getConnection().prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                lastId = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }

        return lastId;
    }

    public List<Criteria> getDomainCriteriaByDomainId(Integer dID) throws SQLException {
        String str = "SELECT * FROM pms.projectphase_criteria WHERE domainId=?";
        List<Criteria> list = new ArrayList<>();

        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, dID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Criteria criteria = new Criteria();
                    criteria.setId(rs.getInt("id"));
                    criteria.setName(rs.getString("name"));
                    criteria.setWeight(rs.getInt("weight"));
                    criteria.setStatus(rs.getBoolean("status"));
                    criteria.setPhase(phdao.getPhaseById(rs.getInt("phaseId")));
                    criteria.setDescription(rs.getString(6));
                    Group group = new Group();
                    group.setId(dID);
                    criteria.setDomain(group);
                    list.add(criteria);
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error fetching domain criteria by domain ID.", e);
        }

        return list;
    }
}
