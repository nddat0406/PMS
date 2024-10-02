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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Allocation;
import model.Criteria;
import model.Group;
import model.Project;
import model.User;

/**
 *
 * @author HP
 */
public class ProjectDAO extends BaseDAO {

    private GroupDAO gdao = new GroupDAO();
    private UserDAO udao = new UserDAO();
    private MilestoneDAO mdao= new MilestoneDAO();

    public List<Allocation> getAllInAllocation() throws SQLException {
        String str = "select * from project";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            ResultSet rs = pre.executeQuery();
            List<Allocation> projectList = new ArrayList<>();
            while (rs.next()) {
                Allocation temp = new Allocation();
                temp.setProject(setProjectInfor(rs));
                projectList.add(temp);
            }
            return projectList;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Project> getAllByUser(int id) throws SQLException {
        String str = "select p.* from allocation a join project p on p.id = a.projectId where userId = ?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();

            List<Project> projectList = new ArrayList<>();
            while (rs.next()) {
                projectList.add(setProjectInfor(rs));
            }
            return projectList;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Allocation> getAllocation(int id) throws SQLException {
        String str = "select * from allocation where userId = ?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            List<Allocation> AllocateList = new ArrayList<>();
            while (rs.next()) {
                AllocateList.add(setAllocationInfor(rs));
            }
            return AllocateList;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    private Project setProjectInfor(ResultSet rs) throws SQLException {
        try {
            Project temp = new Project();
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
            return temp;
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    private Allocation setAllocationInfor(ResultSet rs) throws SQLException {
        try {
            Allocation temp = new Allocation();
            temp.setUser(udao.getActiveUserById(rs.getInt(1)));
            temp.setProject(getById(rs.getInt(2)));
            temp.setStartDate(rs.getDate(3));
            temp.setEndDate(rs.getDate(4));
            temp.setProjectRole(rs.getString(5));
            temp.setEffortRate(rs.getInt(6));
            temp.setStatus(rs.getBoolean(7));
            return temp;
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    private String getBizTerm(int id) throws SQLException {
        String str = "select name from setting where id=? and type=1 and status = 1";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();
            return rs.getString(1);
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    private Project getById(int id) throws SQLException {
        String str = "select * from project where id=?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();
            return (Project) setProjectInfor(rs);
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

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
                temp.setProject(getById(rs.getInt(4)));
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
}
