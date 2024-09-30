/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import dal.SettingDAO;
import model.Setting;
import java.sql.SQLException;
import java.util.List;

/**
 * Service layer for handling operations related to Settings
 */
public class SettingService {

    private SettingDAO settingDAO;

    // Constructor
    public SettingService() {
        this.settingDAO = new SettingDAO();
    }

    // Lấy tất cả các settings
    public List<Setting> getAllSettings() throws SQLException {
        try {
            return settingDAO.getAllSettings();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    // Thêm setting mới
    public boolean addSetting(String name, int type, int priority, boolean status, String description) throws SQLException {
        Setting setting = new Setting();
        setting.setName(name);
        setting.setType(type);
        setting.setPriority(priority);
        setting.setStatus(status);
        setting.setDescription(description);
        int rowsAffected = settingDAO.addSetting(setting);
        return rowsAffected > 0;
    }

    // Cập nhật setting theo ID
    public boolean updateSetting(int id, String name, int type, int priority, boolean status, String description) throws SQLException {
        Setting setting = new Setting(id, name, type, priority, status, description);
        int rowsAffected = settingDAO.updateSetting(setting);
        return rowsAffected > 0;
    }

    // Xóa setting theo ID
    public boolean deleteSetting(int settingID) throws SQLException {
        int rowsAffected = settingDAO.deleteSetting(settingID);
        return rowsAffected > 0;
    }

    // Lấy chi tiết setting theo ID
    public Setting getSettingDetail(int settingID) throws SQLException {
        try {
            return settingDAO.getSettingById(settingID);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

// Lọc danh sách settings theo type, status, và keyword
public List<Setting> filterSettings(String filterType, String filterStatus, String keyword) throws SQLException {
    // Nếu filterType null hoặc rỗng, bỏ qua điều kiện lọc theo type
    if (filterType == null || filterType.trim().isEmpty()) {
        filterType = null;  // Truyền null để bỏ qua trong DAO
    }

    // Nếu filterStatus null hoặc rỗng, bỏ qua điều kiện lọc theo status
    if (filterStatus == null || filterStatus.trim().isEmpty()) {
        filterStatus = null;  // Truyền null để bỏ qua trong DAO
    }

    // Nếu keyword null hoặc rỗng, bỏ qua điều kiện lọc theo keyword
    if (keyword == null || keyword.trim().isEmpty()) {
        keyword = null;  // Truyền null để bỏ qua trong DAO
    }

    // Gọi phương thức DAO để lấy danh sách settings sau khi lọc
    return settingDAO.getFilteredSettings(filterType, filterStatus, keyword);
}

    // Tìm kiếm settings theo từ khóa
    public List<Setting> searchSettings(String keyword) throws SQLException {
        return filterSettings(null, null, keyword);
    }

    // Kiểm tra trùng lặp name hoặc type
    public boolean isNameOrTypeDuplicate(String name, int type) throws SQLException {
        List<Setting> settings = filterSettings(String.valueOf(type), null, name);
        return !settings.isEmpty();  // Trả về true nếu có setting trùng lặp
    }
}