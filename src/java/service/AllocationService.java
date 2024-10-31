/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.AllocationDAO;
import java.sql.SQLException;
import java.util.List;
import model.Allocation;
import model.User;


/**
 *
 * @author ASUS TUF
 */
public class AllocationService {
 private AllocationDAO allocationDAO;
 
    public AllocationService() {
        this.allocationDAO = new AllocationDAO();
    }
    public List<Allocation> getAllocationsByProjectId(int id) {
        return allocationDAO.getAllocationsByProjectId(id);
    }

    public List<Allocation> getAlloList(User user) throws SQLException {
        if(user.getRole()==BaseService.ADMIN_ROLE || user.getRole()==BaseService.DEPARTMENT_MANAGER){
            return allocationDAO.getAll();
        }else{
            return allocationDAO.getProjectAllocationByUser(user.getId());
        }
        
    }
}
