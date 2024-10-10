/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.util.Comparator;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import model.Group;
import model.User;
import service.UserService;

/**
 *
 * @author DELL
 */
@WebServlet(name = "AdminController", urlPatterns = {"/admin/userlist", "/admin/userdetail"})
public class AdminController extends HttpServlet {

    private UserService uService = new UserService();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath().substring("/admin/".length());

        switch (action) {
            case "userlist" -> {
                List<User> list = null;
                HttpSession session = request.getSession(false);

                // Fetch the list from session or database
                if (session != null && session.getAttribute("listUser") != null) {
                    list = (List<User>) session.getAttribute("listUser");
                    session.removeAttribute("listUser");
                } else {
                    try {
                        list = uService.getAll();

                    } catch (SQLException ex) {
                        Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
                        response.getWriter().print("Error retrieving user list: " + ex.getMessage());
                        return;
                    }

                }
                List<Group> departments = null;
                try {
                    departments = uService.getAllDepartments();
                } catch (SQLException ex) {
                    Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("departments", departments);

                // Sorting users by fullname
                String sortOrder = request.getParameter("sort");
                if ("asc".equals(sortOrder)) {
                    list.sort(Comparator.comparing(User::getFullname));
                } else if ("desc".equals(sortOrder)) {
                    list.sort(Comparator.comparing(User::getFullname).reversed());
                }

                // Call pagination logic to handle large user lists
                try {
                    pagination(request, response, list);
                } catch (SQLException ex) {
                    Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
                }

                // Set the list into the request attribute to forward to the JSP
                request.setAttribute("data", list);
                request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
            }


            case "userdetail" -> {

                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    User user = uService.getUserById(id); // Get user by ID
                    List<Group> departments = uService.getAllDepartments(); // Get departments list
                    request.setAttribute("updateUser", user);
                    request.setAttribute("departments", departments);
                    request.getRequestDispatcher("/WEB-INF/view/admin/UserDetails.jsp").forward(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
                    response.getWriter().print("SQL Error: " + ex.getMessage());
                }
            }

            default -> {

                response.getWriter().print("Invalid action");
            }
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        UserService dao = new UserService();

        try {
            switch (action) {
                case "search":

                    List<User> list = searchUser(request, response);
                    request.setAttribute("data", list);
                    request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);

                    break;

                case "add":
                    addUser(request, response, dao);

                    break;

                case "edit":

                    editUser(request, response, dao);

                    break;

                case "changeStatus":
                    changeStatus(request, response, dao);
                    break;

                default:

                    response.getWriter().print("Invalid action in POST request");
                    break;
            }
        } catch (ServletException | IOException | SQLException e) {
            Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, e);
            response.getWriter().print("Error: " + e.getMessage());

        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    public List<User> searchUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
    String departmentId = request.getParameter("departmentId");
    String status = request.getParameter("status");
    
    UserDAO dao = new UserDAO();
    List<User> listUser = new ArrayList<>(); // Khởi tạo danh sách rỗng

    if (keyword == null) keyword = ""; // Nếu từ khóa null, gán giá trị rỗng

    // Tìm kiếm người dùng theo từ khóa
    listUser = dao.findByName(keyword);

    // Nếu có departmentId hoặc status, lọc danh sách
    if (departmentId != null && !departmentId.isEmpty()) {
        listUser = listUser.stream()
            .filter(user -> String.valueOf(user.getDepartment().getId()).equals(departmentId))
            .collect(Collectors.toList());
    }

    if (status != null && !status.isEmpty()) {
        int statusValue = Integer.parseInt(status); // Chuyển đổi status sang số nguyên
        listUser = listUser.stream()
            .filter(user -> user.getStatus() == statusValue)
            .collect(Collectors.toList());
    }

    return listUser; // Trả về danh sách người dùng đã lọc
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response, UserService dao) throws SQLException, ServletException, IOException {
        // Lấy dữ liệu từ request
        String fullname = request.getParameter("fullname");
        String mobile = request.getParameter("mobile");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        String address = request.getParameter("address");
        int role = Integer.parseInt(request.getParameter("role"));
        int status = Integer.parseInt(request.getParameter("status"));
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            if (uService.isMobileExistss(mobile)) {
                // Nếu số điện thoại đã tồn tại, gửi thông báo lỗi
                request.setAttribute("error", "Mobile number already exists.");
                // Điều hướng tới trang thêm người dùng (có thể là trang UserList.jsp hoặc trang AddUser.jsp)
                request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
                return; // Dừng lại nếu mobile trùng
            }
            if (uService.isEmailExists(email)) {
                request.setAttribute("error", "Mobile number already exists.");
                // Điều hướng tới trang thêm người dùng (có thể là trang UserList.jsp hoặc trang AddUser.jsp)
                request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
                return; // Dừng lại nếu mobile trùng
            }
            User uNew = new User();
            uNew.setEmail(email);
            uNew.setMobile(mobile);
            uNew.setFullname(fullname);
            uNew.setAddress(address);
            uNew.setPassword(password);
            uNew.setRole(role);
            uNew.setStatus(status);
            Group g = new Group();
            g.setId(departmentId);
            uNew.setDepartment(g);
            uService.addUser(uNew);
            List<User> updatedList = uService.getAll();
            pagination(request, response, updatedList);

        } catch (SQLException e) {
//            // Xử lý ngoại lệ khi id không hợp lệ hoặc xảy ra lỗi khác
//            request.setAttribute("error", "Invalid ID or other input errors.");
//            // Điều hướng tới trang UserList với thông báo lỗi
//            request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
            response.getWriter().print(e);
        }

    }

    private void editUser(HttpServletRequest request, HttpServletResponse response, UserService dao) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String mobile = request.getParameter("mobile");
            String email = request.getParameter("email");
            String fullname = request.getParameter("fullname");
            String address = request.getParameter("address");
            int role = Integer.parseInt(request.getParameter("role"));

            String departmentIdParam = request.getParameter("departmentId");

            User user = new User();
            Group department = new Group();
            int departmentId = Integer.parseInt(departmentIdParam);
            department.setId(departmentId);

            // Set user details
            user.setId(id);
            user.setMobile(mobile);
            user.setEmail(email);
            user.setFullname(fullname);
            user.setRole(role);

            user.setAddress(address);
            user.setDepartment(department);

            // Update user
            uService.updateUser(user);
//
            response.sendRedirect(request.getContextPath() + "/admin/userlist");
        } catch (NumberFormatException e) {
            response.getWriter().print("Invalid number format: " + e.getMessage());

        } catch (IOException e) {
            Logger.getLogger(AdminController.class
                    .getName()).log(Level.SEVERE, null, e);
        }
    }

    public void pagination(HttpServletRequest request, HttpServletResponse response, List<?> list) throws ServletException, IOException, SQLException {
        try {
            int page, numperpage = 12;
            int size = list.size();
            int num = (size % numperpage == 0 ? (size / numperpage) : (size / numperpage) + 1); // số trang
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
            int start = (page - 1) * numperpage;
            int end = Math.min(page * numperpage, size);

            List<?> paginatedList = uService.getListByPages(list, start, end);

            request.setAttribute("page", page);
            request.setAttribute("num", num);
            request.getSession().setAttribute("numberPage", numperpage);

            request.setAttribute("data", paginatedList);
            request.setAttribute("deptList", uService.getAll());

            request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public static void main(String[] args) throws SQLException {
        List<User> list = new ArrayList<>();
        UserService u = new UserService();
        list = u.getAll();
        System.out.println(list.size());
    }

    public void changeStatus(HttpServletRequest request, HttpServletResponse response, UserService dao) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int status = Integer.parseInt(request.getParameter("status"));
            uService.updateUserStatus(id, status);
            response.sendRedirect(request.getContextPath() + "/admin/userlist");

        } catch (NumberFormatException e) {
            response.getWriter().print("Invalid number format: " + e.getMessage());

        }
    }
}
