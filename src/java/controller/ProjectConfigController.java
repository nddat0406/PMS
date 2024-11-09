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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import model.Allocation;
import model.Criteria;
import model.Project;
import service.BaseService;
import model.Milestone;
import model.Team;
import org.apache.poi.ss.usermodel.Workbook;
import service.CriteriaService;
import service.GroupService;
import service.MilestoneService;
import service.ProjectService;
import service.TeamService;

/**
 *
 * @author HP
 */
@WebServlet(name = "ProjectConfigController", urlPatterns = {"/project", "/project/eval", "/project/milestone", "/project/member", "/project/team"})

public class ProjectConfigController extends HttpServlet {

    private ProjectService pService = new ProjectService();
    private BaseService baseService = new BaseService();
    private MilestoneService mService = new MilestoneService();
    private CriteriaService cService = new CriteriaService();
    private GroupService gService = new GroupService();
    private TeamService tService = new TeamService();

    private String linkEval = "/WEB-INF/view/user/projectConfig/projecteval.jsp";
    private String linkMile = "/WEB-INF/view/user/projectConfig/projectmilestone.jsp";
    private String linkMember = "/WEB-INF/view/user/projectConfig/projectmember.jsp";
    private String linkTeam = "/WEB-INF/view/user/projectConfig/projectteam.jsp";

    List<Project> myProjects;

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
        myProjects = (List<Project>) request.getSession().getAttribute("myProjectList");
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
            case "team" -> {
                if (request.getParameter("page") != null) {
                    List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
                    String modalItemIDRaw = request.getParameter("modalItemID");
                    String teamAddId = request.getParameter("teamAddId");
                    if (teamAddId != null) {
                        try {
                            Integer pID = (Integer) request.getSession().getAttribute("selectedProject");
                            Integer mID = (Integer) request.getSession().getAttribute("milestoneFilter");
                            request.setAttribute("addMemberList", tService.getAddMemberList(pID, mID));
                        } catch (SQLException ex) {
                            throw new ServletException(ex);
                        }
                    }
                    if (modalItemIDRaw != null) {
                        try {
                            int modalItemID = Integer.parseInt(modalItemIDRaw);
                            Integer mID = (Integer) request.getSession().getAttribute("milestoneFilter");

                            request.setAttribute("modalItem", tService.getTeamById(modalItemID, list, mID));
                        } catch (SQLException ex) {
                            throw new ServletException(ex);
                        }
                    }
                    pagination(request, response, list, linkTeam);
                } else {
                    getProjectTeam(request, response);
                }
            }
            case "milestone" ->
                getProjectMilestone(request, response);
            default ->
                getProjectMilestone(request, response);
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
                    case "filter" ->
                        postMemberFilter(request, response);
                    case "export" ->
                        exportToExcel(response, request);
                    default ->
                        throw new AssertionError();
                }
            }
            case "milestone" -> {
                String action = request.getParameter("action");
                switch (action) {
                    case "update" -> {
                        try {
                            updateMilestone(request, response);
                        } catch (SQLException ex) {
                            Logger.getLogger(ProjectConfigController.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    case "sort" ->
                        postSortMilestone(request, response);
                    default ->
                        getProjectMilestone(request, response);
                }
            }
            case "team" -> {
                String action = request.getParameter("action");
                if (null != action) {
                    switch (action) {
                        case "add" -> {
                            postTeamAdd(request, response);
                        }
                        case "update" -> {
                            postTeamUpdate(request, response);
                        }
                        case "delete" -> {
                            postTeamDelete(request, response);
                        }
                        case "filter" -> {
                            postTeamFilter(request, response);
                        }
                        case "addMember" -> {
                            postAddTeamMember(request, response);
                        }
                        case "deleteMember" -> {
                            postDeleteTeamMember(request, response);
                        }
                        case "changeRole" -> {
                            postChangeRoleTeam(request, response);
                        }
                        case "changeStatus" -> {
                            postChangeStatusTeam(request, response);
                        }
                        default ->
                            getProjectTeam(request, response);
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
                    throw new ServletException("Some thing went wrong, cannot find the project id");
                }
            } else {
                pID = Integer.valueOf(pIdRaw);
                if (pService.havePermission(pID, myProjects)) {
                    session.setAttribute("selectedProject", pID);
                }
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
            session.removeAttribute("searchKey");
            session.removeAttribute("deptFilter");
            session.removeAttribute("statusFilter");
            session.removeAttribute("sortFieldName");
            session.removeAttribute("sortOrder");
            Integer pID;
            String pIdRaw = request.getParameter("projectId");
            if (pIdRaw == null) {
                pID = (Integer) session.getAttribute("selectedProject");
                if (pID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the project id");
                }
            } else {
                pID = Integer.valueOf(pIdRaw);
                if (pService.havePermission(pID, myProjects)) {
                    session.setAttribute("selectedProject", pID);
                }
            }
            List<Allocation> list = pService.getProjectMembers(pID);
            session.setAttribute("memberList", list);
            session.setAttribute("deptList", gService.getAllDepartment());
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
                    throw new ServletException("Something went wrong, cannot find the project id");
                }
            } else {
                pID = Integer.valueOf(pIdRaw);
                if (pService.havePermission(pID, myProjects)) {
                    session.setAttribute("selectedProject", pID);
                }
            }

            List<Milestone> milestones = mService.getAllMilestone(pID);
            if (pService.havePermission(pID, myProjects)) {
                session.setAttribute("selectedProject", pID);
            }
            session.setAttribute("milestoneList", milestones);
            // Use the existing pagination method
            pagination(request, response, milestones, linkMile);
        } catch (SQLException ex) {
            // Handle exception
            response.getWriter().print("An error occurred: " + ex.getMessage());
        }

    }

    private void getProjectTeam(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            session.removeAttribute("searchKey");
            session.removeAttribute("milestoneFilter");
            session.removeAttribute("statusFilter");
            session.removeAttribute("sortFieldName");
            session.removeAttribute("sortOrder");
            Integer pID;
            String pIdRaw = request.getParameter("projectId");
            if (pIdRaw == null) {
                pID = (Integer) session.getAttribute("selectedProject");
                if (pID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the project id");
                }
            } else {
                pID = Integer.valueOf(pIdRaw);
                if (pService.havePermission(pID, myProjects)) {
                    session.setAttribute("selectedProject", pID);
                }
            }
            List<Milestone> mList = mService.getAllMilestone(pID);
            List<Team> list = tService.getTeamsByProject(pID, mList.get(0).getId());
            list = tService.searchFilter(list, mList.get(0).getId(), "");
            session.setAttribute("teamList", list);
            session.setAttribute("msList", mList);
            session.setAttribute("milestoneFilter", mList.get(0).getId());
            pagination(request, response, list, linkTeam);
        } catch (SQLException ex) {
            throw new ServletException(ex);
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

    private void updateMilestone(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        // Lấy dữ liệu từ form
        int id = Integer.parseInt(request.getParameter("mileStoneId"));
        String name = request.getParameter("milestoneName");
        int priority = Integer.parseInt(request.getParameter("milestonePriority"));
        String endDate = request.getParameter("milestoneEndDate");
        int status = Integer.parseInt(request.getParameter("milestoneStatus"));
        String details = request.getParameter("milestoneDetails");

        try {

            // Validate input
            List<String> errors = new ArrayList<>();

            // Validate name
            if (name == null || name.trim().isEmpty()) {
                errors.add("Name is required");
            } else if (name.length() > 30) {
                errors.add("Name must be less than 30 characters");
            }

            // Validate details
            if (details == null || details.trim().isEmpty()) {
                errors.add("Details is required");
            } else if (details.length() > 500) {
                errors.add("Details must be less than 500 characters");
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errorMessage", String.join(", ", errors));
                getProjectMilestone(request, response);
                return;
            }
            // Get original milestone to check its current state
            Milestone originalMilestone = mService.getMilestoneById(id);
            int projectId = (int) request.getSession().getAttribute("selectedProject");
            List<Milestone> projectMilestones = mService.getAllMilestone(projectId);

            // Case 1: Closing a milestone in final phase - check if all others are closed
            if (status == 0 && originalMilestone.getPhase().isFinalPhase()) {
                boolean hasOpenMilestones = projectMilestones.stream()
                        .filter(m -> m.getId() != id) // Exclude current milestone
                        .anyMatch(m -> m.getStatus() != 0); // Check if any milestone is not closed

                if (hasOpenMilestones) {
                    throw new SQLException("Cannot close this milestone: All other milestones must be closed first because this milestone belongs to a final phase.");
                }

                pService.updateProjectStatus(projectId, 3);
            }

            // Case 2: Opening a milestone - need to open final phase milestones
            if (status != 0) { // Assuming 1 is "open" status
                // Find final phase milestones
                List<Milestone> finalPhaseMilestones = projectMilestones.stream()
                        .filter(m -> m.getPhase().isFinalPhase())
                        .collect(Collectors.toList());

                // Update their status to open
                for (Milestone finalMilestone : finalPhaseMilestones) {
                    if (finalMilestone.getStatus() == 0) { // If it was closed
                        finalMilestone.setStatus(1); // Set to open
                        mService.updateMilestone(finalMilestone);
                    }
                }
                pService.updateProjectStatus(projectId, 1);
            }

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
        } catch (SQLException ex) {
            // Add error message to request and forward back to milestone page
            request.setAttribute("errorMessage", ex.getMessage());
            getProjectMilestone(request, response);
        }
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
            request.setAttribute("modalItem", c);
            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
            cService.updateEvalProject(c, list);
            list = refreshEvalChanges(request);
            request.setAttribute("successMess", "Update successfull");
            request.removeAttribute("modalItem");
            pagination(request, response, list, linkEval);
        } catch (SQLException ex) {
            request.setAttribute("UpdateErrorMess", ex.getMessage());
            request.setAttribute("isUpdate", "true");
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
            request.setAttribute("oldAddItem", c);
            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("criteriaList");
            cService.addEvalProject(c, list);
            list = refreshEvalChanges(request);
            request.setAttribute("successMess", "Add successfull");
            request.removeAttribute("oldAddItem");

            pagination(request, response, list, linkEval);
        } catch (SQLException ex) {
            request.setAttribute("AddErrorMess", ex.getMessage());
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
            int pID = (int) session.getAttribute("selectedProject");
            List<Criteria> list = cService.listCriteriaOfProject(pID);
            session.setAttribute("msList", mService.getAllMilestone(pID));
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
        String searchKey = (String) session.getAttribute("searchKey");
        Integer deptFilter = (Integer) session.getAttribute("deptFilter");
        Integer statusFilter = (Integer) session.getAttribute("statusFilter");
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        try {
            List<Allocation> list = pService.getProjectMembers((int) session.getAttribute("selectedProject"));
            list = pService.searchFilterMember(list, deptFilter, statusFilter, searchKey);
            if (fieldName != null && order != null) {
                baseService.sortListByField(list, fieldName, order);
            }
            session.setAttribute("memberList", list);
            return list;
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postMemberFilter(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String deptFilterRaw = request.getParameter("deptFilter");
        String statusFilterRaw = request.getParameter("statusFilter");
        try {
            int deptFilter = baseService.TryParseInt(deptFilterRaw);
            int statusFilter = baseService.TryParseInt(statusFilterRaw);
            String searchKey = request.getParameter("searchKey");
            HttpSession session = request.getSession();
            List<Allocation> list = pService.getProjectMembers((int) session.getAttribute("selectedProject"));
            list = pService.searchFilterMember(list, deptFilter, statusFilter, searchKey);
            session.setAttribute("searchKey", searchKey);
            session.setAttribute("deptFilter", deptFilter);
            session.setAttribute("statusFilter", statusFilter);
            session.setAttribute("memberList", list);

            pagination(request, response, list, linkMember);
        } catch (SQLException e) {
            throw new ServletException(e);
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

    private void postTeamAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String name = request.getParameter("Name");
            String[] mileRaw = request.getParameterValues("Milestone");
            String topic = request.getParameter("Topic");
            String des = request.getParameter("Description");
            int projectId = (int) request.getSession().getAttribute("selectedProject");
            Team t = new Team();
            t.setName(name);
            t.setTopic(topic);
            int[] mile;
            List<Milestone> m = new ArrayList<>();
            if (mileRaw != null && mileRaw.length != 0) {
                mile = Arrays.stream(mileRaw).mapToInt(Integer::valueOf).toArray();
                for (Integer integer : mile) {
                    m.add(new Milestone(integer));
                }
            }
            t.setMilestone(m);
            t.setDetails(des);
            Project p = new Project();
            p.setId(projectId);
            t.setProject(p);
            request.setAttribute("oldAddItem", t);
            List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
            tService.addTeam(t);
            list = refreshTeamChanges(request);
            request.setAttribute("successMess", "Add successfull");
            request.removeAttribute("oldAddItem");
            pagination(request, response, list, linkTeam);
        } catch (SQLException | NumberFormatException ex) {
            request.setAttribute("AddErrorMess", ex.getMessage());
            request.setAttribute("isAdd", "true");
            List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
            pagination(request, response, list, linkTeam);
        }
    }

    private void postTeamUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int uID = Integer.parseInt(request.getParameter("uID"));
            String uName = request.getParameter("uName");
            String uTopic = request.getParameter("uTopic");
            String[] mileRaw = request.getParameterValues("uMilestone");
            String uDescription = request.getParameter("uDescription");
            int projectId = (int) request.getSession().getAttribute("selectedProject");
            Team t = new Team();
            t.setId(uID);
            t.setName(uName);
            t.setTopic(uTopic);
            int[] mile;
            List<Milestone> m = new ArrayList<>();
            if (mileRaw != null && mileRaw.length != 0) {
                mile = Arrays.stream(mileRaw).mapToInt(Integer::valueOf).toArray();
                for (Integer integer : mile) {
                    m.add(new Milestone(integer));
                }
            }
            t.setMilestone(m);
            t.setDetails(uDescription);
            Project p = new Project();
            p.setId(projectId);
            t.setProject(p);
            request.setAttribute("modalItem", t);
            List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
            tService.updateTeam(t, list);
            list = refreshTeamChanges(request);
            request.setAttribute("successMess", "Update successfull");
            request.removeAttribute("modalItem");
            pagination(request, response, list, linkTeam);
        } catch (SQLException | NumberFormatException ex) {
            request.setAttribute("UpdateErrorMess", ex.getMessage());
            request.setAttribute("isUpdate", "true");
            List<Criteria> list = (List<Criteria>) request.getSession().getAttribute("teamList");
            pagination(request, response, list, linkTeam);
        }
    }

    private void postTeamDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("teamId"));
            List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
            tService.deleteTeam(id, list);
            list = refreshTeamChanges(request);
            pagination(request, response, list, linkTeam);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    private List<Team> refreshTeamChanges(HttpServletRequest request) throws ServletException {
        HttpSession session = request.getSession();
        String searchKey = (String) session.getAttribute("searchKey");
        Integer mileFilter = (Integer) session.getAttribute("milestoneFilter");
        try {
            int pID = (int) session.getAttribute("selectedProject");
            int mID = (int) session.getAttribute("milestoneFilter");
            List<Team> list = tService.getTeamsByProject(pID, mID);
            list = tService.searchFilter(list, mileFilter, searchKey);
            session.setAttribute("teamList", list);
            return list;
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void postTeamFilter(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mileFilterRaw = request.getParameter("milestoneFilter");
        try {
            int mileFilter = baseService.TryParseInt(mileFilterRaw);
            String searchKey = request.getParameter("searchKey");
            HttpSession session = request.getSession();
            int pID = (int) session.getAttribute("selectedProject");
            List<Team> list = tService.getTeamsByProject(pID, mileFilter);
            list = tService.searchFilter(list, mileFilter, searchKey);
            session.setAttribute("searchKey", searchKey);
            session.setAttribute("milestoneFilter", mileFilter);
            session.setAttribute("teamList", list);
            pagination(request, response, list, linkTeam);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void postAddTeamMember(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            String[] json = request.getParameterValues("json");
            int teamId = Integer.parseInt(request.getParameter("teamId"));
            String temp = json[0];
            String[] stringNumbers = temp.replaceAll("[\\[\\]\"]", "").split(",");
            // Convert to int array
            int[] numbers = Arrays.stream(stringNumbers).mapToInt(Integer::parseInt).toArray();
            List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
            int mID = (int) request.getSession().getAttribute("milestoneFilter");
            tService.addMembers(numbers, teamId, mID, list);
            list = refreshTeamChanges(request);
            pagination(request, response, list, linkTeam);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }

    }

    private void postDeleteTeamMember(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int teamId = Integer.parseInt(request.getParameter("teamId"));
            int memberId = Integer.parseInt(request.getParameter("memberId"));
            List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
            int mID = (int) request.getSession().getAttribute("milestoneFilter");
            tService.deleteMember(teamId, memberId, list, mID);
            list = refreshTeamChanges(request);
            pagination(request, response, list, linkTeam);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    private void postChangeRoleTeam(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int teamId = Integer.parseInt(request.getParameter("teamId"));
            int memberId = Integer.parseInt(request.getParameter("memberId"));
            List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
            int mID = (int) request.getSession().getAttribute("milestoneFilter");
            tService.changeRole(teamId, memberId, list, mID);
            list = refreshTeamChanges(request);
            pagination(request, response, list, linkTeam);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    private void postSortMilestone(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");
        List<Milestone> list = (List<Milestone>) request.getSession().getAttribute("milestoneList");
        baseService.sortListByField(list, fieldName, order);
        request.getSession().setAttribute("milestoneList", list);
        request.getSession().setAttribute("sortFieldName", fieldName);
        request.getSession().setAttribute("sortOrder", order);
        pagination(request, response, list, linkMile);
    }

    private void postChangeStatusTeam(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("teamId"));
            List<Team> list = (List<Team>) request.getSession().getAttribute("teamList");
            tService.changeStatus(id, list);
            list = refreshTeamChanges(request);
            pagination(request, response, list, linkTeam);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }
}
