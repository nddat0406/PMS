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
import model.Team;
import model.User;

/**
 *
 * @author HP
 */
public class TeamDAO extends BaseDAO {

    private MilestoneDAO mdao = new MilestoneDAO();
    private UserDAO udao = new UserDAO();

    public List<Team> getTeamsByProject(int id) throws SQLException {
        String str = "select * from team where projectId=?";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, id);

        ResultSet rs = pre.executeQuery();
        List<Team> teamList = new ArrayList<>();
        while (rs.next()) {
            Team temp = new Team();
            temp.setId(rs.getInt(1));
            temp.setName(rs.getString(2));
            temp.setTopic(rs.getString(3));
            temp.setDetails(rs.getString(4));
            temp.setMilestone(mdao.getMilestoneById(rs.getInt(5)));
            temp.setMembers(getTeamMembers(temp.getId()));
            temp.setTeamLeader(getTeamLeader(temp.getId()));
            teamList.add(temp);
        }
        return teamList;
    }

    public Team getTeamById(int id) throws SQLException {
        String str = "select * from team where id=?";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, id);
        ResultSet rs = pre.executeQuery();
        rs.next();
        Team temp = new Team();
        temp.setId(rs.getInt(1));
        temp.setName(rs.getString(2));
        temp.setTopic(rs.getString(3));
        temp.setDetails(rs.getString(4));
        temp.setMilestone(mdao.getMilestoneById(rs.getInt(5)));
        temp.setMembers(getTeamMembers(id));
        temp.setTeamLeader(getTeamLeader(id));
        return temp;
    }

    private List<User> getTeamMembers(int id) throws SQLException {
        String str = "select * from team_member where teamId=? and isLeader=0";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, id);
        ResultSet rs = pre.executeQuery();
        List<User> teamList = new ArrayList<>();
        while (rs.next()) {
            User temp = udao.getUserFullById(rs.getInt("userId"));
            teamList.add(temp);
        }
        return teamList;
    }

    private User getTeamLeader(int id) {
        try {
            String str = "select * from team_member where teamId=? and isLeader=1";
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();
            User temp = udao.getUserFullById(rs.getInt("userId"));
            return temp;
        } catch (SQLException ex) {
            return null;
        }
    }

    public static void main(String[] args) throws SQLException {
        System.out.println(new TeamDAO().getTeamLeader(9));
    }
}
