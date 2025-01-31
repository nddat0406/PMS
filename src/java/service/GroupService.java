/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.GroupDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Group;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class GroupService {

    private GroupDAO gdao = new GroupDAO();
    public static final int CODE_MAX_LENGTH = 10;

    public GroupService() {
        this.gdao = new GroupDAO();
    }

    public List<Group> getAllGroups(int pageNumber, int pageSize) throws SQLException {
        if (pageNumber <= 0 || pageSize <= 0) {
            throw new IllegalArgumentException("Page number and page size must be greater than 0.");
        }
        return gdao.Read(pageNumber, pageSize);
    }

    public int addGroup(String code, String name, String details, int status) {
        validateGroup(code, name, details, status);
        // Kiểm tra xem code hoặc name đã tồn tại chưa
        if (gdao.isCodeExist(code)) {
            throw new IllegalArgumentException("Code already exists.");
        }
        if (gdao.isNameExist(name)) {
            throw new IllegalArgumentException("Name already exists.");
        }
        return gdao.Add(code, name, details, status);
    }

    public int updateGroup(int domainID, String code, String name, String details, int status) {
        if (domainID <= 0) {
            throw new IllegalArgumentException("Domain ID must be greater than 0.");
        }
        // Kiểm tra xem code hoặc name đã tồn tại chưa khi cập nhật
//        if (gdao.isCodeExist(code)) {
//            throw new IllegalArgumentException("Code already exists.");
//        }
//        if (gdao.isNameExist(name)) {
//            throw new IllegalArgumentException("Name already exists.");
//        }
        return gdao.Update(domainID, code, name, details, status);
    }

    public Workbook exportDomainUser(List<Group> domainUsers) {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Domain Users");

        Row headerRow = sheet.createRow(0);
        String[] headers = {"ID", "Username", "Email", "Phone", "Domain", "Status"};

        CellStyle headerCellStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerCellStyle.setFont(headerFont);

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerCellStyle);
        }
        int rowNum = 1;
        for (Group user : domainUsers) {
            Row row = sheet.createRow(rowNum++);

            row.createCell(0).setCellValue(user.getId());
            if (user.getUser() != null) {
                row.createCell(1).setCellValue(user.getUser().getFullname());
                row.createCell(2).setCellValue(user.getUser().getEmail());
                row.createCell(3).setCellValue(user.getUser().getMobile());
            } else {
                row.createCell(1).setCellValue("Deactivated User");
                row.createCell(2).setCellValue("Deactivated User");
                row.createCell(3).setCellValue("Deactivated User");
            }
            row.createCell(4).setCellValue(user.getName());

            String status = "Unknown";
            if (user.getStatus() == 1) {
                status = "Active";
            } else if (user.getStatus() == 0) {
                status = "Inactive";
            }
            row.createCell(5).setCellValue(status);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        return workbook;
    }

    public Group getGroupDetail(int groupID) {
        if (groupID <= 0) {
            throw new IllegalArgumentException("Group ID must be greater than 0.");
        }
        return gdao.Detail(groupID);
    }

    public List<Group> searchDomain(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("Search keyword cannot be null or empty.");
        }
        return gdao.Search(keyword);
    }

    public List<Group> filterGroups(int pageNumber, int pageSize, Integer status) {
        if (pageNumber <= 0 || pageSize <= 0) {
            throw new IllegalArgumentException("Page number and page size must be greater than 0.");
        }
        return gdao.filterGroups(pageNumber, pageSize, status);
    }

    private void validateGroup(String code, String name, String details, int status) {
        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException("Code cannot be null or empty.");
        }
        if (code.length() > CODE_MAX_LENGTH) {
            throw new IllegalArgumentException("Code cannot exceed " + CODE_MAX_LENGTH + " characters.");
        }
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty.");
        }
        if (status < 0 || status > 1) {
            throw new IllegalArgumentException("Status must be either 0 (inactive) or 1 (active).");
        }

        // Có thể thêm kiểm tra cho 'details' nếu cần
    }

//department
    public List<Group> getAllDepartment() throws SQLException {
        try {
            return gdao.getAllDepartment();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Group> getAllDomains() throws SQLException {
        try {
            return gdao.getAllDomain();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    // Lấy tên phòng ban theo ID
    public String getDepartmentNameById(int id) {
        try {
            return gdao.getDeptNameById(id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Đọc danh sách phòng ban với phân trang
    public List<Group> getDepartmentsByPage(int pageNumber, int pageSize) {
        return gdao.readDepartments(pageNumber, pageSize);
    }

    // Thêm phòng ban mới
    public boolean addDepartment(String code, String name, String details, Integer parent, int status) {
        validateGroup(code, name, details, status);
        if (gdao.isCodeExists(code)) {
            throw new IllegalArgumentException("Code already exists.");
        }
        if (gdao.isNameExists(name)) {
            throw new IllegalArgumentException("Name already exists.");
        }
        int rowsAffected = gdao.Add(code, name, details, parent, status);
        return rowsAffected > 0;
    }

// Cập nhật thông tin phòng ban
    public boolean updateDepartment(int departmentID, String code, String name, String details, Integer parent, int status) {
        int rowsAffected = gdao.Update(departmentID, code, name, details, parent, status);
        return rowsAffected > 0;
    }

    // Lấy thông tin chi tiết của phòng ban theo ID
    public Group getDepartmentDetail(int departmentID) {
        return gdao.getDepartmentDetail(departmentID);
    }

    // Lọc danh sách phòng ban theo tiêu chí
    public List<Group> filterDepartments(int pageNumber, int pageSize, Integer status) {
        return gdao.filter(pageNumber, pageSize, status);
    }

    // Tìm kiếm phòng ban theo từ khóa
    public List<Group> searchDepartments(String keyword) throws SQLException {
        return gdao.searchDepartments(keyword);
    }

    public boolean isCodeOrNameDuplicate(String code, String name) {
        boolean isCodeDuplicate = gdao.isCodeExists(code);
        boolean isNameDuplicate = gdao.isNameExists(name);
        return isCodeDuplicate || isNameDuplicate; // Trả về true nếu code hoặc name bị trùng
    }

    public List<Group> getDomainUsersWithPagination(int page, int pageSize) {
        return gdao.getDomainUsersWithPagination(page, pageSize);
    }

    public int getDomainUserCount() {
        return gdao.getDomainUserCount();
    }

    public List<Group> getDomainUser() {
        return gdao.getDomainUser();
    }

    public List<Group> getDomainUserByDomainId(int domainId) throws SQLException {
        return gdao.getDomainUserByDomainId(domainId);
    }

    public void addDomainUser(Group user) throws SQLException {
        gdao.addDomainUser(user);
    }

    public Group getDomainUserById(int id) throws SQLException {

        return gdao.getDomainUserById(id);
    }

    public void UpdateStatusDomain(String action, int idU) throws SQLException {
        gdao.updateStatusDomain(action, idU);
    }

    public void deleteDomainUser(int idUD) throws SQLException {
        gdao.deleteDomainUser(idUD);
    }

    public int getLatestId() throws SQLException {
        return gdao.getLatestId();
    }

    public void updateDomainUser(Group user) throws SQLException {
        gdao.updateDomainUser(user);
    }
}
