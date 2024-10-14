/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Group;
import service.GroupService;

/**
 *
 * @author ASUS TUF
 */
@WebServlet(urlPatterns = {"/admin/domain"})
public class GroupController extends HttpServlet {

    private GroupService Domain = new GroupService();

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số action từ request
        String action = request.getParameter("action");

        // Nếu action bị null hoặc không hợp lệ, mặc định là "list"
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list" -> // Xử lý danh sách với phân trang
                    paginateList(request, response);

                case "filter" -> // Xử lý filter khi action là "filter"
                    paginateListWithFilter(request, response);
                case "detail" -> {
                    // Lấy id của domain từ request
                    int detailId = Integer.parseInt(request.getParameter("id"));

                    // Lấy thông tin chi tiết của domain với id
                    Group groupDetail = Domain.getGroupDetail(detailId);

                    // Đặt thông tin chi tiết vào request
                    request.setAttribute("groupDetail", groupDetail);

                    // Điều hướng đến trang hiển thị chi tiết
                    request.getRequestDispatcher("/WEB-INF/view/admin/DomainDetail.jsp").forward(request, response);
                }

                case "edit" -> {
                    // Lấy id của nhóm từ request
                    int editId = Integer.parseInt(request.getParameter("id"));

                    // Lấy thông tin chi tiết của nhóm
                    Group detailEdit = Domain.getGroupDetail(editId);

                    // Đặt thông tin chi tiết vào request
                    request.setAttribute("groupDetail", detailEdit);

                    // Chuyển hướng đến trang chỉnh sửa
                    request.getRequestDispatcher("/WEB-INF/view/admin/EditDomain.jsp").forward(request, response);
                }

                case "add" -> // Điều hướng đến trang thêm mới
                    request.getRequestDispatcher("/WEB-INF/view/admin/AddDomain.jsp").forward(request, response);

                case "search" -> {
                    // Lấy từ khóa tìm kiếm từ request
                    String keyword = request.getParameter("keyword");

                    // Gọi phương thức search từ service để lấy danh sách domain theo từ khóa
                    List<Group> searchResults = Domain.searchDomain(keyword);

                    // Đặt danh sách domain tìm được vào request
                    request.setAttribute("listD", searchResults);

                    // Điều hướng đến trang danh sách domain
                    request.getRequestDispatcher("/WEB-INF/view/admin/Domain.jsp").forward(request, response);
                }
            }
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu tham số "id" không phải là số hợp lệ
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Domain ID");
        } catch (Exception e) {
            // Xử lý các lỗi khác
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Action parameter determines what operation to perform (add, update)
        String action = request.getParameter("action");
        switch (action) {
            case "update":
                // Lấy thông tin từ request
                int updateId = Integer.parseInt(request.getParameter("id"));
                String updateCode = request.getParameter("code");
                String updateName = request.getParameter("name");
                String updateDetails = request.getParameter("details");
                int updateStatus = Integer.parseInt(request.getParameter("status"));

                try {
                    // Kiểm tra xem các giá trị khác có null không, nếu null thì giữ nguyên giá trị cũ từ cơ sở dữ liệu
                    Group detailEdit = Domain.getGroupDetail(updateId);

                    if (updateCode == null || updateCode.isEmpty()) {
                        updateCode = detailEdit.getCode();  // Giữ nguyên code cũ
                    }

                    if (updateName == null || updateName.isEmpty()) {
                        updateName = detailEdit.getName();  // Giữ nguyên name cũ
                    }

                    if (updateDetails == null || updateDetails.isEmpty()) {
                        updateDetails = detailEdit.getDetails();  // Giữ nguyên details cũ
                    }

                    // Gọi phương thức cập nhật
                    Domain.updateGroup(updateId, updateCode, updateName, updateDetails, updateStatus);

                    // Cập nhật lại danh sách với phân trang
                    paginateList(request, response);
                } catch (IllegalArgumentException e) {
                    // Lưu trữ thông báo lỗi vào request
                    request.setAttribute("errorMessage", e.getMessage());

                    // Lấy lại thông tin chi tiết của nhóm để hiển thị lại form
                    Group detailEdit = Domain.getGroupDetail(updateId);
                    
                    request.setAttribute("groupDetail", detailEdit);

                    // Chuyển hướng về trang chỉnh sửa
                    request.getRequestDispatcher("/WEB-INF/view/admin/EditDomain.jsp").forward(request, response);
                }
                break;

            case "add":
                // Lấy thông tin từ request
                String addCode = request.getParameter("code");
                String addName = request.getParameter("name");
                String addDetails = request.getParameter("details");
                int addStatus = Integer.parseInt(request.getParameter("status"));

                try {
                    // Gọi phương thức thêm domain mới
                    Domain.addGroup(addCode, addName, addDetails, addStatus);
                    // Cập nhật lại danh sách sau khi thêm với phân trang
                    paginateList(request, response);
                } catch (IllegalArgumentException e) {
                    // Bắt lỗi và chuyển hướng đến trang thêm nhóm với thông báo lỗi
                    request.setAttribute("errorMessage", e.getMessage());
                    request.getRequestDispatcher("/WEB-INF/view/admin/AddDomain.jsp").forward(request, response);
                }
                break;
        }
    }

    private void paginateList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy số trang hiện tại từ request, nếu không có thì mặc định là trang 1
        int pageNumber = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            pageNumber = Integer.parseInt(pageParam);
        }

        // Định nghĩa số lượng domain trên mỗi trang 
        int pageSize = 6;

        // Gọi phương thức service để lấy danh sách domain có phân trang
        List<Group> listD = Domain.getAllGroups(pageNumber, pageSize);

        // Đặt list domain vào request
        request.setAttribute("listD", listD);

        // Đặt số trang hiện tại vào request để xử lý giao diện phân trang
        request.setAttribute("currentPage", pageNumber);

        // Điều hướng về trang danh sách domain
        request.getRequestDispatcher("/WEB-INF/view/admin/Domain.jsp").forward(request, response);
    }

    private void paginateListWithFilter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy số trang hiện tại từ request, nếu không có thì mặc định là trang 1
        int pageNumber = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            pageNumber = Integer.parseInt(pageParam);
        }

        // Định nghĩa số lượng domain trên mỗi trang
        int pageSize = 6;

        // Lấy các giá trị filter từ request
        String filterName = request.getParameter("name");
        String filterCode = request.getParameter("code");
        String filterStatusParam = request.getParameter("status");
        Integer filterStatus = (filterStatusParam != null && !filterStatusParam.isEmpty()) ? Integer.parseInt(filterStatusParam) : null;

        // Gọi service để lấy danh sách domain đã filter
        List<Group> filteredList = Domain.filterGroups(pageNumber, pageSize, filterName, filterCode, filterStatus);

        // Đặt danh sách domain vào request
        request.setAttribute("listD", filteredList);

        // Đặt thông tin filter lại request để hiển thị lại trong form
        request.setAttribute("filterName", filterName);
        request.setAttribute("filterCode", filterCode);
        request.setAttribute("filterStatus", filterStatus);

        // Đặt số trang hiện tại vào request để xử lý phân trang
        request.setAttribute("currentPage", pageNumber);

        // Điều hướng đến trang danh sách domain
        request.getRequestDispatcher("/WEB-INF/view/admin/Domain.jsp").forward(request, response);
    }

}
