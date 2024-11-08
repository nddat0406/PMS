/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.text.SimpleDateFormat;

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

    public int getStatusInt() {
        return status ? 1 : 2;
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

    public String getStartDateString() {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        if (startDate != null) {
            return formatter.format(startDate);
        } else {
            return null;
        }
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getEndDateString() {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        if (endDate != null) {
            return formatter.format(endDate);
        } else {
            return null;
        }
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
            return "<span class=\"badge bg-success\">Active</span>";
        } else {
            return "<span class=\"badge bg-secondary\">Inactive</span>";
        }
    }
    public String getStatusS() {
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
        if (this.role == null) {
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

    @Override
    public String toString() {
        return "Allocation{" + "id=" + id + ", user=" + user + ", project=" + project + ", startDate=" + startDate + ", endDate=" + endDate + ", effortRate=" + effortRate + ", status=" + status + ", role=" + role + '}';
    }

}
