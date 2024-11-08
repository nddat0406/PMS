package service;

import dal.MilestoneDAO;
import dal.ProjectDAO;
import dal.RequirementDAO;
import dal.UserDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Milestone;
import model.Project;
import model.Requirement;
import model.User;

public class RequirementService extends BaseService {

    private final RequirementDAO requirementDAO = new RequirementDAO();
    private final ProjectDAO projectDAO = new ProjectDAO();
    private final MilestoneDAO mileStoneDAO = new MilestoneDAO();
    private final UserDAO userDAO=new UserDAO();
    

    public List<Requirement> getRequirementsByProject(int projectId) throws SQLException {
        try {
            return requirementDAO.getAllByProjectId(projectId);
        } catch (SQLException e) {
            throw new SQLException("Error getting requirements for project: " + e.getMessage());
        }
    }

    public List<Requirement> getAll() throws SQLException {
        try {
            return requirementDAO.getAll();
        } catch (SQLException e) {
            throw new SQLException("Error getting all requirements: " + e.getMessage());
        }
    }

    public Requirement getRequirementById(int id) throws SQLException {
        try {
            return requirementDAO.getRequirementById(id);
        } catch (SQLException e) {
            throw new SQLException("Error getting requirement with ID " + id + ": " + e.getMessage());
        }
    }

    public void updateRequirement(Requirement requirement) throws SQLException {
        try {
            // Validation
            validateRequirement(requirement);

            // Check if estimated effort is within reasonable bounds
            if (requirement.getEstimatedEffort() < 0 || requirement.getEstimatedEffort() > 1000) {
                throw new SQLException("Estimated effort must be between 0 and 1000 hours");
            }

            requirementDAO.updateRequirement(requirement);
        } catch (SQLException e) {
            throw new SQLException("Error updating requirement: " + e.getMessage());
        }
    }

//    public void deleteRequirement(int id) throws SQLException {
//        try {
//            requirementDAO.deleteRequirement(id);
//        } catch (SQLException e) {
//            throw new SQLException("Error deleting requirement: " + e.getMessage());
//        }
//    }

    public void insertRequirement(Requirement requirement) throws SQLException {
        try {
            // Validation
            validateRequirement(requirement);

            // Check if project exists
            if (!isValidProject(requirement.getProjectId())) {
                throw new SQLException("Invalid project ID");
            }

            // Check if user exists
            if (!isValidUser(requirement.getUserId())) {
                throw new SQLException("Invalid user ID");
            }

            requirementDAO.insertRequirement(requirement);
        } catch (SQLException e) {
            throw new SQLException("Error inserting requirement: " + e.getMessage());
        }
    }

    public List<Requirement> getRequirementsByFilter(
            String complexity, Integer projectId, Integer status, String searchKey) throws SQLException {
        try {
            if (complexity != null && complexity.equals("0")) {
                complexity = null;
            }
            if (projectId != null && projectId == 0) {
                projectId = null;
            }
            if (status != null && status == 0) {
                status = null;
            }
            if (searchKey != null && searchKey.trim().isEmpty()) {
                searchKey = null;
            }

            return requirementDAO.searchRequirements(searchKey, complexity, status);
        } catch (SQLException e) {
            throw new SQLException("Error filtering requirements: " + e.getMessage());
        }
    }

    // Helper methods for validation
    private void validateRequirement(Requirement requirement) throws SQLException {
        List<String> errors = new ArrayList<>();

        // Title validation
        if (requirement.getTitle() == null || requirement.getTitle().trim().isEmpty()) {
            errors.add("Title is required");
        } else if (requirement.getTitle().length() > 100) {
            errors.add("Title must be less than 100 characters");
        }

        // Details validation
        if (requirement.getDetails() != null && requirement.getDetails().length() > 1000) {
            errors.add("Details must be less than 1000 characters");
        }

        // Complexity validation
        if (requirement.getComplexity() == null || requirement.getComplexity().trim().isEmpty()) {
            errors.add("Complexity is required");
        } else if (!isValidComplexity(requirement.getComplexity())) {
            errors.add("Invalid complexity value");
        }

        // Status validation
        if (!isValidStatus(requirement.getStatus())) {
            errors.add("Invalid status value");
        }

        // Estimated effort validation
        if (requirement.getEstimatedEffort() < 0) {
            errors.add("Estimated effort cannot be negative");
        }

        if (!errors.isEmpty()) {
            throw new SQLException(String.join(", ", errors));
        }
    }

    private boolean isValidComplexity(String complexity) {
        // Add your complexity validation logic here
        // For example: return Arrays.asList("Low", "Medium",
        // "High").contains(complexity);
        return true; // Placeholder
    }

    private boolean isValidStatus(int status) {
        // Status values: 0 = To Do, 1 = In Progress, 2 = Completed, 3 = Cancelled
        return status >= 0 && status <= 3;
    }

    private boolean isValidProject(int projectId) {
        // Add your project validation logic here
        // For example, check if project exists in database
        return true; // Placeholder
    }

    private boolean isValidUser(int userId) {
        // Add your user validation logic here
        // For example, check if user exists in database
        return true; // Placeholder
    }

    public String getProjectName(int id) {
        return projectDAO.getProjectById(id).getName();
    }
    
    public List<Project> getAllProject() throws SQLException {
        return projectDAO.getAllProject();
    }
    
    public List<Milestone> getListMileStoneByProjectId(int projectId) {
        try {
            return mileStoneDAO.getAllByProjectId(projectId);
        } catch (SQLException ex) {
            Logger.getLogger(RequirementService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return new ArrayList<>();
    }

    public void insertRequirementWithMilestone(Requirement requirement, Integer milestoneId) throws SQLException {
        try {
            // Validation
            validateRequirement(requirement);

            // Check if project exists
            if (!isValidProject(requirement.getProjectId())) {
                throw new SQLException("Invalid project ID");
            }

            // Check if user exists
            if (!isValidUser(requirement.getUserId())) {
                throw new SQLException("Invalid user ID");
            }

            // Insert requirement (this will set the ID in the requirement object)
            requirementDAO.insertRequirement(requirement);
            
            // If milestone is specified, create the relationship using the new requirement ID
            if (milestoneId != null && milestoneId > 0) {
                requirementDAO.insertRequirementMilestone(requirement.getId(), milestoneId);
            }
        } catch (SQLException e) {
            throw new SQLException("Error inserting requirement: " + e.getMessage());
        }
    }

    public void updateRequirementWithMilestone(Requirement requirement, Integer milestoneId) throws SQLException {
        try {
            // Validation
            validateRequirement(requirement);

            // Check if estimated effort is within reasonable bounds
            if (requirement.getEstimatedEffort() < 0 || requirement.getEstimatedEffort() > 1000) {
                throw new SQLException("Estimated effort must be between 0 and 1000 hours");
            }

            // Update requirement
            requirementDAO.updateRequirement(requirement);
            
            // Update milestone relationship
            requirementDAO.updateRequirementMilestone(requirement.getId(), milestoneId);
        } catch (SQLException e) {
            throw new SQLException("Error updating requirement: " + e.getMessage());
        }
    }

    public Integer getMilestoneIdForRequirement(int requirementId) throws SQLException {
        return requirementDAO.getMilestoneIdForRequirement(requirementId);
    }

    public List<User> getListUsersByProjectId(int projectId) {
        return userDAO.getUsersByProjectId(projectId);
    }

    public Integer getAssigneeIdForRequirement(int requirementId) {
        try {
            Requirement requirement = requirementDAO.getRequirementById(requirementId);
            return requirement != null ? requirement.getUserId() : null;
        } catch (SQLException e) {
            Logger.getLogger(RequirementService.class.getName()).log(Level.SEVERE, null, e);
            return null;
        }
    }
}
