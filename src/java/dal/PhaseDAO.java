/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.ProjectPhase;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Group;
/**
 *
 * @author ASUS TUF
 */
public class PhaseDAO extends BaseDAO{
 // Phương thức lấy danh sách ProjectPhase theo domainId
    public List<ProjectPhase> getPhasesByDomain(int domainId) {
        List<ProjectPhase> phases = new ArrayList<>();
        String query = "SELECT id, name, priority, details, finalPhase, completeRate, status "
                     + "FROM projectphase WHERE domainId = ?";
        
        try (PreparedStatement pre = getConnection().prepareStatement(query)) {
            pre.setInt(1, domainId);
            ResultSet resultSet = pre.executeQuery();
            
            while (resultSet.next()) {
                ProjectPhase phase = new ProjectPhase();
                phase.setId(resultSet.getInt("id"));
                phase.setName(resultSet.getString("name"));
                phase.setPriority(resultSet.getInt("priority"));
                phase.setDetails(resultSet.getString("details"));
                phase.setFinalPhase(resultSet.getBoolean("finalPhase"));
                phase.setCompleteRate(resultSet.getInt("completeRate"));
                phase.setStatus(resultSet.getBoolean("status"));

                // Thiết lập domain cho phase
                Group domain = new Group();
                domain.setId(domainId);
                phase.setDomain(domain);

                phases.add(phase);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Thay thế bằng log nếu cần thiết
        }
        
        return phases;
    }
    public ProjectPhase getPhaseById(int id) throws SQLException {
        String str = "SELECT * FROM pms.projectphase where id=?";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            rs.next();
            ProjectPhase temp = new ProjectPhase();
            temp.setId(rs.getInt(1));
            temp.setName(rs.getString(2));
            temp.setPriority(rs.getInt(3));
            temp.setDetails(rs.getString(4));
            temp.setFinalPhase(rs.getBoolean(5));
            temp.setCompleteRate(rs.getInt(6));
            temp.setStatus(rs.getBoolean(7));
            return temp;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }
}

