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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Group;

public class SettingDAO extends BaseDAO {

    private GroupDAO gdao = new GroupDAO();

    public List<Setting> getAllSettings() throws SQLException {
        List<Setting> settingsList = new ArrayList<>();
        String sql = "SELECT * FROM setting";

        // Sử dụng try-with-resources để tự động đóng tài nguyên
        try {
            PreparedStatement pre = getConnection().prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
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
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
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
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
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

    // Thay đổi trạng thái
    public int changeSetting(int id, int idSetting) throws SQLException {
        String sql = "UPDATE setting SET status = ? WHERE id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, idSetting);
            ps.setInt(2, id);

            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Xóa setting theo ID
    public int deleteSetting(int settingID) throws SQLException {
        String sql = "DELETE FROM setting WHERE id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
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
            sql.append(" AND priority = ?");
        }

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql.toString());
            int index = 1;

            if (filterType != null && !filterType.isEmpty()) {
                stmt.setInt(index++, Integer.parseInt(filterType));
            }

            if (filterStatus != null && !filterStatus.isEmpty()) {
                stmt.setInt(index++, Integer.parseInt(filterStatus));
            }

            if (keyword != null && !keyword.isEmpty()) {
                stmt.setInt(index++, Integer.parseInt(keyword));
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
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return settings;
    }

    public static void main(String[] args) {
        SettingDAO d = new SettingDAO();
        try {
            System.out.println(d.getSearchSettings("ROI"));

        } catch (SQLException ex) {
            Logger.getLogger(SettingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public List<Setting> getSearchSettings(String keyword) throws SQLException {
        List<Setting> settings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM setting WHERE 1=1");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND name like ?");
        }

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql.toString());
            int index = 1;

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
        } catch (SQLException e) {
            throw new SQLException(e);
        }
        return settings;
    }

    public List<Setting> getFilteredDomainSettings(String filterType, String filterStatus, String keyword) throws SQLException {
        List<Setting> settings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM domain_setting WHERE 1=1");

        if (filterType != null && !filterType.isEmpty()) {
            sql.append(" AND type = ?");
        }

        if (filterStatus != null && !filterStatus.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND priority = ?");
        }

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql.toString());
            int index = 1;

            if (filterType != null && !filterType.isEmpty()) {
                stmt.setInt(index++, Integer.parseInt(filterType));
            }

            if (filterStatus != null && !filterStatus.isEmpty()) {
                stmt.setInt(index++, Integer.parseInt(filterStatus));
            }

            if (keyword != null && !keyword.isEmpty()) {
                stmt.setInt(index++, Integer.parseInt(keyword));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Setting setting = new Setting();
                setting.setId(rs.getInt("id"));
                setting.setName(rs.getString("name"));
                setting.setType(rs.getInt("type"));
                setting.setPriority(rs.getInt("priority"));
                setting.setStatus(rs.getBoolean("status"));
                setting.setDomain(new Group(gdao.getDeptNameById(rs.getInt("domainId"))));
                settings.add(setting);
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }
        return settings;
    }

    // lấy bizterm cho project list vs project detail
    public List<Setting> getAllBizTerms() throws SQLException {
        List<Setting> bizTerms = new ArrayList<>();
        String sql = "SELECT id, name FROM setting WHERE type = 1 AND status = 1";

        try {
            PreparedStatement statement = getConnection().prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Setting setting = new Setting();
                setting.setId(resultSet.getInt("id"));
                setting.setName(resultSet.getString("name"));
                bizTerms.add(setting);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bizTerms;

    }

    public Setting geDomaintById(int id) {
        String sql = "SELECT * FROM domain_setting WHERE id = ?";
        Setting setting = null;

        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                setting = new Setting();
                setting.setId(rs.getInt("id"));
                setting.setName(rs.getString("name"));
                setting.setType(rs.getInt("type"));
                setting.setDescription(rs.getString("details"));
                setting.setPriority(rs.getInt("priority"));
                setting.setStatus(rs.getBoolean("status"));
                setting.setDomain(new Group(gdao.getDeptNameById(rs.getInt("domainId"))));
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }

        return setting;
    }

    public void updateStatusDomain(String domain, int domainId) {
        String sql = "UPDATE domain_setting SET status = ? WHERE id = ?";
        try {
            PreparedStatement statement = getConnection().prepareStatement(sql);
            statement.setBoolean(1, domain.equals("active"));
            statement.setInt(2, domainId);
            statement.executeUpdate();
        } catch (SQLException e) {

        }
    }

    public void deleteDomain(int id) {
        String sql = "DELETE FROM domain_setting WHERE id = ?";
        try {
            PreparedStatement statement = getConnection().prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {

        }
    }

  public void addDomain(Setting domain) throws SQLException {
        String sql = "INSERT INTO domain_setting (name, type, priority, status, details, domainId, id) VALUES (?,?, ?, ?, ?, ?, ?)";
        int newId = getMaxId() + 1;
        try {
            PreparedStatement statement = getConnection().prepareStatement(sql);
            statement.setString(1, domain.getName());
            statement.setInt(2, domain.getType());
            statement.setInt(3, domain.getPriority());
            statement.setBoolean(4, domain.isStatus());
            statement.setString(5, domain.getDescription());
            statement.setInt(6, domain.getDomain().getId());
            statement.setInt(7, newId);
            statement.executeUpdate();
        }catch(SQLException e){
            
        }
    }

    public void updateDomain(Setting domain) throws SQLException {
        String sql = "UPDATE domain_setting SET name = ?, type = ?, priority = ?, status = ?, details = ?, domainId = ? WHERE id = ?";
        try {
            PreparedStatement statement = getConnection().prepareStatement(sql);
            statement.setString(1, domain.getName());
            statement.setInt(2, domain.getType());
            statement.setInt(3, domain.getPriority());
            statement.setBoolean(4, domain.isStatus());
            statement.setString(5, domain.getDescription());
            statement.setInt(6, domain.getDomain().getId());
            statement.setInt(7, domain.getId());
            statement.executeUpdate();
        }catch(SQLException e){
            
        }
    }

     public int getMaxId() throws SQLException {
        String sql = "SELECT MAX(id) FROM domain_setting";
        try {
            PreparedStatement statement = getConnection().prepareStatement(sql);
               
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        }catch(SQLException e){
            
        }
        return 0;
    }
}
