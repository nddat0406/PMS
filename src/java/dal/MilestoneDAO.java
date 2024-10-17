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
import model.Criteria;
import model.Milestone;

/**
 *
 * @author HP
 */
public class MilestoneDAO extends BaseDAO {

    public Milestone getMilestoneById(int id) throws SQLException {
        String str = "SELECT * FROM pms.milestone where id=?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();
            Milestone temp = new Milestone();
            temp.setId(rs.getInt(1));
            temp.setName(rs.getString(2));
            temp.setPriority(rs.getInt(3));
            temp.setDetails(rs.getString(4));
            temp.setEndDate(rs.getDate(5));
            temp.setStatus(rs.getInt(6));
            temp.setDeliver(rs.getString(7));
            return temp;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Milestone> getAllByProjectId(int id) throws SQLException {
        String str = "SELECT * FROM pms.milestone where projectId=?";
        try {
            List<Milestone> list = new ArrayList<>();
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                Milestone temp = new Milestone();
                temp.setId(rs.getInt(1));
                temp.setName(rs.getString(2));
                temp.setPriority(rs.getInt(3));
                temp.setDetails(rs.getString(4));
                temp.setEndDate(rs.getDate(5));
                temp.setStatus(rs.getInt(6));
                temp.setDeliver(rs.getString(7));
                list.add(temp);
            }
            return list;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public void updateMilestone(Milestone milestone) throws SQLException {
        String query = "UPDATE pms.milestone SET name=?, priority=?, details=?, endDate=?, status=? WHERE id=?";
        try (PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, milestone.getName());
            ps.setInt(2, milestone.getPriority());
            ps.setString(3, milestone.getDetails());
            ps.setDate(4, new java.sql.Date(milestone.getEndDate().getTime()));
            ps.setObject(5, milestone.getStatus());
//            ps.setString(6, milestone.getDeliver());
            ps.setInt(6, milestone.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public void insertMilestone(Milestone milestone) throws SQLException {
        String sql = "INSERT INTO milestone (name, priority, details, endDate, status, deliver, projectId, phaseId) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
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

    public List<Milestone> searchMilestones(String searchKey) throws SQLException {
        List<Milestone> result = new ArrayList<>();
        String sql = "SELECT ml.*\n"
                + "FROM \n"
                + "	milestone as ml,\n"
                + "    project as pj\n"
                + "where pj.name = ?\n"
                + "AND ml.projectId = pj.id";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, searchKey);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Milestone temp = new Milestone();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setPriority(rs.getInt(3));
                    temp.setDetails(rs.getString(4));
                    temp.setEndDate(rs.getDate(5));
                    temp.setStatus(rs.getInt(6));
                    temp.setDeliver(rs.getString(7));
                    result.add(temp);
                }
            }
        }
        return result;
    }
}
