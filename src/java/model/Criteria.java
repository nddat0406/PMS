/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HP
 */
public class Criteria {
    private int id;
    private String name;
    private int weight;
    private Project project;
    private String description;
    private boolean status;
    private Milestone milestone;
    private ProjectPhase phase;

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

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }

    public Project getProject() {
        return project;
    }

    public void setProject(Project project) {
        this.project = project;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isStatus() {
        return status;
    }
    public int getStatusInt(){
        return status?1:2;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Milestone getMilestone() {
        return milestone;
    }

    public void setMilestone(Milestone milestone) {
        this.milestone = milestone;
    }

    public ProjectPhase getPhase() {
        return phase;
    }

    public void setPhase(ProjectPhase phase) {
        this.phase = phase;
    }

    @Override
    public String toString() {
        return "Criteria{" + "id=" + id + ", name=" + name + ", weight=" + weight + ", project=" + project + ", description=" + description + ", status=" + status + ", milestone=" + milestone + ", phase=" + phase + '}';
    }
    
    
}
