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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Allocation;
import model.Criteria;
import model.Milestone;
import model.Project;
import static service.BaseService.*;

/**
 *
 * @author HP
 */
public class ProjectService {

    private UserDAO udao = new UserDAO();
    private ProjectDAO pdao = new ProjectDAO();
    private CriteriaDAO cdao = new CriteriaDAO();
    private MilestoneDAO mdao =new MilestoneDAO();

    public List<Allocation> getByUser(int id, int role) throws SQLException {
        try {
            if (ADMIN_ROLE == role) {
                return pdao.getAllInAllocation();
            } else {
                return pdao.getAllocation(id);
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Allocation> searchFilter(List<Allocation> list, int deptFilter, int domainFilter, int statusFilter, String searchKey) {
        List<Allocation> pList = new ArrayList<>();
        for (Allocation allocation : list) {
            Project temp = allocation.getProject();
            if ((temp.getDomain().getId() == domainFilter || domainFilter == 0)
                    && (temp.getDepartment().getId() == deptFilter || deptFilter == 0)
                    && (temp.getStatus() == statusFilter || statusFilter == 0)) {
                if (searchKey == null || searchKey.isBlank() || temp.getName().toLowerCase().contains(searchKey.toLowerCase())) {
                    pList.add(allocation);
                }
            }
        }
        return pList;
    }

}
