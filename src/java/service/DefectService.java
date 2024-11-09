/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dal.AllocationDAO;
import dal.DefectDAO;
import dal.ProjectDAO;
import dal.RequirementDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Defect;
import model.Project;
import model.Setting;
import model.User;

/**
 *
 * @author nmngh
 */
public class DefectService {

    private DefectDAO ddao = new DefectDAO();

    public List<Defect> getDefectByAssignee(int id) throws SQLException {
        return ddao.getDefectByAssignee(id);
    }

    public List<Defect> getAll() throws SQLException {
        return ddao.getAll();
    }

    public Defect getById(int id) throws SQLException {
        return ddao.getById(id);
    }

    public List<Defect> searchFilter(List<Defect> defects, Integer requirementId, Integer projectId, Integer serverityId, Integer status, String keyword) {
        return ddao.searchFilter(defects, requirementId, projectId, serverityId, status, keyword);
    }

    public void insert(Defect defect) throws SQLException {
        ddao.insert(defect);
    }

    public void update(Defect defect) throws SQLException {
        ddao.update(defect);
    }

    public void updateStatus(int id, int status) throws SQLException {
        ddao.updateStatus(id, status);
    }

    public void delete(int id) throws SQLException {
        ddao.delete(id);
    }

    public Project getProjectAdd(Integer pID) throws SQLException {
        ProjectDAO pdao = new ProjectDAO();
        RequirementDAO rdao = new RequirementDAO();
        Project temp = pdao.getById(pID);
        temp.setMember(pdao.getProjectMembers(pID));
        temp.setRequirement(rdao.getAllByProjectId(pID));
        return temp;
    }

    public JsonObject getResponseJson(int PID) throws SQLException {

        Project temp = this.getProjectAdd(PID);
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
            m.setFullname("This project dont have a memeber yet!");
            List<User> uLi = new ArrayList<>();
            uLi.add(m);
            jsonResponse.add("memberList", gson.toJsonTree(uLi));
        }

        if (!temp.getListRole().isEmpty() && temp.getListRole() != null) {
            jsonResponse.add("reqList", gson.toJsonTree(temp.getRequirement()));
        } else {
            Setting s = new Setting();
            s.setId(-1);
            s.setName("The project has no requirement !");
            List<Setting> sLi = new ArrayList<>();
            sLi.add(s);
            jsonResponse.add("roleList", gson.toJsonTree(sLi));
        }
        return jsonResponse;
    }
}
