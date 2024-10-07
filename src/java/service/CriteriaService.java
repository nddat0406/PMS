/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import com.mysql.cj.jdbc.exceptions.NotUpdatable;
import dal.CriteriaDAO;
import dal.MilestoneDAO;
import dal.ProjectDAO;
import dal.UserDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Criteria;

/**
 *
 * @author HP
 */
public class CriteriaService {

    private UserDAO udao = new UserDAO();
    private ProjectDAO pdao = new ProjectDAO();
    private CriteriaDAO cdao = new CriteriaDAO();
    private MilestoneDAO mdao = new MilestoneDAO();
    private BaseService baseService = new BaseService();

    public List<Criteria> listCriteriaOfProject(int id) throws SQLException {
        try {
            return cdao.getCriteriaByProject(id);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public List<Criteria> searchFilter(List<Criteria> list, int mileFilter, int statusFilter, String searchKey) {
        List<Criteria> temp = new ArrayList<>();
        for (Criteria c : list) {
            if ((c.getMilestone().getId() == mileFilter || mileFilter == 0)
                    && (statusFilter == 0 || c.getStatusInt() == statusFilter)) {

                if (searchKey == null || searchKey.isBlank() || c.getName().toLowerCase().contains(searchKey.toLowerCase())) {
                    temp.add(c);
                }
            }
        }
        return temp;
    }

    public void flipStatus(int id, List<Criteria> list) throws SQLException {
        if (baseService.objectWithIdExists(id, list)) {
            cdao.flipStatusCriteriaOfPrj(id);
        } else {
            throw new SQLException("Illegal action!");
        }
    }

    public void deleteEval(int id, List<Criteria> list) throws SQLException {
        if (baseService.objectWithIdExists(id, list)) {
            cdao.deleteCriteriaOfPrj(id);

        } else {
            throw new SQLException("Illegal action!");
        }
    }

    public Criteria getCriteria(int modalItemID, List<Criteria> list) throws SQLException {
        if (baseService.objectWithIdExists(modalItemID, list)) {
            return cdao.getCriteria(modalItemID);

        } else {
            throw new SQLException("Illegal action!");
        }
    }
}