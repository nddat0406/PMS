/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.GroupDAO;
import dal.SettingDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Group;
import model.Setting;
import model.User;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author DELL
 */
@WebServlet(name = "DomainConfigController", urlPatterns = {"/domain", "/domain/domainuser", "/domain/domainsetting"})
public class DomainConfigController extends HttpServlet {

    private GroupDAO gdao = new GroupDAO();
    String linkDomainUser = "/WEB-INF/view/user/domainConfig/domainuser.jsp";
    String linkSetting = "/WEB-INF/view/user/domainConfig/domainsetting.jsp";

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
            out.println("<title>Servlet DomainConfigController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DomainConfigController at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        action = action != null ? action : "";
        switch (action) {

            case "domainSetting":
                this.domainSetting(request, response);
                break;
            case "domainUser":
                this.domainUser(request, response);
                break;
            case "projectPhaseCriteria":
//                this.ProjectPhaseCriteria(request, response);
                break;
            
           
             default:
                this.domainSetting(request, response);
                break;

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

        if ("export".equals(action)) {
            exportDomainUsersToExcel(response);
        } else if ("import".equals(action)) {
            importFromExcel(request);
        }
        response.sendRedirect("DomainConfigController?action=domainUser");
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

    private void domainSetting(HttpServletRequest request, HttpServletResponse response) {
        try {
            String searchName = request.getParameter("search");
            String filterStatus = request.getParameter("status");
            String type = request.getParameter("type");
            SettingDAO dao = new SettingDAO();
            searchName = searchName != null ? searchName.trim() : null;
            filterStatus = filterStatus != null ? filterStatus.trim() : null;
            List<Setting> domainSettings;
            domainSettings = dao.getFilteredDomainSettings(type, filterStatus, searchName);
            request.setAttribute("searchName", searchName);
            request.setAttribute("filterStatus", filterStatus);
            request.setAttribute("type", type);
            request.setAttribute("domainSettings", domainSettings);
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainsetting.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void domainUser(HttpServletRequest request, HttpServletResponse response) {
        try {
            GroupDAO dao = new GroupDAO();
            List<Group> domainUsers = dao.getDomainUser();
            request.setAttribute("domainUsers", domainUsers);
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainuser.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void ProjectPhaseCriteria(HttpServletRequest request, HttpServletResponse response) {
//        ProjectPhaseCriteriaDAO dao = new ProjectPhaseCriteriaDAO();
//        try {
//            String searchName = request.getParameter("search");
//            String filterStatus = request.getParameter("status");
//            searchName = searchName != null ? searchName.trim() : null;
//            filterStatus = filterStatus != null ? filterStatus.trim() : null;
//            List<ProjectPhaseCriteria> criteriaList;
//            if (filterStatus != null && !filterStatus.isBlank()) {
//                criteriaList = dao.filterCriteria(filterStatus, searchName);
//            } else
//            if (searchName != null && !searchName.isEmpty()) {
//                criteriaList = dao.searchCriteriaByName(searchName);
//            }
//            else {
//                criteriaList = dao.getAllCriteria();
//            }
//            request.setAttribute("searchName", searchName);
//            request.setAttribute("filterStatus", filterStatus);
//            request.setAttribute("criteriaList", criteriaList);
//            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/domainprojectphase.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
    }

    private void exportDomainUsersToExcel(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=domain_users.xlsx");
        response.setCharacterEncoding("UTF-8");
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Domain Users");

        Row headerRow = sheet.createRow(0);
        String[] headers = {"ID", "Username", "Email", "Phone", "Domain", "Status"};

        CellStyle headerCellStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerCellStyle.setFont(headerFont);

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerCellStyle);
        }
        GroupDAO dao = new GroupDAO();
        List<Group> domainUsers = dao.getDomainUser();
        int rowNum = 1;
        for (Group user : domainUsers) {
            Row row = sheet.createRow(rowNum++);

            row.createCell(0).setCellValue(user.getId());
            row.createCell(1).setCellValue(user.getUser().getFullname());
            row.createCell(2).setCellValue(user.getUser().getEmail());
            row.createCell(3).setCellValue(user.getUser().getMobile());
            row.createCell(4).setCellValue(user.getParent().getName());

            String status = "Unknown";
            if (user.getParent().getStatus() == 1) {
                status = "Active";
            } else if (user.getParent().getStatus() == 0) {
                status = "Inactive";
            }
            row.createCell(5).setCellValue(status);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        try {
            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
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
            GroupDAO dao = new GroupDAO();
            for (Row row : sheet) {
                if (row.getRowNum() == 0) {
                    continue;
                }
                Group user = new Group();
                user.setId((int) row.getCell(0).getNumericCellValue());
                user.getUser().setId(Integer.parseInt(row.getCell(1).getStringCellValue()));
                user.getParent().setId((int) row.getCell(2).getNumericCellValue());
                user.setStatus(Integer.parseInt(row.getCell(3).getStringCellValue()));
                dao.addDomainUser(user);
            }
        } catch (Exception e) {
            throw new ServletException("Error importing data from Excel file", e);
        }
    }
}

