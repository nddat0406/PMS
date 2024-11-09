/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import model.User;
import service.BaseService;
import service.UserService;

/**
 *
 * @author HP
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login", "/logout", "/register", "/verifyEmail", "/forgot-password"})
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
        } else if (action.contains("forgot-password")) {
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
        String action = request.getServletPath();
        if (action.contains("login")) {
            loginPost(request, response);
        } else if (action.contains("register")) {
            registerPost(request, response);
        } else if (action.contains("forgot-password")) {
            String contain = request.getParameter("contain");
            if (contain.contains("forgot")) {
                forgotPost(request, response);
            } else if (contain.contains("verify")) {
                verifyPost(request, response);
            } else if (contain.contains("reset")) {
                resetPost(request, response);
            }
        } else if (action.contains("verifyEmail")) {
            String contain = request.getParameter("action");
            if (contain.contains("sendEmail")) {
                sendVerifyEmailPost(request, response);
            } else if (contain.contains("verify")) {
                verifyEmailPost(request, response);
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

    private void loginPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        try {
            if (uService.verifyLogin(email, pass)) {
                request.getSession().setAttribute("loginedUser", uService.getUserByEmail(email));
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.getSession().setAttribute("email", email);
                request.getSession().setAttribute("pass", pass);
                request.getSession().setAttribute("errorMess", "Email or password is wrong!");
                request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            request.setAttribute("errorMess", "Login failed! Some thing went wrong. (This user might been deactivated!)");
            request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
        }
    }

    private void registerPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();
        String rePassword = request.getParameter("rePassword").trim();
        if (email.isBlank()) {
            request.setAttribute("emailError", "Email can not be blank");
            request.getRequestDispatcher("/WEB-INF/view/user/register.jsp").forward(request, response);
        } else if (uService.isEmailExists(email)) {
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
        if (!uService.createUser(fullName, email, password)) {
            request.setAttribute("error", "Register unsuccessfully");
            request.getRequestDispatcher("/WEB-INF/view/user/register.jsp").forward(request, response);
        } else {
            request.setAttribute("success", "Register successful successfully! Please login");
            request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
        }
    }

    private void forgotPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            request.setAttribute("oldEmail", email);
            if (uService.isEmailExists(email)) {
                String otp = BaseService.getRandom();
                uService.saveOtp(email, otp);
                boolean result = BaseService.sendEmail(email, "Forgot password OTP", "Here is OTP to reset your password: " + otp);
                if (result) {
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("/WEB-INF/view/user/verify.jsp").forward(request, response);
                }
            }else{
                request.setAttribute("errorMess", "Email not found!");
                request.getRequestDispatcher("/WEB-INF/view/user/fogotpassword.jsp").forward(request, response);
            }
        } catch (MessagingException ex) {
            throw new ServletException(ex);
        }
    }

    private void verifyPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String otp = request.getParameter("otp");
        String email = request.getParameter("email");
        request.setAttribute("email", email);
        User user = null;
        try {
            user = uService.getUserByEmail(email);
        } catch (SQLException ex) {
            Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (user == null) {
            request.setAttribute("error", "User is null");
            request.getRequestDispatcher("/WEB-INF/view/user/verify.jsp").forward(request, response);
        }
        if (otp.trim().equals(user.getOtp())) {
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/view/user/resetpassword.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Otp invalid or has been expired!");
            request.getRequestDispatcher("/WEB-INF/view/user/verify.jsp").forward(request, response);
        }
    }

    private void resetPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("re-password");
        if (!rePassword.trim().equals(password.trim())) {
            request.setAttribute("error", "Password is not match");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/view/user/resetpassword.jsp").forward(request, response);
        }
        boolean check = uService.resetPassword(email, rePassword);
        if (!check) {
            request.setAttribute("errorMess", "Can not save new password");
            request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
        }
        request.setAttribute("success", "Reset password successfully");
        request.getRequestDispatcher("/WEB-INF/view/user/login.jsp").forward(request, response);
    }

    private void verifyEmailPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String otp = request.getParameter("otpValue");
        String rightOtp = (String) request.getSession().getAttribute("otpCode");
        LocalDateTime otpExpire = (LocalDateTime) request.getSession().getAttribute("otpCodeExpire");
        LocalDateTime now = LocalDateTime.now();
        Map<String, String> responseMap = new HashMap<>();

        if (otpExpire.compareTo(now) < 0 || rightOtp == null) {
            responseMap.put("status", "error");
            responseMap.put("message", "OTP expired! Please send another and try again!");
        } else {
            if (!otp.equals(rightOtp)) {
                responseMap.put("status", "error");
                responseMap.put("message", "OTP is not match!!");
            } else {
                responseMap.put("status", "success");
            }
        }
        Gson gson = new Gson();
        // Convert Map to JSON and write it to the response
        String jsonResponse = gson.toJson(responseMap);
        response.getWriter().write(jsonResponse);
    }

    private void sendVerifyEmailPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String otp = BaseService.getRandom();
        String email = request.getParameter("registerEmail");
        request.getSession().setAttribute("otpCode", otp);
        LocalDateTime now = LocalDateTime.now();
        // Add 10 minutes to the current time
        LocalDateTime timePlus10Minutes = now.plusMinutes(10);
        request.getSession().setAttribute("otpCodeExpire", timePlus10Minutes);

        Map<String, String> responseMap = new HashMap<>();
        boolean isValid = true;
        if (email.isBlank()) {
            responseMap.put("status", "error");
            responseMap.put("message", "Email is blank.");
            isValid = false;
        } else if (uService.isEmailExists(email)) {
            responseMap.put("status", "error");
            responseMap.put("message", "Email existed.");
            isValid = false;
        } else if (!email.matches(BaseService.EMAIL_PATTERN)) {
            responseMap.put("status", "error");
            responseMap.put("message", "Email not match the pattern!");
            isValid = false;
        }
        // Prepare JSON response with Gson
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();

        if (isValid) {
            try {
                BaseService.sendEmail(email, "Change Email Verify OTP", "Here is OTP to verify your email: " + otp);
                // Success response
                responseMap.put("status", "success");
            } catch (MessagingException e) {
                // Failure response
                responseMap.put("status", "error");
                responseMap.put("message", "Failed to send email. Please try again.");
            }
        }

        // Convert Map to JSON and write it to the response
        String jsonResponse = gson.toJson(responseMap);
        response.getWriter().write(jsonResponse);
    }

}
