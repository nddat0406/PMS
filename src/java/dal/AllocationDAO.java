/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Allocation;
import model.Project;
import model.Setting;
import model.User;
/**
 *
 * @author ASUS TUF
 */
public class AllocationDAO extends BaseDAO {

    private UserDAO udao = new UserDAO();
    private ProjectDAO pdao = new ProjectDAO();

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

    public List<Allocation> getAllProject() throws SQLException {
        String str = "select * from project";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            ResultSet rs = pre.executeQuery();
            List<Allocation> projectList = new ArrayList<>();
            while (rs.next()) {
                Allocation temp = new Allocation();
                temp.setProject(pdao.setProjectInfor(rs));
                projectList.add(temp);
            }
            return projectList;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    private Allocation setAllocationInfor(ResultSet rs) throws SQLException {
        try {
            Allocation temp = new Allocation();
            temp.setId(rs.getInt(7));
            temp.setUser(udao.getActiveUserByIdNull(rs.getInt(1)));
            temp.setProject(pdao.getById(rs.getInt(2)));
            temp.setStartDate(rs.getDate(3));
            temp.setEndDate(rs.getDate(4));
            temp.setEffortRate(rs.getInt(5));
            temp.setStatus(rs.getBoolean(6));
            return temp;
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    private Allocation setAllocationInforWithSt(ResultSet rs) throws SQLException {
        try {
            Allocation temp = new Allocation();
            temp.setId(rs.getInt(7));
            temp.setUser(udao.getActiveUserByIdNull(rs.getInt(1)));
            temp.setProject(pdao.getById(rs.getInt(2)));
            temp.setStartDate(rs.getDate(3));
            temp.setEndDate(rs.getDate(4));
            temp.setEffortRate(rs.getInt(5));
            temp.setStatus(rs.getBoolean(6));
            temp.setRole(this.getRoleNameOfAllocation(rs.getInt(7)));
            return temp;
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }

    public List<Allocation> getActiveAllocationByUser(int id) throws SQLException {
        String str = "select * from allocation where userId = ? and status = 1";
        try {
            PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            List<Allocation> AllocateList = new ArrayList<>();
            while (rs.next()) {
                AllocateList.add(setAllocationInforWithSt(rs));
            }
            return AllocateList;
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }

    public List<Allocation> getAllMember(int id) throws SQLException {
        String str = "select a.* from allocation a join user u on u.id = a.userId where a.projectId = ?";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, id);
        ResultSet rs = pre.executeQuery();

        List<Allocation> userList = new ArrayList<>();

        while (rs.next()) {
            Allocation user = setAllocationInforWithSt(rs);
            if (user.getUser() != null) {
                userList.add(user);
            }
        }
        return userList;
    }

    private Setting getRoleNameOfAllocation(int aID) throws SQLException {
        String sql = """
                     select ds.id,ds.name,ds.priority from domain_setting ds, 
                     (select p.domainId, a.role from allocation a join project p on a.projectId = p.id where a.id = ?) as t1 
                     where ds.domainId = t1.domainId and type = 2 and t1.role = ds.id""";
        PreparedStatement pre = getConnection().prepareStatement(sql);
        pre.setInt(1, aID);
        ResultSet rs = pre.executeQuery();
        if (rs.next()) {
            Setting temp = new Setting();
            temp.setId(rs.getInt(1));
            temp.setName(rs.getString(2));
            temp.setPriority(rs.getInt(3));
            return temp;
        }
        return null;
    }

    public List<Allocation> getAll() throws SQLException {
        String str = "select * from allocation";
        PreparedStatement pre = getConnection().prepareStatement(str);
        ResultSet rs = pre.executeQuery();
        List<Allocation> AllocateList = new ArrayList<>();
        while (rs.next()) {
            Allocation temp = new Allocation();
            temp.setId(rs.getInt(7));
            temp.setUser(udao.getUserById(rs.getInt(1)));
            temp.setProject(pdao.getById(rs.getInt(2)));
            temp.setStartDate(rs.getDate(3));
            temp.setEndDate(rs.getDate(4));
            temp.setEffortRate(rs.getInt(5));
            temp.setStatus(rs.getBoolean(6));
            temp.setRole(this.getRoleNameOfAllocation(rs.getInt(7)));
            AllocateList.add(temp);
        }
        return AllocateList;
    }

    public List<Allocation> getProjectAllocationByUser(int id) throws SQLException {
        String str = "SELECT a1.* FROM pms.allocation a1 where a1.projectId in (select distinct a2.projectId from allocation a2 where a2.userId=?)";

        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, id);
        ResultSet rs = pre.executeQuery();
        List<Allocation> AllocateList = new ArrayList<>();
        while (rs.next()) {
            Allocation temp = new Allocation();
            temp.setId(rs.getInt(7));
            temp.setUser(udao.getUserById(rs.getInt(1)));
            temp.setProject(pdao.getById(rs.getInt(2)));
            temp.setStartDate(rs.getDate(3));
            temp.setEndDate(rs.getDate(4));
            temp.setEffortRate(rs.getInt(5));
            temp.setStatus(rs.getBoolean(6));
            temp.setRole(this.getRoleNameOfAllocation(rs.getInt(7)));
            AllocateList.add(temp);
        }
        return AllocateList;
    }

    public void flipStatus(int alloId) throws SQLException {
        String sql = """
                     UPDATE `pms`.`allocation`
                     SET
                     `status` = status ^ 1
                     WHERE `id` = ?""";
        PreparedStatement st = getConnection().prepareStatement(sql);
        st.setInt(1, alloId);
        st.executeUpdate();
    }

    public void delete(int alloId) throws SQLException {
        String sql = """
                     DELETE FROM `pms`.`allocation`
                     WHERE id=?""";
        PreparedStatement st = getConnection().prepareStatement(sql);
        st.setInt(1, alloId);
        st.executeUpdate();
    }

    public void add(Allocation allocation, int[] memberIds) throws SQLException {
        String str = """
                     INSERT INTO `pms`.`allocation`
                     (`userId`,
                     `projectId`,
                     `startDate`,
                     `endDate`,
                     `effortRate`,
                     `role`,
                     `status`)
                     VALUES
                     (?,?,?,?,?,?,?);""";
        PreparedStatement pre = getConnection().prepareStatement(str);
        for (int i : memberIds) {
            pre.setInt(1, i);
            pre.setInt(2, allocation.getProject().getId());
            pre.setDate(3, allocation.getStartDate());
            pre.setDate(4, allocation.getEndDate());
            pre.setInt(5, allocation.getEffortRate());
            pre.setInt(6, allocation.getRole().getId());
            pre.setBoolean(7, allocation.isStatus());
            pre.addBatch();
        }
        try {
            getConnection().setAutoCommit(false);
            pre.executeBatch();
            getConnection().commit();
        } finally {
            getConnection().setAutoCommit(true);
        }
    }

    public Allocation getModalItem(int modalItemID) throws SQLException {
        String str = "SELECT * FROM pms.allocation where id=?";
        PreparedStatement pre = getConnection().prepareStatement(str);
        pre.setInt(1, modalItemID);
        ResultSet rs = pre.executeQuery();
        Allocation temp = new Allocation();

        if (rs.next()) {
            temp.setId(rs.getInt(7));
            temp.setUser(udao.getUserById(rs.getInt(1)));
            Project p = pdao.getById(rs.getInt(2));
            p.setListRole(pdao.getListRole(rs.getInt(2)));
            temp.setProject(p);
            temp.setStartDate(rs.getDate(3));
            temp.setEndDate(rs.getDate(4));
            temp.setEffortRate(rs.getInt(5));
            temp.setStatus(rs.getBoolean(6));
            temp.setRole(this.getRoleNameOfAllocation(rs.getInt(7)));
        }
        return temp;
    }

    public void update(Allocation allocation) throws SQLException {
        String str = """
                     UPDATE `pms`.`allocation`
                     SET
                     `endDate` =?,
                     `effortRate` = ?,
                     `status` = ?,
                     `role` = ?
                     WHERE `id` = ?""";
        PreparedStatement pre = getConnection().prepareStatement(str);
            pre.setDate(1, allocation.getEndDate());
            pre.setInt(2, allocation.getEffortRate());
            pre.setBoolean(3, allocation.isStatus());
            pre.setInt(4, allocation.getRole().getId());
            pre.setInt(5, allocation.getId());
            pre.executeUpdate();
    }

}
