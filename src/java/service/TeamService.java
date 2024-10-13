/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.TeamDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Criteria;
import model.Team;
import model.User;

/**
 *
 * @author HP
 */
public class TeamService {

    private BaseService baseService = new BaseService();
    private TeamDAO tdao = new TeamDAO();

    public List<Team> getTeamsByProject(Integer pID) throws SQLException {
        return tdao.getTeamsByProject(pID);
    }

    public void addTeam(Team t, List<Team> list) throws SQLException {
        if (!tdao.isDuplicated(t)) {
            tdao.addTeam(t);
        } else {
            throw new SQLException("There was a team with name = " + t.getName() + " in that milestone ! ");
        }
    }

    public List<Team> searchFilter(List<Team> list, Integer mileFilter, String searchKey) {
        mileFilter = baseService.TryParseInteger(mileFilter);
        List<Team> temp = new ArrayList<>();
        for (Team c : list) {
            if ((c.getMilestone().getId() == mileFilter || mileFilter == 0)) {
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
            if (!t.getName().equals(oldT.getName()) || t.getMilestone().getId() != oldT.getMilestone().getId()) {
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

    public Object getTeamById(int modalItemID, List<Team> list) throws SQLException {
        if (baseService.objectWithIdExists(modalItemID, list)) {
            return tdao.getTeamById(modalItemID);
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

    public void deleteMember(int teamId, int memberId, List<Team> list) throws SQLException {
        if (baseService.objectWithIdExists(teamId, list)) {
            tdao.deleteTeamMember(memberId, teamId);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void changeRole(int teamId, int memberId, List<Team> list) throws SQLException {
        if (baseService.objectWithIdExists(teamId, list)) {
            tdao.changeRoleMember(memberId, teamId);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void addMembers(int[] numbers, int teamId, List<Team> list) throws SQLException {
        if (baseService.objectWithIdExists(teamId, list)) {
            tdao.addMembers(numbers, teamId);

        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public List<User> getAddMemberList(int teamId,int pID) throws SQLException {
        return tdao.getAddMembers(teamId,pID);
    }

}
