package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Allocation;
import model.Group;
import model.Milestone;
import model.Project;
import model.Setting;
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
                        // Xem chi tiết dự án
                        projectDetail(request, response);
                    } catch (SQLException ex) {
                        Logger.getLogger(ProjectController.class.getName()).log(Level.SEVERE, null, ex);
                        request.setAttribute("error", "Unable to view project details: " + ex.getMessage());
//                        request.getRequestDispatcher("ErrorPage.jsp").forward(request, response);
                    }
                    break;
                }
                case "add": {
                    // Lấy danh sách các domain và department từ service
                    List<Group> domains = groupService.getAllDomains();
                    List<Group> departments = groupService.getAllDepartment();

                    // Lấy danh sách các bizTerm từ SettingService
                    List<Setting> bizTerms = settingService.getAllBizTerms();

                    // Đưa danh sách này vào request để truyền đến JSP
                    request.setAttribute("bizTerms", bizTerms);
                    request.setAttribute("domains", domains);
                    request.setAttribute("departments", departments);

                    // Chuyển tiếp đến trang AddProject.jsp để thêm dự án
                    request.getRequestDispatcher("AddProject.jsp").forward(request, response);
                    break;
                }
                case "list": {

                    // Gọi phương thức listProjects để lấy danh sách dự án và chuyển tiếp đến Projectlist.jsp
                    listProjects(request, response);
                    break;
                }
                default:
                    // Trường hợp không xác định, gọi phương thức listProjects như là mặc định
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
                try {
                    // Lấy dữ liệu từ request
                    String name = request.getParameter("name");
                    String code = request.getParameter("code");
                    String details = request.getParameter("details");
                    String bizTerm = request.getParameter("bizTerm"); // Lấy giá trị bizTerm
                    int status = Integer.parseInt(request.getParameter("status"));
                    int departmentId = Integer.parseInt(request.getParameter("departmentId"));
                    int domainId = Integer.parseInt(request.getParameter("domainId"));
                    String startDateStr = request.getParameter("startDate");

                    // Chuyển đổi ngày bắt đầu từ String sang java.sql.Date
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    java.sql.Date startDate = null;
                    try {
                        java.util.Date parsedDate = dateFormat.parse(startDateStr);
                        startDate = new java.sql.Date(parsedDate.getTime());
                    } catch (ParseException ex) {
                        request.setAttribute("error", "Invalid date format. Please use yyyy-MM-dd.");
                        request.getRequestDispatcher("AddProject.jsp").forward(request, response);
                        return;
                    }

                    // Tạo đối tượng Project
                    Project project = new Project();
                    project.setName(name);
                    project.setCode(code);
                    project.setDetails(details);
                    project.setBizTerm(bizTerm); // Thiết lập giá trị bizTerm
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
                    boolean result = projectService.addProjectWithMilestones(project);

                    // Xử lý kết quả
                    if (result) {
                        response.sendRedirect(request.getContextPath() + "/projectlist?action=list&success=true");
                    } else {
                        request.setAttribute("error", "Unable to add project and its milestones.");
                        request.getRequestDispatcher("AddProject.jsp").forward(request, response);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid input for numerical values.");
                    request.getRequestDispatcher("AddProject.jsp").forward(request, response);
                } catch (Exception e) {
                    request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
                    request.getRequestDispatcher("AddProject.jsp").forward(request, response);
                    e.printStackTrace();
                }
                break;

            }
            case "update": {
                try {
                    // Gọi phương thức updatestatus để xử lý cập nhật trạng thái dự án
                    updatestatus(request, response);
                } catch (SQLException e) {
                    e.printStackTrace();
                    // Xử lý lỗi và điều hướng về trang lỗi
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                }
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/projectlist?action=list");
                break;
        }
    }

    private void listProjects(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        // LẤY USER ID
//        Integer userId = (Integer) request.getSession().getAttribute("userId");
        Integer userId = 4;//ĐANG FIX CỨNG DO LỖI ĐĂNG NHẬP :))
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy danh sách dự án của người dùng từ service
        List<Project> projects = projectService.getProjects(userId, page, pageSize, keyword, status);
        int totalProjects = projectService.getTotalProjects(userId, keyword, status);
        int totalPages = (int) Math.ceil((double) totalProjects / pageSize);

        // Đưa dữ liệu vào request attribute để gửi tới trang JSP.
        request.setAttribute("projects", projects);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);

        // Chuyển tiếp đến trang Project.jsp
        request.getRequestDispatcher("Project.jsp").forward(request, response);
    }

    private void projectDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            // LẤY USER ID
//        Integer userId = (Integer) request.getSession().getAttribute("userId");
            Integer userId = 4;//ĐANG FIX CỨNG DO LỖI ĐĂNG NHẬP :))
            if (userId == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int id = Integer.parseInt(request.getParameter("id"));
            //lấy role
            String role = projectService.getRoleByUserAndProject(userId, id);
            // Lấy thông tin chi tiết của dự án
            Project project = projectService.getProjectById(id);

            // Lấy danh sách các domain và department
            List<Group> domains = groupService.getAllDomains();
            List<Group> departments = groupService.getAllDepartment();

            // Lấy danh sách các cột mốc và phân công cho dự án
            List<Milestone> milestones = milestoneService.getAllMilestone(id);

            List<Allocation> allocations = allocationService.getAllocationsByProjectId(id);

            if (project != null) {
                request.setAttribute("role", role);
                request.setAttribute("domains", domains);
                request.setAttribute("departments", departments);
                request.setAttribute("project", project);
                request.setAttribute("milestones", milestones);
                request.setAttribute("allocations", allocations);
                request.getRequestDispatcher("ProjectDetail.jsp").forward(request, response);
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
}
