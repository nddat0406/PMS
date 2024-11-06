/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.util.List;

/**
 *
 * @author HP
 */
public class Project {

    private int id;
    private String bizTerm;
    private String code;
    private String name;
    private String details;
    private Date startDate;
    private int status;
    private Group department;
    private Group domain;
    private List<User> member;
    private List<Allocation> allocation;
    private List<Setting> listRole;

    public Project() {
    }

    public Project(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBizTerm() {
        return bizTerm;
    }

    public void setBizTerm(String bizTerm) {
        this.bizTerm = bizTerm;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Group getDepartment() {
        return department;
    }

    public void setDepartment(Group department) {
        this.department = department;
    }

    public Group getDomain() {
        return domain;
    }

    public void setDomain(Group domain) {
        this.domain = domain;
    }

    public List<User> getMember() {
        return member;
    }

    public void setMember(List<User> member) {
        this.member = member;
    }

    public List<Setting> getListRole() {
        return listRole;
    }

    public void setListRole(List<Setting> listRole) {
        this.listRole = listRole;
    }



    public int getDepartmentId() {
        return department != null ? department.getId() : 0; // Trả về 0 nếu department là null
    }

    public int getDomainId() {
        return domain != null ? domain.getId() : 0; // Trả về 0 nếu domain là null
    }

    public List<Allocation> getAllocation() {
        return allocation;
    }

    public void setAllocation(List<Allocation> allocation) {
        this.allocation = allocation;
    }
}
