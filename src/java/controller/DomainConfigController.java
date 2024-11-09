/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;
import dal.PhaseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Criteria;
import model.Group;
import model.ProjectPhase;
import model.Setting;
import model.User;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import service.CriteriaService;
import service.GroupService;
import service.ProjectService;
import service.SettingService;
import service.UserService;

/**
 *
 * @author HP
 */
@WebServlet(name = "DomainConfigController", urlPatterns = {"/domain", "/domain/domainuser", "/domain/domainsetting", "/domain/domaineval"})

@MultipartConfig
public class DomainConfigController extends HttpServlet {

    private PhaseDAO phaseDAO = new PhaseDAO();

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
        String page = request.getRequestURI();
        String contextPath = request.getContextPath();
        page = page.replace(contextPath, "").toLowerCase();
        switch (page) {
            case "/domain/domainsetting" -> {
                this.domainSetting(request, response);
            }
            case "/domain/domainuser" -> {
                this.domainUser(request, response);
            }
            case "/domain/domaineval" -> {
                this.DoaminCriteria(request, response);
            }
            default -> {
                this.domainSetting(request, response);
            }
        }
    }

    private void domainSetting(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = request.getParameter("action");
        action = action != null ? action : "";
        GroupService groupService = new GroupService();
        SettingService settingService = new SettingService();

        HttpSession session = request.getSession();
        switch (action) {
            case "add":
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomainsetting.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                Setting st = settingService.geDomaintById(id);
                request.setAttribute("setting", st);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/editdomainsetting.jsp").forward(request, response);
                break;
            case "deactive":
            case "active":
                int idU = Integer.parseInt(request.getParameter("id"));
                 {
                    try {
                        settingService.updateStatusDomain(action, idU);
                    } catch (SQLException ex) {
                        throw new ServletException(ex);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
                break;

            default:
                try {
                List<Setting> domainSettings;
                String searchName = request.getParameter("search");
                String filterStatus = request.getParameter("status");
                String type = request.getParameter("type");
                Integer dID;
                String dIdRaw = request.getParameter("domainId");//lay parameter  domainId
                if (dIdRaw == null) {
                    dID = (Integer) session.getAttribute("domainId");
                    if (dID == null) {
                        throw new ServletException("Some thing went wrong, cannot find the domain id");
                    }
                } else {
                    dID = Integer.valueOf(dIdRaw);
                    session.setAttribute("domainId", dID);
                }
                SettingService se = new SettingService();
                if ((searchName != null && !searchName.isEmpty())
                        || (filterStatus != null && !filterStatus.isEmpty())
                        || (type != null && !type.isEmpty())) {
                    // Nếu có bộ lọc, dùng danh sách đã lọc
                    domainSettings = se.getFilteredDomainSettings(filterStatus, searchName, dID);
                } else {
                    // Nếu không có bộ lọc, lấy toàn bộ danh sách
                    domainSettings = se.getDomainSettingByDomainId(dID);
                }

                request.setAttribute("searchName", searchName);
                request.setAttribute("filterStatus", filterStatus);
                request.setAttribute("type", type);
                request.setAttribute("domainSettings", domainSettings);

                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainsetting.jsp").forward(request, response);
            } catch (NumberFormatException | SQLException e) {
                throw new ServletException(e);
            }
        }
    }

    private void domainUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String action = request.getParameter("action");
            action = action != null ? action : "";
            UserService userService = new UserService();
            GroupService groupService = new GroupService();
            List<User> users = userService.getAll();
            List<Group> groups = groupService.getAllDomains();
            switch (action) {
                case "add" -> {
                    request.setAttribute("users", users);
                    request.setAttribute("groups", groups);
                    request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomainuser.jsp").forward(request, response);
                }
                case "edit" -> {
                    request.setAttribute("users", users);
                    request.setAttribute("groups", groups);
                    int id = Integer.parseInt(request.getParameter("id"));
                    Group us = groupService.getDomainUserById(id);
                    request.setAttribute("us", us);
                    request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/editdomainuser.jsp").forward(request, response);
                }
                case "deactive", "active" -> {
                    int idU = Integer.parseInt(request.getParameter("id"));
                    groupService.UpdateStatusDomain(action, idU);
                    response.sendRedirect(request.getContextPath() + "/domain/domainuser");
                }
                default -> {
                    Integer dID;
                    String dIdRaw = request.getParameter("domainId");//lay parameter  domainId
                    if (dIdRaw == null) {
                        dID = (Integer) session.getAttribute("domainId");
                        if (dID == null) {
                            throw new ServletException("Some thing went wrong, cannot find the domain id");
                        }
                    } else {
                        dID = Integer.valueOf(dIdRaw);
                        session.setAttribute("domainId", dID);
                    }
                    GroupService service = new GroupService();
                    List<Group> domainUsers = service.getDomainUserByDomainId(dID);
                    request.setAttribute("domainUsers", domainUsers);
                    request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainuser.jsp").forward(request, response);
                }
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void DoaminCriteria(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = action != null ? action : "";
        CriteriaService cr = new CriteriaService();
        switch (action) {
            case "add" ->
                getEvalAdd(request, response);
            case "edit" ->
                postEvalUpdate(request, response);
            case "deactive", "active" -> {
                int idU = Integer.parseInt(request.getParameter("id"));
                cr.editStatusDomainEval(action, idU);
                response.sendRedirect(request.getContextPath() + "/domain/domaineval");
            }
            default -> {
                try {
                    getDomainEval(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(DomainConfigController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (null != action) {
            switch (action) {
                case "export" -> {
                    exportDomainUsersToExcel(request, response);
                    response.sendRedirect(request.getContextPath() + "/domain/domainuser?page=1");
                }
                case "import" -> {
                    importFromExcel(request);
                    response.sendRedirect(request.getContextPath() + "/domain/domainuser?page=1");
                }
                case "adddomainsetting" ->
                    this.addDomainSetting(request, response);
                case "editdomainsetting" ->
                    this.editDomainSetting(request, response);
                case "adddomainuser" ->
                    this.addDomainUser(request, response);
                case "editdomainuser" ->
                    this.editDomainUser(request, response);
                case "adddomaineval" ->
                    this.addDomainEval(request, response);
                case "editdomaineval" ->
                    this.editDomainEval(request, response);
                default -> {
                }
            }
        }
    }

    private void editDomainEval(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String weightStr = request.getParameter("weight");
            String statusStr = request.getParameter("status");
            String description = request.getParameter("description");
            int phase = Integer.parseInt(request.getParameter("phase"));
            
            HttpSession session = request.getSession();
            int domainId = (int) session.getAttribute("domainId");
            List<String> errors = new ArrayList<>();

            if (name == null || name.trim().isEmpty()) {
                errors.add("Criteria name is required.");
            }

            double weight = 0;
            try {
                weight = Double.parseDouble(weightStr);
                if (weight <= 0) {
                    errors.add("Weight must be greater than zero.");
                }
            } catch (NumberFormatException e) {
                errors.add("Invalid weight.");
            }

            int status = 1;
            try {
                status = Integer.parseInt(statusStr);
                if (status != 0 && status != 1) {
                    errors.add("Invalid status.");
                }
            } catch (NumberFormatException e) {
                errors.add("Invalid status.");
            }

          

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                this.postEvalUpdate(request, response);
                return;
            }

            Criteria criteria = new Criteria();
            criteria.setId(id);
            criteria.setPhase(new ProjectPhase(phase));
            criteria.setName(name);
            criteria.setWeight((int) weight);
            criteria.setStatus(status == 1);
            criteria.setDescription(description);
            CriteriaService service = new CriteriaService();
            service.editDomainEval(criteria);
            response.sendRedirect(request.getContextPath() + "/domain/domaineval");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void addDomainEval(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String name = request.getParameter("name");
            String weightStr = request.getParameter("weight");
            String statusStr = request.getParameter("status");
            int phase = Integer.parseInt(request.getParameter("phase"));
            String description = request.getParameter("description");
            int domainId = (int) session.getAttribute("domainId");

            List<String> errors = new ArrayList<>();

            if (name == null || name.trim().isEmpty()) {
                errors.add("Criteria name is required.");
            }

            double weight = 0;
            try {
                weight = Double.parseDouble(weightStr);
                if (weight <= 0) {
                    errors.add("Weight must be greater than zero.");
                }
            } catch (NumberFormatException e) {
                errors.add("Invalid weight.");
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                this.getEvalAdd(request, response);
                return;
            }

            Criteria criteria = new Criteria();
            criteria.setPhase(new ProjectPhase(phase));
            criteria.setName(name);
            criteria.setWeight((int) weight);
            criteria.setStatus(Boolean.parseBoolean(statusStr));
            criteria.setDescription(description);
            Group group = new Group();
            group.setId(domainId);
            criteria.setDomain(group);

            CriteriaService service = new CriteriaService();
            service.addDomainEval(criteria);
            response.sendRedirect(request.getContextPath() + "/domain/domaineval");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void addDomainUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            int userId = Integer.parseInt(request.getParameter("user"));
            Integer dID;
            String dIdRaw = request.getParameter("domainId");//lay parameter  domainId
            if (dIdRaw == null) {
                dID = (Integer) session.getAttribute("domainId");
                if (dID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the domain id");
                }
            } else {
                dID = Integer.valueOf(dIdRaw);
                session.setAttribute("domainId", dID);
            }
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            Group user = new Group();
            user.setUser(new User(userId));
            user.setId(dID);
            user.setStatus(status ? 1 : 0);
            GroupService groupService = new GroupService();
            groupService.addDomainUser(user);
            response.sendRedirect(request.getContextPath() + "/domain/domainuser");
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    private void editDomainUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int userId = Integer.parseInt(request.getParameter("user"));
            int domainId = Integer.parseInt(request.getParameter("domain"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            Group user = new Group();
            user.setId(id);
            user.setUser(new User());
            user.setParent(new Group());
            user.getUser().setId(userId);
            user.getParent().setId(domainId);
            user.setStatus(status ? 1 : 0);
            GroupService groupService = new GroupService();
            groupService.updateDomainUser(user);
            response.sendRedirect(request.getContextPath() + "/domain/domainuser");
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    private void addDomainSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String name = request.getParameter("name");
            String typeStr = request.getParameter("type");
            String priorityStr = request.getParameter("priority");
            String statusStr = request.getParameter("status");
            String description = request.getParameter("description");

            int domainId = (int) session.getAttribute("domainId");//lay parameter  domainId
            String errorMessage = null;
            if (name == null || name.trim().length() < 3) {
                errorMessage = "Name must be at least 3 characters long.";
            } else if (typeStr == null || !typeStr.matches("\\d+")) {
                errorMessage = "Type must be a valid number.";
            } else if (priorityStr == null || !priorityStr.matches("\\d+")) {
                errorMessage = "Priority must be a valid number.";
            } else if (statusStr == null || (!statusStr.equalsIgnoreCase("true") && !statusStr.equalsIgnoreCase("false"))) {
                errorMessage = "Status must be either 'true' or 'false'.";
            } else if (description == null || description.trim().isEmpty()) {
                errorMessage = "Description is required.";
            }
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomainsetting.jsp").forward(request, response);
                return;
            }
            Group group = new Group();
            group.setId(domainId);
            Setting st = new Setting(0, name, Integer.parseInt(typeStr), Integer.parseInt(priorityStr), Boolean.parseBoolean(statusStr), description);
            st.setDomain(group);
            SettingService settingService = new SettingService();

            settingService.addDomain(st);
            response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void editDomainSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String priorityStr = request.getParameter("priority");
            String statusStr = request.getParameter("status");
            String description = request.getParameter("description");
            int domainId = (int) session.getAttribute("domainId");
            String errorMessage = null;
            if (name == null || name.trim().length() < 3) {
                errorMessage = "Name must be at least 3 characters long.";
            }  else if (priorityStr == null || !priorityStr.matches("\\d+")) {
                errorMessage = "Priority must be a valid number.";
            } else if (statusStr == null || (!statusStr.equalsIgnoreCase("true") && !statusStr.equalsIgnoreCase("false"))) {
                errorMessage = "Status must be either 'true' or 'false'.";
            } else if (description == null || description.trim().isEmpty()) {
                errorMessage = "Description is required.";

            }

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                GroupService groupService = new GroupService();
                List<Group> groups = groupService.getAllDomains();
                request.setAttribute("groups", groups);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomainsetting.jsp").forward(request, response);
                return;
            }
            Setting st = new Setting(Integer.parseInt(id), name,  Integer.parseInt(priorityStr), Boolean.parseBoolean(statusStr), description);
            SettingService settingService = new SettingService();
            Group g = new Group();
            g.setId(domainId);
            st.setDomain(g);
            settingService.updateDomain(st);
            response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    public void exportDomainUsersToExcel(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            GroupService gservice = new GroupService();
            Integer dID;
            String dIdRaw = request.getParameter("domainId");//lay parameter  domainId
            if (dIdRaw == null) {
                dID = (Integer) request.getSession().getAttribute("domainId");
                if (dID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the domain id");
                }
            } else {
                dID = Integer.valueOf(dIdRaw);
                request.getSession().setAttribute("domainId", dID);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=domain_users.xlsx");

            List<Group> list = gservice.getDomainUserByDomainId(dID);
            Workbook workBook = gservice.exportDomainUser(list);
            OutputStream outputStream = response.getOutputStream();
            workBook.write(outputStream);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void importFromExcel(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("file");
        try (Workbook workbook = new XSSFWorkbook(filePart.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            GroupService service = new GroupService();
            for (Row row : sheet) {
                if (row.getRowNum() == 0) {
                    continue;
                }
                Group user = new Group();
                user.setUser(new User());
                user.setParent(new Group());
                user.setId((int) row.getCell(0).getNumericCellValue());
                user.getUser().setId((int) row.getCell(1).getNumericCellValue());
                user.getParent().setId((int) row.getCell(2).getNumericCellValue());
                user.getParent().setStatus((int) row.getCell(3).getNumericCellValue());
                service.addDomainUser(user);
            }
        } catch (Exception e) {
            throw new ServletException("Error importing data from Excel file", e);
        }

    }

    private void getEvalAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            ProjectService projectService = new ProjectService();
            //lay tu session
            Integer dID;
            String dIdRaw = request.getParameter("domainId");//lay parameter  domainId
            if (dIdRaw == null) {
                dID = (Integer) session.getAttribute("domainId");
                if (dID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the domain id");
                }
            } else {
                dID = Integer.valueOf(dIdRaw);
                session.setAttribute("domainId", dID);
            }
            List<ProjectPhase> projects = projectService.getAllProjectPharseByDomainId(dID);
            request.setAttribute("projectsphases", projects);
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomaineval.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }

    }

    private void postEvalUpdate(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        try {
            Integer dID;
            String dIdRaw = request.getParameter("domainId");//lay parameter  domainId
            if (dIdRaw == null) {
                dID = (Integer) session.getAttribute("domainId");
                if (dID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the domain id");
                }
            } else {
                dID = Integer.valueOf(dIdRaw);
                session.setAttribute("domainId", dID);
            }
            int id = Integer.parseInt(request.getParameter("id"));
            CriteriaService crService = new CriteriaService();
            Criteria criteria = crService.getDomainEvalById(id);
            ProjectService projectService = new ProjectService();
            List<ProjectPhase> projects = projectService.getAllProjectPharseByDomainId(dID);
            request.setAttribute("projects", projects);
            request.setAttribute("domainEval", criteria);
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/editdomaineval.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void getDomainEval(HttpServletRequest request, HttpServletResponse response) throws SQLException {
        CriteriaService dao = new CriteriaService();
        HttpSession session = request.getSession();
        try {
            Integer dID;
            String dIdRaw = request.getParameter("domainId");//lay parameter  domainId
            if (dIdRaw == null) {
                dID = (Integer) session.getAttribute("domainId");
                if (dID == null) {
                    throw new ServletException("Some thing went wrong, cannot find the domain id");
                }
            } else {
                dID = Integer.valueOf(dIdRaw);
                session.setAttribute("domainId", dID);
            }
            String searchName = request.getParameter("search");
            String filterStatus = request.getParameter("status");
            searchName = searchName != null ? searchName.trim() : null;
            filterStatus = filterStatus != null ? filterStatus.trim() : null;
            List<Criteria> criteriaList;

            criteriaList = dao.getDomainCriterriaByDomainId(dID);
            request.setAttribute("searchName", searchName);
            request.setAttribute("filterStatus", filterStatus);
            request.setAttribute("criteriaList", criteriaList);

            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domaineval.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            e.printStackTrace();
        }
    }

//    private void ProjectPhaseCriteria(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
//        String path = request.getServletPath().substring("/domain/".length());
//        CriteriaService cr = new CriteriaService();
//        switch (path) {
//            case "eval" -> {
//                String action = request.getParameter("action");
//                switch (action) {
//                    case "filter":
//                        postEvalFilter(request, response);
//                        break;
//                    case "changeStatus":
//                        postEvalFlipStatus(request, response);
//                        break;
//                    case "delete":
//                        postEvalDelete(request, response);
//                        break;
//                    case "add":
//                        getEvalAdd(request, response);
//                        break;
//                    case "update":
//                        postEvalUpdate(request, response);
//                        break;
//                    case "sort":
//                        postSortEval(request, response);
//                        break;
//                    case "deactive":
//                        break;
//                    case "active":
//                        int idU = Integer.parseInt(request.getParameter("id"));
//                        System.out.println(action);
//                        cr.editStatusDomainEval(action, idU);
//                        response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
//                        break;
//                    default: {
//                        getDomainEval(request, response);
//                    }
//                }
//            }
//
//            default ->
//                throw new AssertionError();
//        }
//        CriteriaDAO dao = new CriteriaDAO();
//        try {
//            String searchName = request.getParameter("search");
//            String filterStatus = request.getParameter("status");
//            searchName = searchName != null ? searchName.trim() : null;
//            filterStatus = filterStatus != null ? filterStatus.trim() : null;
//            List<Criteria> criteriaList;
//            criteriaList = dao.getAllCriteria(searchName, filterStatus);
//            request.setAttribute("searchName", searchName);
//            request.setAttribute("filterStatus", filterStatus);
//            request.setAttribute("criteriaList", criteriaList);
//            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainprojectphase.jsp").forward(request, response);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//    private void domaineval(HttpServletRequest request, HttpServletResponse response) {
//        CriteriaService service = new CriteriaService();
//        CriteriaService cr = new CriteriaService();
//        try {
//            String searchName = request.getParameter("search");
//            String filterStatus = request.getParameter("status");
//            searchName = searchName != null ? searchName.trim() : null;
//            filterStatus = filterStatus != null ? filterStatus.trim() : null;
//            List<Criteria> criteriaList;
//            criteriaList = service.getAllCriteria(searchName, filterStatus);
//            request.setAttribute("searchName", searchName);
//            request.setAttribute("filterStatus", filterStatus);
//            request.setAttribute("criteriaList", criteriaList);
//            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domaineval.jsp").forward(request, response);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
}
