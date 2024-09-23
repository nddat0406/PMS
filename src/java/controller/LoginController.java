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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import service.BaseService;
import service.UserService;

/**
 *
 * @author HP
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login", "/logout", "/register"})
public class LoginController extends HttpServlet {

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
            out.println("<title>Servlet LoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginController at " + request.getContextPath() + "</h1>");
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
        String action = request.getServletPath();
        if (action.contains("login")) {
            request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
        } else if (action.contains("logout")) {
            request.getSession().removeAttribute("loginedUser");
            request.getSession().invalidate();
            request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
        } else if (action.contains("register")) {
            request.getRequestDispatcher("/WEB-INF/view/user/register.jsp").forward(request, response);
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
        String action = request.getServletPath();
        if (action.contains("login")) {
            String email = request.getParameter("email");
            String pass = request.getParameter("password");
            try {
                if (uService.verifyLogin(email, pass)) {
                    request.getSession().setAttribute("loginedUser", uService.getUserByEmail(email));
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }else{
                    request.getSession().setAttribute("errorMess", "Sai tài khoản mật khẩu");
                    request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
                }
            } catch (SQLException ex) {
                request.setAttribute("errorMess", "Login failed!");
                request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
            }
        } else if (action.contains("register")) {
            String firstName = request.getParameter("firstName").trim();
            String lastName = request.getParameter("lastName").trim();
            String email = request.getParameter("email").trim();
            String password = request.getParameter("password").trim();
            String rePassword = request.getParameter("rePassword").trim();
            if (email.isBlank()) {
                request.setAttribute("emailError", "Email can not be blank");
                request.getRequestDispatcher("/WEB-INF/view/user/register.jsp").forward(request, response);
            }else if(uService.isEmailExists(email)){
                request.setAttribute("emailError", "Email is used");
                request.getRequestDispatcher("/WEB-INF/view/user/register.jsp").forward(request, response);
            }
            if (password.isEmpty()) {
                request.setAttribute("passwordError", "Password can not be empty or null");
                request.getRequestDispatcher("/WEB-INF/view/user/register.jsp").forward(request, response);
            }
            if (!rePassword.equals(password)) {
                request.setAttribute("rePasswordError", "Re-enter password does not match");
                request.getRequestDispatcher("/WEB-INF/view/user/register.jsp").forward(request, response);
            }
            String fullName = firstName.concat(" " + lastName);
            if (!uService.createUser(fullName, email, password)) {
                request.setAttribute("error", "Register unsuccessfully");
                request.getRequestDispatcher("/WEB-INF/view/user/register.jsp").forward(request, response);
            }
            request.setAttribute("success", "Register successfully");
            request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
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

}
