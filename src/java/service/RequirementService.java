package service;

import dal.RequirementDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Requirement;
import model.Project;
import model.Setting;

public class RequirementService {
    
    private RequirementDAO requirementDAO;
    private ProjectService projectService;
    private SettingService settingService;
    private BaseService baseService;
    
    public RequirementService() {
        requirementDAO = new RequirementDAO();
        projectService = new ProjectService();
        settingService = new SettingService();
        baseService = new BaseService();
    }
    
    public List<Requirement> getAllRequirements() throws SQLException {
        try {
            return requirementDAO.getAll();
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
    
    public Requirement getRequirementById(int id) throws SQLException {
        try {
            return requirementDAO.getById(id);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
    
    public List<Requirement> getRequirementsByProject(int projectId) throws SQLException {
        try {
            return requirementDAO.getByProject(projectId);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
    
    public void addRequirement(Requirement requirement) throws SQLException {
        try {
            // Validate before insert
            validateRequirement(requirement);
            requirementDAO.insert(requirement);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
    
    public void updateRequirement(Requirement requirement) throws SQLException {
        try {
            // Validate before update
            validateRequirement(requirement);
            requirementDAO.update(requirement);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
    
    public void updateRequirementStatus(int id, int statusId) throws SQLException {
        try {
            // Validate status before update
            Setting status = settingService.getSettingDetail(statusId);
            if (status == null) {
                throw new SQLException("Invalid status");
            }
            requirementDAO.updateStatus(id, statusId);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
    
    public void deleteRequirement(int id) throws SQLException {
        try {
            requirementDAO.delete(id);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
    
    public List<Requirement> searchAndFilterRequirements(Integer projectId, Integer ownerId, 
            Integer statusId, String complexity, String keyword) throws SQLException {
        try {
            List<Requirement> allRequirements = requirementDAO.getAll();
            return requirementDAO.searchFilter(allRequirements, projectId, ownerId, 
                                             statusId, complexity, keyword);
        } catch (SQLException ex) {
            throw new SQLException(ex);
        }
    }
    
    private void validateRequirement(Requirement requirement) throws SQLException {
        // Validate project exists
        Project project = projectService.getProjectById(requirement.getProject().getId());
        if (project == null) {
            throw new SQLException("Project not found");
        }
        
        // Validate owner exists
        if (requirement.getOwner() == null || 
            requirement.getOwner().getId() <= 0) {
            throw new SQLException("Invalid owner");
        }
        
        // Validate status exists
        Setting status = settingService.getSettingDetail(requirement.getStatus().getId());
        if (status == null) {
            throw new SQLException("Invalid status");
        }
        
        // Validate title
        if (requirement.getTitle() == null || 
            requirement.getTitle().trim().isEmpty()) {
            throw new SQLException("Title is required");
        }
        
        // Validate complexity
        if (!isValidComplexity(requirement.getComplexity())) {
            throw new SQLException("Invalid complexity value");
        }
        
        // Validate estimated effort
        if (requirement.getEstimatedEffort() < 0) {
            throw new SQLException("Estimated effort must be positive");
        }
    }
    
    private boolean isValidComplexity(String complexity) {
        if (complexity == null) return false;
        return complexity.equals("Simple") || 
               complexity.equals("Medium") || 
               complexity.equals("Complex");
    }
    
    public List<String> getValidComplexityValues() {
        // Return list of valid complexity values for UI
        List<String> values = new ArrayList<>();
        values.add("Simple");
        values.add("Medium");
        values.add("Complex");
        return values;
    }
    
    public boolean isRequirementInProject(int requirementId, List<Project> userProjects) {
        try {
            Requirement requirement = getRequirementById(requirementId);
            if (requirement != null) {
                return baseService.objectWithIdExists(
                    requirement.getProject().getId(), 
                    userProjects
                );
            }
        } catch (SQLException ex) {
            return false;
        }
        return false;
    }
}