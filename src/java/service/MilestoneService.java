/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CriteriaDAO;
import dal.MilestoneDAO;
import dal.ProjectDAO;
import dal.UserDAO;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Milestone;

/**
 *
 * @author HP
 */
public class MilestoneService {

    private MilestoneDAO mdao = new MilestoneDAO();

    public List<Milestone> getAllMilestone(int id) throws SQLException {
        try {
            return mdao.getAllByProjectId(id);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public void updateMilestone(Milestone milestone) throws SQLException {
        try {
            mdao.updateMilestone(milestone);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
}
