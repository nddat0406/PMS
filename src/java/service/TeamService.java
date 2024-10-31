/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.TeamDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Team;
import model.User;

/**
 *
 * @author HP
 */
public class TeamService {

    private BaseService baseService = new BaseService();
    private TeamDAO tdao = new TeamDAO();

    public List<Team> getTeamsByProject(Integer pID,int mID) throws SQLException {
        return tdao.getTeamsByProject(pID,mID);
    }

    public void addTeam(Team t) throws SQLException {
        if (!tdao.isDuplicated(t)) {
            tdao.addTeam(t);
        } else {
            throw new SQLException("There was a team with name = " + t.getName() + " in this project ! ");
        }
    }

    public List<Team> searchFilter(List<Team> list, Integer mileFilter, String searchKey) {
        mileFilter = baseService.TryParseInteger(mileFilter);
        List<Team> temp = new ArrayList<>();
        for (Team c : list) {
            if (baseService.objectWithIdExists(mileFilter, c.getMilestone()) || mileFilter == 0) {
                if (searchKey == null || searchKey.isBlank() || c.getName().toLowerCase().contains(searchKey.toLowerCase())) {
                    temp.add(c);
                }
            }
        }
        return temp;
    }

    public void updateTeam(Team t, List<Team> list) throws SQLException {
        if (baseService.objectWithIdExists(t.getId(), list)) {
            Team oldT = tdao.getTeamById(t.getId());
            if (!t.getName().equals(oldT.getName()) || t.getProject().getId() != oldT.getProject().getId()) {
                if (!tdao.isDuplicated(t)) {
                    tdao.updateTeam(t);
                } else {
                    throw new SQLException("Criteria with that name is already existed");
                }
            } else {
                tdao.updateTeam(t);
            }
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public Team getTeamById(int modalItemID, List<Team> list,int mID) throws SQLException {
        if (baseService.objectWithIdExists(modalItemID, list)) {
            return tdao.getTeamById(modalItemID,mID);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void deleteTeam(int id, List<Team> list) throws SQLException {
        if (baseService.objectWithIdExists(id, list)) {
            tdao.deleteTeam(id);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void deleteMember(int teamId, int memberId, List<Team> list, int mID) throws SQLException {
        if (baseService.objectWithIdExists(teamId, list)) {
            tdao.deleteTeamMember(memberId, teamId,mID);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void changeRole(int teamId, int memberId, List<Team> list, int mID) throws SQLException {
        if (baseService.objectWithIdExists(teamId, list)) {
            tdao.changeRoleMember(memberId, teamId,mID);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void addMembers(int[] numbers, int teamId, int mID, List<Team> list) throws SQLException {
        if (baseService.objectWithIdExists(teamId, list)) {
            tdao.addMembers(numbers, teamId,mID);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public List<User> getAddMemberList( int pID,int mID) throws SQLException {
        return tdao.getAddMembers( pID,mID);
    }

    public void changeStatus(int id, List<Team> list) throws SQLException {
        if (baseService.objectWithIdExists(id, list)) {
            tdao.changeStatusTeam(id);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

}
