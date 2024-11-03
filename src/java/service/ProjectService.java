/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.AllocationDAO;
import dal.ProjectDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import model.Allocation;
import model.Milestone;
import model.Project;
import model.ProjectPhase;
import model.User;
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
    private AllocationDAO adao = new AllocationDAO();

    public List<Allocation> getByUser(int id, int role) throws SQLException {
        try {
            if (ADMIN_ROLE == role) {
                return adao.getAllProject();
            } else {
                return adao.getActiveAllocationByUser(id);
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

    public List<Allocation> getProjectMembers(Integer pID) throws SQLException {
        return adao.getAllMember(pID);
    }

    public void flipStatusMember(int id, List<Allocation> list) throws SQLException {
        if (baseService.objectWithIdExists(id, list)) {
            pdao.flipStatusMemberOfPrj(id);
        } else {
            throw new IllegalAccessError("" + id + "/" + list.toString());
        }
    }

    public List<Allocation> searchFilterMember(List<Allocation> list, Integer deptFilter, Integer statusFilter, String searchKey) {
        List<Allocation> pList = new ArrayList<>();
        deptFilter = baseService.TryParseInteger(deptFilter);
        boolean status = baseService.TryParseInteger(statusFilter) == 1;
        for (Allocation allocation : list) {
            User temp = allocation.getUser();
            if ((temp.getDepartment().getId() == deptFilter || deptFilter == 0)
                    && (allocation.isStatus() == status || statusFilter == 0)) {
                if (searchKey == null || searchKey.isBlank() || temp.getFullname().toLowerCase().contains(searchKey.toLowerCase())) {
                    pList.add(allocation);
                }
            }
        }
        return pList;
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
            row.createCell(3).setCellValue(a.getRole().getName());
            row.createCell(4).setCellValue(a.getEffortRate());
            row.createCell(5).setCellValue(u.getDepartment().getName());
            row.createCell(6).setCellValue(a.getStatusString());
        }
        return workbook;
    }

    public List<User> getProjectUsers(Integer pID) throws SQLException {
        List<Allocation> list = adao.getAllMember(pID);
        List<User> temp = new ArrayList<>();
        for (Allocation allocation : list) {
            temp.add(allocation.getUser());
        }
        return temp;
    }
//  ------------------  project list vs project detail -----------------------------

    public List<Project> getProjects(int userId, int page, int pageSize, String keyword, Integer status, Integer domainId, Integer departmentId, int role) {
        // Kiểm tra tính hợp lệ của page và pageSize
        if (role == 1) {
            return pdao.listAllProjectsForAdmin(page, pageSize, keyword, status, domainId, departmentId);
        } else {

            return pdao.listProjects(userId, page, pageSize, keyword, status, domainId, departmentId);
        }
    }

    public int getTotalProjects(int userId, String keyword, Integer status) {
        // Gọi phương thức DAO để đếm tổng số dự án của người dùng
        return pdao.getTotalProjects(userId, keyword, status);
    }

    public Project getProjectById(int id) {
        return pdao.getProjectById(id);
    }
// hàm add project

    public String addProjectWithMilestones(Project project) {
        try {
            // Check Code length
            if (project.getCode() != null && project.getCode().length() > 10) {
                return "Project code must not exceed 10 characters.";  // Trả về thông báo lỗi
            }
            // check Code and name
            if (pdao.isCodeExists(project.getCode()) && pdao.isNameExists(project.getName())) {
                return " code and name already exists";  // Trả về thông báo lỗi
            }
            if (pdao.isCodeExists(project.getCode())) {
                return "code already exists";  // Trả về thông báo lỗi
            }

            // check Name
            if (pdao.isNameExists(project.getName())) {
                return "name already exists";  // Trả về thông báo lỗi
            }
// Thiết lập startDate cho các milestones
            Date startDate = project.getStartDate();

// Lấy ngày hiện tại mà không có thành phần thời gian
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);
            cal.set(java.util.Calendar.MILLISECOND, 0);
            java.util.Date currentDate = cal.getTime();

// Kiểm tra xem startDate có phải là ngày hôm nay hoặc trong tương lai không
            if (startDate == null || startDate.before(currentDate)) {
                return "Start date must be today or in the future.";  // Trả về thông báo lỗi
            }

            // Gọi phương thức thêm project và lấy projectId
            int projectId = pdao.addProject(project);

            // Kiểm tra nếu projectId hợp lệ
            if (projectId > 0) {
                System.out.println("Project added with ID: " + projectId);
                project.setId(projectId);

                // Lấy danh sách các giai đoạn (phases) dựa trên domainId
                List<ProjectPhase> phases = pdao.getPhasesByDomainId(project.getDomain().getId());
                System.out.println("Number of phases found for domainId " + project.getDomain().getId() + ": " + phases.size());

                // Kiểm tra nếu không có phases nào được trả về
                if (phases.isEmpty()) {
                    return "No phases found for domainId: " + project.getDomain().getId();  // Trả về thông báo lỗi
                }

                // Lặp qua các giai đoạn và tạo milestones
                for (ProjectPhase phase : phases) {
                    System.out.println("Processing phase: " + phase.getName() + " with priority: " + phase.getPriority());

                    // Tính toán endDate dựa trên priority của phase
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(startDate);
                    calendar.add(Calendar.DAY_OF_YEAR, phase.getPriority() * 45);
                    Date endDate = new Date(calendar.getTimeInMillis());
                    System.out.println("Calculated endDate for phase " + phase.getName() + ": " + endDate);

                    // Tạo đối tượng Milestone
                    Milestone milestone = new Milestone();
                    milestone.setName("Milestone for " + phase.getName());
                    milestone.setPriority(phase.getPriority());
                    milestone.setDetails("Generated milestone for phase: " + phase.getName());
                    milestone.setEndDate(new java.sql.Date(endDate.getTime()));
                    milestone.setStatus(0); // Default status (e.g., not started)
                    milestone.setDeliver("Default deliverable");
                    milestone.setProject(project); // Đặt đối tượng Project vào milestone
                    milestone.setPhase(phase); // Đặt đối tượng Phase vào milestone

                    // Thêm milestone vào cơ sở dữ liệu
                    try {
                        pdao.addMilestone(milestone);
                        System.out.println("Milestone added for phase: " + phase.getName());
                    } catch (SQLException e) {
                        System.err.println("Error while adding milestone for phase: " + phase.getName());
                        e.printStackTrace();
                        return "Error while adding milestone for phase: " + phase.getName();  // Trả về thông báo lỗi
                    }

                    // Cập nhật startDate cho mốc tiếp theo (bắt đầu sau khi mốc trước kết thúc)
                    startDate = endDate;
                }

                // Nếu tất cả các milestones được thêm thành công, trả về null (không có lỗi)
                return null;
            } else {
                return "Failed to retrieve a valid projectId.";  // Trả về thông báo lỗi
            }
        } catch (SQLException e) {
            System.err.println("Error while adding project or retrieving phases: " + e.getMessage());
            return "An error occurred while adding the project: " + e.getMessage();  // Trả về thông báo lỗi
        }
    }

    public String getRoleByUserAndProject(int userId, int projectId) throws SQLException {
        // Gọi hàm từ ProjectDAO
        return pdao.getRoleByUserAndProject(userId, projectId);
    }

    public void updateProjectStatus(int projectId, int status) throws SQLException {
        pdao.updateProjectStatus(projectId, status);
    }

    public List<Project> getAllProjectPharse() throws SQLException {
        return pdao.getAllProjectPharse();
    }

    public Project getAllProjectPharseBYId(int id) throws SQLException {
        return pdao.getAllProjectPharseBYId(id);
    }

    public List<Project> getProjectsInAllocation(List<Allocation> list) {
        List<Project> temp = new ArrayList<>();
        for (Allocation allocation : list) {
            temp.add(allocation.getProject());
        }
        return temp;
    }

    public boolean havePermission(Integer pID, List<Project> myProjects) {
        if (baseService.objectWithIdExists(pID, myProjects)) {
            return true;
        } else {
            throw new IllegalAccessError("Illegal action!");
        }
    }
    
    public List<Project> getAllProject() throws SQLException{
        return pdao.getAllProject();
    }


}
