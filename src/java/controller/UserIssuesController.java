package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Allocation;
import model.Issue;
import model.Project;
import model.User;
import service.BaseService;
import service.IssueService;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import java.util.List;
import service.ProjectService;

@WebServlet(name = "UserIssuesController", urlPatterns = {"/user-issues"})
public class UserIssuesController extends HttpServlet {

    private final IssueService issueService = new IssueService();
    private final BaseService baseService = new BaseService();
    private final String USER_ISSUES_PAGE = "/WEB-INF/view/user/issues/user-issues.jsp";
    private final ProjectService projectService = new ProjectService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User loginedUser = (User) session.getAttribute("loginedUser");

            // Redirect to login if user not logged in
            if (loginedUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get all projects associated with the user
            List<Allocation> userAllocations = projectService.getByUser(loginedUser.getId(), loginedUser.getRole());
            List<Project> userProjects = projectService.getProjectsInAllocation(userAllocations);
            request.setAttribute("projects", userProjects);

            if (request.getParameter("page") == null) {
                // Clear existing filters
                session.removeAttribute("searchKey");
                session.removeAttribute("projectFilter");
                session.removeAttribute("statusFilter");
                session.removeAttribute("typeFilter");
                session.removeAttribute("sortFieldName");
                session.removeAttribute("sortOrder");

                // Get issues for logged in user
                List<Issue> list = issueService.getIssuesByUserId(loginedUser.getId());
                session.setAttribute("issueList", list);

                // Add type and status lists for dropdowns
                request.setAttribute("typeList", issueService.getAllTypes());
                request.setAttribute("statusList", List.of(
                        "Open", "To Do", "Doing", "Done", "Closed"
                ));

                pagination(request, response, list);
            } else {
                List<Issue> list = (List<Issue>) session.getAttribute("issueList");
                String modalItemIDRaw = request.getParameter("modalItemID");
                if (modalItemIDRaw != null) {
                    int modalItemID = Integer.parseInt(modalItemIDRaw);
                    Issue issue = issueService.getIssueById(modalItemID);
                    // Only show issue details if it belongs to the logged-in user
                    if (issue != null && issue.getAssignee_id() == loginedUser.getId()) {
                        request.setAttribute("modalItem", issue);
                    }
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
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");

        // Redirect to login if user not logged in
        if (loginedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            doGet(request, response);
            return;
        }

        try {
            switch (action) {
                case "filter" ->
                    postFilter(request, response, loginedUser.getId());
                case "sort" ->
                    postSort(request, response);
                case "update" ->
                    postUpdate(request, response, loginedUser.getId());
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
        request.getRequestDispatcher(USER_ISSUES_PAGE).forward(request, response);
    }

    private void postFilter(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        // Get all projects associated with the user
        List<Allocation> userAllocations = projectService.getByUser(loginedUser.getId(), loginedUser.getRole());
        List<Project> userProjects = projectService.getProjectsInAllocation(userAllocations);
        request.setAttribute("projects", userProjects);
        String projectFilterRaw = request.getParameter("projectFilter");
        String statusFilterRaw = request.getParameter("statusFilter");
        String typeFilter = request.getParameter("typeFilter");
        String searchKey = request.getParameter("searchKey");

        int projectFilter = baseService.TryParseInt(projectFilterRaw);
        int statusFilter = baseService.TryParseInt(statusFilterRaw);

        // Include userId in search to ensure user only sees their issues
        List<Issue> list = issueService.searchAdvancedForUser(
                searchKey, projectFilter, typeFilter, statusFilter, userId
        );

        session.setAttribute("searchKey", searchKey);
        session.setAttribute("projectFilter", projectFilter);
        session.setAttribute("statusFilter", statusFilter);
        session.setAttribute("typeFilter", typeFilter);
        session.setAttribute("issueList", list);

        pagination(request, response, list);
    }

    private void postSort(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        List<Issue> list = (List<Issue>) request.getSession().getAttribute("issueList");

        baseService.sortListByField(list, fieldName, order);
        request.getSession().setAttribute("issueList", list);
        request.getSession().setAttribute("sortFieldName", fieldName);
        request.getSession().setAttribute("sortOrder", order);

        pagination(request, response, list);
    }

    private void postUpdate(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException, SQLException {
        try {
            int issueId = Integer.parseInt(request.getParameter("id"));
            // Verify issue belongs to user before updating
            Issue existingIssue = issueService.getIssueById(issueId);
            if (existingIssue == null || existingIssue.getAssignee_id() != userId) {
                throw new ServletException("Unauthorized access to issue");
            }

            Issue issue = Issue.builder()
                    .id(issueId)
                    .title(request.getParameter("title"))
                    .description(request.getParameter("description"))
                    .type(request.getParameter("type"))
                    .status(Integer.parseInt(request.getParameter("status")))
                    .due_date(Date.valueOf(request.getParameter("dueDate")))
                    .end_date(Date.valueOf(request.getParameter("endDate")))
                    .assignee_id(userId) // Ensure assignee remains the same
                    .build();

            issueService.updateIssue(issue);

            List<Issue> list = refreshList(request, userId);
            request.setAttribute("successMess", "Update successful");
            pagination(request, response, list);
        } catch (SQLException | NumberFormatException ex) {
            request.setAttribute("UpdateErrorMess", ex.getMessage());
            request.setAttribute("isUpdate", "true");
            List<Issue> list = (List<Issue>) request.getSession().getAttribute("issueList");
            pagination(request, response, list);
        }
    }

    private List<Issue> refreshList(HttpServletRequest request, int userId) throws SQLException {
        HttpSession session = request.getSession();
        String searchKey = (String) session.getAttribute("searchKey");
        Integer projectFilter = (Integer) session.getAttribute("projectFilter");
        Integer statusFilter = (Integer) session.getAttribute("statusFilter");
        String typeFilter = (String) session.getAttribute("typeFilter");
        String fieldName = (String) session.getAttribute("sortFieldName");
        String order = (String) session.getAttribute("sortOrder");

        List<Issue> list = issueService.searchAdvancedForUser(
                searchKey, projectFilter, typeFilter, statusFilter, userId
        );

        if (fieldName != null && order != null) {
            baseService.sortListByField(list, fieldName, order);
        }
        session.setAttribute("issueList", list);
        return list;
    }
}
