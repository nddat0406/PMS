package service;

import dal.TimesheetDAO;
import model.Timesheet;
import java.util.List;
import model.Project;
import model.Requirement;
import model.User;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import static service.BaseService.*;

public class TimesheetService {

    private TimesheetDAO timesheetDAO;

    public TimesheetService() {
        this.timesheetDAO = new TimesheetDAO();
    }

    public List<Timesheet> getTimesheets(int role, int userId, String searchKeyword, Integer status, Integer projectId, int offset, int limit) {
        if (role == ADMIN_ROLE) {
            return timesheetDAO.getAllTimesheets(searchKeyword, status, projectId, offset, limit);
        } else {
            return timesheetDAO.getTimesheetsByUserId(userId, searchKeyword, status, projectId, offset, limit);
        }
    }

    public int getTotalTimesheets(int role, int userId, String searchKeyword, Integer status, Integer projectId) {
        if (role == ADMIN_ROLE) {
            return timesheetDAO.getTotalTimesheets(searchKeyword, status, projectId);
        } else {
            return timesheetDAO.getTotalTimesheetsByUserId(userId, searchKeyword, status, projectId);
        }
    }

    public boolean deleteTimesheet(int timesheetId) {
        return timesheetDAO.deleteTimesheet(timesheetId);
    }

    // TimesheetService.java
    // Phương thức để xuất timesheet sang Excel
    public Workbook exportTimesheetToExcel(int role, int userId, String searchKeyword, Integer status, Integer projectId) {
        List<Timesheet> timesheets = getTimesheets(role, userId, searchKeyword, status, projectId, 0, Integer.MAX_VALUE);
        return createExcelWorkbook(timesheets);
    }

    // Tạo Workbook Excel từ danh sách Timesheet
    private Workbook createExcelWorkbook(List<Timesheet> timesheets) {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Timesheets");

        // Tạo header cho file Excel
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("ID");
        headerRow.createCell(1).setCellValue("Reporter");
        headerRow.createCell(2).setCellValue("Reviewer");
        headerRow.createCell(3).setCellValue("Project");
        headerRow.createCell(4).setCellValue("Requirement");
        headerRow.createCell(5).setCellValue("Time Created");
        headerRow.createCell(6).setCellValue("Time Completed");
        headerRow.createCell(7).setCellValue("Status");

        // Điền dữ liệu timesheet vào các hàng của Excel
        int rowNum = 1;
        for (Timesheet timesheet : timesheets) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(timesheet.getId());
            row.createCell(1).setCellValue(timesheet.getReporter().getFullname());
            row.createCell(2).setCellValue(timesheet.getReviewer().getFullname());
            row.createCell(3).setCellValue(timesheet.getProject().getName());
            row.createCell(4).setCellValue(timesheet.getRequirement().getTitle());
            row.createCell(5).setCellValue(timesheet.getTimeCreated().toString());
            row.createCell(6).setCellValue(timesheet.getTimeCompleted().toString());
            row.createCell(7).setCellValue(timesheet.getStatus() == 1 ? "Active" : "Inactive");
        }

        return workbook;
    }

    public Timesheet getTimesheetById(int timesheetId) {
        Timesheet timesheet = timesheetDAO.getTimesheetById(timesheetId);
        return timesheet;
    }

    public boolean updateTimesheet(Timesheet timesheet) {
        validateUpdate(timesheet);
        return timesheetDAO.updateTimesheet(timesheet);
    }

    public List<Project> getProjectsByUserRole(int userId, int role) {
        return timesheetDAO.getProjectsByUserId(userId, role);
    }

    public List<User> getReporter(int prjID) {
        return timesheetDAO.getAllReportersByProjectId(prjID);
    }

    public List<User> getReviewer(int prjID) {
        return timesheetDAO.getAllReviewersByProjectId(prjID);
    }

    public List<Requirement> getAllRequirements(int projectid, int role) {
        return timesheetDAO.getAllRequirements(projectid, role);
    }

    public boolean updateTimesheetStatus(int timesheetId, int newStatus,String reasonReject) {
        return timesheetDAO.updateTimesheetStatus(timesheetId, newStatus,reasonReject);
    }

    public boolean addTimesheet(Timesheet timesheet) throws IllegalArgumentException {
        validateTimesheet(timesheet);
        return timesheetDAO.insertTimesheet(timesheet);
    }
    private void validateUpdate(Timesheet timesheet) throws IllegalArgumentException {
        // Kiểm tra các trường bắt buộc
        if (timesheet.getProject() == null || timesheet.getProject().getId() <= 0) {
            throw new IllegalArgumentException("Project is required.");
        }
        if (timesheet.getReporter() == null || timesheet.getReporter().getId() <= 0) {
            throw new IllegalArgumentException("Reporter is required.");
        }
        if (timesheet.getReviewer() == null || timesheet.getReviewer().getId() <= 0) {
            throw new IllegalArgumentException("Reviewer is required.");
        }
        if (timesheet.getRequirement() == null || timesheet.getRequirement().getId() <= 0) {
            throw new IllegalArgumentException("Requirement is required.");
        }

        // Lấy ngày hiện tại không có thành phần thời gian
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        java.util.Date currentDate = cal.getTime();

        // Kiểm tra Time Created
        if (timesheet.getTimeCreated() == null) {
            throw new IllegalArgumentException("Time Created is required.");
        }
        if (timesheet.getTimeCompleted() != null && timesheet.getTimeCompleted().before(timesheet.getTimeCreated())) {
            throw new IllegalArgumentException("Time Completed must be after Time Created.");
        }

        int status = timesheet.getStatus();
        if (status < 0 || status > 3) {
            throw new IllegalArgumentException("Invalid status value.");
        }
    }
    private void validateTimesheet(Timesheet timesheet) throws IllegalArgumentException {
        // Kiểm tra các trường bắt buộc
        if (timesheet.getProject() == null || timesheet.getProject().getId() <= 0) {
            throw new IllegalArgumentException("Project is required.");
        }
        if (timesheet.getReporter() == null || timesheet.getReporter().getId() <= 0) {
            throw new IllegalArgumentException("Reporter is required.");
        }
        if (timesheet.getReviewer() == null || timesheet.getReviewer().getId() <= 0) {
            throw new IllegalArgumentException("Reviewer is required.");
        }
        if (timesheet.getRequirement() == null || timesheet.getRequirement().getId() <= 0) {
            throw new IllegalArgumentException("Requirement is required.");
        }

        // Lấy ngày hiện tại không có thành phần thời gian
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        java.util.Date currentDate = cal.getTime();

        // Kiểm tra Time Created
        if (timesheet.getTimeCreated() == null) {
            throw new IllegalArgumentException("Time Created is required.");
        }
        if (timesheet.getTimeCreated().before(currentDate)) {
            throw new IllegalArgumentException("Time Created must be today or a future date.");
        }

        if (timesheet.getTimeCompleted() != null && timesheet.getTimeCompleted().before(timesheet.getTimeCreated())) {
            throw new IllegalArgumentException("Time Completed must be after Time Created.");
        }

        int status = timesheet.getStatus();
        if (status < 0 || status > 3) {
            throw new IllegalArgumentException("Invalid status value.");
        }
    }
}
