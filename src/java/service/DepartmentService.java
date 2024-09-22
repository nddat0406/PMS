/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.DepartmentDAO;
import java.sql.SQLException;
import java.util.List;
import model.Group;

/**
 *
 * @author ASUS TUF
 */
public class DepartmentService {

    private DepartmentDAO departmentDAO = new DepartmentDAO();

    public List<Group> getAllDepartment() throws SQLException {
        try {
            return departmentDAO.getAllDepartment();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public DepartmentService() {
        this.departmentDAO = new DepartmentDAO();
    }

    // Lấy tên phòng ban theo ID
    public String getDepartmentNameById(int id) {
        try {
            return departmentDAO.getDeptNameById(id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Xóa phòng ban theo ID
    public boolean deleteDepartment(int departmentID) {
        int rowsAffected = departmentDAO.Delete(departmentID);
        return rowsAffected > 0;
    }

    // Đọc danh sách phòng ban với phân trang
    public List<Group> getDepartmentsByPage(int pageNumber, int pageSize) {
        return departmentDAO.readDepartments(pageNumber, pageSize);
    }

    // Thêm phòng ban mới
    public boolean addDepartment(String code, String name, String details, Integer parent, int status) {
        int rowsAffected = departmentDAO.Add(code, name, details, parent, status);
        return rowsAffected > 0;
    }

// Cập nhật thông tin phòng ban
    public boolean updateDepartment(int departmentID, String code, String name, String details, Integer parent, int status) {
        int rowsAffected = departmentDAO.Update(departmentID, code, name, details, parent, status);
        return rowsAffected > 0;
    }

    // Lấy thông tin chi tiết của phòng ban theo ID
    public Group getDepartmentDetail(int departmentID) {
        return departmentDAO.getDepartmentDetail(departmentID);
    }

    // Lọc danh sách phòng ban theo tiêu chí
    public List<Group> filterDepartments(int pageNumber, int pageSize, String code, String name, Integer status) {
        return departmentDAO.filter(pageNumber, pageSize, code, name, status);
    }

    // Tìm kiếm phòng ban theo từ khóa
    public List<Group> searchDepartments(String keyword) {
        return departmentDAO.searchDepartments(keyword);
    }

    public boolean isCodeOrNameDuplicate(String code, String name) {
        boolean isCodeDuplicate = departmentDAO.isCodeExists(code);
        boolean isNameDuplicate = departmentDAO.isNameExists(name);
        return isCodeDuplicate || isNameDuplicate; // Trả về true nếu code hoặc name bị trùng
    }

}
