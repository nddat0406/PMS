package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Group;
import service.GroupService;

@WebServlet(urlPatterns = {"/admin/domain"})
public class GroupController extends HttpServlet {

    private GroupService Domain = new GroupService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list" ->
                    paginateList(request, response);
                case "filter" ->
                    paginateListWithFilter(request, response);
                case "detail" ->
                    handleDetail(request, response);
                case "edit" ->
                    handleEdit(request, response);
                case "add" ->
                    request.getRequestDispatcher("/WEB-INF/view/admin/AddDomain.jsp").forward(request, response);
                case "search" ->
                    handleSearch(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Domain ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "update" ->
                    handleUpdate(request, response);
                case "add" ->
                    handleAdd(request, response);
                default ->
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    private void paginateList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNumber = getPageNumber(request);
        int pageSize = 6;
        Integer filterStatus = getFilterStatus(request);
        List<Group> listD;
        if (filterStatus != null) {
            listD = Domain.filterDepartments(pageNumber, pageSize, filterStatus);
        } else {
            listD = Domain.getAllGroups(pageNumber, pageSize);
        }

        request.setAttribute("listD", listD);
        request.setAttribute("currentPage", pageNumber);
        request.setAttribute("filterStatus", filterStatus);
        request.getRequestDispatcher("/WEB-INF/view/admin/Domain.jsp").forward(request, response);
    }

    private void paginateListWithFilter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNumber = getPageNumber(request);
        int pageSize = 6;
        String filterStatusParam = request.getParameter("status");
        Integer filterStatus = (filterStatusParam != null && !filterStatusParam.isEmpty()) ? Integer.parseInt(filterStatusParam) : null;

        List<Group> filteredList = Domain.filterGroups(pageNumber, pageSize, filterStatus);

        request.setAttribute("listD", filteredList);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("currentPage", pageNumber);
        request.getRequestDispatcher("/WEB-INF/view/admin/Domain.jsp").forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int detailId = Integer.parseInt(request.getParameter("id"));
        Group groupDetail = Domain.getGroupDetail(detailId);
        request.setAttribute("groupDetail", groupDetail);
        request.getRequestDispatcher("/WEB-INF/view/admin/DomainDetail.jsp").forward(request, response);
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int editId = Integer.parseInt(request.getParameter("id"));
        Group detailEdit = Domain.getGroupDetail(editId);
        request.setAttribute("groupDetail", detailEdit);
        request.getRequestDispatcher("/WEB-INF/view/admin/EditDomain.jsp").forward(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Group> searchResults = Domain.searchDomain(keyword);
        request.setAttribute("listD", searchResults);
        request.getRequestDispatcher("/WEB-INF/view/admin/Domain.jsp").forward(request, response);
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int updateId = Integer.parseInt(request.getParameter("id"));
        String updateCode = request.getParameter("code");
        String updateName = request.getParameter("name");
        String updateDetails = request.getParameter("details");
        int updateStatus = Integer.parseInt(request.getParameter("status"));

        Group detailEdit = Domain.getGroupDetail(updateId);
        if (updateCode == null || updateCode.isEmpty()) {
            updateCode = detailEdit.getCode();
        }
        if (updateName == null || updateName.isEmpty()) {
            updateName = detailEdit.getName();
        }
        if (updateDetails == null || updateDetails.isEmpty()) {
            updateDetails = detailEdit.getDetails();
        }

        Domain.updateGroup(updateId, updateCode, updateName, updateDetails, updateStatus);
        // Chuyển hướng về danh sách không áp dụng bộ lọc
        response.sendRedirect(request.getContextPath() + "/admin/domain");
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String addCode = request.getParameter("code");
        String addName = request.getParameter("name");
        String addDetails = request.getParameter("details");
        int addStatus = Integer.parseInt(request.getParameter("status"));

        Domain.addGroup(addCode, addName, addDetails, addStatus);
        paginateList(request, response);
    }

    private int getPageNumber(HttpServletRequest request) {
        String pageParam = request.getParameter("page");
        return (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    }

    private Integer getFilterStatus(HttpServletRequest request) {
        String filterStatusParam = request.getParameter("status");
        return (filterStatusParam != null && !filterStatusParam.isEmpty()) ? Integer.parseInt(filterStatusParam) : null;
    }
}
