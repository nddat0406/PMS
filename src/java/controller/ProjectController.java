package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Allocation;
import model.Group;
import model.Milestone;
import model.Project;
import model.Setting;
import model.User;
import service.AllocationService;
import service.GroupService;
import service.MilestoneService;
import service.ProjectService;
import service.SettingService;

@WebServlet(name = "ProjectController", urlPatterns = {"/projectlist"})
public class ProjectController extends HttpServlet {

    private ProjectService projectService = new ProjectService();
    private GroupService groupService = new GroupService();
    private MilestoneService milestoneService = new MilestoneService();
    private AllocationService allocationService = new AllocationService();
    private SettingService settingService = new SettingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "view": {
                    try {
                        projectDetail(request, response);
                    } catch (SQLException ex) {
                        Logger.getLogger(ProjectController.class.getName()).log(Level.SEVERE, null, ex);
                        request.setAttribute("error", "Unable to view project details: " + ex.getMessage());
//                        request.getRequestDispatcher("ErrorPage.jsp").forward(request, response);
                    }
                    break;
                }
                case "list": {
                    listProjects(request, response);
                    break;
                }
                default:
                    listProjects(request, response);
                    break;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProjectController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "An error occurred while processing your request: " + ex.getMessage());
            request.getRequestDispatcher("ErrorPage.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "add": {
                addProject(request, response);
                break;
            }
            case "update": {
                try {
                    updatestatus(request, response);
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                }
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/projectlist?action=list");
                break;
        }
    }

    private void listProjects(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        // Lấy danh sách các bizTerm từ SettingService
        List<Setting> bizTerms = settingService.getAllBizTerms();

        // Đưa danh sách này vào request để truyền đến JSP
        request.setAttribute("bizTerms", bizTerms);

        int page = 1;
        int pageSize = 7;

        // Lấy số trang từ request (nếu có)
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lấy từ khóa tìm kiếm (nếu có)
        String keyword = request.getParameter("keyword");

        // Lấy trạng thái tìm kiếm (nếu có)
        Integer status = null;
        if (request.getParameter("status") != null) {
            try {
                status = Integer.parseInt(request.getParameter("status"));
            } catch (NumberFormatException e) {
                status = null;
            }
        }
        // Lấy thông tin lọc theo domain (nếu có)
        Integer domainId = null;
        if (request.getParameter("domainId") != null) {
            try {
                domainId = Integer.parseInt(request.getParameter("domainId"));
            } catch (NumberFormatException e) {
                domainId = null;
            }
        }

        // Lấy thông tin lọc theo department (nếu có)
        Integer departmentId = null;
        if (request.getParameter("departmentId") != null) {
            try {
                departmentId = Integer.parseInt(request.getParameter("departmentId"));
            } catch (NumberFormatException e) {
                departmentId = null;
            }
        }
        List<Group> domains = groupService.getAllDomains();
        List<Group> departments = groupService.getAllDepartment();

        HttpSession session = request.getSession();
        // LẤY USER ID
        User loginedUser = (User) session.getAttribute("loginedUser");
        int userId = loginedUser.getId();
        int roleUser = loginedUser.getRole();
        // Lấy danh sách dự án của người dùng từ service
        List<Project> projects = projectService.getProjects(userId, page, pageSize, keyword, status, domainId, departmentId, roleUser);
        int totalProjects = projectService.getTotalProjects(userId, keyword, status);
        int totalPages = (int) Math.ceil((double) totalProjects / pageSize);

        // Đưa dữ liệu vào request attribute để gửi tới trang JSP.
        request.setAttribute("projects", projects);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("domains", domains);
        request.setAttribute("departments", departments);

        // Chuyển tiếp đến trang Project.jsp
        request.getRequestDispatcher("/WEB-INF/view/user/projectList/Project.jsp").forward(request, response);
    }

    private void projectDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            HttpSession session = request.getSession();
            User loginedUser = (User) session.getAttribute("loginedUser");
            int id = Integer.parseInt(request.getParameter("id"));
            //lấy role
            int roleUser = loginedUser.getRole();;
            // Lấy thông tin chi tiết của dự án
            Project project = projectService.getProjectById(id);

            // Lấy danh sách các domain và department
            List<Group> domains = groupService.getAllDomains();
            List<Group> departments = groupService.getAllDepartment();

            // Lấy danh sách các cột mốc và phân công cho dự án
            List<Milestone> milestones = milestoneService.getAllMilestone(id);

            List<Allocation> allocations = allocationService.getAllocationsByProjectId(id);

            if (project != null) {
                request.setAttribute("role", roleUser);
                request.setAttribute("domains", domains);
                request.setAttribute("departments", departments);
                request.setAttribute("project", project);
                request.setAttribute("milestones", milestones);
                request.setAttribute("allocations", allocations);
                request.getRequestDispatcher("/WEB-INF/view/user/projectList/ProjectDetail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/projectlist?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/projectlist?action=list");
        }
    }

    private void updatestatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            // Lấy giá trị projectId và status từ form trong JSP
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            int status = Integer.parseInt(request.getParameter("status"));

            // Gọi phương thức trong Service để cập nhật trạng thái dự án
            projectService.updateProjectStatus(projectId, status);

            // Lưu thông báo thành công vào session
            request.getSession().setAttribute("message", "Update successfully!");

            response.sendRedirect(request.getContextPath() + "/projectlist?action=list");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/projectlist?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            // Nếu xảy ra lỗi khi cập nhật trạng thái, điều hướng về trang lỗi hoặc hiển thị thông báo
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private void addProject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String code = request.getParameter("code");
        String details = request.getParameter("details");
        String bizTerm = request.getParameter("bizTerm");
        int status = Integer.parseInt(request.getParameter("status"));
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        int domainId = Integer.parseInt(request.getParameter("domainId"));
        String startDateStr = request.getParameter("startDate");

        HttpSession session = request.getSession();  // Sử dụng session

        try {
            // Lấy các danh sách cần thiết từ service
            List<Group> domains = groupService.getAllDomains();
            List<Group> departments = groupService.getAllDepartment();
            List<Setting> bizTerms = settingService.getAllBizTerms();
            session.setAttribute("bizTerms", bizTerms);
            session.setAttribute("domains", domains);
            session.setAttribute("departments", departments);

            // Chuyển đổi ngày bắt đầu từ String sang java.sql.Date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.sql.Date startDate = null;
            try {
                java.util.Date parsedDate = dateFormat.parse(startDateStr);
                startDate = new java.sql.Date(parsedDate.getTime());
            } catch (ParseException ex) {
                forwardWithError(session, request, response, "Invalid date format. Please use yyyy-MM-dd.",
                        name, code, details, bizTerm, status, departmentId, domainId, startDateStr);
                return;
            }

            // Tạo đối tượng Project
            Project project = new Project();
            project.setName(name);
            project.setCode(code);
            project.setDetails(details);
            project.setBizTerm(bizTerm);
            project.setStartDate(startDate);
            project.setStatus(status);

            // Tạo các đối tượng Group cho department và domain
            Group department = new Group();
            department.setId(departmentId);
            project.setDepartment(department);

            Group domain = new Group();
            domain.setId(domainId);
            project.setDomain(domain);

            // Gọi Service để thêm Project cùng với Milestones
            String result = projectService.addProjectWithMilestones(project);

            // Xử lý kết quả
            if (result == null) {
                // Thành công, thêm thông báo vào session
                session.setAttribute("message", "Add project successfully!");

                // Chuyển hướng đến danh sách dự án
                response.sendRedirect(request.getContextPath() + "/projectlist?action=list&success=true");
            } else {
                // Có lỗi, chuyển tiếp lại trang thêm với thông báo lỗi
                forwardWithError(session, request, response, result, name, code, details, bizTerm, status, departmentId, domainId, startDateStr);
            }
        } catch (NumberFormatException e) {
            forwardWithError(session, request, response, "Invalid input for numerical values.",
                    name, code, details, bizTerm, status, departmentId, domainId, startDateStr);
        } catch (Exception e) {
            forwardWithError(session, request, response, "An unexpected error occurred: " + e.getMessage(),
                    name, code, details, bizTerm, status, departmentId, domainId, startDateStr);
            e.printStackTrace();
        }
    }

    private void forwardWithError(HttpSession session, HttpServletRequest request, HttpServletResponse response, String errorMessage, String name, String code, String details, String bizTerm, int status, int departmentId, int domainId, String startDateStr)
            throws ServletException, IOException {
        // Đặt thông báo lỗi vào session
        session.setAttribute("error", errorMessage);

        // Chuyển tiếp lại dữ liệu người dùng đã nhập vào session
        session.setAttribute("name", name);
        session.setAttribute("code", code);
        session.setAttribute("details", details);
        session.setAttribute("bizTerm", bizTerm);
        session.setAttribute("status", status);
        session.setAttribute("departmentId", departmentId);
        session.setAttribute("domainId", domainId);
        session.setAttribute("startDateStr", startDateStr);

        // Chuyển hướng đến trang AddProject.jsp
        response.sendRedirect(request.getContextPath() + "/projectlist?action=list&showAddPopup=true");
    }

}
