<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Issue Management</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/select2.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <style>
            .content-wrapper {
                max-height: 50px;
                overflow: hidden;
                transition: max-height 0.4s ease-in-out;
                position: relative;
            }
            .content-wrapper.expanded {
                max-height: 1000px;
            }
            .read-more-btn {
                display: inline-block;
                color: #008ce6;
                cursor: pointer;
            }
            th {
                cursor: pointer;
                position: relative;
            }
            .sort-icon {
                margin-left: 5px;
                font-size: 12px;
                width: 10px;
                height: 20px;
            }
            .error-message {
                font-size: 0.875rem;
                margin-top: 0.25rem;
                color: #dc3545;
            }
            .is-invalid {
                border-color: #dc3545;
            }
            /* Status badges */
            .status-badge {
                padding: 0.25em 0.6em;
                border-radius: 0.25rem;
                font-size: 0.875em;
            }
            .status-open {
                background-color: #17a2b8;
                color: white;
            }
            .status-todo {
                background-color: #ffc107;
                color: black;
            }
            .status-doing {
                background-color: #0d6efd;
                color: white;
            }
            .status-done {
                background-color: #198754;
                color: white;
            }
            .status-closed {
                background-color: #6c757d;
                color: white;
            }
            /* Type badges */
            .type-badge {
                padding: 0.25em 0.6em;
                border-radius: 0.25rem;
                font-size: 0.875em;
            }
            .type-qa {
                background-color: #17a2b8;
                color: white;
            }
            .type-task {
                background-color: #28a745;
                color: white;
            }
            .type-issue {
                background-color: #ffc107;
                color: black;
            }
            .type-complaint {
                background-color: #dc3545;
                color: white;
            }
        </style>
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <!-- Header Section -->
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i>
                                            </a> 
                                            Issues
                                        </h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Home</a></li>
                                            <li class="breadcrumb-item active">Issues</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Filters Section -->
                            <div class="row g-3 mb-3">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-body">
                                            <form action="${pageContext.request.contextPath}/issue" method="post" id="filterForm">
                                            <input type="hidden" name="action" value="filter">
                                            <div class="row g-3">
                                                <div class="col-md-2">
                                                    <input type="text" class="form-control" name="searchKey" 
                                                           placeholder="Search..." value="${sessionScope.searchKey}">
                                                </div>
                                                <!-- Change this in the filter form -->
                                                <div class="col-md-2">
                                                    <div class="mb-3">
                                                        <select class="form-select" name="projectFilter" id="projectFilter" required> <!-- Change name="projectId" to name="projectFilter" -->
                                                            <option value="0">All Projects</option>
                                                            <c:forEach items="${projects}" var="project">
                                                                <option value="${project.id}" 
                                                                        ${project.id == sessionScope.projectFilter ? 'selected' : ''}>
                                                                    ${project.name}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" name="typeFilter">
                                                        <option value="">All Types</option>
                                                        <option value="Q&A" ${sessionScope.typeFilter == 'Q&A' ? 'selected' : ''}>Q&A</option>
                                                        <option value="Task" ${sessionScope.typeFilter == 'Task' ? 'selected' : ''}>Task</option>
                                                        <option value="Issue" ${sessionScope.typeFilter == 'Issue' ? 'selected' : ''}>Issue</option>
                                                        <option value="Complaint" ${sessionScope.typeFilter == 'Complaint' ? 'selected' : ''}>Complaint</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" name="statusFilter">
                                                        <option value="0">All Status</option>
                                                        <option value="0" ${sessionScope.statusFilter == 0 ? 'selected' : ''}>Open</option>
                                                        <option value="1" ${sessionScope.statusFilter == 1 ? 'selected' : ''}>To Do</option>
                                                        <option value="2" ${sessionScope.statusFilter == 2 ? 'selected' : ''}>Doing</option>
                                                        <option value="3" ${sessionScope.statusFilter == 3 ? 'selected' : ''}>Done</option>
                                                        <option value="4" ${sessionScope.statusFilter == 4 ? 'selected' : ''}>Closed</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-4">
                                                    <button type="submit" class="btn btn-primary">Filter</button>
                                                    <button type="button" class="btn btn-success add-issue float-end">Add New Issue</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Issues Table -->
                        <div class="row g-3">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <!-- Alert Messages -->
                                        <c:if test="${not empty successMess}">
                                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                                ${successMess}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty AddErrorMess}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                ${AddErrorMess}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty UpdateErrorMess}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                ${UpdateErrorMess}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>

                                        <!-- Table -->
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th name="id" sortBy="desc" class="sortTableHead">ID <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="requirementId" sortBy="desc" class="sortTableHead">Requirement <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="projectId" sortBy="desc" class="sortTableHead">Project <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="title" sortBy="desc" class="sortTableHead">Title <i class="fa fa-sort sort-icon"></i></th>
                                                        <th style="display: none">Description</th>
                                                        <th name="type" sortBy="desc" class="sortTableHead">Type <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="assignee_id" sortBy="desc" class="sortTableHead">Assignee <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="status" sortBy="desc" class="sortTableHead">Status <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="due_date" sortBy="desc" class="sortTableHead">Due Date <i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="end_date" sortBy="desc" class="sortTableHead">End Date <i class="fa fa-sort sort-icon"></i></th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${tableData}" var="issue">
                                                        <tr>
                                                            <td>${issue.id}</td>
                                                            <td>${issue.requirementId}</td>
                                                            <td>
                                                                <c:forEach items="${projects}" var="project">
                                                                    <c:if test="${project.id == issue.projectId}">
                                                                        ${project.name}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </td>
                                                            <td>${issue.title}</td>
                                                            <td style="display: none">
                                                                <div class="content-wrapper">
                                                                    <p>${issue.description}</p>
                                                                    <span class="read-more-btn">Read More</span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="type-badge type-${fn:toLowerCase(issue.type)}">${issue.type}</span>
                                                            </td>
                                                            <td>
                                                                <c:forEach items="${users}" var="user">
                                                                    <c:if test="${user.id == issue.assignee_id}">
                                                                        ${user.fullname}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${issue.status == 0}">
                                                                        <span class="status-badge status-open">Open</span>
                                                                    </c:when>
                                                                    <c:when test="${issue.status == 1}">
                                                                        <span class="status-badge status-todo">To Do</span>
                                                                    </c:when>
                                                                    <c:when test="${issue.status == 2}">
                                                                        <span class="status-badge status-doing">Doing</span>
                                                                    </c:when>
                                                                    <c:when test="${issue.status == 3}">
                                                                        <span class="status-badge status-done">Done</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="status-badge status-closed">Closed</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${issue.due_date}</td>
                                                            <td>${issue.end_date}</td>
                                                            <td>
                                                                <div class="btn-group" role="group">
                                                                    <button type="button" class="btn btn-sm btn-primary edit-issue" 
                                                                            data-issue-id="${issue.id}" title="Edit">
                                                                        <i class="fa fa-edit"></i>
                                                                    </button>

                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination -->
                                        <div class="row mt-3">
                                            <div class="col-12">
                                                <nav aria-label="Page navigation">
                                                    <ul class="pagination justify-content-center">
                                                        <c:if test="${page > 1}">
                                                            <li class="page-item">
                                                                <a class="page-link" href="issue?page=${page-1}">&laquo;</a>
                                                            </li>
                                                        </c:if>
                                                        <c:forEach begin="1" end="${num}" var="i">
                                                            <li class="page-item ${i == page ? 'active' : ''}">
                                                                <a class="page-link" href="issue?page=${i}">${i}</a>
                                                            </li>
                                                        </c:forEach>
                                                        <c:if test="${page < num}">
                                                            <li class="page-item">
                                                                <a class="page-link" href="issue?page=${page+1}">&raquo;</a>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </nav>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Issue Modal -->
            <div class="modal fade" id="issueModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Issue Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="issueForm" action="${pageContext.request.contextPath}/issue" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="id" id="modalIssueId">

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Requirement ID <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control" name="requirementId" id="modalRequirementId" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Project <span class="text-danger">*</span></label>
                                            <select class="form-select" name="projectId" id="modalProjectId" required>
                                                <option value="">Select Project</option>
                                                <c:forEach items="${projects}" var="project">
                                                    <option value="${project.id}">${project.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Title <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="title" id="modalTitle" required 
                                           maxlength="100" placeholder="Enter issue title">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Description <span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="description" id="modalDescription" 
                                              rows="4" required maxlength="1000" 
                                              placeholder="Enter issue description"></textarea>
                                    <div class="form-text">Maximum 1000 characters</div>
                                </div>

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Type <span class="text-danger">*</span></label>
                                            <select class="form-select" name="type" id="modalType" required>
                                                <option value="">Select Type</option>
                                                <option value="Q&A">Q&A</option>
                                                <option value="Task">Task</option>
                                                <option value="Issue">Issue</option>
                                                <option value="Complaint">Complaint</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Assignee <span class="text-danger">*</span></label>
                                            <select class="form-select" name="assigneeId" id="modalAssigneeId" required>
                                                <option value="">Select Assignee</option>
                                                <c:forEach items="${users}" var="user">
                                                    <option value="${user.id}">${user.fullname}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Status <span class="text-danger">*</span></label>
                                    <select class="form-select" name="status" id="modalStatus" required>
                                        <option value="0">Open</option>
                                        <option value="1">To Do</option>
                                        <option value="2">Doing</option>
                                        <option value="3">Done</option>
                                        <option value="4">Closed</option>
                                    </select>
                                </div>

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Due Date <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" name="dueDate" id="modalDueDate" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">End Date <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" name="endDate" id="modalEndDate" required>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-primary"  id="saveIssue">Save</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

        <script>
            $(document).ready(function () {
                // Handle Read More buttons
                $('.read-more-btn').click(function () {
                    $(this).closest('.content-wrapper').toggleClass('expanded');
                    $(this).text(function (i, text) {
                        return text === "Read More" ? "Read Less" : "Read More";
                    });
                });

                // Handle Add Issue button
                // Update the add issue handler
                $('.add-issue').click(function () {
                    $('#issueForm')[0].reset();
                    $('#modalIssueId').val('');
                    $('input[name="action"]').val('add');
                    $('.modal-title').text('Add New Issue');
                    $('#saveIssue').text('Add Issue');

                    // Reset select fields
                    $('#modalProjectId').val(''); // Make sure it's empty, not '0'
                    $('#modalAssigneeId').val('');
                    $('#modalType').val('');
                    $('#modalStatus').val('0');

                    // Set default dates
                    const today = new Date().toISOString().split('T')[0];
                    $('#modalDueDate').val(today);
                    $('#modalEndDate').val(today);

                    clearErrors();
                    $('#issueModal').modal('show');
                });

                // Handle Edit Issue button
                $('.edit-issue').click(function () {
                    const row = $(this).closest('tr');

                    // Set form action to update
                    $('input[name="action"]').val('update');

                    // Populate form with row data
                    $('#modalIssueId').val(row.find('td:eq(0)').text());
                    $('#modalRequirementId').val(row.find('td:eq(1)').text());
                    $('#modalProjectId').val(row.find('td:eq(2)').text());
                    $('#modalTitle').val(row.find('td:eq(3)').text());
                    $('#modalDescription').val(row.find('td:eq(4) p').text().trim());
                    $('#modalType').val(row.find('td:eq(5) span').text().trim());
                    $('#modalAssigneeId').val(row.attr('data-assignee-id')); // Add this data attribute to your tr element
                    $('#modalStatus').val(getStatusValue(row.find('td:eq(7) span').text().trim()));
                    $('#modalDueDate').val(row.find('td:eq(8)').text());
                    $('#modalEndDate').val(row.find('td:eq(9)').text());

                    $('.modal-title').text('Edit Issue');
                    $('#saveIssue').text('Save Changes');
                    $('#issueModal').modal('show');
                });

                // Handle form submission
                $('#saveIssue').click(function () {
                    if (validateForm()) {
                        $('#issueForm').submit();
                    }
                });

                // Handle Sorting
                $('.sortTableHead').click(function () {
                    const fieldName = $(this).attr('name');
                    const currentOrder = $(this).attr('sortBy');
                    const newOrder = currentOrder === 'asc' ? 'desc' : 'asc';

                    // Update UI
                    $('.sortTableHead').attr('sortBy', 'desc');
                    $('.sortTableHead i').removeClass('fa-sort-up fa-sort-down').addClass('fa-sort');

                    $(this).attr('sortBy', newOrder);
                    $(this).find('i')
                            .removeClass('fa-sort')
                            .addClass(newOrder === 'asc' ? 'fa-sort-up' : 'fa-sort-down');

                    // Submit sort form
                    const form = $('<form>')
                            .attr('method', 'post')
                            .attr('action', '${pageContext.request.contextPath}/issue');

                    form.append($('<input>')
                            .attr('type', 'hidden')
                            .attr('name', 'action')
                            .attr('value', 'sort'));

                    form.append($('<input>')
                            .attr('type', 'hidden')
                            .attr('name', 'fieldName')
                            .attr('value', fieldName));

                    form.append($('<input>')
                            .attr('type', 'hidden')
                            .attr('name', 'sortBy')
                            .attr('value', newOrder));

                    $('body').append(form);
                    form.submit();
                });
            });

            // Form validation
            // Form validation with debugging
            function validateForm() {
                clearErrors();
                let isValid = true;

                // Debug logging
                console.log('Starting form validation');
                console.log('Type value:', $('#modalType').val());
                console.log('Project value:', $('#modalProjectId').val());
                console.log('Assignee value:', $('#modalAssigneeId').val());

                // Required fields validation
                const requiredFields = {
                    'modalTitle': 'Title is required',
                    'modalDescription': 'Description is required',
                    'modalRequirementId': 'Requirement ID is required',
                    'modalProjectId': 'Project is required',
                    'modalType': 'Type is required',
                    'modalAssigneeId': 'Assignee is required',
                    'modalDueDate': 'Due Date is required',
                    'modalEndDate': 'End Date is required'
                };

                // Check each required field
                for (const [fieldId, message] of Object.entries(requiredFields)) {
                    const field = $('#' + fieldId);
                    const value = field.val();

                    console.log(`Checking ${fieldId}:`, value); // Debug logging

                    // Special handling for select fields
                    if (field.is('select')) {
                        if (!value || value === '' || value === '0' || value === null) { // Added check for '0'
                            console.log(`Invalid select value for ${fieldId}`);
                            showError(fieldId, message);
                            isValid = false;
                        }
                    } else {
                        // Text input validation
                        if (!value || !value.trim()) {
                            console.log(`Empty value for ${fieldId}`);
                            showError(fieldId, message);
                            isValid = false;
                        }
                    }
                }

                // Length validations
                const titleLength = $('#modalTitle').val().length;
                const descLength = $('#modalDescription').val().length;
                console.log('Title length:', titleLength);
                console.log('Description length:', descLength);

                if (titleLength > 100) {
                    showError('modalTitle', 'Title must be less than 100 characters');
                    isValid = false;
                }

                if (descLength > 1000) {
                    showError('modalDescription', 'Description must be less than 1000 characters');
                    isValid = false;
                }

                // Date validation
                const dueDate = new Date($('#modalDueDate').val());
                const endDate = new Date($('#modalEndDate').val());
                console.log('Due date:', dueDate);
                console.log('End date:', endDate);

                if (dueDate > endDate) { // Fixed the comparison
                    showError('modalDueDate', 'Due date cannot be later than end date');
                    isValid = false;
                }

                console.log('Form validation result:', isValid);
                return isValid;
            }

            function showError(fieldId, message) {
                const field = $('#' + fieldId);
                field.addClass('is-invalid');

                // Remove any existing error message first
                field.next('.invalid-feedback').remove();

                // Add new error message
                field.after('<div class="invalid-feedback">' + message + '</div>');

                // For select elements, also add a red border
                if (field.is('select')) {
                    field.css('border-color', '#dc3545');
                }
            }

            function clearErrors() {
                $('.is-invalid').removeClass('is-invalid');
                $('.invalid-feedback').remove();
                // Reset select borders
                $('select').css('border-color', '');
            }

            function getStatusValue(statusText) {
                const statusMap = {
                    'Open': '0',
                    'To Do': '1',
                    'Doing': '2',
                    'Done': '3',
                    'Closed': '4'
                };
                return statusMap[statusText.trim()] || '0';
            }
        </script>
    </body>
</html>