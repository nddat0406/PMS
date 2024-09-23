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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import service.BaseService;
import service.UserService;

/**
 *
 * @author nmngh
 */
@WebServlet(name = "ForgotpasswordController", urlPatterns = {"/forgot-password"})
public class ForgotpasswordController extends HttpServlet {

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
            out.println("<title>Servlet ForgotpasswordController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotpasswordController at " + request.getContextPath() + "</h1>");
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
        String contain = request.getServletPath();
        if (contain.contains("forgot-password")) {
            request.getRequestDispatcher("/WEB-INF/view/user/fogotpassword.jsp").forward(request, response);
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
        String contain = request.getParameter("contain");
        UserService userService = new UserService();
        if (contain.contains("forgot")) {
            String email = request.getParameter("email");
            String otp = BaseService.getRandom();
            userService.saveOtp(email, otp);
            boolean result = BaseService.sendEmail(email, otp);
            if (result) {
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/view/user/verify.jsp").forward(request, response);
            }
        } else if (contain.contains("verify")) {
            String otp = request.getParameter("otp");
            String email = request.getParameter("email");
            User user = null;
            try {
                user = userService.getUserByEmail(email);
            } catch (SQLException ex) {
                Logger.getLogger(ForgotpasswordController.class.getName()).log(Level.SEVERE, null, ex);
            }
            if(user==null){
                request.setAttribute("error", "User is null");
                request.getRequestDispatcher("/WEB-INF/view/user/verify.jsp").forward(request, response);
            }
            if(otp.trim().equals(user.getOtp())){
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/view/user/resetpassword.jsp").forward(request, response);
            }
        } else if (contain.contains("reset")) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String rePassword = request.getParameter("re-password");
            if(!rePassword.trim().equals(password.trim())){
                request.setAttribute("error", "Password is not match");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/view/user/resetpassword.jsp").forward(request, response);
            }
            boolean check = userService.resetPassword(email, rePassword);
            if(!check){
                request.setAttribute("errorMess", "Can not save new password");
                request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
            }
            request.setAttribute("success", "Change password successfully");
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
