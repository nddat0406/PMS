/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.AllocationDAO;
import java.util.List;
import model.Allocation;


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
}
