package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Timesheet;
import model.Project;
import model.User;
import service.TimesheetService;
import service.ProjectService;
import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import model.Requirement;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "TimesheetController", urlPatterns = {"/timesheet"})
public class TimesheetController extends HttpServlet {

    private final TimesheetService timesheetService = new TimesheetService();
    private final ProjectService projectService = new ProjectService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        switch (action) {
            case "list":
                listTimesheets(request, response);
                break;
            case "view":
                view(request, response);
                break;
            default:
                listTimesheets(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "update":
                updateTimesheet(request, response);
                break;
            case "export":
                exportToExcel(request, response);
                break;
            case "delete":
                deleteTimesheet(request, response);
                break;
            case "add":
                addTimesheet(request, response);
                break;
            case "changestatus":
                changeStatus(request, response);

                break;
        }

    }

    private void listTimesheets(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        int userId = loginedUser.getId();
        int role = loginedUser.getRole();

        try {
            int page = 1;
            int limit = 10;
            int offset = 0;

            try {
                page = Integer.parseInt(request.getParameter("page").trim());
                limit = Integer.parseInt(request.getParameter("limit").trim());
                offset = (page - 1) * limit;
            } catch (NumberFormatException | NullPointerException e) {
                // giữ nguyên giá trị mặc định cho `page` và `limit` nếu có lỗi
            }

            String searchKeyword = request.getParameter("searchKeyword") != null ? request.getParameter("searchKeyword").trim() : "";
            Integer status = null;
            Integer projectId = null;

            try {
                String statusParam = request.getParameter("status");
                if (statusParam != null && !statusParam.isEmpty()) {
                    status = Integer.parseInt(statusParam.trim());
                }

                String projectIdParam = request.getParameter("projectId");
                if (projectIdParam != null && !projectIdParam.isEmpty()) {
                    projectId = Integer.parseInt(projectIdParam.trim());
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid filter values.");
                request.getRequestDispatcher("ErrorPage.jsp").forward(request, response);
                return;
            }

            // Lấy danh sách timesheets và dự án
            List<Timesheet> timesheets = timesheetService.getTimesheets(role, userId, searchKeyword, status, projectId, offset, limit);
            int totalTimesheets = timesheetService.getTotalTimesheets(role, userId, searchKeyword, status, projectId);
            int totalPages = (int) Math.ceil((double) totalTimesheets / limit);
            List<Project> projects = timesheetService.getProjectsByUserRole(userId, role);

            List<User> reporters = timesheetService.getAllReporters();
            List<User> reviewers = timesheetService.getAllReviewers();
            List<Requirement> requirements = timesheetService.getAllRequirements(userId, role);
            // Chuyển dữ liệu vào request để hiển thị trong JSP
            request.setAttribute("reporters", reporters);
            request.setAttribute("reviewers", reviewers);
            request.setAttribute("requirements", requirements);
            request.setAttribute("role", role);
            // Gán giá trị vào request
            request.setAttribute("projects", projects);
            request.setAttribute("timesheets", timesheets);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("status", status);
            request.setAttribute("projectId", projectId);

            request.getRequestDispatcher("/WEB-INF/view/user/timesheet/timesheet.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    private void deleteTimesheet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            int timesheetId = Integer.parseInt(request.getParameter("timesheetId").trim());
            boolean isDeleted = timesheetService.deleteTimesheet(timesheetId);

            if (isDeleted) {
                request.setAttribute("message", "Timesheet deleted successfully!");
            } else {
                request.setAttribute("message", "Failed to delete timesheet!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid timesheet ID!");
        }

        // Gọi lại hàm list để hiển thị lại danh sách và thông báo
        listTimesheets(request, response);
    }

    private void exportToExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        int userId = loginedUser.getId();
        int role = loginedUser.getRole();

        // Lấy tất cả Timesheet cần xuất ra Excel dựa trên quyền của user
        List<Timesheet> timesheets = timesheetService.getTimesheets(role, userId, "", null, null, 0, Integer.MAX_VALUE);

        // Tạo workbook Excel
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Timesheet List");

        // Tạo tiêu đề cột
        Row headerRow = sheet.createRow(0);
        String[] columns = {"ID", "Reporter", "Reviewer", "Project", "Requirement", "Start Date", "End Date", "Status"};
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
            cell.setCellStyle(getHeaderCellStyle(workbook));
        }

        // Điền dữ liệu timesheet vào các dòng tiếp theo
        int rowNum = 1;
        for (Timesheet timesheet : timesheets) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(timesheet.getId());
            row.createCell(1).setCellValue(timesheet.getReporter().getFullname());
            row.createCell(2).setCellValue(timesheet.getReviewer() != null ? timesheet.getReviewer().getFullname() : "");
            row.createCell(3).setCellValue(timesheet.getProject().getName());
            row.createCell(4).setCellValue(timesheet.getRequirement().getTitle());
            row.createCell(5).setCellValue(timesheet.getTimeCreated().toString());
            row.createCell(6).setCellValue(timesheet.getTimeCompleted() != null ? timesheet.getTimeCompleted().toString() : "");
            row.createCell(7).setCellValue(
                    timesheet.getStatus() == 0 ? "Draft"
                    : timesheet.getStatus() == 1 ? "Submitted"
                    : timesheet.getStatus() == 2 ? "Approved"
                    : timesheet.getStatus() == 3 ? "Rejected" : "Unknown"
            );

        }

        // Đặt tiêu đề cho file Excel
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=Timesheet_List.xlsx");

        // Ghi workbook ra output stream
        try (OutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
        } finally {
            workbook.close();
        }
    }

    private CellStyle getHeaderCellStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        return style;
    }

    private void view(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        int userId = loginedUser.getId();
        int role = loginedUser.getRole();

        int timesheetId = Integer.parseInt(request.getParameter("id"));

        // Lấy thông tin timesheet qua service
        Timesheet timesheet = timesheetService.getTimesheetById(timesheetId);
        if (timesheet == null) {
            // Nếu timesheet không tồn tại
            request.setAttribute("message", "Timesheet not found.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
            return;
        }
        List<Project> projects = timesheetService.getProjectsByUserRole(userId, role);
        List<User> reporters = timesheetService.getAllReporters();
        List<User> reviewers = timesheetService.getAllReviewers();
        List<Requirement> requirements = timesheetService.getAllRequirements(userId, role);
        // Chuyển dữ liệu vào request để hiển thị trong JSP
        request.setAttribute("reporters", reporters);
        request.setAttribute("reviewers", reviewers);
        request.setAttribute("requirements", requirements);
        request.setAttribute("projects", projects);
        // Gán timesheet vào request
        request.setAttribute("role", role);
        request.setAttribute("timesheet", timesheet);
        request.getRequestDispatcher("/WEB-INF/view/user/timesheet/timesheetdetail.jsp").forward(request, response);
    }

    private void updateTimesheet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            String reporterIdStr = request.getParameter("reporter");
            String reviewerIdStr = request.getParameter("reviewer");
            String projectIdStr = request.getParameter("projectId");
            String requirementIdStr = request.getParameter("requirementId");
            String statusStr = request.getParameter("status");
            String timeCreateStr = request.getParameter("timeCreate");


            int id = idStr != null && !idStr.trim().isEmpty() ? Integer.parseInt(idStr.trim()) : 0;
            int reporterId = reporterIdStr != null && !reporterIdStr.trim().isEmpty() ? Integer.parseInt(reporterIdStr.trim()) : 0;
            int reviewerId = reviewerIdStr != null && !reviewerIdStr.trim().isEmpty() ? Integer.parseInt(reviewerIdStr.trim()) : 0;
            int projectId = projectIdStr != null && !projectIdStr.trim().isEmpty() ? Integer.parseInt(projectIdStr.trim()) : 0;
            int requirementId = requirementIdStr != null && !requirementIdStr.trim().isEmpty() ? Integer.parseInt(requirementIdStr.trim()) : 0;
            int status = statusStr != null && !statusStr.trim().isEmpty() ? Integer.parseInt(statusStr.trim()) : 0;
            java.sql.Date timeCreate = timeCreateStr != null && !timeCreateStr.trim().isEmpty() ? java.sql.Date.valueOf(timeCreateStr.trim()) : null;

            // Xử lý timeComplete có thể là null
            java.sql.Date timeComplete = null;
            String timeCompleteStr = request.getParameter("timeComplete");
            if (timeCompleteStr != null && !timeCompleteStr.trim().isEmpty()) {
                timeComplete = java.sql.Date.valueOf(timeCompleteStr.trim());
            }

            Timesheet timesheet = new Timesheet();
            timesheet.setId(id);

            User reporter = new User();
            reporter.setId(reporterId);
            timesheet.setReporter(reporter);

            if (reviewerId != 0) {
                User reviewer = new User();
                reviewer.setId(reviewerId);
                timesheet.setReviewer(reviewer);
            }

            Project project = new Project();
            project.setId(projectId);
            timesheet.setProject(project);

            Requirement requirement = new Requirement();
            requirement.setId(requirementId);
            timesheet.setRequirement(requirement);

            timesheet.setStatus(status);
            timesheet.setTimeCreated(timeCreate);
            timesheet.setTimeCompleted(timeComplete);

            TimesheetService timesheetService = new TimesheetService();
            boolean isUpdated = timesheetService.updateTimesheet(timesheet);

            if (isUpdated) {
                request.getSession().setAttribute("message", "Timesheet updated successfully!");
                response.sendRedirect(request.getContextPath() + "/timesheet?action=list");
            } else {
                request.getSession().setAttribute("message", "Failed to update timesheet!");
                storeInputAttributes(request);
                response.sendRedirect(request.getContextPath() + "/timesheet?action=view&id=" + id);
            }
        } catch (IllegalArgumentException e) {
            // Gán thông báo lỗi từ IllegalArgumentException vào session
            request.getSession().setAttribute("errorMessage", e.getMessage());
            storeInputAttributes(request);
            response.sendRedirect(request.getContextPath() + "/timesheet?action=view&id=" + request.getParameter("id"));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Invalid input data!");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private java.sql.Date parseDate(String dateString) {
        try {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            format.setLenient(false); // Kiểm tra chặt chẽ định dạng
            java.util.Date utilDate = format.parse(dateString);
            return new java.sql.Date(utilDate.getTime());
        } catch (ParseException e) {
            System.err.println("Date parsing error: Invalid format for input - " + dateString);
            return null;
        }
    }

    private void addTimesheet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String reporterStr = request.getParameter("reporter");
            String reviewerStr = request.getParameter("reviewer");
            String projectStr = request.getParameter("projectId");
            String requirementStr = request.getParameter("requirementId");
            String statusStr = request.getParameter("status");

            int reporterId = reporterStr != null && !reporterStr.isEmpty() ? Integer.parseInt(reporterStr) : 0;
            int reviewerId = reviewerStr != null && !reviewerStr.isEmpty() ? Integer.parseInt(reviewerStr) : 0;
            int projectId = projectStr != null && !projectStr.isEmpty() ? Integer.parseInt(projectStr) : 0;
            int requirementId = requirementStr != null && !requirementStr.isEmpty() ? Integer.parseInt(requirementStr) : 0;
            int status = statusStr != null && !statusStr.isEmpty() ? Integer.parseInt(statusStr) : 0;

            // Xử lý chuỗi ngày tháng
            String timeCreateStr = request.getParameter("timeCreate");
            String timeCompleteStr = request.getParameter("timeComplete");

            Date timeCreateUtil = (timeCreateStr != null && !timeCreateStr.isEmpty()) ? parseDate(timeCreateStr) : null;
            Date timeCompleteUtil = (timeCompleteStr != null && !timeCompleteStr.isEmpty()) ? parseDate(timeCompleteStr) : null;

            java.sql.Date timeCreate = timeCreateUtil != null ? new java.sql.Date(timeCreateUtil.getTime()) : null;
            java.sql.Date timeComplete = timeCompleteUtil != null ? new java.sql.Date(timeCompleteUtil.getTime()) : null;

            // Tạo đối tượng Timesheet
            Timesheet timesheet = new Timesheet();
            User reporter = new User();
            reporter.setId(reporterId);
            timesheet.setReporter(reporter);

            User reviewer = new User();
            reviewer.setId(reviewerId);
            timesheet.setReviewer(reviewer);
            Project project = new Project();
            project.setId(projectId);
            timesheet.setProject(project);
            Requirement requirement = new Requirement();
            requirement.setId(requirementId);
            timesheet.setRequirement(requirement);

            timesheet.setStatus(status);
            timesheet.setTimeCreated(timeCreate);
            timesheet.setTimeCompleted(timeComplete);

            // Gọi service để thêm Timesheet (service sẽ tự động validate)
            boolean isInserted = timesheetService.addTimesheet(timesheet);

            if (isInserted) {
                request.getSession().setAttribute("message", "Timesheet added successfully!");
                response.sendRedirect(request.getContextPath() + "/timesheet?action=list");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add timesheet!");
                storeInputAttributesforadd(request);
                response.sendRedirect(request.getContextPath() + "/timesheet?action=list");
            }

        } catch (IllegalArgumentException e) {
            // Xử lý lỗi từ service
            request.getSession().setAttribute("errorMessagee", e.getMessage());
            storeInputAttributesforadd(request);
            response.sendRedirect(request.getContextPath() + "/timesheet?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessagee", "An unexpected error occurred. Please check your input.");
            storeInputAttributesforadd(request);
            response.sendRedirect(request.getContextPath() + "/timesheet?action=list");
        }
    }

    private void changeStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        TimesheetService timesheetService = new TimesheetService();
        int timesheetId = Integer.parseInt(request.getParameter("timesheetId"));
        int newStatus = Integer.parseInt(request.getParameter("newStatus")); // Set status thành SUBMITTED

        boolean isUpdated = timesheetService.updateTimesheetStatus(timesheetId, newStatus);

        if (isUpdated) {
            request.getSession().setAttribute("message", "Timesheet submit successfully!");
        } else {
            request.getSession().setAttribute("message", "Failed to submit timesheet!");
        }
        response.sendRedirect(request.getContextPath() + "/timesheet?action=list");
    }

    private void storeInputAttributesforadd(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.setAttribute("reporterId", request.getParameter("reporter"));
        session.setAttribute("reviewerId", request.getParameter("reviewer"));
        session.setAttribute("projectId", request.getParameter("projectId"));
        session.setAttribute("requirementId", request.getParameter("requirementId"));
        session.setAttribute("status", request.getParameter("status"));
        session.setAttribute("timeCreate", request.getParameter("timeCreate"));
        session.setAttribute("timeComplete", request.getParameter("timeComplete"));
        session.setAttribute("showAddModal", true);  // Đặt flag để mở modal khi có lỗi
    }

    private void storeInputAttributes(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.setAttribute("reporterId", request.getParameter("reporter"));
        session.setAttribute("reviewerId", request.getParameter("reviewer"));
        session.setAttribute("projectId", request.getParameter("projectId"));
        session.setAttribute("requirementId", request.getParameter("requirementId"));
        session.setAttribute("status", request.getParameter("status"));
        session.setAttribute("timeCreate", request.getParameter("timeCreate"));
        session.setAttribute("timeComplete", request.getParameter("timeComplete"));
    }

}
