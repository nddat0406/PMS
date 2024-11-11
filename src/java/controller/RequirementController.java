package controller;

import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import model.Milestone;
import model.Requirement;
import model.User;
import service.BaseService;
import service.RequirementService;

@WebServlet(name = "RequirementController", urlPatterns = { "/requirement" })
public class RequirementController extends HttpServlet {

    private final RequirementService requirementService = new RequirementService();
    private final BaseService baseService = new BaseService();
    private final String REQUIREMENT_PAGE = "/WEB-INF/view/user/requirement/requirement-manage.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            request.setAttribute("requirementService", requirementService);
            // First time loading the page - clear existing filters
            if (request.getParameter("page") == null) {
                session.removeAttribute("searchKey");
                session.removeAttribute("complexityFilter");
                session.removeAttribute("projectFilter");
                session.removeAttribute("statusFilter");
                session.removeAttribute("sortFieldName");
                session.removeAttribute("sortOrder");

                List<Requirement> list = requirementService.getAll();
                session.setAttribute("requirementList", list);
                pagination(request, response, list);
            } else {
                // Handle pagination for filtered results
                List<Requirement> list = (List<Requirement>) session.getAttribute("requirementList");
                try {
                    String modalItemIDRaw = request.getParameter("modalItemID");
                    if (modalItemIDRaw != null) {
                        int modalItemID = Integer.parseInt(modalItemIDRaw);
                        request.setAttribute("modalItem", requirementService.getRequirementById(modalItemID));
                    }
                    pagination(request, response, list);
                } catch (SQLException ex) {
                    throw new ServletException(ex);
                }
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            doGet(request, response);
            return;
        }
        try {
            switch (action) {
                case "filter" ->
                    postFilter(request, response);
                
                case "add" ->
                    postAdd(request, response);
                case "update" ->
                    postUpdate(request, response);
               
                case "getMilestones" -> {
                    int projectId = Integer.parseInt(request.getParameter("projectId"));
                    List<Milestone> milestones = requirementService.getListMileStoneByProjectId(projectId);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    // Convert milestones list to JSON
                    //su dung noi chuoi de tao JSON
                    String json = "[";
                    for (int i = 0; i < milestones.size(); i++) {
                        Milestone m = milestones.get(i);
                        json += "{\"id\":" + m.getId() + ",\"name\":\"" + m.getName() + "\"}";
                        if (i < milestones.size() - 1) {
                            json += ",";
                        }
                    }
                    json += "]";
                    response.getWriter().write(json);
                    return; // Important to return here
                }
                case "getMilestoneId" -> {
                    int requirementId = Integer.parseInt(request.getParameter("requirementId"));
                    Integer milestoneId = requirementService.getMilestoneIdForRequirement(requirementId);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(String.valueOf(milestoneId != null ? milestoneId : ""));
                    return;
                }
                case "getAssignees" -> {
                    int projectId = Integer.parseInt(request.getParameter("projectId"));
                    List<User> assignees = requirementService.getListUsersByProjectId(projectId);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    // Convert assignees list to JSON with better string building
                    StringBuilder json = new StringBuilder("[");
                    for (int i = 0; i < assignees.size(); i++) {
                        User user = assignees.get(i);
                        if (i > 0) {
                            json.append(",");
                        }
                        json.append("{\"id\":").append(user.getId())
                                .append(",\"name\":\"").append(user.getFullname().replace("\"", "\\\""))
                                .append("\"}");
                    }
                    json.append("]");
                    response.getWriter().write(json.toString());
                    return;
                }
                case "getAssigneeId" -> {
                    int requirementId = Integer.parseInt(request.getParameter("requirementId"));
                    Integer assigneeId = requirementService.getAssigneeIdForRequirement(requirementId);
                    System.out.println(assigneeId);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(String.valueOf(assigneeId != null ? assigneeId : ""));
                    return;
                }
                default ->
                    doGet(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void pagination(HttpServletRequest request, HttpServletResponse response, List<?> list)
            throws ServletException, IOException {
        int page, numperpage = 12;
        int size = list.size();
        int num = (size % numperpage == 0 ? (size / numperpage) : (size / numperpage) + 1);// so trang
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
        request.getRequestDispatcher(REQUIREMENT_PAGE).forward(request, response);
    }

   private void postFilter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        request.setAttribute("requirementService", requirementService);
         List<Requirement> listServiceAll = requirementService.getAll();
                session.setAttribute("requirementList", listServiceAll);
            
        String complexityFilter = request.getParameter("complexityFilter");
        String projectFilterRaw = request.getParameter("projectFilter");
        String statusFilterRaw = request.getParameter("statusFilter");
        String searchKey = request.getParameter("searchKey");

        int projectFilter = baseService.TryParseInt(projectFilterRaw);
        int statusFilter = baseService.TryParseInt(statusFilterRaw);
        
        List<Requirement> list = requirementService.getRequirementsByFilter(complexityFilter, projectFilter,
                statusFilter, searchKey);

        session.setAttribute("searchKey", searchKey);
        session.setAttribute("complexityFilter", complexityFilter);
        session.setAttribute("projectFilter", projectFilter);
        session.setAttribute("statusFilter", statusFilter);
        session.setAttribute("requirementList", list);

        pagination(request, response, list);
    }



    private void postAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            String title = request.getParameter("title");
            String details = request.getParameter("details");
            String complexity = request.getParameter("complexity");
            int status = Integer.parseInt(request.getParameter("status"));
            int estimatedEffort = Integer.parseInt(request.getParameter("estimatedEffort"));
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            
            // Get assignee ID
            String assigneeIdStr = request.getParameter("assigneeId");
            Integer assigneeId = null;
            if (assigneeIdStr != null && !assigneeIdStr.isEmpty()) {
                assigneeId = Integer.parseInt(assigneeIdStr);
            }

            // Get milestone ID if provided
            String milestoneIdStr = request.getParameter("milestoneId");
            Integer milestoneId = null;
            if (milestoneIdStr != null && !milestoneIdStr.isEmpty()) {
                milestoneId = Integer.parseInt(milestoneIdStr);
            }
            
            Requirement requirement = Requirement.builder()
                    .title(title)
                    .details(details)
                    .complexity(complexity)
                    .status(status)
                    .estimatedEffort(estimatedEffort)
                    .projectId(projectId)
                    .userId(assigneeId) // Set the assignee ID
                    .build();
            
            requirementService.insertRequirementWithMilestone(requirement, milestoneId);
            
            // Refresh the list after adding
            List<Requirement> list = refreshChanges(request);
            request.setAttribute("successMess", "Add successful");
            doGet(request, response);
            
        } catch (SQLException ex) {
            request.setAttribute("AddErrorMess", ex.getMessage());
            request.setAttribute("isAdd", "true");
            List<Requirement> list = (List<Requirement>) request.getSession().getAttribute("requirementList");
            doGet(request, response);
        }
    }

    private void postUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String details = request.getParameter("details");
            String complexity = request.getParameter("complexity");
            int status = Integer.parseInt(request.getParameter("status"));
            int estimatedEffort = Integer.parseInt(request.getParameter("estimatedEffort"));

            // Get assignee ID
            String assigneeIdStr = request.getParameter("assigneeId");
            Integer assigneeId = null;
            if (assigneeIdStr != null && !assigneeIdStr.isEmpty()) {
                assigneeId = Integer.parseInt(assigneeIdStr);
            }

            // Get milestone ID if provided
            String milestoneIdStr = request.getParameter("milestoneId");
            Integer milestoneId = null;
            if (milestoneIdStr != null && !milestoneIdStr.isEmpty()) {
                milestoneId = Integer.parseInt(milestoneIdStr);
            }

            Requirement requirement = Requirement.builder()
                    .id(id)
                    .title(title)
                    .details(details)
                    .complexity(complexity)
                    .status(status)
                    .estimatedEffort(estimatedEffort)
                    .userId(assigneeId) // Set the assignee ID
                    .build();

            request.setAttribute("modalItem", requirement);
            requirementService.updateRequirementWithMilestone(requirement, milestoneId);

            // Refresh the list after updating
            List<Requirement> list = refreshChanges(request);
            request.setAttribute("successMess", "Update successful");
            request.removeAttribute("modalItem");
            doGet(request, response);

        } catch (SQLException ex) {
            request.setAttribute("UpdateErrorMess", ex.getMessage());
            request.setAttribute("isUpdate", "true");
            List<Requirement> list = (List<Requirement>) request.getSession().getAttribute("requirementList");
            doGet(request, response);
        }
    }

  

    private List<Requirement> refreshChanges(HttpServletRequest request) throws SQLException {
        HttpSession session = request.getSession();
        String searchKey = (String) session.getAttribute("searchKey");
        String complexityFilter = (String) session.getAttribute("complexityFilter");
        Integer projectFilter = (Integer) session.getAttribute("projectFilter");
        Integer statusFilter = (Integer) session.getAttribute("statusFilter");
        String fieldName = request.getParameter("fieldName");
        String order = request.getParameter("sortBy");

        List<Requirement> list = requirementService.getRequirementsByFilter(
                complexityFilter, projectFilter, statusFilter, searchKey);

        if (fieldName != null && order != null) {
            baseService.sortListByField(list, fieldName, order);
        }
        session.setAttribute("requirementList", list);
        return list;
    }

    private String getProjectName(int id) {
        return requirementService.getProjectName(id);
    }
}
