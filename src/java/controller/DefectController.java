package controller;

import com.google.gson.Gson;
import dal.DefectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Defect;
import model.Milestone;
import model.Project;
import model.User;
import model.Requirement;
import model.Setting;
import service.ProjectService;
import service.RequirementService;
import service.SettingService;
import service.UserService;

@WebServlet(name = "DefectController",
        urlPatterns = {"/defectlist", "/defectdetail", "/getProject"})
public class DefectController extends HttpServlet {

    private DefectDAO defectDAO;
    private RequirementService requirementService;
    private ProjectService projectService;
    private SettingService settingService;
    private UserService userService;
    @Override
    public void init() throws ServletException {
        defectDAO = new DefectDAO();
        requirementService = new RequirementService();
        projectService = new ProjectService();
        settingService = new SettingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        try {
            if (path.contains("/defectlist")) {
                showDefectList(request, response);
            } else if (path.contains("/defectdetail")) {
                showDefectDetail(request, response);
            } else if (path.contains("/getProject")) {
                handleGetProject(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "search" ->
                    handleSearch(request, response);
                case "add" ->
                    handleAdd(request, response);
                case "edit" ->
                    handleEdit(request, response);
                case "delete" ->
                    handleDelete(request, response);
                case "changeStatus" ->
                    handleStatusChange(request, response);
                default ->
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            try {
                showDefectList(request, response);
            } catch (SQLException ex1) {
                Logger.getLogger(DefectController.class.getName()).log(Level.SEVERE, null, ex1);
            }
        }
    }

    private void showDefectList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginedUser");

        // Get all defects for logged user's projects
        List<Defect> defects;
//        if (loginUser.equals("1")) { // Assuming isAdmin() checks if the user has admin privileges
        // Admins get all defects
        if (loginUser.getRole() == 2) {
        // Nếu người dùng là member, chỉ lấy defect của họ
        defects = defectDAO.getDefectByAssignee(loginUser.getId());
        request.setAttribute("project", projectService.getAllProject(loginUser.getId()));
    } else {
        // Nếu là admin, lấy tất cả defect
        defects = defectDAO.getAll();
        request.setAttribute("project", projectService.getAllProject());
    }
//        } else {
//            // Members get defects only for the projects they participate in
//            defects = defectDAO.getDefectsByUserProjects(loginUser.getId());
//            request.setAttribute("project", projectService.getAllProject(loginUser.getId()));
//        }
        // Get data for filters
        request.setAttribute("defects", defects);
        request.setAttribute("requirements", requirementService.getAll());
        request.setAttribute("serverities", settingService.getAllSettings());

        request.getRequestDispatcher("/WEB-INF/view/admin/DefectList.jsp")
                .forward(request, response);
    }

    private void showDefectDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Defect defect = defectDAO.getById(id);

        if (defect != null) {
            // Load related data
            request.setAttribute("defect", defect);

            request.setAttribute("requirements", requirementService.getAll());
            request.setAttribute("project", projectService.getAllProject(
                    ((User) request.getSession().getAttribute("loginedUser")).getId()));
            request.setAttribute("serverities", settingService.getAllSettings());
            //request.setAttribute("assignee", userService.getAll());
            request.getRequestDispatcher("/WEB-INF/view/admin/DefectDetails.jsp")
                    .forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/defectlist");
        }
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String keyword = request.getParameter("keyword");
        Integer requirementId = parseIntParameter(request.getParameter("requirementId"));
        Integer projectId = parseIntParameter(request.getParameter("projectId"));
        Integer serverityId = parseIntParameter(request.getParameter("serverityId"));
        Integer status = parseIntParameter(request.getParameter("status"));

        List<Defect> defects = defectDAO.getAll();
        defects = defectDAO.searchFilter(defects, requirementId, projectId,
                serverityId, status, keyword);

        request.setAttribute("defects", defects);
        request.setAttribute("requirements", requirementService.getAll());
        request.setAttribute("project", projectService.getAllProject(
                ((User) request.getSession().getAttribute("loginedUser")).getId()
        ));

        request.setAttribute("serverities", settingService.getAllSettings());

        request.getRequestDispatcher("/WEB-INF/view/admin/DefectList.jsp")
                .forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Defect defect = new Defect();
        populateDefectFromRequest(defect, request);

        try {
            // Validate defect data
            validateDefect(defect);
            defectDAO.insert(defect);
            response.sendRedirect(request.getContextPath() + "/defectlist");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("defect", defect);
            showDefectList(request, response);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Defect defect = defectDAO.getById(id);

        if (defect != null) {
            populateDefectFromRequest(defect, request);

            try {
                validateDefect(defect);
                defectDAO.update(defect);
                response.sendRedirect(request.getContextPath() + "/defectlist");
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
                request.setAttribute("defect", defect);
                showDefectDetail(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/defectlist");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        defectDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/defectlist");
    }

    private void handleStatusChange(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));
        defectDAO.updateStatus(id, status);
        response.sendRedirect(request.getContextPath() + "/defectlist");
    }

    private void populateDefectFromRequest(Defect defect, HttpServletRequest request)
            throws SQLException {
        // Basic fields
        defect.setTitle(request.getParameter("title"));
        defect.setDetails(request.getParameter("details"));
        defect.setLeakage(request.getParameter("leakage") != null);
        defect.setDuedate(Date.valueOf(request.getParameter("duedate")));
        defect.setStatus(Integer.parseInt(request.getParameter("status")));

        // Relationships
        Requirement requirement = requirementService.getRequirementById(
                Integer.parseInt(request.getParameter("requirementId"))
        );
        defect.setRequirement(requirement);

        Project project = projectService.getProjectById(
                Integer.parseInt(request.getParameter("projectId"))
        );
        defect.setProject(project);

        Setting serverity = settingService.getSettingDetail(
                Integer.parseInt(request.getParameter("serverityId"))
        );
        defect.setServerity(serverity);
    }

    private void handleGetProject(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int requirementId = Integer.parseInt(request.getParameter("requirementId"));
            Requirement requirement = requirementService.getRequirementById(requirementId);

            Project projects = projectService.getProjectById(requirement.getProjectId());
            // Convert to JSON and send response
            Gson gson = new Gson();
            String json = gson.toJson(projects);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);
        } catch (Exception e) {
            Logger.getLogger(DefectController.class.getName()).log(Level.SEVERE, null, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error loading milestones");
        }
    }

    private void validateDefect(Defect defect) throws SQLException {
        if (defect.getTitle() == null || defect.getTitle().trim().isEmpty()) {
            throw new SQLException("Title is required");
        }
        if (defect.getDuedate() == null) {
            throw new SQLException("Due date is required");
        }
        if (defect.getRequirement() == null) {
            throw new SQLException("Requirement is required");
        }
        if (defect.getProject() == null) {
            throw new SQLException("Project is required");
        }
        if (defect.getServerity() == null) {
            throw new SQLException("Serverity is required");
        }
    }

    private Integer parseIntParameter(String param) {
        try {
            return param != null && !param.isEmpty() ? Integer.valueOf(param) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
