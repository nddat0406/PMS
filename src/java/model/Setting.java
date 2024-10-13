/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Setting {

    private int id;
    private String name;
    private int type;
    private int priority;
    private boolean status; // 1: Active, 0: Inactive
    private String description;
    private Group domain;

    // Constructor
    public Setting() {
    }

    public Setting(int id, String name, int type, int priority, boolean status, String description) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.priority = priority;
        this.status = status;
        this.description = description;
    }

    // Getters and Setters
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

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
     public Group getDomain() {
        return domain;
    }

    public void setDomain(Group domain) {
        this.domain = domain;
    }
}
