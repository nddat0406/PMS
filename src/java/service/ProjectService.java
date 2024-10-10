/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ProjectDAO;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Allocation;
import model.Project;
import model.User;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import static service.BaseService.*;

/**
 *
 * @author HP
 */
public class ProjectService {

    private ProjectDAO pdao = new ProjectDAO();
    private BaseService baseService = new BaseService();

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

    public List<Allocation> getProjectMembers(int pID) throws SQLException {
        return pdao.getAllMember(pID);

    }

    public void flipStatusMember(int id, List<Allocation> list) throws SQLException {
        if (baseService.objectWithIdExists(id, list)) {
            pdao.flipStatusMemberOfPrj(id);
        } else {
            throw new IllegalAccessError("" + id + "/" + list.toString());
        }
    }

    public List<Allocation> searchFilterMember(List<Allocation> list, Integer mileFilter, Integer statusFilter, String searchKey) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public Workbook exportProjectMember(List<Allocation> list) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Users");

        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("ID");
        headerRow.createCell(1).setCellValue("Name");
        headerRow.createCell(2).setCellValue("Email");
        headerRow.createCell(3).setCellValue("Role");
        headerRow.createCell(4).setCellValue("Effort Rate");
        headerRow.createCell(5).setCellValue("Department");
        headerRow.createCell(6).setCellValue("Status");
        int rowNum = 1;
        for (Allocation a : list) {
            User u = a.getUser();
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(u.getId());
            row.createCell(1).setCellValue(u.getFullname());
            row.createCell(2).setCellValue(u.getEmail());
            row.createCell(3).setCellValue(u.getRoleString());
            row.createCell(4).setCellValue(a.getEffortRate());
            row.createCell(5).setCellValue(u.getDepartment().getName());
            row.createCell(6).setCellValue(a.getStatusString());
        }
        return workbook;
    }

}
