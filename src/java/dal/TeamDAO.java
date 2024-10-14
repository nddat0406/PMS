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
import model.Milestone;
import model.Project;
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

    public boolean isDuplicated(Team t) throws SQLException {
        String str = "select count(*) as num  FROM pms.team where projectId=? and milestoneId=? and name = ?;";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, t.getProject().getId());
        pre.setInt(2, t.getMilestone().getId());
        pre.setString(3, t.getName());
        ResultSet rs = pre.executeQuery();
        rs.next();
        return rs.getInt(1) >= 1;
    }

    public void addTeam(Team t) throws SQLException {
        String str = """
                     INSERT INTO `pms`.`team`
                     (
                     `name`,
                     `topic`,
                     `details`,
                     `milestoneId`,
                     `projectId`)
                     VALUES
                     (
                     ?,
                     ?,
                     ?,
                     ?,
                     ?
                     )""";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setString(1, t.getName());
        pre.setString(2, t.getTopic());
        pre.setString(3, t.getDetails());
        pre.setInt(4, t.getMilestone().getId());
        pre.setInt(5, t.getProject().getId());
        pre.executeUpdate();
    }

    public void updateTeam(Team t) throws SQLException {
        String str = """
                     UPDATE `pms`.`team`
                     SET
                     `name` =?,
                     `topic` = ?,
                     `details` = ?,
                     `milestoneId` = ?,
                     `projectId` = ?
                     WHERE `id` = ?""";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setString(1, t.getName());
        pre.setString(2, t.getTopic());
        pre.setString(3, t.getDetails());
        pre.setInt(4, t.getMilestone().getId());
        pre.setInt(5, t.getProject().getId());
        pre.setInt(6, t.getId());
        pre.executeUpdate();
    }

    public void deleteTeam(int id) throws SQLException {
        String str = """
                     DELETE FROM `pms`.`team`
                     WHERE id=?""";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, id);
        pre.executeUpdate();
    }

    public static void main(String[] args) throws SQLException {

        System.out.println(new TeamDAO().getAddMembers(1, 21));
    }

    public void deleteTeamMember(int memberId, int teamId) throws SQLException {
        String str = """
                     DELETE FROM `pms`.`team_member`
                     WHERE teamId=? and userId=?""";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, teamId);
        pre.setInt(2, memberId);
        pre.executeUpdate();
    }

    public void changeRoleMember(int memberId, int teamId) throws SQLException {
        String str1 = """
                     UPDATE `pms`.`team_member`
                     SET
                     `isLeader` = FALSE
                     WHERE teamId = ?
                     """;
        String str2 = """
                        UPDATE `pms`.`team_member`
                        SET
                        `isLeader` = True
                        WHERE teamId = ? and userId = ?
                     """;
        PreparedStatement pre1 = getConnection().prepareStatement(str1);
        pre1.setInt(1, teamId);
        pre1.executeUpdate();
        PreparedStatement pre2 = getConnection().prepareStatement(str2);

        pre2.setInt(1, teamId);
        pre2.setInt(2, memberId);
        pre2.executeUpdate();
    }

    public void addMembers(int[] membersId, int teamId) throws SQLException {
        String str = """
                     INSERT INTO `pms`.`team_member`
                     (
                     `teamId`,
                     `userId`)
                     VALUES
                     (?,?)""";
        PreparedStatement pre = getConnection().prepareStatement(str);
        for (int i : membersId) {
            pre.setInt(1, teamId);
            pre.setInt(2, i);
            pre.addBatch();
        }
        try {
            getConnection().setAutoCommit(false);
            pre.executeBatch();
            getConnection().commit();
        } finally {
            getConnection().setAutoCommit(true);
        }
    }

    public List<User> getAddMembers(int teamId, int pID) throws SQLException {
        String str = """
                     SELECT DISTINCT a.userId
                     FROM allocation AS a
                     WHERE a.userId NOT IN (
                         SELECT userId
                         FROM team_member
                         WHERE teamId = ?
                     )
                     AND a.projectId = ? and status = 1""";
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, teamId);
            pre.setInt(2, pID);
            ResultSet rs = pre.executeQuery();
            List<User> temp = new ArrayList<>();
            while (rs.next()) {
                temp.add(udao.getActiveUserByIdNull(rs.getInt(1)));
            }
            return temp;
    }
}
