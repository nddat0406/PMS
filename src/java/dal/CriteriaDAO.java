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

/**
 *
 * @author HP
 */
public class CriteriaDAO extends BaseDAO {

    private ProjectDAO pdao = new ProjectDAO();
    private MilestoneDAO mdao = new MilestoneDAO();

    public List<Criteria> getCriteriaByProject(int id) throws SQLException {
        String str = "SELECT * FROM pms.project_criteria where projectId=?";
        try {
            List<Criteria> list = new ArrayList<>();
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                Criteria temp = new Criteria();
                temp.setId(rs.getInt(1));
                temp.setName(rs.getString(2));
                temp.setWeight(rs.getInt(3));
                temp.setProject(pdao.getById(rs.getInt(4)));
                temp.setStatus(rs.getBoolean(5));
                temp.setDescription(rs.getString(6));
                temp.setMilestone(mdao.getMilestoneById(rs.getInt(7)));
                list.add(temp);
            }
            return list;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public void deleteCriteriaOfPrj(int id) throws SQLException {
        String sql = """
                     DELETE FROM `pms`.`project_criteria`
                     WHERE id=?""";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);

            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public void flipStatusCriteriaOfPrj(int id) throws SQLException {
        String sql = """
                     UPDATE `pms`.`project_criteria`
                     SET
                     `status` = status ^ 1
                     WHERE `id` = ?""";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);

            st.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public Criteria getCriteria(int modalItemID) throws SQLException {
        String str = "SELECT * FROM pms.project_criteria where id=?";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, modalItemID);
        ResultSet rs = pre.executeQuery();
        rs.next();
        Criteria temp = new Criteria();
        temp.setId(rs.getInt(1));
        temp.setName(rs.getString(2));
        temp.setWeight(rs.getInt(3));
        temp.setProject(pdao.getById(rs.getInt(4)));
        temp.setStatus(rs.getBoolean(5));
        temp.setDescription(rs.getString(6));
        temp.setMilestone(mdao.getMilestoneById(rs.getInt(7)));

        return temp;
    }
}
