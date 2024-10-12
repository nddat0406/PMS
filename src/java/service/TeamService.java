/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.TeamDAO;
import java.sql.SQLException;
import java.util.List;
import model.Team;

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

}
