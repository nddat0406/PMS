/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.IssueDAO;
import java.util.ArrayList;
import java.util.List;
import model.Issue;
import java.sql.*;

public class IssueService extends BaseService {
    // Status constants

    public static final int STATUS_OPEN = 0;
    public static final int STATUS_TODO = 1;
    public static final int STATUS_DOING = 2;
    public static final int STATUS_DONE = 3;
    public static final int STATUS_CLOSED = 4;

    // Type constants
    public static final String TYPE_QA = "Q&A";
    public static final String TYPE_TASK = "Task";
    public static final String TYPE_ISSUE = "Issue";
    public static final String TYPE_COMPLAINT = "Complaint";

    private final IssueDAO issueDAO = new IssueDAO();

    public List<Issue> getAll() throws SQLException {
        try {
            return issueDAO.getAll();
        } catch (SQLException e) {
            throw new SQLException("Error getting all issues: " + e.getMessage());
        }
    }

    public Issue getIssueById(int id) throws SQLException {
        try {
            return issueDAO.getIssueById(id);
        } catch (SQLException e) {
            throw new SQLException("Error getting issue with ID " + id + ": " + e.getMessage());
        }
    }

    public void updateIssue(Issue issue) throws SQLException {
        try {
            validateIssue(issue);
            issueDAO.updateIssue(issue);
        } catch (SQLException e) {
            throw new SQLException("Error updating issue: " + e.getMessage());
        }
    }

    public void insertIssue(Issue issue) throws SQLException {
        try {
            validateIssue(issue);
            issueDAO.insertIssue(issue);
        } catch (SQLException e) {
            throw new SQLException("Error inserting issue: " + e.getMessage());
        }
    }

    public List<Issue> getIssuesByFilter(String searchKey, Integer projectId, Integer status) throws SQLException {
        try {
            if (projectId != null && projectId == 0) {
                projectId = null;
            }
            if (status != null && status == 0) {
                status = null;
            }
            if (searchKey != null && searchKey.trim().isEmpty()) {
                searchKey = null;
            }
            return issueDAO.searchIssues(searchKey, projectId, status);
        } catch (SQLException e) {
            throw new SQLException("Error filtering issues: " + e.getMessage());
        }
    }

    public List<Issue> getIssuesByAssignee(int assigneeId) throws SQLException {
        try {
            return issueDAO.getIssuesByAssignee(assigneeId);
        } catch (SQLException e) {
            throw new SQLException("Error getting issues for assignee: " + e.getMessage());
        }
    }

    public List<Issue> getIssuesByType(String type) throws SQLException {
        try {
            return issueDAO.getIssuesByType(type);
        } catch (SQLException e) {
            throw new SQLException("Error getting issues by type: " + e.getMessage());
        }
    }

    private void validateIssue(Issue issue) throws SQLException {
        List<String> errors = new ArrayList<>();

        // Title validation
        if (issue.getTitle() == null || issue.getTitle().trim().isEmpty()) {
            errors.add("Title is required");
        } else if (issue.getTitle().length() > 100) {
            errors.add("Title must be less than 100 characters");
        }

        // Description validation
        if (issue.getDescription() != null && issue.getDescription().length() > 1000) {
            errors.add("Description must be less than 1000 characters");
        }

        // Type validation
        if (issue.getType() == null || issue.getType().trim().isEmpty()) {
            errors.add("Type is required");
        } else if (!isValidType(issue.getType())) {
            errors.add("Invalid issue type. Must be one of: Q&A, Task, Issue, or Complaint");
        }

        // Assignee validation
        if (issue.getAssignee_id() <= 0) {
            errors.add("Valid assignee is required");
        }

        // Date validation
        if (issue.getDue_date() == null) {
            errors.add("Due date is required");
        }
        if (issue.getEnd_date() == null) {
            errors.add("End date is required");
        }
        if (issue.getDue_date() != null && issue.getEnd_date() != null
                && issue.getDue_date().before(issue.getEnd_date())) {
            errors.add("Due date cannot be earlier than end date");
        }

        // Status validation
        if (!isValidStatus(issue.getStatus())) {
            errors.add("Invalid status value");
        }

        if (!errors.isEmpty()) {
            throw new SQLException(String.join(", ", errors));
        }
    }

    // Status-related methods
    private boolean isValidStatus(int status) {
        return status >= STATUS_OPEN && status <= STATUS_CLOSED;
    }

    private boolean isValidType(String type) {
        return List.of(TYPE_QA, TYPE_TASK, TYPE_ISSUE, TYPE_COMPLAINT).contains(type);
    }

    public String getStatusText(int status) {
        return switch (status) {
            case STATUS_OPEN ->
                "Open";
            case STATUS_TODO ->
                "To Do";
            case STATUS_DOING ->
                "Doing";
            case STATUS_DONE ->
                "Done";
            case STATUS_CLOSED ->
                "Closed";
            default ->
                "Unknown";
        };
    }

    public String getStatusBadgeClass(int status) {
        return switch (status) {
            case STATUS_OPEN ->
                "status-open";
            case STATUS_TODO ->
                "status-todo";
            case STATUS_DOING ->
                "status-doing";
            case STATUS_DONE ->
                "status-done";
            case STATUS_CLOSED ->
                "status-closed";
            default ->
                "status-open";
        };
    }

    public String getStatusColor(int status) {
        return switch (status) {
            case STATUS_OPEN ->
                "#17a2b8";    // Info blue
            case STATUS_TODO ->
                "#ffc107";     // Warning yellow
            case STATUS_DOING ->
                "#0d6efd";    // Primary blue
            case STATUS_DONE ->
                "#198754";     // Success green
            case STATUS_CLOSED ->
                "#6c757d";   // Secondary gray
            default ->
                "#6c757d";             // Default gray
        };
    }

    public String getTypeColor(String type) {
        return switch (type) {
            case TYPE_QA ->
                "#17a2b8";       // Info blue for Q&A
            case TYPE_TASK ->
                "#28a745";     // Green for Task
            case TYPE_ISSUE ->
                "#ffc107";    // Warning yellow for Issue
            case TYPE_COMPLAINT ->
                "#dc3545"; // Danger red for Complaint
            default ->
                "#6c757d";            // Secondary gray for unknown
        };
    }

    public String getTypeBadgeClass(String type) {
        return switch (type) {
            case TYPE_QA ->
                "type-qa";
            case TYPE_TASK ->
                "type-task";
            case TYPE_ISSUE ->
                "type-issue";
            case TYPE_COMPLAINT ->
                "type-complaint";
            default ->
                "type-default";
        };
    }

    public List<String> getAllTypes() {
        return List.of(TYPE_QA, TYPE_TASK, TYPE_ISSUE, TYPE_COMPLAINT);
    }

    public List<Issue> searchAdvanced(String searchKey, Integer projectId, String type,
            Integer assigneeId, Integer status, Date startDate, Date endDate) throws SQLException {
        try {
            // Normalize parameters
            if (projectId != null && projectId == 0) {
                projectId = null;
            }
            if (assigneeId != null && assigneeId == 0) {
                assigneeId = null;
            }
            if (status != null && status == 0) {
                status = null;
            }
            if (searchKey != null && searchKey.trim().isEmpty()) {
                searchKey = null;
            }
            if (type != null && !isValidType(type)) {
                type = null;
            }

            return issueDAO.searchAdvanced(searchKey, projectId, type, assigneeId, status, startDate, endDate);
        } catch (SQLException e) {
            throw new SQLException("Error performing advanced search: " + e.getMessage());
        }
    }

}