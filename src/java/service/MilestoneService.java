/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.MilestoneDAO;
import java.sql.SQLException;
import java.util.List;
import model.Milestone;
import model.Project;

/**
 *
 * @author HP
 */
public class MilestoneService {

    private MilestoneDAO mdao = new MilestoneDAO();
    private BaseService baseService = new BaseService();
    public void updateMilestone(Milestone milestone) throws SQLException {
        try {
            mdao.updateMilestone(milestone);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public List<Milestone> searchMilestones(String searchKey) throws SQLException {
        try {
            return mdao.searchMilestones(searchKey);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public List<Milestone> getAllMilestone(int id) throws SQLException {
        return mdao.getAllByProjectId(id);
    }
}
