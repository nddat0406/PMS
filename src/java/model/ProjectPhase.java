/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HP
 */
public class ProjectPhase {
    private int id;
    private String name;
    private int priority;
    private String details;
    private boolean finalPhase;
    private int completeRate;
    private boolean status;
    private Group domain;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public boolean isFinalPhase() {
        return finalPhase;
    }

    public void setFinalPhase(boolean finalPhase) {
        this.finalPhase = finalPhase;
    }

    public int getCompleteRate() {
        return completeRate;
    }

    public void setCompleteRate(int completeRate) {
        this.completeRate = completeRate;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Group getDomain() {
        return domain;
    }

    public void setDomain(Group domain) {
        this.domain = domain;
    }

    @Override
    public String toString() {
        return "ProjectPhase{" + "id=" + id + ", name=" + name + ", priority=" + priority + ", details=" + details + ", finalPhase=" + finalPhase + ", completeRate=" + completeRate + ", status=" + status + ", domain=" + domain + '}';
    }
    
    
}
