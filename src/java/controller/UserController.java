/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.SQLException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import model.Allocation;
import model.User;
import service.ProjectService;
import service.UserService;
import service.BaseService;
import service.GroupService;

/**
 *
 * @author HP
 */
@WebServlet(
        name = "UserController",
        urlPatterns = {"/user", "/user/profile", "/dashboard", "/user/changePass", "/user/changeEmail"})
@MultipartConfig
public class UserController extends HttpServlet {

    private UserService uService = new UserService();
    private ProjectService pService = new ProjectService();
    private GroupService gService = new GroupService();
    private BaseService baseService = new BaseService();

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
            out.println("<title>Servlet userController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet userController at " + request.getContextPath() + "</h1>");
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
        if (request.getServletPath().contains("dashboard")) {
            if (request.getParameter("page") != null) {
                try {
                    List<Allocation> list = (List<Allocation>) request.getSession().getAttribute("allocationList");
                    pagination(request, response, list, "/WEB-INF/view/Dashboard.jsp");
                } catch (SQLException ex) {
                    response.getWriter().print(ex);
                }
            } else {
                getDashboard(request, response);
            }
        } else {
            String action = request.getServletPath().substring("/user/".length());
            switch (action) {
                case "profile" -> {
                    getProfile(request, response);
                }
                case "login" -> {
                    request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
                }
                default ->
                    throw new AssertionError();
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
        if (request.getServletPath().contains("dashboard")) {
            String action = request.getParameter("action");
            if (action.equals("filter")) {
                postSearchAndFilter(request, response);
            } else if (action.equals("sort")) {
                postSort(request, response);
            }
        } else {
            String action = request.getServletPath().substring("/user/".length());
            switch (action) {
                case "profile" -> {
                    postProfile(request, response);
                }
                case "changeEmail" -> {
                    postChangeEmail(request, response);
                }
                case "changePass" -> {
                    postChangePass(request, response);
                }
                default ->
                    throw new AssertionError();
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    public void pagination(HttpServletRequest request, HttpServletResponse response, List<?> list, String link) throws ServletException, IOException, SQLException {
        int page, numperpage = 12;
        int size = list.size();
        int num = (size % numperpage == 0 ? (size / numperpage) : (size / numperpage) + 1);//so trang
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
        request.getRequestDispatcher(link).forward(request, response);
    }

    private void getDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        session.removeAttribute("deptFilter");
        session.removeAttribute("domainFilter");
        session.removeAttribute("statusFilter");
        session.removeAttribute("searchKey");
        session.removeAttribute("allocationList");
        try {
            int id = loginedUser.getId();
            int role = loginedUser.getRole();
            List<Allocation> list = pService.getByUser(id, role);
            session.setAttribute("listSize", list.size());
            session.setAttribute("assignedReq", uService.countAssignedReq(id));
            session.setAttribute("assignedIssue", uService.countAssignedIssue(id));
            session.setAttribute("avgEffort", uService.getAvgEffort(list));
            session.setAttribute("searchSize", list.size());
            session.setAttribute("allocationList", list);
            session.setAttribute("myProjectList", pService.getProjectsInAllocation(list));
            session.setAttribute("deptList", gService.getAllDepartment());
            session.setAttribute("domainList", gService.getAllDomains());
            pagination(request, response, list, "/WEB-INF/view/Dashboard.jsp");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void getProfile(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            HttpSession session = request.getSession();
            User loginedUser = (User) session.getAttribute("loginedUser");
            int id = loginedUser.getId();
            String profileChanged = request.getParameter("profileChanged");
            String passChanged = request.getParameter("passChanged");
            if (profileChanged != null) {
                request.setAttribute("successMess", "Profile Changed!");
            }
            if (passChanged != null) {
                request.setAttribute("passSuccessMess", "Password Changed!");
                request.setAttribute("passSuccessMesstext", " You will be redirect to login!");
            }
            request.setAttribute("profile", uService.getUserProfile(id));
            request.getRequestDispatcher("/WEB-INF/view/user/profile.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postChangePass(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String reNewPass = request.getParameter("reNewPass");
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        int id = loginedUser.getId();
        //check if repass equal newpass
        if (reNewPass.equals(newPass)) {
            try {
                uService.updatePassword(oldPass, newPass, id);
                request.setAttribute("profile", uService.getUserProfile(id));
                response.sendRedirect(request.getContextPath() + "/user/profile?passChanged=success");

            } catch (SQLException ex) {
                request.setAttribute("oldPass", oldPass);
                request.setAttribute("newPass", newPass);
                request.setAttribute("newRePass", reNewPass);
                request.setAttribute("errorPass", ex.getMessage());
                request.setAttribute("isSetting", "true");
                try {
                    request.setAttribute("profile", uService.getUserProfile(id));

                } catch (SQLException ex1) {
                    Logger.getLogger(UserController.class
                            .getName()).log(Level.SEVERE, null, ex1);
                }
                request.getRequestDispatcher("/WEB-INF/view/user/profile.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("oldPass", oldPass);
            request.setAttribute("newPass", newPass);
            request.setAttribute("newRePass", reNewPass);
            request.setAttribute("errorPass", "New password not match");
            request.setAttribute("isSetting", "true");
            try {
                request.setAttribute("profile", uService.getUserProfile(id));

            } catch (SQLException ex) {
                Logger.getLogger(UserController.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            request.getRequestDispatcher("/WEB-INF/view/user/profile.jsp").forward(request, response);
        }
    }

    private void postProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        int id = loginedUser.getId();
        String fullname = request.getParameter("fullname");
        String genderRaw = request.getParameter("gender");
        String address = request.getParameter("address");
        String mobile = request.getParameter("mobile");
        String birthdate = request.getParameter("birthdate");
        User user = new User();
        user.setId(id);
        user.setAddress(address);
        user.setFullname(fullname);
        user.setMobile(mobile);
        user.setGender(genderRaw.equals("male"));
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        try {
            user.setBirthdate(new Date(formatter.parse(birthdate).getTime()));
            Part part = request.getPart("image");
            user.setImage(request.getContextPath() + "/images/" + user.getId() + "_" + part.getSubmittedFileName());
            Map<String, String> errorMessages = uService.validateUpdateProfile(user, part);
            // Check if there are any validation errors
            if (!errorMessages.isEmpty()) {
                // Send error messages back to JSP
                request.setAttribute("oldInfor", user);
                request.setAttribute("error", errorMessages);
                request.setAttribute("profile", uService.getUserProfile(user.getId()));
                request.getRequestDispatcher("/WEB-INF/view/user/profile.jsp").forward(request, response);
            } else {
                uService.updateProfile(user, part);
                // Redirect to a profile page if everything is valid
                session.setAttribute("loginedUser", uService.getUserProfile(user.getId()));
                response.sendRedirect(request.getContextPath() + "/user/profile?profileChanged=success");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void postSearchAndFilter(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String deptFilterRaw = request.getParameter("deptFilter");
        String domainFilterRaw = request.getParameter("domainFilter");
        String statusFilterRaw = request.getParameter("statusFilter");
        String searchKey = request.getParameter("searchKey");
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");

        try {
            int id = loginedUser.getId();
            int role = loginedUser.getRole();
            int deptFilter = baseService.TryParseInt(deptFilterRaw);
            int domainFilter = baseService.TryParseInt(domainFilterRaw);
            int statusFilter = baseService.TryParseInt(statusFilterRaw);
            List<Allocation> list = pService.getByUser(id, role);
            request.setAttribute("listSize", list.size());
            list = pService.searchFilter(list, deptFilter, domainFilter, statusFilter, searchKey);
            session.setAttribute("deptFilter", deptFilter);
            session.setAttribute("domainFilter", domainFilter);
            session.setAttribute("statusFilter", statusFilter);
            session.setAttribute("searchKey", searchKey);
            session.setAttribute("allocationList", list);
            request.setAttribute("searchSize", list.size());
            pagination(request, response, list, "/WEB-INF/view/Dashboard.jsp");
        } catch (SQLException ex) {
            response.getWriter().print(ex.getMessage());
        }
    }

    private void postSort(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        List<Allocation> list = (List<Allocation>) request.getSession().getAttribute("allocationList");
        try {
            baseService.sortListByField(list, fieldName, order);
            request.getSession().setAttribute("allocationList", list);
            pagination(request, response, list, "/WEB-INF/view/Dashboard.jsp");

        } catch (SQLException e) {
            response.getWriter().print(e.getMessage());

        }

    }

    private void postChangeEmail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User user = (User) request.getSession().getAttribute("loginedUser");
        if (action.equals("sendOTP")) {
            String email = request.getParameter("email");
            try {
                if (uService.validateEmail(email, user.getId())) {
                    String otp = BaseService.getRandom();
                    uService.saveOtpId(user.getId(), otp);
                    BaseService.sendEmail(email,"Change Email Verify OTP","Here is OTP to verify your email: " + otp);
                    request.setAttribute("profile", uService.getUserProfile(user.getId()));
                    request.setAttribute("oldFilledEmail", email);
                    request.setAttribute("showOTPModal", "true");
                    request.getRequestDispatcher("/WEB-INF/view/user/profile.jsp").forward(request, response);
                }
            } catch (SQLException | MessagingException e) {
                try {
                    request.setAttribute("profile", uService.getUserProfile(user.getId()));
                } catch (SQLException ex) {
                    throw new ServletException(ex);
                }
                request.setAttribute("emailError", e.getMessage());
                request.setAttribute("oldFilledEmail", email);
                request.getRequestDispatcher("/WEB-INF/view/user/profile.jsp").forward(request, response);
            }
        } else if (action.equals("verify")) {
            try {
                String otp = request.getParameter("otp");
                String email = request.getParameter("oldFilledEmail");
                String error = uService.verifyOTP(otp, user.getId());
                if (error == null) {
                    uService.updateEmail(email, user.getId());
                    // Redirect to a profile page if everything is valid
                    request.getSession().setAttribute("loginedUser", uService.getUserProfile(user.getId()));
                    response.sendRedirect(request.getContextPath() + "/user/profile?profileChanged=success");
                } else {
                    request.setAttribute("otpModalError", error);
                    request.setAttribute("oldFilledEmail", email);
                    request.setAttribute("showOTPModal", "true");
                    request.getRequestDispatcher("/WEB-INF/view/user/profile.jsp").forward(request, response);
                }
            } catch (SQLException ex) {
                throw new ServletException(ex);
            }
        }
    }
}
