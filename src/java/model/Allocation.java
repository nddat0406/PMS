/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author HP
 */
public class Allocation {

    private int id;
    private User user;
    private Project project;
    private Date startDate;
    private Date endDate;
    private int effortRate;
    private boolean status;
    private Setting role;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Project getProject() {
        return project;
    }

    public void setProject(Project project) {
        this.project = project;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getEffortRate() {
        return effortRate;
    }

    public void setEffortRate(int effortRate) {
        this.effortRate = effortRate;
    }

    public boolean isStatus() {
        return status;
    }

    public String getStatusString() {
        if (this.status) {
            return "Active";
        } else {
            return "Inactive";
        }
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Setting getRole() {
        return role;
    }

    public void setRole(Setting role) {
        this.role = role;
    }

    public String getRoleBadge() {
        if(this.role==null){
            return "<span class=\"badge bg-danger\">Cannot find role</span>";
        }
        if (role.getId() == 1) {
            return "<span class=\"badge bg-info\">" + role.getName() + "</span>";
        } else if (role.getId() == 2) {
            return "<span class=\"badge bg-secondary\">" + role.getName() + "</span>";
        } else if (role.getId() == 3 || role.getId() == 4) {
            return "<span class=\"badge bg-success\">" + role.getName() + "</span>";
        } else if (role.getId() >= 5) {
            return "<span class=\"badge bg-primary\">" + role.getName() + "</span>";
        } else {
            return "<span class=\"badge bg-danger\">" + role.getName() + "</span>";
        }
    }
}
