/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Allocation;
import model.User;

/**
 *
 * @author ASUS TUF
 */
public class AllocationDAO extends BaseDAO {

    public List<Allocation> getAllocationsByProjectId(int projectId) {
        List<Allocation> allocations = new ArrayList<>();
        String query = "SELECT a.*, u.fullname AS userFullname, u.email AS userEmail "
                + "FROM allocation a "
                + "JOIN user u ON a.userId = u.id "
                + "WHERE a.projectId = ?";

        try {
            PreparedStatement pre = getConnection().prepareStatement(query);
            pre.setInt(1, projectId);
            ResultSet rs = pre.executeQuery();

            while (rs.next()) {
                Allocation allocation = new Allocation();

                // Thiết lập thông tin cho đối tượng Allocation
                allocation.setId(rs.getInt("id"));
                allocation.setStartDate(rs.getDate("startDate"));
                allocation.setEndDate(rs.getDate("endDate"));
                allocation.setProjectRole(rs.getString("projectRole"));
                allocation.setEffortRate(rs.getInt("effortRate"));
                allocation.setStatus(rs.getBoolean("status"));

                // Tạo đối tượng User từ kết quả truy vấn
                User user = new User();
                user.setId(rs.getInt("userId"));
                user.setFullname(rs.getString("userFullname"));
                user.setEmail(rs.getString("userEmail"));

                // Thiết lập user vào allocation
                allocation.setUser(user);

                // Thêm allocation vào danh sách
                allocations.add(allocation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return allocations;
    }

}
