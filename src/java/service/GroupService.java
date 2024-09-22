/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.GroupDAO;
import java.sql.SQLException;
import java.util.List;
import model.Group;

/**
 *
 * @author HP
 */
public class GroupService {
    
    private GroupDAO gdao =new GroupDAO();
    public static final int CODE_MAX_LENGTH = 10;
    public GroupService() {
        this.gdao = new GroupDAO();
    }

    public List<Group> getAllGroups(int pageNumber, int pageSize) {
        if (pageNumber <= 0 || pageSize <= 0) {
            throw new IllegalArgumentException("Page number and page size must be greater than 0.");
        }
        return gdao.Read(pageNumber, pageSize);
    }

    public int addGroup(String code, String name, String details, int status) {
        validateGroup(code, name, details, status);
        return gdao.Add(code, name, details, status);
    }

    public int updateGroup(int domainID, String code, String name, String details, int status) {
        if (domainID <= 0) {
            throw new IllegalArgumentException("Domain ID must be greater than 0.");
        }
        validateGroup(code, name, details, status);
        return gdao.Update(domainID, code, name, details, status);
    }

    public int deleteGroup(int groupID) {
        if (groupID <= 0) {
            throw new IllegalArgumentException("Group ID must be greater than 0.");
        }
        return gdao.Delete(groupID);
    }

    public Group getGroupDetail(int groupID) {
        if (groupID <= 0) {
            throw new IllegalArgumentException("Group ID must be greater than 0.");
        }
        return gdao.Detail(groupID);
    }

    public List<Group> searchDomain(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("Search keyword cannot be null or empty.");
        }
        return gdao.Search(keyword);
    }

    public List<Group> filterGroups(int pageNumber, int pageSize, String name, String code, Integer status) {
        if (pageNumber <= 0 || pageSize <= 0) {
            throw new IllegalArgumentException("Page number and page size must be greater than 0.");
        }
        return gdao.filterGroups(pageNumber, pageSize, name, code, status);
    }

    private void validateGroup(String code, String name, String details, int status) {
        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException("Code cannot be null or empty.");
        }
        if (code.length() > CODE_MAX_LENGTH) {
            throw new IllegalArgumentException("Code cannot exceed " + CODE_MAX_LENGTH + " characters.");
        }
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty.");
        }
        if (status < 0 || status > 1) {
            throw new IllegalArgumentException("Status must be either 0 (inactive) or 1 (active).");
        }
        // Có thể thêm kiểm tra cho 'details' nếu cần
    }

        public List<Group> getAllDepartment() throws SQLException {
        try {
            return gdao.getAllDepartment();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }


    public List<Group> getAllDomains() throws SQLException {
        try {
            return gdao.getAllDomain();
        } catch (SQLException e) {
            throw new SQLException(e);
        }
    }
}
