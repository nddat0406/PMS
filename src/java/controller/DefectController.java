package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
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
import model.Project;
import model.User;
import model.Requirement;
import model.Setting;
import service.DefectService;
import service.ProjectService;
import service.RequirementService;
import service.SettingService;

@WebServlet(name = "DefectController",
        urlPatterns = {"/defectlist", "/defectdetail", "/getProject", "/defect"})
public class DefectController extends HttpServlet {

    private DefectService defectService;
    private RequirementService requirementService;
    private ProjectService projectService;
    private SettingService settingService;

    @Override
    public void init() throws ServletException {
        defectService = new DefectService();
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
                handleGetRequirement(request, response);
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
                case "getProjectAdd" ->
                    handleGetProjectAdd(request, response);
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
        List<Defect> defects;
        if (loginUser.getRole() == 1) {
            // Nếu là admin, lấy tất cả defect
            defects = defectService.getAll();
            request.setAttribute("project", projectService.getAllProject());
        } else {

            // Nếu người dùng là member, chỉ lấy defect của họ
            defects = defectService.getDefectByAssignee(loginUser.getId());
            request.setAttribute("project", projectService.getAllProject(loginUser.getId()));
        }

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
        Defect defect = defectService.getById(id);

        if (defect != null) {
            // Load related data
            request.setAttribute("defect", defect);
            Project p = defectService.getProjectAdd(defect.getProject().getId());
            request.setAttribute("requirements", p.getRequirement());
            request.setAttribute("members", p.getMember());
            request.setAttribute("serverities", settingService.getAllSeverites());
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

        List<Defect> defects = defectService.getAll();
        defects = defectService.searchFilter(defects, requirementId, projectId,
                serverityId, status, keyword);

        request.setAttribute("defects", defects);
        request.setAttribute("requirements", requirementService.getAll());
        request.setAttribute("project", projectService.getAllProject(
                ((User) request.getSession().getAttribute("loginedUser")).getId()
        ));
        request.getSession().setAttribute("projectFilter",projectId);
        request.getSession().setAttribute("serverityFilter",serverityId);
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
            defectService.insert(defect);
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
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginedUser");
        Defect defect = defectService.getById(id);

        if (defect != null) {
            populateDefectFromRequest(defect, request);
            try {
                validateDefect(defect);
                defectService.update(defect);
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
        defectService.delete(id);
        response.sendRedirect(request.getContextPath() + "/defectlist");
    }

    private void handleStatusChange(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));
        defectService.updateStatus(id, status);
        response.sendRedirect(request.getContextPath() + "/defectlist");
    }

    private void populateDefectFromRequest(Defect defect, HttpServletRequest request)
            throws SQLException {
        // Basic fields
        defect.setTitle(request.getParameter("title"));
        defect.setDetails(request.getParameter("details"));
        defect.setLeakage(request.getParameter("leakage") != null);
        defect.setAssignee(new User(Integer.parseInt(request.getParameter("assigneeId"))));
        defect.setDuedate(Date.valueOf(request.getParameter("duedate")));
        defect.setStatus(1);

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
    private void handleGetRequirement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            int projectId = Integer.parseInt(request.getParameter("projectId"));

            Requirement requirement = requirementService.getRequirementById(projectId);

            // Convert to JSON and send response
            Gson gson = new Gson();
            String json = gson.toJson(projectId);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);
        } catch (Exception e) {
            throw new ServletException(e);
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

    private void handleGetProjectAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Integer pID = Integer.parseInt(request.getParameter("pId"));
            JsonObject jsonResponse = defectService.getResponseJson(pID);
            Gson gson = new Gson();
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(jsonResponse));
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
