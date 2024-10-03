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
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Allocation;
import model.Criteria;
import model.User;
import service.BaseService;
import static service.BaseService.ADMIN_ROLE;
import service.GroupService;
import service.MilestoneService;
import service.ProjectService;
import service.UserService;

/**
 *
 * @author HP
 */
@WebServlet(name = "ProjectController", urlPatterns = {"/project", "/project/list", "/project/eval", "/project/milestone"})
public class ProjectController extends HttpServlet {

    private UserService uService = new UserService();
    private ProjectService pService = new ProjectService();
    private GroupService gService = new GroupService();
    private BaseService baseService = new BaseService();
    private MilestoneService mService = new MilestoneService();

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
            out.println("<title>Servlet ProjectController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProjectController at " + request.getContextPath() + "</h1>");
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
        String action = request.getServletPath().substring("/project/".length());
        switch (action) {
            case "eval" -> {
                if (request.getParameter("page") != null) {
                    List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
                    try {
                        pagination(request, response, list, "/WEB-INF/view/user/projecteval.jsp");
                    } catch (SQLException ex) {
                        Logger.getLogger(ProjectController.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    getProjectEval(request, response);
                }
            }
            case "milestone" ->
                getProjectMilestone(request, response);
            default ->
                throw new AssertionError();
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
        processRequest(request, response);
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

    private void getProjectEval(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String pIdRaw = request.getParameter("projectId");
            int pID = Integer.parseInt(pIdRaw);
            session.setAttribute("selectedProject", pID);
            List<Criteria> list = pService.listCriteriaOfProject(pID);
            session.setAttribute("criteriaList", list);
            session.setAttribute("msList", mService.getAllMilestone(pID));
            pagination(request, response, list, "/WEB-INF/view/user/projecteval.jsp");
        } catch (SQLException ex) {
            response.getWriter().print(ex);
        }
    }

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

    private void getProjectMilestone(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/user/projectmilestone.jsp").forward(request, response);
    }

}
