package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import model.Requirement;
import model.User;
import service.RequirementService;
import service.BaseService;
import service.ProjectService;

@WebServlet(name = "UserRequirementsServlet", urlPatterns = {"/user-requirements"})
public class UserRequirementsServlet extends HttpServlet {

    private final RequirementService requirementService = new RequirementService();
    private final ProjectService projectService = new ProjectService();
    private final BaseService baseService = new BaseService();
    private final String USER_REQUIREMENTS_PAGE = "/WEB-INF/view/user/requirement/user-requirements.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User account = (User) session.getAttribute("loginedUser");
            int userId = account.getId();

            // Add projectService to request attributes
            request.setAttribute("projectService", projectService);

            // First time loading the page - clear existing filters
            if (request.getParameter("page") == null) {
                session.removeAttribute("searchKey");
                session.removeAttribute("complexityFilter");
                session.removeAttribute("projectFilter");
                session.removeAttribute("statusFilter");
                session.removeAttribute("sortFieldName");
                session.removeAttribute("sortOrder");

                List<Requirement> list = requirementService.getRequirementsByFilter(null, null, null, null);
                // Filter for only requirements assigned to this user
                list = list.stream()
                        .filter(req -> req.getUserId() == userId)
                        .toList();

                session.setAttribute("requirementList", list);
                pagination(request, response, list);
            } else {
                // Handle pagination for filtered results
                List<Requirement> list = (List<Requirement>) session.getAttribute("requirementList");
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
                default ->
                    doGet(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void pagination(HttpServletRequest request, HttpServletResponse response, List<?> list)
            throws ServletException, IOException {
        // Add projectService to request attributes
        request.setAttribute("projectService", projectService);
        // Get values from session and set to request
        HttpSession session = request.getSession();
        request.setAttribute("searchKey", session.getAttribute("searchKey"));
        request.setAttribute("complexityFilter", session.getAttribute("complexityFilter"));
        request.setAttribute("projectFilter", session.getAttribute("projectFilter"));
        request.setAttribute("statusFilter", session.getAttribute("statusFilter"));
        int page, numperpage = 12;
        int size = list.size();
        int num = (size % numperpage == 0 ? (size / numperpage) : (size / numperpage) + 1);
        if (num == 0) {
            num = 1;
        }
        String xpage = request.getParameter("page");
        if (xpage == null) {
            page = 1;
        } else {
            page = Integer.parseInt(xpage);
            if (page > num) {
                page = num;
            }
        }
        int start, end;
        start = (page - 1) * numperpage;
        end = Math.min(page * numperpage, size);
        request.setAttribute("page", page);
        request.setAttribute("num", num);
        request.getSession().setAttribute("numberPage", numperpage);
        request.setAttribute("tableData", baseService.getListByPage(list, start, end));
        request.getRequestDispatcher(USER_REQUIREMENTS_PAGE).forward(request, response);
    }

    private void postFilter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("loginedUser");
        int userId = account.getId();

// Add projectService to request attributes
        request.setAttribute("projectService", projectService);

        String complexityFilter = request.getParameter("complexityFilter");
        String projectFilterRaw = request.getParameter("projectFilter");
        String statusFilterRaw = request.getParameter("statusFilter");
        String searchKey = request.getParameter("searchKey");

// Convert project filter to Integer instead of int to allow null
        Integer projectFilter = null;
        if (projectFilterRaw != null && !projectFilterRaw.equals("0")) {
            projectFilter = Integer.parseInt(projectFilterRaw);
        }

// Convert status filter to Integer, handling -1 as null
        Integer statusFilter = null;
        if (statusFilterRaw != null) {
            int statusValue = Integer.parseInt(statusFilterRaw);
            if (statusValue != -1) { // Only set if not "All Status"
                statusFilter = statusValue;
            }
        }

        List<Requirement> list = requirementService.getRequirementsByFilter(complexityFilter, projectFilter,
                statusFilter, searchKey);

// Filter for only requirements assigned to this user
        list = list.stream()
                .filter(req -> req.getUserId() == userId)
                .toList();

// Set attributes in both session and request
        session.setAttribute("searchKey", searchKey);
        session.setAttribute("complexityFilter", complexityFilter);
        session.setAttribute("projectFilter", projectFilter);
        session.setAttribute("statusFilter", statusFilterRaw); // Store the raw value including -1
        session.setAttribute("requirementList", list);

// Also set in request for immediate use in JSP
        request.setAttribute("searchKey", searchKey);
        request.setAttribute("complexityFilter", complexityFilter);
        request.setAttribute("projectFilter", projectFilter);
        request.setAttribute("statusFilter", Integer.parseInt(statusFilterRaw)); // Convert to int for JSP comparison

        pagination(request, response, list);
    }

    private void postSort(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        List<Requirement> list = (List<Requirement>) request.getSession().getAttribute("requirementList");
        baseService.sortListByField(list, fieldName, order);
        request.getSession().setAttribute("requirementList", list);
        request.getSession().setAttribute("sortFieldName", fieldName);
        request.getSession().setAttribute("sortOrder", order);
        pagination(request, response, list);
    }
}
