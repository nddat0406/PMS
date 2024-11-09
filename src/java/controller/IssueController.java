package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Issue;
import model.Project;
import model.Requirement;
import model.User;
import service.BaseService;
import service.IssueService;
import service.ProjectService;
import service.UserService;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import java.util.List;
import service.RequirementService;

@WebServlet(name = "IssueController", urlPatterns = {"/issue"})
public class IssueController extends HttpServlet {

    private final IssueService issueService = new IssueService();
    private final BaseService baseService = new BaseService();
    private final ProjectService projectService = new ProjectService();
    private final String ISSUE_PAGE = "/WEB-INF/view/user/issues/issue-manage.jsp";
    private final String ISSUE_FORM_PAGE = "/WEB-INF/view/user/issues/addEditIssue.jsp";
    private final UserService userService = new UserService();
    private final RequirementService requirementService = new RequirementService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User loginedUser = (User) session.getAttribute("loginedUser");

            // Get all projects
            List<Project> allProjects = projectService.getAllProject();
            request.setAttribute("projects", allProjects);

            // Get all requirements
            List<Requirement> allRequirements = requirementService.getAll();
            request.setAttribute("requirements", allRequirements);

            UserService userService = new UserService();
            List<User> users = userService.getAll();
            request.setAttribute("users", users);
            request.setAttribute("userService", userService);

            String action = request.getParameter("action");

            // Handle different actions
            if (action != null) {
                switch (action) {
                    case "showAdd":
                        // Show add form
                        request.getRequestDispatcher(ISSUE_FORM_PAGE).forward(request, response);
                        return;
                    case "showEdit":
                        // Show edit form with existing issue data
                        String idStr = request.getParameter("id");
                        if (idStr != null && !idStr.trim().isEmpty()) {
                            try {
                                int id = Integer.parseInt(idStr);
                                Issue issue = issueService.getIssueById(id);
                                if (issue != null) {
                                    request.setAttribute("issue", issue);
                                }
                            } catch (NumberFormatException e) {
                                // Handle invalid ID
                                response.sendRedirect("issue");
                                return;
                            }
                        }
                        request.getRequestDispatcher(ISSUE_FORM_PAGE).forward(request, response);
                        return;
                }
            }

            if (request.getParameter("page") == null) {
                // Clear existing filters
                session.removeAttribute("searchKey");
                session.removeAttribute("projectFilter");
                session.removeAttribute("statusFilter");
                session.removeAttribute("typeFilter");
                session.removeAttribute("sortFieldName");
                session.removeAttribute("sortOrder");

                List<Issue> list = issueService.getAll();
                session.setAttribute("issueList", list);

                // Add type and status lists for dropdowns
                request.setAttribute("typeList", issueService.getAllTypes());
                request.setAttribute("statusList", List.of(
                        "Open", "To Do", "Doing", "Done", "Closed"));

                pagination(request, response, list);
            } else {
                List<Issue> list = (List<Issue>) session.getAttribute("issueList");
                String modalItemIDRaw = request.getParameter("modalItemID");
                if (modalItemIDRaw != null) {
                    int modalItemID = Integer.parseInt(modalItemIDRaw);
                    request.setAttribute("modalItem", issueService.getIssueById(modalItemID));
                }
                pagination(request, response, list);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            doGet(request, response);
            return;
        }

        try {
            switch (action) {
                case "filter" ->
                    postFilter(request, response);
                case "sort" ->
                    postSort(request, response);
                case "add" ->
                    postAdd(request, response);
                case "update" ->
                    postUpdate(request, response);
                case "getRequirements" ->
                    handleGetRequirements(request, response);
                case "getAssignees" ->
                    handleGetAssignees(request, response);
                default ->
                    doGet(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void pagination(HttpServletRequest request, HttpServletResponse response, List<?> list)
            throws ServletException, IOException {
        int page, numperpage = 12;
        int size = list.size();
        int num = (size % numperpage == 0 ? (size / numperpage) : (size / numperpage) + 1);
        if (num == 0) {
            num = 1;
        }

        String xpage = request.getParameter("page");
        page = (xpage == null) ? 1 : Integer.parseInt(xpage);
        if (page > num) {
            page = num;
        }

        int start = (page - 1) * numperpage;
        int end = Math.min(page * numperpage, size);

        request.setAttribute("page", page);
        request.setAttribute("num", num);
        request.getSession().setAttribute("numberPage", numperpage);
        request.setAttribute("tableData", baseService.getListByPage(list, start, end));
        request.getRequestDispatcher(ISSUE_PAGE).forward(request, response);
    }

    private void postFilter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");

        // Get all projects
        List<Project> allProjects = projectService.getAllProject();
        request.setAttribute("projects", allProjects);

        // Get all requirements
        List<Requirement> allRequirements = requirementService.getAll();
        request.setAttribute("requirements", allRequirements);
        request.setAttribute("userService", userService);

        UserService userService = new UserService();
        List<User> users = userService.getAll();

        String projectFilterRaw = request.getParameter("projectFilter");
        String statusFilterRaw = request.getParameter("statusFilter");
        String typeFilter = request.getParameter("typeFilter");
        String searchKey = request.getParameter("searchKey");

        int projectFilter = baseService.TryParseInt(projectFilterRaw);

        // Change status filter handling
        Integer statusFilter = null;
        if (statusFilterRaw != null && !statusFilterRaw.trim().isEmpty()) {
            try {
                statusFilter = Integer.parseInt(statusFilterRaw);
            } catch (NumberFormatException e) {
                statusFilter = null; // This will handle the empty string case ("All Status")
            }
        }

        List<Issue> list = issueService.searchAdvanced(searchKey, projectFilter, typeFilter, null, statusFilter, null,
                null);

        session.setAttribute("searchKey", searchKey);
        session.setAttribute("projectFilter", projectFilter);
        session.setAttribute("statusFilter", statusFilter);
        session.setAttribute("typeFilter", typeFilter);
        session.setAttribute("issueList", list);

        pagination(request, response, list);
    }

    private void postSort(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");

        // Get all projects
        List<Project> allProjects = projectService.getAllProject();
        request.setAttribute("projects", allProjects);

        // Get all requirements
        List<Requirement> allRequirements = requirementService.getAll();
        request.setAttribute("requirements", allRequirements);

        UserService userService = new UserService();
        List<User> users = userService.getAll();
        request.setAttribute("users", users);
        request.setAttribute("userService", userService);
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        List<Issue> list = (List<Issue>) request.getSession().getAttribute("issueList");

        baseService.sortListByField(list, fieldName, order);
        request.getSession().setAttribute("issueList", list);
        request.getSession().setAttribute("sortFieldName", fieldName);
        request.getSession().setAttribute("sortOrder", order);

        pagination(request, response, list);
    }

    private void postAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            // Get end date if provided, otherwise it will be null
            String endDateStr = request.getParameter("endDate");
            Date endDate = null;
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                endDate = Date.valueOf(endDateStr);
            }

            Issue issue = Issue.builder()
                    .requirementId(Integer.parseInt(request.getParameter("requirementId")))
                    .projectId(Integer.parseInt(request.getParameter("projectId")))
                    .title(request.getParameter("title"))
                    .description(request.getParameter("description"))
                    .type(request.getParameter("type"))
                    .assignee_id(Integer.parseInt(request.getParameter("assigneeId")))
                    .status(Integer.parseInt(request.getParameter("status")))
                    .due_date(Date.valueOf(request.getParameter("dueDate")))
                    .end_date(endDate)
                    .build();

            issueService.insertIssue(issue);

            List<Issue> list = refreshList(request);
            request.setAttribute("successMess", "Add successful");
            request.setAttribute("userService", userService);
            doGet(request, response);
        } catch (SQLException | NumberFormatException ex) {
            request.setAttribute("AddErrorMess", ex.getMessage());
            request.setAttribute("isAdd", "true");
            List<Issue> list = (List<Issue>) request.getSession().getAttribute("issueList");
            doGet(request, response);
        }
    }

    private void postUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            // Get end date if provided, otherwise it will be null
            String endDateStr = request.getParameter("endDate");
            Date endDate = null;
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                endDate = Date.valueOf(endDateStr);
            }
            Issue issue = Issue.builder()
                    .id(Integer.parseInt(request.getParameter("id")))
                    .title(request.getParameter("title"))
                    .description(request.getParameter("description"))
                    .type(request.getParameter("type"))
                    .assignee_id(Integer.parseInt(request.getParameter("assigneeId")))
                    .status(Integer.parseInt(request.getParameter("status")))
                    .due_date(Date.valueOf(request.getParameter("dueDate")))
                    .end_date(endDate)
                    .build();

            issueService.updateIssue(issue);

            List<Issue> list = refreshList(request);
            request.setAttribute("successMess", "Update successful");
            request.setAttribute("userService", userService);
            doGet(request, response);
        } catch (SQLException | NumberFormatException ex) {
            request.setAttribute("UpdateErrorMess", ex.getMessage());
            request.setAttribute("isUpdate", "true");
            List<Issue> list = (List<Issue>) request.getSession().getAttribute("issueList");
            doGet(request, response);
        }
    }

    private List<Issue> refreshList(HttpServletRequest request) throws SQLException {
        HttpSession session = request.getSession();
        String searchKey = (String) session.getAttribute("searchKey");
        Integer projectFilter = (Integer) session.getAttribute("projectFilter");
        Integer statusFilter = (Integer) session.getAttribute("statusFilter");
        String typeFilter = (String) session.getAttribute("typeFilter");
        String fieldName = (String) session.getAttribute("sortFieldName");
        String order = (String) session.getAttribute("sortOrder");

        List<Issue> list = issueService.searchAdvanced(
                searchKey, projectFilter, typeFilter, null, statusFilter, null, null);

        if (fieldName != null && order != null) {
            baseService.sortListByField(list, fieldName, order);
        }
        session.setAttribute("issueList", list);
        request.setAttribute("userService", userService);
        return list;
    }

    private void handleGetRequirements(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        try {
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            List<Requirement> requirements = requirementService.getAllByProjectId(projectId);

            // Create JSON response manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < requirements.size(); i++) {
                Requirement req = requirements.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{")
                        .append("\"id\":").append(req.getId()).append(",")
                        .append("\"title\":\"").append(req.getTitle().replace("\"", "\\\"")).append("\"")
                        .append("}");
            }
            json.append("]");

            // Send response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid project ID");
        }
    }

    private void handleGetAssignees(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        try {
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            List<User> assignees = userService.getUsersByProjectId(projectId);

            // Create JSON response manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < assignees.size(); i++) {
                User user = assignees.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{")
                        .append("\"id\":").append(user.getId()).append(",")
                        .append("\"fullname\":\"").append(user.getFullname().replace("\"", "\\\"")).append("\"")
                        .append("}");
            }
            json.append("]");

            // Send response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid project ID");
        }
    }

    public Integer TryParseInt(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

}
