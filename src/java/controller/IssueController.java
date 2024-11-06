/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Issue;
import service.BaseService;
import service.IssueService;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "IssueController", urlPatterns = {"/issue"})
public class IssueController extends HttpServlet {

    private final IssueService issueService = new IssueService();
    private final BaseService baseService = new BaseService();
    private final String ISSUE_PAGE = "/WEB-INF/view/user/issues/issue-manage.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

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
                    "Open", "To Do", "Doing", "Done", "Closed"
                ));
                
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
                case "filter" -> postFilter(request, response);
                case "sort" -> postSort(request, response);
                case "add" -> postAdd(request, response);
                case "update" -> postUpdate(request, response);
                default -> doGet(request, response);
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
        String projectFilterRaw = request.getParameter("projectFilter");
        String statusFilterRaw = request.getParameter("statusFilter");
        String typeFilter = request.getParameter("typeFilter");
        String searchKey = request.getParameter("searchKey");

        int projectFilter = baseService.TryParseInt(projectFilterRaw);
        int statusFilter = baseService.TryParseInt(statusFilterRaw);

        HttpSession session = request.getSession();
        List<Issue> list = issueService.searchAdvanced(
            searchKey, projectFilter, typeFilter, null, statusFilter, null, null
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

    private void postAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            Issue issue = Issue.builder()
                    .requirementId(Integer.parseInt(request.getParameter("requirementId")))
                    .projectId(Integer.parseInt(request.getParameter("projectId")))
                    .title(request.getParameter("title"))
                    .description(request.getParameter("description"))
                    .type(request.getParameter("type"))
                    .assignee_id(Integer.parseInt(request.getParameter("assigneeId")))
                    .status(Integer.parseInt(request.getParameter("status")))
                    .due_date(Date.valueOf(request.getParameter("dueDate")))
                    .end_date(Date.valueOf(request.getParameter("endDate")))
                    .build();

            issueService.insertIssue(issue);

            List<Issue> list = refreshList(request);
            request.setAttribute("successMess", "Add successful");
            pagination(request, response, list);
        } catch (SQLException | NumberFormatException ex) {
            request.setAttribute("AddErrorMess", ex.getMessage());
            request.setAttribute("isAdd", "true");
            List<Issue> list = (List<Issue>) request.getSession().getAttribute("issueList");
            pagination(request, response, list);
        }
    }

    private void postUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            Issue issue = Issue.builder()
                    .id(Integer.parseInt(request.getParameter("id")))
                    .title(request.getParameter("title"))
                    .description(request.getParameter("description"))
                    .type(request.getParameter("type"))
                    .assignee_id(Integer.parseInt(request.getParameter("assigneeId")))
                    .status(Integer.parseInt(request.getParameter("status")))
                    .due_date(Date.valueOf(request.getParameter("dueDate")))
                    .end_date(Date.valueOf(request.getParameter("endDate")))
                    .build();

            issueService.updateIssue(issue);

            List<Issue> list = refreshList(request);
            request.setAttribute("successMess", "Update successful");
            pagination(request, response, list);
        } catch (SQLException | NumberFormatException ex) {
            request.setAttribute("UpdateErrorMess", ex.getMessage());
            request.setAttribute("isUpdate", "true");
            List<Issue> list = (List<Issue>) request.getSession().getAttribute("issueList");
            pagination(request, response, list);
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
            searchKey, projectFilter, typeFilter, null, statusFilter, null, null
        );

        if (fieldName != null && order != null) {
            baseService.sortListByField(list, fieldName, order);
        }
        session.setAttribute("issueList", list);
        return list;
    }
}
