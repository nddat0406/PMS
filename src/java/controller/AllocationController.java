/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.sql.Date;
import java.text.ParseException;
import java.time.LocalDateTime;
import java.util.List;
import model.Allocation;
import model.Project;
import model.Setting;
import model.User;
import service.AllocationService;
import service.BaseService;
import service.ProjectService;
import service.UserService;

/**
 *
 * @author HP
 */
@WebServlet(name = "AllocationController", urlPatterns = {"/allocation", "/allocation/", "/allocation/add"})
public class AllocationController extends HttpServlet {

    private AllocationService aService = new AllocationService();
    private UserService uService = new UserService();
    private ProjectService pService = new ProjectService();
    private BaseService baseService = new BaseService();

    private final String alloLink = "/WEB-INF/view/user/Allocation/alloList.jsp";
    private final String alloAdd = "/WEB-INF/view/user/Allocation/alloAdd.jsp";

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
            String modalItemIDRaw = request.getParameter("modalItemID");
            if (modalItemIDRaw != null) {
                int modalItemID = Integer.parseInt(modalItemIDRaw);
                try {
                    request.getSession().setAttribute("modalItem", aService.getModalItem(modalItemID));
                } catch (SQLException ex) {
                    throw new ServletException(ex);
                }
            }
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
            case "sort" ->
                postSort(request, response);
            case "filter" ->
                postFilter(request, response);
            case "add" ->
                postAdd(request, response);
            case "update" ->
                postUpdate(request, response);
            case "status" ->
                postStatus(request, response);
            case "delete" ->
                postDelete(request, response);
            case "getPrjInfor" ->
                postGetProjectInfor(request, response);
            default ->
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
            request.getSession().removeAttribute("userFilter");
            request.getSession().removeAttribute("projectFilter");
            request.getSession().removeAttribute("statusFilter");
            User user = (User) request.getSession().getAttribute("loginedUser");
            List<Allocation> list = aService.getAlloList(user);
            if (user.getRole() == BaseService.ADMIN_ROLE || user.getRole() == BaseService.DEPARTMENT_MANAGER || user.getRole() == BaseService.PMO_MANAGER) {
                request.getSession().setAttribute("userFilterlist", uService.getAll());
                request.getSession().setAttribute("ProjectFilterList", pService.getAllProject());
            } else {
                request.getSession().setAttribute("userFilterlist", aService.getDistinctUsersById(list));
                request.getSession().setAttribute("ProjectFilterList", aService.getDistinctProjectsById(list));
            }
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

    private void postFilter(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userFilter = Integer.parseInt(request.getParameter("userFilter"));
            int projectFilter = Integer.parseInt(request.getParameter("projectFilter"));
            int statusFilter = Integer.parseInt(request.getParameter("statusFilter"));
            User user = (User) request.getSession().getAttribute("loginedUser");
            List<Allocation> list = aService.getAlloList(user);
            list = aService.filterAllocation(userFilter, projectFilter, statusFilter, list);
            request.getSession().setAttribute("alloList", list);
            request.getSession().setAttribute("userFilter", userFilter);
            request.getSession().setAttribute("projectFilter", projectFilter);
            request.getSession().setAttribute("statusFilter", statusFilter);
            pagination(request, response, list, alloLink);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    private void postAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String project = request.getParameter("project");
            String[] members = request.getParameterValues("members"); // Member IDs as strings
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String roleStr = request.getParameter("role");
            String effortRateStr = request.getParameter("effoRate");
            int effortRate = Integer.parseInt(effortRateStr);
            int role = Integer.parseInt(roleStr);
            int pId = Integer.parseInt(project);
            int[] memberIds = null;
            if (members != null) {
                memberIds = new int[members.length];
                for (int i = 0; i < members.length; i++) {
                    memberIds[i] = Integer.parseInt(members[i]);
                }
            }
            SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");

            Allocation allocation = new Allocation();
            allocation.setRole(new Setting(role));
            allocation.setEffortRate(effortRate);
            if (startDate == null || startDate.isBlank()) {
                LocalDateTime now = LocalDateTime.now();
                allocation.setStartDate(Date.valueOf(now.toLocalDate()));
            } else {
                allocation.setStartDate(new Date(formatter.parse(startDate).getTime()));
            }
            if (endDate == null || endDate.isBlank()) {
                allocation.setEndDate(null);
            } else {
                allocation.setEndDate(new Date(formatter.parse(endDate).getTime()));
            }
            allocation.setProject(new Project(pId));

            List<String> error = aService.addAllocation(allocation, memberIds);
            if (error != null) {
                List<Allocation> list = (List<Allocation>) request.getSession().getAttribute("alloList");
                request.setAttribute("addErrorMess", error);
                request.setAttribute("isAdd", true);
                pagination(request, response, list, alloLink);
                return;
            }
            List<Allocation> list = refreshChanges(request);
            request.setAttribute("successMess", "Add successful!");
            pagination(request, response, list, alloLink);
        } catch (NumberFormatException | ParseException | SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idstr = request.getParameter("id");
            String endDate = request.getParameter("endDate");
            String roleStr = request.getParameter("role");
            String effortRateStr = request.getParameter("effoRate");
            int effortRate = Integer.parseInt(effortRateStr);
            int role = Integer.parseInt(roleStr);
            int id = Integer.parseInt(idstr);

            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            Allocation modalItem = (Allocation) request.getSession().getAttribute("modalItem");
            Allocation allocation = new Allocation();
            allocation.setId(id);
            allocation.setRole(new Setting(role));
            allocation.setEffortRate(effortRate);
            allocation.setStartDate(modalItem.getStartDate());

            if (endDate == null || endDate.isBlank()) {
                allocation.setEndDate(null);
            } else {
                allocation.setEndDate(new Date(formatter.parse(endDate).getTime()));
            }
            List<String> error = aService.update(allocation);
            if (error != null) {
                List<Allocation> list = (List<Allocation>) request.getSession().getAttribute("alloList");
                request.setAttribute("updateErrorMess", error);
                request.setAttribute("isUpdate", true);
                pagination(request, response, list, alloLink);
            }
            List<Allocation> list = refreshChanges(request);
            request.setAttribute("successMess", "Update successful!");
            request.removeAttribute("modalItem");
            pagination(request, response, list, alloLink);
        } catch (NumberFormatException | ParseException | SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int alloId = Integer.parseInt(request.getParameter("alloId"));
            aService.flipStatus(alloId);
            List<Allocation> list = refreshChanges(request);
            pagination(request, response, list, alloLink);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int alloId = Integer.parseInt(request.getParameter("alloId"));
            aService.delete(alloId);
            List<Allocation> list = refreshChanges(request);
            pagination(request, response, list, alloLink);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private List<Allocation> refreshChanges(HttpServletRequest request) throws ServletException {
        HttpSession session = request.getSession();
        Integer projectFilter = (Integer) session.getAttribute("projectFilter");
        Integer userFilter = (Integer) session.getAttribute("userFilter");
        Integer statusFilter = (Integer) session.getAttribute("statusFilter");
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        try {
            User user = (User) request.getSession().getAttribute("loginedUser");
            List<Allocation> list = aService.getAlloList(user);
            list = aService.filterAllocation(userFilter, projectFilter, statusFilter, list);

            if (fieldName != null && order != null) {
                baseService.sortListByField(list, fieldName, order);
            }
            session.setAttribute("alloList", list);
            return list;
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void postGetProjectInfor(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            Integer PID = Integer.valueOf(request.getParameter("PID"));

            if (PID <= 0) {
                return;
            }

            JsonObject jsonResponse = aService.getResponseJson(PID);
            Gson gson = new Gson();

            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(jsonResponse));
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
