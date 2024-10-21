/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CriteriaDAO;
import dal.GroupDAO;
import dal.SettingDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Criteria;
import model.Group;
import model.Project;
import model.Setting;
import model.User;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
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
@WebServlet(name = "DomainConfigController", urlPatterns = {"/domain", "/domain/domainuser", "/domain/domainsetting", "/domain/projectphasecriteria", "/domain/domaineval"})

@MultipartConfig
public class DomainConfigController extends HttpServlet {

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
        String action = request.getRequestURI();
        String contextPath = request.getContextPath();
        action = action.replace(contextPath, "").toLowerCase();
        switch (action) {
            case "/domain/domainsetting": {
                try {
                    this.domainSetting(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(DomainConfigController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            break;

            case "/domain/domainuser": {
                try {
                    this.domainUser(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(DomainConfigController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            break;

            case "/domain/domaineval":
                this.domaineval(request, response);
                break;

            default: {
                try {
                    this.domainSetting(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(DomainConfigController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

        }
    }

    private void domainSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String action = request.getParameter("action");
        action = action != null ? action : "";
        GroupService groupService = new GroupService();
        SettingService settingService = new SettingService();
        List<Group> groups = groupService.getAllDomains();
        switch (action) {
            case "add":
                request.setAttribute("groups", groups);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomainsetting.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                Setting st = settingService.geDomaintById(id);
                request.setAttribute("setting", st);
                request.setAttribute("groups", groups);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/editdomainsetting.jsp").forward(request, response);
                break;
            case "deactive":
            case "active":
                int idU = Integer.parseInt(request.getParameter("id"));
                settingService.updateStatusDomain(action, idU);
                response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
                break;
            case "delete":
                int idUD = Integer.parseInt(request.getParameter("id"));
                settingService.deleteDomain(idUD);
                response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
                break;
            default:
                try {
                String searchName = request.getParameter("search");
                String filterStatus = request.getParameter("status");
                String type = request.getParameter("type");
                SettingService se = new SettingService();
                searchName = searchName != null ? searchName.trim() : null;
                filterStatus = filterStatus != null ? filterStatus.trim() : null;
                List<Setting> domainSettings;
                domainSettings = se.getFilteredDomainSettings(type, filterStatus, searchName);
                request.setAttribute("searchName", searchName);
                request.setAttribute("filterStatus", filterStatus);
                request.setAttribute("type", type);
                request.setAttribute("domainSettings", domainSettings);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainsetting.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void domainUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String action = request.getParameter("action");
        action = action != null ? action : "";
        UserService userService = new UserService();
        GroupService groupService = new GroupService();
        List<User> users = userService.getAll();
        List<Group> groups = groupService.getAllDomains();
        switch (action) {
            case "add":
                request.setAttribute("users", users);
                request.setAttribute("groups", groups);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomainuser.jsp").forward(request, response);
                break;
            case "edit":
                request.setAttribute("users", users);
                request.setAttribute("groups", groups);
                int id = Integer.parseInt(request.getParameter("id"));
                Group us = groupService.getDomainUserById(id);
                request.setAttribute("us", us);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/editdomainuser.jsp").forward(request, response);
                break;
            case "deactive":
            case "active":
                int idU = Integer.parseInt(request.getParameter("id"));
                groupService.UpdateStatusDomain(action, idU);
                response.sendRedirect(request.getContextPath() + "/domain/domainuser");
                break;
            case "delete":
                int idUD = Integer.parseInt(request.getParameter("id"));
                groupService.deleteDomainUser(idUD);
                response.sendRedirect(request.getContextPath() + "/domain/domainuser");
                break;
            default:

                GroupService service = new GroupService();
                List<Group> domainUsers = service.getDomainUser();
                request.setAttribute("domainUsers", domainUsers);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainuser.jsp").forward(request, response);
        }
    }

    private void ProjectPhaseCriteria(HttpServletRequest request, HttpServletResponse response) {
        String path = request.getServletPath().substring("/domain/".length());
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
                        getDomainEval(request, response);
                    }
                }
            }

            default ->
                throw new AssertionError();
        }
        CriteriaDAO dao = new CriteriaDAO();
        try {
            String searchName = request.getParameter("search");
            String filterStatus = request.getParameter("status");
            searchName = searchName != null ? searchName.trim() : null;
            filterStatus = filterStatus != null ? filterStatus.trim() : null;
            List<Criteria> criteriaList;
            criteriaList = dao.getAllCriteria(searchName, filterStatus);
            request.setAttribute("searchName", searchName);
            request.setAttribute("filterStatus", filterStatus);
            request.setAttribute("criteriaList", criteriaList);

            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainprojectphase.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void domaineval(HttpServletRequest request, HttpServletResponse response) {
        CriteriaService service = new CriteriaService();
        try {
            String searchName = request.getParameter("search");
            String filterStatus = request.getParameter("status");
            searchName = searchName != null ? searchName.trim() : null;
            filterStatus = filterStatus != null ? filterStatus.trim() : null;
            List<Criteria> criteriaList;
            criteriaList = service.getAllCriteria(searchName, filterStatus);
            request.setAttribute("searchName", searchName);
            request.setAttribute("filterStatus", filterStatus);
            request.setAttribute("criteriaList", criteriaList);
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domaineval.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void DoaminCriteria(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String action = request.getParameter("action");
        action = action != null ? action : "";
        CriteriaService cr = new CriteriaService();
        switch (action) {
            case "filter":
                postEvalFilterDomain(request, response);
            case "changeStatus":
                postEvalFlipStatusDomain(request, response);
            case "delete":
                postEvalDeleteDomain(request, response);
            case "add":
                postEvalAddDomain(request, response);
            case "update":
                postEvalUpdateDomain(request, response);
            case "sort":
                postSortEvalDomain(request, response);
            case "deactive":
            case "active":
                int idU = Integer.parseInt(request.getParameter("id"));
                System.out.println(action);
                cr.editStatusDomainEval(action, idU);
                response.sendRedirect(request.getContextPath() + "/domain/domaineval");
                break;
            default: {
                getDomainEval(request, response);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("export".equals(action)) {
            exportDomainUsersToExcel(response);
            response.sendRedirect("domain/domainuser?page=1");
        } else if ("import".equals(action)) {
            importFromExcel(request);
            response.sendRedirect("domain/domainuser?page=1");
        } else if ("adddomainsetting".equals(action)) {
            this.addDomainSetting(request, response);
        } else if ("editdomainsetting".equals(action)) {
            this.editDomainSetting(request, response);
        } else if ("adddomainuser".equals(action)) {
            this.addDomainUser(request, response);
        } else if ("editdomainuser".equals(action)) {
            this.editDomainUser(request, response);
        }
    }

    public void exportDomainUsersToExcel(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=domain_users.xlsx");
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Domain Users");

        // Create header row
        String[] headers = {"ID", "Username", "Email", "Phone", "Domain", "Status"};
        Row headerRow = sheet.createRow(0);
        CellStyle headerCellStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerCellStyle.setFont(headerFont);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerCellStyle);
        }

        // Fetch domain users and write to Excel
        GroupService service = new GroupService();
        List<Group> domainUsers = service.getDomainUser();
        int rowNum = 1;
        for (Group user : domainUsers) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(user.getId());
            row.createCell(1).setCellValue(user.getUser().getFullname());
            row.createCell(2).setCellValue(user.getUser().getEmail());
            row.createCell(3).setCellValue(user.getUser().getMobile());
            row.createCell(4).setCellValue(user.getParent().getName());
            String status = user.getParent().getStatus() == 1 ? "Active" : "Inactive";
            row.createCell(5).setCellValue(status);
        }

        // Autosize columns
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        // Write Excel file to response
        try (ServletOutputStream out = response.getOutputStream()) {
            workbook.write(out);
            out.flush();
        } catch (IOException e) {
            throw new IOException("Error while writing Excel data to output stream", e);
        } finally {
            workbook.close();
        }
    }

    private void importFromExcel(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("file");
        try (Workbook workbook = new XSSFWorkbook(filePart.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            GroupService service = new GroupService();

            for (Row row : sheet) {
                if (row.getRowNum() == 0) {
                    continue; // Skip header row
                }

                Group group = new Group();
                group.setUser(new User());
                group.setParent(new Group());

                // Reading and setting data from Excel to Group object
                if (row.getCell(0) != null) {
                    group.setId((int) row.getCell(0).getNumericCellValue());
                }

                if (row.getCell(1) != null) {
                    group.getUser().setFullname(row.getCell(1).getStringCellValue());
                }

                if (row.getCell(2) != null) {
                    group.getUser().setEmail(row.getCell(2).getStringCellValue());
                }

                if (row.getCell(3) != null) {
                    group.getUser().setMobile(row.getCell(3).getStringCellValue());
                }

                if (row.getCell(4) != null) {
                    group.getParent().setName(row.getCell(4).getStringCellValue());
                }

                if (row.getCell(5) != null) {
                    group.getParent().setStatus((int) row.getCell(5).getNumericCellValue());
                }

                // Add group to the database using service
                service.addDomainUser(group);
            }
        } catch (Exception e) {
            throw new ServletException("Error importing data from Excel file", e);
        }

    }

    private void postEvalFilter(HttpServletRequest request, HttpServletResponse response) {

    }

    private void postEvalFlipStatus(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void postEvalDelete(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void postEvalAdd(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void postEvalUpdate(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void postSortEval(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }


    private void domainEval(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void addDomainUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("user"));
            int domainId = Integer.parseInt(request.getParameter("domain"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            Group user = new Group();
            user.setUser(new User());
            user.setParent(new Group());
            user.getUser().setId(userId);
            user.getParent().setId(domainId);
            user.setStatus(status ? 1 : 0);
            GroupService groupService = new GroupService();
            user.setId(groupService.getLatestId());
            groupService.addDomainUser(user);
            response.sendRedirect(request.getContextPath() + "/domain/domainuser");
        } catch (Exception e) {
            System.out.println("Error: " + e);
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
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void addDomainSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String typeStr = request.getParameter("type");
            String priorityStr = request.getParameter("priority");
            String statusStr = request.getParameter("status");
            String description = request.getParameter("description");
            String domainStr = request.getParameter("domain");
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
            } else if (domainStr == null || !domainStr.matches("\\d+")) {
                errorMessage = "Domain ID must be a valid number.";
            }

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                GroupService groupService = new GroupService();
                List<Group> groups = groupService.getAllDomains();
                request.setAttribute("groups", groups);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomainsetting.jsp").forward(request, response);
                return;
            }
            Setting st = new Setting(0, name, Integer.parseInt(typeStr), Integer.parseInt(priorityStr), Boolean.parseBoolean(statusStr), description);
            SettingService settingService = new SettingService();
            Group g = new Group();
            g.setId(Integer.parseInt(domainStr));
            st.setDomain(g);
            settingService.addDomain(st);
            response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void editDomainSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String typeStr = request.getParameter("type");
            String priorityStr = request.getParameter("priority");
            String statusStr = request.getParameter("status");
            String description = request.getParameter("description");
            String domainStr = request.getParameter("domain");
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
            } else if (domainStr == null || !domainStr.matches("\\d+")) {
                errorMessage = "Domain ID must be a valid number.";
            }

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                GroupService groupService = new GroupService();
                List<Group> groups = groupService.getAllDomains();
                request.setAttribute("groups", groups);
                request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomainsetting.jsp").forward(request, response);
                return;
            }
            Setting st = new Setting(Integer.parseInt(id), name, Integer.parseInt(typeStr), Integer.parseInt(priorityStr), Boolean.parseBoolean(statusStr), description);
            SettingService settingService = new SettingService();
            Group g = new Group();
            g.setId(Integer.parseInt(domainStr));
            st.setDomain(g);
            settingService.updateDomain(st);
            response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void postEvalFilterDomain(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void postEvalFlipStatusDomain(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void postEvalDeleteDomain(HttpServletRequest request, HttpServletResponse response) {
        CriteriaService cr = new CriteriaService();
        try {
            int idUD = Integer.parseInt(request.getParameter("id"));
            cr.deleteDomainEval(idUD);
            response.sendRedirect(request.getContextPath() + "/domain/domainsetting");
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void postEvalAddDomain(HttpServletRequest request, HttpServletResponse response) {
        try {
            ProjectService projectService = new ProjectService();
            List<Project> projects = projectService.getAllProjectPharse();
            request.setAttribute("projects", projects);
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/adddomaineval.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error: " + e);
        }
    }

    private void postEvalUpdateDomain(HttpServletRequest request, HttpServletResponse response) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CriteriaService crService = new CriteriaService();
            Criteria criteria = crService.getDomainEvalById(id);
            ProjectService projectService = new ProjectService();
            List<Project> projects = projectService.getAllProjectPharse();
            request.setAttribute("projects", projects);
            request.setAttribute("domainEval", criteria);
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/editdomaineval.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void postSortEvalDomain(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
     private void getDomainEval(HttpServletRequest request, HttpServletResponse response) {
        CriteriaDAO dao = new CriteriaDAO();
        try {
            String searchName = request.getParameter("search");
            String filterStatus = request.getParameter("status");
            searchName = searchName != null ? searchName.trim() : null;
            filterStatus = filterStatus != null ? filterStatus.trim() : null;
            List<Criteria> criteriaList;
            criteriaList = dao.getAllCriteriaPhase(searchName, filterStatus);
            request.setAttribute("searchName", searchName);
            request.setAttribute("filterStatus", filterStatus);
            request.setAttribute("criteriaList", criteriaList);
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domaineval.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
