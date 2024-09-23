/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

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
                if (session != null && session.getAttribute("listUser") != null) {

                    list = (List<User>) session.getAttribute("listUser");
                    // Clear the session attribute to avoid stale data in future requests
                    session.removeAttribute("listUser");
                } else {
                    try {
                        // If no listUser in session, fetch from the database
                        list = uService.getAll();
                    } catch (SQLException ex) {
                        Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
                        response.getWriter().print("Error retrieving user list: " + ex.getMessage());
                        return;
                    }
                }
                request.setAttribute("data", list);
                // Forward to UserList.jsp
                request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
            }
            case "userdetail" -> {

                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    User user = uService.getUserById(id);
                    List<Group> departments = uService.getAllDepartments();
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
                    // Tìm kiếm người dùng
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

                case "delete":

                    deleteUser(request, response, dao);
                    request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
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
    private List<User> searchUser(HttpServletRequest request, HttpServletResponse response) throws SQLException {
        String keyword = request.getParameter("keyword");
        UserDAO dao = new UserDAO();
        List<User> listUser = new ArrayList<>(); // Khởi tạo danh sách rỗng

        if (keyword == null || keyword.trim().isEmpty()) {
            Logger.getLogger(AdminController.class.getName()).log(Level.INFO, "Keyword is empty or null.");
            return listUser;
        }

        listUser = dao.findByName(keyword); // Tìm kiếm người dùng theo từ khóa
        return listUser != null ? listUser : new ArrayList<>(); // Trả về danh sách rỗng nếu không tìm thấy user
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response, UserService dao) throws SQLException, ServletException, IOException {
        // Lấy dữ liệu từ request
        String fullname = request.getParameter("fullname");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        String address = request.getParameter("address");
        int role = Integer.parseInt(request.getParameter("role"));
        int status = Integer.parseInt(request.getParameter("status"));
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User uNew = new User();
            uNew.setEmail(email);
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
            request.setAttribute("data", updatedList);
            request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
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
            String fullname = request.getParameter("fullname");
            String address = request.getParameter("address");
            int role = Integer.parseInt(request.getParameter("role"));
            int status = Integer.parseInt(request.getParameter("status"));
            String departmentIdParam = request.getParameter("departmentId");
            
            User user = new User();
            Group department = new Group();
            int departmentId = Integer.parseInt(departmentIdParam);
            department.setId(departmentId);

            // Set user details
            user.setId(id);
            user.setFullname(fullname);
            user.setRole(role);
            user.setStatus(status);
            user.setAddress(address);
            user.setDepartment(department);
            
            // Update user
            uService.updateUser(user);
//
            response.sendRedirect(request.getContextPath() + "/admin/userlist");
        } catch (NumberFormatException e) {
            response.getWriter().print("Invalid number format: " + e.getMessage());
        } catch (IOException e) {
            Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, UserService dao) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.deleteUser(id);
        List<User> updatedListAfterDelete = dao.getAll();
        request.setAttribute("data", updatedListAfterDelete);
        request.getRequestDispatcher("/WEB-INF/view/admin/UserList.jsp").forward(request, response);
    }

}
