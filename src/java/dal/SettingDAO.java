/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Admin
 */

import model.Setting;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SettingDAO extends BaseDAO {

public List<Setting> getAllSettings() throws SQLException {
    List<Setting> settingsList = new ArrayList<>();
    String sql = "SELECT * FROM setting";

    // Sử dụng try-with-resources để tự động đóng tài nguyên
    try (Connection conn = getConnection();
         PreparedStatement pre = conn.prepareStatement(sql);
         ResultSet rs = pre.executeQuery()) {

        while (rs.next()) {
            Setting setting = new Setting();
            setting.setId(rs.getInt("id"));
            setting.setName(rs.getString("name"));
            setting.setType(rs.getInt("type"));
            setting.setPriority(rs.getInt("priority"));

            // Nếu cột status trong DB là INT hoặc TINYINT
            int status = rs.getInt("status");
            setting.setStatus(status == 1); // Chuyển đổi từ INT sang boolean (1 = true, 0 = false)

            setting.setDescription(rs.getString("description"));

            settingsList.add(setting);
        }

    } catch (SQLException e) {
        // Quăng ngoại lệ với thông tin lỗi chi tiết hơn
        throw new SQLException("Error fetching settings: " + e.getMessage(), e);
    }

    return settingsList;
}

    // Thêm mới setting
    public int addSetting(Setting setting) throws SQLException {
        String sql = "INSERT INTO setting (name, type, priority, status, description) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, setting.getName());
            ps.setInt(2, setting.getType());
            ps.setInt(3, setting.getPriority());
            ps.setBoolean(4, setting.isStatus());
            ps.setString(5, setting.getDescription());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Cập nhật setting
    public int updateSetting(Setting setting) throws SQLException {
        String sql = "UPDATE setting SET name = ?, type = ?, priority = ?, status = ?, description = ? WHERE id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, setting.getName());
            ps.setInt(2, setting.getType());
            ps.setInt(3, setting.getPriority());
            ps.setBoolean(4, setting.isStatus());
            ps.setString(5, setting.getDescription());
            ps.setInt(6, setting.getId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Xóa setting theo ID
    public int deleteSetting(int settingID) throws SQLException {
        String sql = "DELETE FROM setting WHERE id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, settingID);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Lấy Setting theo ID
    public Setting getSettingById(int id) throws SQLException {
        String sql = "SELECT * FROM setting WHERE id = ?";
        Setting setting = null;
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                setting = new Setting();
                setting.setId(rs.getInt("id"));
                setting.setName(rs.getString("name"));
                setting.setType(rs.getInt("type"));
                setting.setPriority(rs.getInt("priority"));
                setting.setStatus(rs.getBoolean("status"));
                setting.setDescription(rs.getString("description"));
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return setting;
    }

// Lọc settings theo type, status, và keyword
public List<Setting> getFilteredSettings(String filterType, String filterStatus, String keyword) throws SQLException {
    List<Setting> settings = new ArrayList<>();
    StringBuilder sql = new StringBuilder("SELECT * FROM setting WHERE 1=1");

    if (filterType != null && !filterType.isEmpty()) {
        sql.append(" AND type = ?");
    }

    if (filterStatus != null && !filterStatus.isEmpty()) {
        sql.append(" AND status = ?");
    }

    if (keyword != null && !keyword.isEmpty()) {
        sql.append(" AND name LIKE ?");
    }

    try (PreparedStatement stmt = getConnection().prepareStatement(sql.toString())) {
        int index = 1;

        if (filterType != null && !filterType.isEmpty()) {
            stmt.setInt(index++, Integer.parseInt(filterType));
        }

        if (filterStatus != null && !filterStatus.isEmpty()) {
            stmt.setInt(index++, Integer.parseInt(filterStatus));
        }

        if (keyword != null && !keyword.isEmpty()) {
            stmt.setString(index++, "%" + keyword + "%");
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Setting setting = new Setting();
            setting.setId(rs.getInt("id"));
            setting.setName(rs.getString("name"));
            setting.setType(rs.getInt("type"));
            setting.setPriority(rs.getInt("priority"));
            setting.setStatus(rs.getBoolean("status"));
            setting.setDescription(rs.getString("description"));
            settings.add(setting);
        }
    }
    return settings;
}

}
