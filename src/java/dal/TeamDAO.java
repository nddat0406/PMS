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

    public List<Team> getTeamsByProject(int pID, int mID) throws SQLException {
        String str = "SELECT * FROM team WHERE projectId=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, pID);
            try (ResultSet rs = pre.executeQuery()) {
                List<Team> teamList = new ArrayList<>();
                while (rs.next()) {
                    Team temp = new Team();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setTopic(rs.getString(3));
                    temp.setDetails(rs.getString(4));
                    temp.setMilestone(this.getMilestoneByTeam(rs.getInt(1)));
                    temp.setMembers(getTeamMembers(temp.getId(), mID));
                    temp.setTeamLeader(getTeamLeader(temp.getId(), mID));
                    temp.setStatus(rs.getBoolean(6));
                    teamList.add(temp);
                }
                return teamList;
            }
        }
    }

    public Team getTeamById(int id, int mID) throws SQLException {
        String str = "SELECT * FROM team WHERE id=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    Team temp = new Team();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setTopic(rs.getString(3));
                    temp.setDetails(rs.getString(4));
                    temp.setProject(new Project(rs.getInt(5)));
                    temp.setMilestone(this.getMilestoneByTeam(rs.getInt(1)));
                    temp.setMembers(getTeamMembers(id, mID));
                    temp.setTeamLeader(getTeamLeader(id, mID));
                    return temp;
                }
            }
        }
        return null;
    }

    private List<User> getTeamMembers(int tID, int mID) throws SQLException {
        String str = "SELECT * FROM team_member WHERE teamId=? AND isLeader=0 AND milestoneId=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, tID);
            pre.setInt(2, mID);
            try (ResultSet rs = pre.executeQuery()) {
                List<User> teamList = new ArrayList<>();
                while (rs.next()) {
                    User temp = udao.getUserFullById(rs.getInt("userId"));
                    teamList.add(temp);
                }
                return teamList;
            }
        }
    }

    private User getTeamLeader(int tID, int mID) throws SQLException {
        String str = "SELECT * FROM team_member WHERE teamId=? AND isLeader=1 AND milestoneId=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, tID);
            pre.setInt(2, mID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return udao.getUserFullById(rs.getInt("userId"));
                }
            }
        }
        return null;
    }

    public boolean isDuplicated(Team t) throws SQLException {
        String str = "SELECT count(*) AS num FROM pms.team WHERE projectId=? AND name=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, t.getProject().getId());
            pre.setString(2, t.getName());
            try (ResultSet rs = pre.executeQuery()) {
                rs.next();
                return rs.getInt(1) >= 1;
            }
        }
    }

    public void addTeam(Team t) throws SQLException {
        String str = """
                INSERT INTO `pms`.`team`
                (
                    `name`,
                    `topic`,
                    `details`,
                    `projectId`
                )
                VALUES
                (?, ?, ?, ?)
            """;
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setString(1, t.getName());
            pre.setString(2, t.getTopic());
            pre.setString(3, t.getDetails());
            pre.setInt(4, t.getProject().getId());
            pre.executeUpdate();
            this.addTeamMilestone(t.getMilestone());
        }
    }

    public void updateTeam(Team t) throws SQLException {
        String str = """
                 UPDATE `pms`.`team`
                 SET
                 `name` =?,
                 `topic` = ?,
                 `details` = ?,
                 `projectId` = ?
                 WHERE `id` = ?""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setString(1, t.getName());
            pre.setString(2, t.getTopic());
            pre.setString(3, t.getDetails());
            pre.setInt(4, t.getProject().getId());
            pre.setInt(5, t.getId());
            pre.executeUpdate();
            this.updateTeamMilestone(t.getMilestone(), t.getId());
        }
    }

    public void deleteTeam(int id) throws SQLException {
        String str = """
                 DELETE FROM `pms`.`team`
                 WHERE id=?""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);
            pre.executeUpdate();
        }
    }

    public void deleteTeamMember(int memberId, int teamId, int mID) throws SQLException {
        String str = """
                 DELETE FROM `pms`.`team_member`
                 WHERE teamId=? and userId=? and milestoneId=?""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, teamId);
            pre.setInt(2, memberId);
            pre.setInt(3, mID);
            pre.executeUpdate();
        }
    }

    public void changeRoleMember(int memberId, int teamId, int mID) throws SQLException {
        String str1 = """
                 UPDATE `pms`.`team_member`
                 SET
                 `isLeader` = FALSE
                 WHERE teamId = ? and milestoneId=?""";
        String str2 = """
                 UPDATE `pms`.`team_member`
                 SET
                 `isLeader` = True
                 WHERE teamId = ? and userId = ? and milestoneId=?""";
        try (PreparedStatement pre1 = getConnection().prepareStatement(str1); PreparedStatement pre2 = getConnection().prepareStatement(str2)) {
            pre1.setInt(1, teamId);
            pre1.setInt(2, mID);
            pre1.executeUpdate();

            pre2.setInt(1, teamId);
            pre2.setInt(2, memberId);
            pre2.setInt(3, mID);
            pre2.executeUpdate();
        }
    }

    public void addMembers(int[] membersId, int teamId, int mID) throws SQLException {
        String str = """
                 INSERT INTO `pms`.`team_member`
                 (
                 `teamId`,
                 `userId`,
                 milestoneId)
                 VALUES
                 (?,?,?)""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            for (int i : membersId) {
                pre.setInt(1, teamId);
                pre.setInt(2, i);
                pre.setInt(3, mID);
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
    }

    public List<User> getAddMembers(int pID, int mID) throws SQLException {
        String str = """
                 SELECT DISTINCT a.userId
                 FROM allocation a
                 WHERE a.projectId = ?
                   AND a.userId NOT IN (
                       SELECT tm.userId
                       FROM team_member tm
                       JOIN team t ON tm.teamId = t.id
                       WHERE t.projectId = ?  and tm.milestoneId =?
                   )
                   AND a.status = 1""";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, pID);
            pre.setInt(2, pID);
            pre.setInt(3, mID);
            try (ResultSet rs = pre.executeQuery()) {
                List<User> temp = new ArrayList<>();
                while (rs.next()) {
                    temp.add(udao.getActiveUserByIdNull(rs.getInt(1)));
                }
                return temp;
            }
        }
    }

    private List<Milestone> getMilestoneByTeam(int aInt) throws SQLException {
        String str = "SELECT milestoneId FROM pms.team_milestone where teamId=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, aInt);
            try (ResultSet rs = pre.executeQuery()) {
                List<Milestone> temp = new ArrayList<>();
                while (rs.next()) {
                    temp.add(mdao.getMilestoneById(rs.getInt(1)));
                }
                return temp;
            }
        }
    }

    private void updateTeamMilestone(List<Milestone> milestone, int id) throws SQLException {
        String sql1 = "delete FROM pms.team_milestone where teamId = ?";
        try (PreparedStatement pre1 = getConnection().prepareStatement(sql1)) {
            pre1.setInt(1, id);
            pre1.executeUpdate();
        }

        String sql2 = """
                  INSERT INTO `pms`.`team_milestone`
                  (
                  `teamId`,
                  `milestoneId`)
                  VALUES
                  (?,?)""";
        try (PreparedStatement pre2 = getConnection().prepareStatement(sql2)) {
            for (Milestone i : milestone) {
                pre2.setInt(1, id);
                pre2.setInt(2, i.getId());
                pre2.addBatch();
            }
            try {
                getConnection().setAutoCommit(false);
                pre2.executeBatch();
                getConnection().commit();
            } finally {
                getConnection().setAutoCommit(true);
            }
        }
    }

    private void addTeamMilestone(List<Milestone> milestone) throws SQLException {
        String sql = """
                  INSERT INTO `pms`.`team_milestone`
                  (
                  `teamId`,
                  `milestoneId`)
                  VALUES
                  ((select max(id) from team),?)""";
        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            for (Milestone i : milestone) {
                pre.setInt(1, i.getId());
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
    }

    public void changeStatusTeam(int id) throws SQLException {
        String sql = """
               UPDATE `pms`.`team`
               SET
               `status` = status ^ 1
               WHERE `id` = ?""";
        try (PreparedStatement pre = getConnection().prepareStatement(sql)) {
            pre.setInt(1, id);
            pre.executeUpdate();
        }
    }

    public Team getTeamById(int id) throws SQLException {
        String str = "select * from team where id=?";
        try (PreparedStatement pre = getConnection().prepareStatement(str)) {
            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    Team temp = new Team();
                    temp.setId(rs.getInt(1));
                    temp.setName(rs.getString(2));
                    temp.setTopic(rs.getString(3));
                    temp.setDetails(rs.getString(4));
                    temp.setProject(new Project(rs.getInt(5)));
                    temp.setMilestone(this.getMilestoneByTeam(rs.getInt(1)));
                    return temp;
                }
            }
        }
        return null; // Return null if no team found
    }

}
