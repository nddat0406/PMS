/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Setting;
import service.SettingService;

@WebServlet(
        name = "SettingController",
        urlPatterns = {"/settings", "/settings/add", "/settings/edit", "/settings/list"}
)
public class SettingController extends HttpServlet {

    private SettingService settingService = new SettingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    paginateList(request, response);
                    break;
                case "add":
                    handleAdd(request, response);
                    break;
                case "edit":
                    handleEdit(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Setting ID");
        } catch (ServletException | IOException | SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            switch (action) {
                case "update" ->
                    handleUpdate(request, response);
                case "add" ->
                    handleAddSetting(request, response);
                case "change" ->
                    handleChange(request, response);
                case "filter" ->
                    paginateListWithFilter(request, response);
                case "search" ->
                    handleSearch(request, response);
                default ->
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException ex) {
            Logger.getLogger(SettingController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void handleChange(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int idSettingCheck = Integer.parseInt(request.getParameter("idSettingCheck"));
        settingService.changeSetting(id,idSettingCheck);
        paginateList(request, response);
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int editId = Integer.parseInt(request.getParameter("id"));
        Setting settingToEdit = settingService.getSettingDetail(editId);

        request.setAttribute("settings", settingToEdit);
        request.getRequestDispatcher("/WEB-INF/view/admin/SettingDetails.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/admin/SettingDetails.jsp").forward(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Setting> searchResults = settingService.searchSettings(keyword);
        request.setAttribute("listS", searchResults);
        request.getRequestDispatcher("/WEB-INF/view/admin/SettingList.jsp").forward(request, response);
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int updateId = Integer.parseInt(request.getParameter("id"));
        String updateName = request.getParameter("name");
        int updateType = Integer.parseInt(request.getParameter("type"));
        int updatePriority = Integer.parseInt(request.getParameter("priority"));
        boolean updateStatus = request.getParameter("status").equals("1");
        String updateDescription = request.getParameter("description");

        try {
            settingService.updateSetting(updateId, updateName, updateType, updatePriority, updateStatus, updateDescription);
            paginateList(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            Setting settingToEdit = settingService.getSettingDetail(updateId);
            request.setAttribute("settingDetail", settingToEdit);
            request.getRequestDispatcher("/WEB-INF/view/admin/SettingList.jsp").forward(request, response);
        }
    }

    private void handleAddSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String addName = request.getParameter("name");
        int addType = Integer.parseInt(request.getParameter("type"));
        int addPriority = Integer.parseInt(request.getParameter("priority"));
        boolean addStatus = request.getParameter("status").equals("1");
        String addDescription = request.getParameter("description");

        try {
            if (settingService.isNameOrTypeDuplicate(addName, addType)) {
                request.setAttribute("errorMessage", "Setting name or type already exists!");
                prepareAddRequest(request, addName, addType, addPriority, addStatus, addDescription);
                request.getRequestDispatcher("/WEB-INF/view/admin/AddSetting.jsp").forward(request, response);
            } else {
                settingService.addSetting(addName, addType, addPriority, addStatus, addDescription);
                paginateList(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            prepareAddRequest(request, addName, addType, addPriority, addStatus, addDescription);
            request.getRequestDispatcher("/WEB-INF/view/admin/AddSetting.jsp").forward(request, response);
        }
    }

    private void prepareAddRequest(HttpServletRequest request, String name, int type, int priority, boolean status, String description) {
        request.setAttribute("name", name);
        request.setAttribute("type", type);
        request.setAttribute("priority", priority);
        request.setAttribute("status", status);
        request.setAttribute("description", description);
    }

    private void paginateList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int pageNumber = getPageNumber(request);
        int pageSize = 6;
        List<Setting> listS = settingService.getAllSettings();
        request.setAttribute("listS", listS);
        request.setAttribute("currentPage", pageNumber);
        request.getRequestDispatcher("/WEB-INF/view/admin/SettingList.jsp").forward(request, response);
    }

    private void paginateListWithFilter(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int pageNumber = getPageNumber(request);
        int pageSize = 6;

        // Lấy các tham số filter từ request
        String filterType = request.getParameter("filterType");
        String filterStatus = request.getParameter("filterStatus");
        String keyword = request.getParameter("keywordPri");

        // Lọc danh sách settings
        List<Setting> filteredList = settingService.filterSettings(filterType, filterStatus, keyword);

        // Set các giá trị filter và danh sách filtered vào request
        request.setAttribute("listS", filteredList);
        request.setAttribute("filterType", filterType);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", pageNumber);

        // Forward đến trang SettingList.jsp để hiển thị kết quả lọc
        request.getRequestDispatcher("/WEB-INF/view/admin/SettingList.jsp").forward(request, response);
    }

    private int getPageNumber(HttpServletRequest request) {
        String pageParam = request.getParameter("page");
        return (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    }
}
