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
import java.util.List;
import model.Allocation;
import model.User;
import service.AllocationService;
import service.BaseService;

/**
 *
 * @author HP
 */
@WebServlet(name = "AllocationController", urlPatterns = {"/allocation"})
public class AllocationController extends HttpServlet {

    private AllocationService aService = new AllocationService();
    private BaseService baseService = new BaseService();

    private final String alloLink = "/WEB-INF/view/user/Allocation/alloList.jsp";

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
            out.println("<title>Servlet AllocationController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AllocationController at " + request.getContextPath() + "</h1>");
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
        if (request.getParameter("page") != null) {
            List<Allocation> list = (List<Allocation>) request.getSession().getAttribute("alloList");
            pagination(request, response, list, alloLink);
        } else {
            getAllocationList(request, response);
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
        switch (action) {
            case "sort":
                postSort(request,response);
                
                break;
            default:
                throw new AssertionError();
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

    public void pagination(HttpServletRequest request, HttpServletResponse response, List<?> list, String link) throws ServletException, IOException {
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

    private void getAllocationList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("loginedUser");
            List<Allocation> list = aService.getAlloList(user);
            request.getSession().setAttribute("alloList", list);
            pagination(request, response, list, alloLink);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postSort(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        List<Allocation> list = (List<Allocation>) request.getSession().getAttribute("alloList");
        baseService.sortListByField(list, fieldName, order);
        request.getSession().setAttribute("alloList", list);
        request.getSession().setAttribute("sortFieldName", fieldName);
        request.getSession().setAttribute("sortOrder", order);
        pagination(request, response, list, alloLink);
    }
}
