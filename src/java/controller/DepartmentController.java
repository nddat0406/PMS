package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Group;
import service.GroupService;

@WebServlet(
        name = "DepartmentController",
        urlPatterns = {"/admin/department"}
)

public class DepartmentController extends HttpServlet {

    private GroupService departmentService = new GroupService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    paginateList(request, response);
                    break;
                case "add":
                    handleAdd(request, response);
                    break;
            }
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid Department ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            switch (action) {
                case "update":
                    handleUpdate(request, response);
                    break;
                case "add":
                    handleAddDepartment(request, response);
                    break;
                case "filter":
                    paginateListWithFilter(request, response);
                    break;
                case "edit":
                    handleEdit(request, response);
                    break;
                case "search":
                    handleSearch(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int editId = Integer.parseInt(request.getParameter("id"));
        Group departmentToEdit = departmentService.getDepartmentDetail(editId);
        List<Group> parentDepartments = departmentService.getAllDepartment();

        request.setAttribute("departmentDetail", departmentToEdit);
        request.setAttribute("listParentDepartments", parentDepartments);
        request.getRequestDispatcher("/WEB-INF/view/admin/EditDepartment.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Group> parentDepartments = departmentService.getAllDepartment();
            request.setAttribute("listParentDepartments", parentDepartments);
            request.getRequestDispatcher("/WEB-INF/view/admin/AddDepartment.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(DepartmentController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");

        // Nếu từ khóa tìm kiếm trống hoặc không có
        if (keyword == null || keyword.trim().isEmpty()) {
            // Sử dụng logic phân trang mặc định
            paginateList(request, response);
            return;
        }

        // Nếu có từ khóa tìm kiếm, tiến hành tìm kiếm
        List<Group> searchResults = departmentService.searchDepartments(keyword);
        request.setAttribute("listD", searchResults);
        request.getRequestDispatcher("/WEB-INF/view/admin/Department.jsp").forward(request, response);
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int updateId = Integer.parseInt(request.getParameter("id"));

        // Các trường từ form (có thể null nếu không gửi từ form)
        String updateCode = request.getParameter("code");
        String updateName = request.getParameter("name");
        String updateDetails = request.getParameter("details");

        // Lấy trạng thái từ form (phải luôn có)
        int updateStatus = Integer.parseInt(request.getParameter("status"));

        // Lấy thông tin phòng ban cha (parent_department), có thể null
        Integer updateParentId = getParentId(request, "parent_department");

        // Lấy thông tin cũ nếu một số trường không được gửi từ form
        Group existingDepartment = departmentService.getDepartmentDetail(updateId);

        // Nếu các trường `code`, `name`, hoặc `details` không được gửi từ form, giữ nguyên giá trị cũ
        if (updateCode == null || updateCode.isEmpty()) {
            updateCode = existingDepartment.getCode();
        }

        if (updateName == null || updateName.isEmpty()) {
            updateName = existingDepartment.getName();
        }

        if (updateDetails == null || updateDetails.isEmpty()) {
            updateDetails = existingDepartment.getDetails();
        }

        try {
            // Gọi phương thức cập nhật
            departmentService.updateDepartment(updateId, updateCode, updateName, updateDetails, updateParentId, updateStatus);

            // Chuyển hướng đến danh sách department sau khi cập nhật thành công
            response.sendRedirect(request.getContextPath() + "/admin/department");
        } catch (IllegalArgumentException e) {
            handleUpdateError(request, response, updateId, e.getMessage());
        }
    }

    private void handleAddDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String addCode = request.getParameter("code");
        String addName = request.getParameter("name");
        String addDetails = request.getParameter("details");
        String statusParam = request.getParameter("status");
        int addStatus = (statusParam != null && !statusParam.isEmpty()) ? Integer.parseInt(statusParam) : 0; // Mặc định là 0 nếu không có giá trị

        // Lấy giá trị parent department (có thể là null)
        Integer addParent = getParentId(request, "parent_department");

        try {
            // Thêm department mới
            departmentService.addDepartment(addCode, addName, addDetails, addParent, addStatus);

            response.sendRedirect(request.getContextPath() + "/admin/department?action=list");

        } catch (IllegalArgumentException e) {
            // Lưu thông tin vào session để điền lại form nếu có lỗi
            request.getSession().setAttribute("errorMessage", e.getMessage());
            request.getSession().setAttribute("code", addCode);
            request.getSession().setAttribute("name", addName);
            request.getSession().setAttribute("details", addDetails);
            request.getSession().setAttribute("status", addStatus);
            request.getSession().setAttribute("parent_department", addParent);
            request.getRequestDispatcher("/WEB-INF/view/admin/AddDepartment.jsp").forward(request, response);
        }
    }

    private Integer getParentId(HttpServletRequest request, String paramName) {
        String parentParam = request.getParameter(paramName);
        return (parentParam != null && !parentParam.isEmpty()) ? Integer.parseInt(parentParam) : null;
    }

    private void handleUpdateError(HttpServletRequest request, HttpServletResponse response, int updateId, String errorMessage) throws ServletException, IOException, SQLException {
        request.setAttribute("errorMessage", errorMessage);
        Group departmentToEdit = departmentService.getDepartmentDetail(updateId);
        request.setAttribute("departmentDetail", departmentToEdit);
        List<Group> parentDepartments = departmentService.getAllDepartment();
        request.setAttribute("listParentDepartments", parentDepartments);
        request.getRequestDispatcher("/WEB-INF/view/admin/EditDepartment.jsp").forward(request, response);
    }

    private void paginateList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pageNumber = getPageNumber(request);
        int pageSize = 6;

        Integer filterStatus = getFilterStatus(request); // Sử dụng filterStatus nếu có

        List<Group> listD;
        if (filterStatus != null) {
            listD = departmentService.filterDepartments(pageNumber, pageSize, filterStatus);
        } else {
            listD = departmentService.getDepartmentsByPage(pageNumber, pageSize);
        }

        request.setAttribute("listD", listD);
        request.setAttribute("currentPage", pageNumber);
        request.setAttribute("filterStatus", filterStatus); // Đặt filterStatus vào attribute để duy trì trạng thái lọc
        request.getRequestDispatcher("/WEB-INF/view/admin/Department.jsp").forward(request, response);
    }

    private void paginateListWithFilter(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pageNumber = getPageNumber(request);
        int pageSize = 6;

        Integer filterStatus = getFilterStatus(request); // Lấy filterStatus từ request

        List<Group> filteredList = departmentService.filterDepartments(pageNumber, pageSize, filterStatus);
        request.setAttribute("listD", filteredList);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("currentPage", pageNumber);
        request.getRequestDispatcher("/WEB-INF/view/admin/Department.jsp").forward(request, response);
    }

    private int getPageNumber(HttpServletRequest request) {
        String pageParam = request.getParameter("page");
        int pageNumber = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        return (pageNumber < 1) ? 1 : pageNumber; // Đảm bảo pageNumber tối thiểu là 1
    }

    private Integer getFilterStatus(HttpServletRequest request) {
        String filterStatusParam = request.getParameter("status");
        return (filterStatusParam != null && !filterStatusParam.isEmpty()) ? Integer.parseInt(filterStatusParam) : null;
    }
}
