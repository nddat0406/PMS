/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CriteriaDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Criteria;
import model.Project;

/**
 *
 * @author HP
 */
public class CriteriaService {

    private CriteriaDAO cdao = new CriteriaDAO();
    private BaseService baseService = new BaseService();

    public List<Criteria> listCriteriaOfProject(Integer id) throws SQLException {
            return cdao.getCriteriaByProject(id);
        
    }

    public List<Criteria> searchFilter(List<Criteria> list, Integer mileFilter, Integer statusFilter, String searchKey) {
        mileFilter = baseService.TryParseInteger(mileFilter);
        statusFilter = baseService.TryParseInteger(statusFilter);
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

    public void flipStatusCriteProject(int id, List<Criteria> list) throws SQLException {
        if (baseService.objectWithIdExists(id, list)) {
            cdao.flipStatusCriteriaOfPrj(id);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void deleteEvalProject(int id, List<Criteria> list) throws SQLException {
        if (baseService.objectWithIdExists(id, list)) {
            cdao.deleteCriteriaOfPrj(id);

        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public Criteria getCriteriaProject(int modalItemID, List<Criteria> list) throws SQLException {
        if (baseService.objectWithIdExists(modalItemID, list)) {
            return cdao.getCriteria(modalItemID);
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void updateEvalProject(Criteria c, List<Criteria> list) throws SQLException {
        if (baseService.objectWithIdExists(c.getId(), list)) {
            Criteria oldC = cdao.getCriteria(c.getId());
            if (!c.getName().equals(oldC.getName()) || c.getMilestone().getId() != oldC.getMilestone().getId()) {
                if (!cdao.isDuplicateInProject(c)) {
                    cdao.updateCriteriaProject(c);
                } else {
                    throw new SQLException("Criteria with that name is already existed");
                }
            } else {
                cdao.updateCriteriaProject(c);
            }
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }

    public void addEvalProject(Criteria c, List<Criteria> list) throws SQLException {
        if (!cdao.isDuplicateInProject(c)) {
            cdao.addCriteriaProject(c);
        } else {
            throw new SQLException("Criteria with that name is already existed");
        }
    }

    public List<Criteria> getAllCriteria(String searchName, String filterStatus) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void editStatusDomainEval(String status, int id) {
        cdao.editStatusDomainEval(status, id);
    }

    public void deleteDomainEval(int id) {
        cdao.deleteDomainEval(id);
    }

    public Criteria getDomainEvalById(int id) throws SQLException {
        return cdao.getDomainEvalById(id);
    }

    public void addDomainEval(Criteria domain) {
        cdao.addDomainEval(domain);
    }

    public void editDomainEval(Criteria domain) {
        cdao.editDomainEval(domain);
    }

    public List<Criteria> getAllCriteriaPhase(String searchName, String filterStatus) throws SQLException {
        return cdao.getAllCriteriaPhase(searchName, filterStatus);
    }

}
