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
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.List;
import java.sql.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Allocation;
import model.Criteria;
import model.Project;
import service.BaseService;
import model.Milestone;
import model.User;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import service.CriteriaService;
import service.GroupService;
import service.MilestoneService;
import service.ProjectService;
import service.UserService;

/**
 *
 * @author HP
 */
@WebServlet(name = "ProjectConfigController", urlPatterns = {"/project", "/project/eval", "/project/milestone", "/project/member"})
public class ProjectConfigController extends HttpServlet {

    private ProjectService pService = new ProjectService();
    private BaseService baseService = new BaseService();
    private MilestoneService mService = new MilestoneService();
    private CriteriaService cService = new CriteriaService();

    private String linkEval = "/WEB-INF/view/user/projectConfig/projecteval.jsp";
    private String linkMile = "/WEB-INF/view/user/projectConfig/projectmilestone.jsp";
    private String linkMember = "/WEB-INF/view/user/projectConfig/projectmember.jsp";

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
                        String modalItemIDRaw = request.getParameter("modalItemID");
                        if (modalItemIDRaw != null) {
                            int modalItemID = Integer.parseInt(modalItemIDRaw);
                            request.setAttribute("modalItem", cService.getCriteriaProject(modalItemID, list));
                        }
                        pagination(request, response, list, linkEval);
                    } catch (SQLException ex) {
                        throw new ServletException(ex);
                    }
                } else {
                    getProjectEval(request, response);
                }
            }
            case "member" -> {
                if (request.getParameter("page") != null) {
                    List<Allocation> list = (List<Allocation>) request.getSession().getAttribute("memberList");
                    pagination(request, response, list, linkMember);
                } else {
                    getProjectMember(request, response);
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
        String path = request.getServletPath().substring("/project/".length());
        switch (path) {
            case "eval" -> {
                String action = request.getParameter("action");
                switch (action) {
                    case "filter" ->
                        postEvalFilter(request, response);
                    case "changeStatus" ->
                        postEvalFlipStatus(request, response);
                    case "delete" ->
                        postEvalDelete(request, response);
                    case "add" ->
                        postEvalAdd(request, response);
                    case "update" ->
                        postEvalUpdate(request, response);
                    case "sort" ->
                        postSortEval(request, response);
                    default -> {
                        getProjectEval(request, response);
                    }
                }
            }
            case "member" -> {
                String action = request.getParameter("action");
                switch (action) {
                    case "sort" ->
                        postMemberSort(request, response);
                    case "changeStatus" ->
                        postMemberFlipStatus(request, response);
                    case "export" ->
                        exportToExcel(response, request);
                    default ->
                        throw new AssertionError();
                }
            }
            case "milestone" -> {
                String action = request.getParameter("action");
                if ("update".equals(action)) {
                    try {
                        updateMilestone(request, response);
                    } catch (SQLException ex) {
                        response.getWriter().print("Update error: " + ex.getMessage());
                    }
                }
            }
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

    private void getProjectEval(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("searchKey");
        session.removeAttribute("milestoneFilter");
        session.removeAttribute("statusFilter");
        session.removeAttribute("sortFieldName");
        session.removeAttribute("sortOrder");
        try {
            Integer pID;
            String pIdRaw = request.getParameter("projectId");
            if (pIdRaw == null) {
                pID = (Integer) session.getAttribute("selectedProject");
                if (pID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the criteria id");
                }
            } else {
                pID = Integer.valueOf(pIdRaw);
                session.setAttribute("selectedProject", pID);
            }
            List<Criteria> list = cService.listCriteriaOfProject(pID);
            session.setAttribute("criteriaList", list);
            session.setAttribute("msList", mService.getAllMilestone(pID));
            pagination(request, response, list, linkEval);
        } catch (SQLException ex) {
            throw new ServletException(ex);

        }
    }

    private void getProjectMember(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer pID;
            String pIdRaw = request.getParameter("projectId");
            if (pIdRaw == null) {
                pID = (Integer) session.getAttribute("selectedProject");
                if (pID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the project id");
                }
            } else {
                pID = Integer.valueOf(pIdRaw);
                session.setAttribute("selectedProject", pID);
            }
            List<Allocation> list = pService.getProjectMembers(pID);
            session.setAttribute("memberList", list);
            pagination(request, response, list, linkMember);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void getProjectMilestone(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Integer pID;
            String pIdRaw = request.getParameter("projectId");
            if (pIdRaw == null) {
                pID = (Integer) session.getAttribute("selectedProject");
                if (pID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the project id");
                }
            } else {
                pID = Integer.valueOf(pIdRaw);
                session.setAttribute("selectedProject", pID);
            }

            List<Milestone> milestones = mService.getAllMilestone(pID);
            session.setAttribute("milestoneList", milestones);
            // Use the existing pagination method
            pagination(request, response, milestones, linkMile);
        } catch (SQLException ex) {
            // Handle exception
            response.getWriter().print("An error occurred: " + ex.getMessage());
        }

    }

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

    private void updateMilestone(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        // Lấy dữ liệu từ form
        int id = Integer.parseInt(request.getParameter("mileStoneId"));
        String name = request.getParameter("milestoneName");
        int priority = Integer.parseInt(request.getParameter("milestonePriority"));
        String endDate = request.getParameter("milestoneEndDate");
        boolean status = "1".equals(request.getParameter("milestoneStatus"));
        String details = request.getParameter("milestoneDetails");

        // Tạo đối tượng Milestone và cập nhật dữ liệu
        Milestone milestone = new Milestone();
        milestone.setId(id);
        milestone.setName(name);
        milestone.setPriority(priority);
        milestone.setEndDate(Date.valueOf(endDate));
        milestone.setStatus(status);
        milestone.setDetails(details);

        // Gọi service để cập nhật milestone
        mService.updateMilestone(milestone);

        // Redirect về trang milestone sau khi cập nhật thành công
        response.sendRedirect(request.getContextPath() + "/project/milestone");
    }

    //post eval
    private void postEvalFilter(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String mileFilterRaw = request.getParameter("milestoneFilter");
        String statusFilterRaw = request.getParameter("statusFilter");
        try {
            int mileFilter = baseService.TryParseInt(mileFilterRaw);
            int statusFilter = baseService.TryParseInt(statusFilterRaw);
            String searchKey = request.getParameter("searchKey");
            HttpSession session = request.getSession();
            List<Criteria> list = cService.listCriteriaOfProject((int) session.getAttribute("selectedProject"));
            list = cService.searchFilter(list, mileFilter, statusFilter, searchKey);
            session.setAttribute("searchKey", searchKey);
            session.setAttribute("milestoneFilter", mileFilter);
            session.setAttribute("statusFilter", statusFilter);
            session.setAttribute("criteriaList", list);
            pagination(request, response, list, linkEval);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void postEvalFlipStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("criteriaId"));

            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
            cService.flipStatusCriteProject(id, list);
            list = refreshEvalChanges(request);
            pagination(request, response, list, linkEval);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    private void postEvalDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("criteriaId"));
            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
            cService.deleteEvalProject(id, list);
            list = refreshEvalChanges(request);
            pagination(request, response, list, linkEval);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    private void postEvalUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int uID = Integer.parseInt(request.getParameter("uID"));
            String uName = request.getParameter("uName");
            int uWeight = Integer.parseInt(request.getParameter("uWeight"));
            int uMilestone = Integer.parseInt(request.getParameter("uMilestone"));
            String uDescription = request.getParameter("uDescript");
            int projectId = (int) request.getSession().getAttribute("selectedProject");

            Criteria c = new Criteria();
            c.setId(uID);
            c.setName(uName);
            c.setWeight(uWeight);
            Milestone m = new Milestone();
            m.setId(uMilestone);
            c.setMilestone(m);
            Project p = new Project();
            p.setId(projectId);
            c.setProject(p);
            c.setDescription(uDescription);
            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
            cService.updateEvalProject(c, list);
            list = refreshEvalChanges(request);
            request.setAttribute("successMess", "Update successfull");
            pagination(request, response, list, linkEval);
        } catch (SQLException ex) {
            request.setAttribute("errorMess", ex.getMessage());
            request.setAttribute("isAdd", "true");
            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
            pagination(request, response, list, linkEval);
        }
    }

    private void postEvalAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String Name = request.getParameter("Name");
            int Weight = Integer.parseInt(request.getParameter("Weight"));
            int Milestone = Integer.parseInt(request.getParameter("Milestone"));
            String Description = request.getParameter("Descript");
            int projectId = (int) request.getSession().getAttribute("selectedProject");

            Criteria c = new Criteria();
            c.setName(Name);
            c.setWeight(Weight);
            Milestone m = new Milestone();
            m.setId(Milestone);
            c.setMilestone(m);
            Project p = new Project();
            p.setId(projectId);
            c.setProject(p);
            c.setDescription(Description);
            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
            cService.addEvalProject(c, list);
            list = refreshEvalChanges(request);
            request.setAttribute("successMess", "Add successfull");

            pagination(request, response, list, linkEval);
        } catch (SQLException ex) {
            request.setAttribute("errorMess", ex.getMessage());
            request.setAttribute("isAdd", "true");
            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
            pagination(request, response, list, linkEval);
        }
    }

    private List<Criteria> refreshEvalChanges(HttpServletRequest request) throws ServletException {
        HttpSession session = request.getSession();
        String searchKey = (String) session.getAttribute("searchKey");
        Integer mileFilter = (Integer) session.getAttribute("milestoneFilter");
        Integer statusFilter = (Integer) session.getAttribute("statusFilter");
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        try {
            List<Criteria> list = cService.listCriteriaOfProject((int) session.getAttribute("selectedProject"));
            list = cService.searchFilter(list, mileFilter, statusFilter, searchKey);
            if (fieldName != null && order != null) {
                baseService.sortListByField(list, fieldName, order);
            }
            session.setAttribute("criteriaList", list);
            return list;
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postSortEval(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
        baseService.sortListByField(list, fieldName, order);
        request.getSession().setAttribute("criteriaList", list);
        request.getSession().setAttribute("sortFieldName", fieldName);
        request.getSession().setAttribute("sortOrder", order);
        pagination(request, response, list, linkEval);
    }

    ///member section
    private void postMemberSort(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("memberList");
        baseService.sortListByField(list, fieldName, order);
        request.getSession().setAttribute("memberList", list);
        request.getSession().setAttribute("sortFieldName", fieldName);
        request.getSession().setAttribute("sortOrder", order);
        pagination(request, response, list, linkMember);
    }

    private List<Allocation> refreshMemberChanges(HttpServletRequest request) throws ServletException {
        HttpSession session = request.getSession();
//        String searchKey = (String) session.getAttribute("searchKey");
//        Integer mileFilter = (Integer) session.getAttribute("milestoneFilter");
//        Integer statusFilter = (Integer) session.getAttribute("statusFilter");
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        try {
            List<Allocation> list = pService.getProjectMembers((int) session.getAttribute("selectedProject"));
//            list = pService.searchFilterMember(list, mileFilter, statusFilter, searchKey);
            if (fieldName != null && order != null) {
                baseService.sortListByField(list, fieldName, order);
            }
            session.setAttribute("memberList", list);
            return list;
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postMemberFlipStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("allocateId"));
            List<Allocation> list = (List<Allocation>) request.getSession().getAttribute("memberList");
            pService.flipStatusMember(id, list);
            list = refreshMemberChanges(request);
            pagination(request, response, list, linkMember);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }

    }

    private void exportToExcel(HttpServletResponse response, HttpServletRequest request) throws IOException, ServletException {
        try {
            List<Allocation> list = pService.getProjectMembers((int) request.getSession().getAttribute("selectedProject"));
            Workbook workbook = pService.exportProjectMember(list);

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=Project_Members.xlsx");

            OutputStream outputStream = response.getOutputStream();
            workbook.write(outputStream);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
