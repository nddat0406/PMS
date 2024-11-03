/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dal.AllocationDAO;
import dal.ProjectDAO;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;
import model.Allocation;
import model.Project;
import model.Setting;
import model.User;

/**
 *
 * @author ASUS TUF
 */
public class AllocationService {

    private AllocationDAO allocationDAO;
    private BaseService baseService = new BaseService();
    private ProjectDAO pdao = new ProjectDAO();

    public AllocationService() {
        this.allocationDAO = new AllocationDAO();
    }

    public List<Allocation> getAllocationsByProjectId(int id) {
        return allocationDAO.getAllocationsByProjectId(id);
    }

    public List<Allocation> getAlloList(User user) throws SQLException {
        if (user.getRole() == BaseService.ADMIN_ROLE || user.getRole() == BaseService.DEPARTMENT_MANAGER) {
            return allocationDAO.getAll();
        } else {
            return allocationDAO.getProjectAllocationByUser(user.getId());
        }

    }

    public List<Project> getDistinctProjectsById(List<Allocation> allocations) {
        return allocations.stream()
                .map(Allocation::getProject) // extract projects
                .collect(Collectors.toMap(
                        Project::getId, // use project id as the key
                        project -> project, // use the project itself as the value
                        (existing, replacement) -> existing // keep the existing project if duplicate id
                ))
                .values()
                .stream()
                .collect(Collectors.toList()); // collect to a list
    }

    public List<User> getDistinctUsersById(List<Allocation> allocations) {
        return allocations.stream()
                .map(Allocation::getUser) // extract users
                .collect(Collectors.toMap(
                        User::getId, // use user id as the key
                        user -> user, // use the user itself as the value
                        (existing, replacement) -> existing // keep the existing user if duplicate id
                ))
                .values()
                .stream()
                .collect(Collectors.toList()); // collect to a list
    }

    public List<Allocation> filterAllocation(Integer userFilter, Integer projectFilter, Integer statusFilter, List<Allocation> list) {
        userFilter = baseService.TryParseInteger(userFilter);
        projectFilter = baseService.TryParseInteger(projectFilter);
        statusFilter = baseService.TryParseInteger(statusFilter);
        List<Allocation> temp = new ArrayList<>();
        for (Allocation c : list) {
            if ((c.getUser().getId() == userFilter || userFilter == 0)
                    && (c.getProject().getId() == projectFilter || projectFilter == 0)
                    && (statusFilter == 0 || c.getStatusInt() == statusFilter)) {
                temp.add(c);
            }
        }
        return temp;
    }

    public void flipStatus(int alloId) throws SQLException {
        allocationDAO.flipStatus(alloId);
    }

    public void delete(int alloId) throws SQLException {
        allocationDAO.delete(alloId);
    }

    public HashMap<String, String> createOption(String id, String text) {
        HashMap<String, String> option = new HashMap<>();
        option.put("id", id);
        option.put("text", text);
        return option;
    }

    public JsonObject getResponseJson(int PID) throws SQLException {

        Project temp = this.getProjectAllocationInfor(PID);
        Gson gson = new Gson();
        JsonObject jsonResponse = new JsonObject();
        if (!temp.getMember().isEmpty() && temp.getMember() != null) {
            User uAll = new User();
            uAll.setId(0);
            uAll.setFullname("Add All");
            temp.getMember().add(0, uAll);
            jsonResponse.add("memberList", gson.toJsonTree(temp.getMember()));
        } else {
            User m = new User();
            m.setId(-1);
            m.setFullname("This project is setup with all the users!");
            List<User> uLi = new ArrayList<>();
            uLi.add(m);
            jsonResponse.add("memberList", gson.toJsonTree(uLi));
        }

        if (!temp.getListRole().isEmpty() && temp.getListRole() != null) {
            jsonResponse.add("roleList", gson.toJsonTree(temp.getListRole()));
        } else {
            Setting s = new Setting();
            s.setId(-1);
            s.setName("The domain has no roles !");
            List<Setting> sLi = new ArrayList<>();
            sLi.add(s);
            jsonResponse.add("roleList", gson.toJsonTree(sLi));
        }
        return jsonResponse;
    }

    public Project getProjectAllocationInfor(Integer PID) throws SQLException {
        Project temp = pdao.getById(PID);
        temp.setMember(pdao.getProjectAllocationUser(PID));
        temp.setListRole(pdao.getListRole(PID));
        return temp;
    }

    public List<String> addAllocation(Allocation allocation, int[] memberIds) throws SQLException {
        List<String> error = new ArrayList<>();
        boolean isValid = true;
        if (memberIds == null) {
            error.add("Please choose a member to add!");
            isValid = false;
        }
        if (allocation.getEffortRate() > 100 || allocation.getEffortRate() < 0) {
            error.add("Please choose correct effort rate (0=< e <=100)");
            isValid = false;
        }
        if (allocation.getEndDate() != null && allocation.getEndDate().compareTo(allocation.getStartDate()) < 0) {
            error.add("Please choose the end date before the start date!");
            isValid = false;
        }
        if (!isValid) {
            return error;
        } else {
            LocalDateTime now = LocalDateTime.now();
            if (allocation.getStartDate().compareTo(Date.valueOf(now.toLocalDate())) < 0) {
                allocation.setStatus(true);
            } else {
                allocation.setStatus(false);
            }
            allocationDAO.add(allocation, memberIds);
            return null;
        }
    }

    public Allocation getModalItem(int modalItemID) throws SQLException {
        return allocationDAO.getModalItem(modalItemID);
    }

    public List<String> update(Allocation allocation) throws SQLException {
        List<String> error = new ArrayList<>();
        boolean isValid = true;
        if (allocation.getEffortRate() > 100 || allocation.getEffortRate() < 0) {
            error.add("Please choose correct effort rate (0=< e <=100)");
            isValid = false;
        }
        if (allocation.getEndDate() != null && allocation.getEndDate().compareTo(allocation.getStartDate()) <= 0) {
            error.add("Please choose the end date before the start date!");
            isValid = false;
        }
        if (!isValid) {
            return error;
        } else {
            LocalDateTime now = LocalDateTime.now();
            if (allocation.getEndDate() != null && allocation.getEndDate().compareTo(Date.valueOf(now.toLocalDate())) < 0) {
                allocation.setStatus(false);
            } else {
                allocation.setStatus(true);
            }
            allocationDAO.update(allocation);
            return null;
        }
    }
}
