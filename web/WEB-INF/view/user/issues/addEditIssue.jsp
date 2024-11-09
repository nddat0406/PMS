<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>${issue == null ? 'Add New Issue' : 'Edit Issue'}</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/select2.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <style>
            .error-message {
                font-size: 0.875rem;
                margin-top: 0.25rem;
                color: #dc3545;
            }
            .is-invalid {
                border-color: #dc3545;
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
                                        ${issue == null ? 'Add New Issue' : 'Edit Issue'}
                                    </h2>
                                    <ul class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="/dashboard">Home</a></li>
                                        <li class="breadcrumb-item"><a href="issue">Issues</a></li>
                                        <li class="breadcrumb-item active">${issue == null ? 'Add New Issue' : 'Edit Issue'}</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Form Section -->
                        <div class="row clearfix">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <form id="issueForm" action="${pageContext.request.contextPath}/issue" method="post">
                                            <input type="hidden" name="action" value="${issue == null ? 'add' : 'update'}">
                                            <c:if test="${issue != null}">
                                                <input type="hidden" name="id" value="${issue.id}">
                                            </c:if>

                                            <div class="mb-3">
                                                <label class="form-label">Title <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" name="title" id="title" 
                                                       value="${issue != null ? issue.title : ''}"
                                                       maxlength="100" placeholder="Enter issue title">
                                            </div>

                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Type <span class="text-danger">*</span></label>
                                                        <select class="form-select" name="type" id="type" >
                                                            <option value="">Select Type</option>
                                                            <option value="Q&A" ${issue != null && issue.type == 'Q&A' ? 'selected' : ''}>Q&A</option>
                                                            <option value="Task" ${issue != null && issue.type == 'Task' ? 'selected' : ''}>Task</option>
                                                            <option value="Issue" ${issue != null && issue.type == 'Issue' ? 'selected' : ''}>Issue</option>
                                                            <option value="Complaint" ${issue != null && issue.type == 'Complaint' ? 'selected' : ''}>Complaint</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Project <span class="text-danger">*</span></label>
                                                        <select class="form-select" name="projectId" id="projectId" >
                                                            <option value="">Select Project</option>
                                                            <c:forEach items="${projects}" var="project">
                                                                <option value="${project.id}" ${issue != null && issue.projectId == project.id ? 'selected' : ''}>
                                                                    ${project.name}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Requirement <span class="text-danger">*</span></label>
                                                        <select class="form-select" name="requirementId" id="requirementId" >
                                                            <option value="">Select Requirement</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Assignee <span class="text-danger">*</span></label>
                                                        <select class="form-select" name="assigneeId" id="assigneeId" >
                                                            <option value="">Select Assignee</option>
                                                            <c:forEach items="${users}" var="user">
                                                                <option value="${user.id}" ${issue != null && issue.assignee_id == user.id ? 'selected' : ''}>
                                                                    ${user.fullname}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Status <span class="text-danger">*</span></label>
                                                        <select class="form-select" name="status" id="status" >
                                                            <option value="0" ${issue != null && issue.status == 0 ? 'selected' : ''}>Open</option>
                                                            <option value="1" ${issue != null && issue.status == 1 ? 'selected' : ''}>To Do</option>
                                                            <option value="2" ${issue != null && issue.status == 2 ? 'selected' : ''}>Doing</option>
                                                            <option value="3" ${issue != null && issue.status == 3 ? 'selected' : ''}>Done</option>
                                                            <option value="4" ${issue != null && issue.status == 4 ? 'selected' : ''}>Closed</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Due Date <span class="text-danger">*</span></label>
                                                        <input type="date" class="form-control" name="dueDate" 
                                                               value="${issue != null ? issue.due_date : ''}"
                                                               id="dueDate" >
                                                    </div>
                                                </div>
                                            </div>
                                            <c:if test="${issue!=null}" >
                                                <div class="mb-3">
                                                    <label class="form-label">End Date <span class="text-danger">*</span></label>
                                                    <input type="date" class="form-control" name="endDate" 
                                                           value="${issue != null ? issue.end_date : ''}"
                                                           id="endDate">
                                                </div>
                                            </c:if>


                                            <div class="mb-3">
                                                <label class="form-label">Description <span class="text-danger">*</span></label>
                                                <textarea class="form-control" name="description" id="description" 
                                                          rows="4"  maxlength="1000" 
                                                          placeholder="Enter issue description">${issue != null ? issue.description : ''}</textarea>
                                                <div class="form-text">Maximum 1000 characters</div>
                                            </div>

                                            <div class="row">
                                                <div class="col-12">
                                                    <button type="submit" class="btn btn-primary me-2">${issue == null ? 'Add Issue' : 'Save Changes'}</button>
                                                    <a href="issue" class="btn btn-secondary">Cancel</a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
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
                // Form validation
                $('#issueForm').on('submit', function (e) {
                    e.preventDefault();
                    if (validateForm()) {
                        this.submit();
                    }
                });

                $('#projectId').on('change', function () {
                    const projectId = $(this).val();

                    if (projectId) {
                        // Load requirements
                        loadRequirements(projectId);
                        // Load assignees
                        loadAssignees(projectId);
                    } else {
                        // Clear both dropdowns if no project selected
                        $('#requirementId').html('<option value="">Select Requirement</option>');
                        $('#assigneeId').html('<option value="">Select Assignee</option>');
                    }
                });
            });

            function validateForm() {
                clearErrors();
                let isValid = true;

                //  fields validation
                // Remove 'endDate' from  fields
                const Fields = {
                    'title': 'Title is ',
                    'description': 'Description is ',
                    'requirementId': 'Requirement ID is ',
                    'projectId': 'Project is ',
                    'type': 'Type is ',
                    'assigneeId': 'Assignee is ',
                    'dueDate': 'Due Date is '
                            // Removed endDate from here
                };

                // Check each  field
                for (const [fieldId, message] of Object.entries(Fields)) {
                    const field = $('#' + fieldId);
                    const value = field.val();

                    if (field.is('select')) {
                        if (!value || value === '' || value === '0') {
                            showError(fieldId, message);
                            isValid = false;
                        }
                    } else {
                        if (!value || !value.trim()) {
                            showError(fieldId, message);
                            isValid = false;
                        }
                    }
                }

                // Length validations
                const titleLength = $('#title').val().length;
                const descLength = $('#description').val().length;

                if (titleLength > 100) {
                    showError('title', 'Title must be less than 100 characters');
                    isValid = false;
                }

                if (descLength > 1000) {
                    showError('description', 'Description must be less than 1000 characters');
                    isValid = false;
                }

                return isValid;
            }

            function showError(fieldId, message) {
                const field = $('#' + fieldId);
                field.addClass('is-invalid');
                field.next('.invalid-feedback').remove();
                field.after('<div class="invalid-feedback">' + message + '</div>');

                if (field.is('select')) {
                    field.css('border-color', '#dc3545');
                }
            }

            function clearErrors() {
                $('.is-invalid').removeClass('is-invalid');
                $('.invalid-feedback').remove();
                $('select').css('border-color', '');
            }
        </script>

        <script>
            function loadRequirements(projectId) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/issue',
                    type: 'POST',
                    data: {
                        action: 'getRequirements',
                        projectId: projectId
                    },
                    success: function (response) {
                        var requirementSelect = $('#requirementId');
                        requirementSelect.empty();
                        requirementSelect.append('<option value="">Select Requirement</option>');

                        try {
                            const requirements = typeof response === 'string' ? JSON.parse(response) : response;

                            if (Array.isArray(requirements)) {
                                requirements.forEach(function (req) {
                                    requirementSelect.append(
                                            $('<option>', {
                                                value: req.id,
                                                text: '#' + req.id + ' - ' + req.title
                                            })
                                            );
                                });
                            }

                            // If editing and has requirement ID, select it
                            var currentReqId = '${issue != null ? issue.requirementId : ""}';
                            if (currentReqId) {
                                requirementSelect.val(currentReqId);
                            }
                        } catch (e) {
                            console.error('Error parsing requirements:', e);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error loading requirements:', error);
                    }
                });
            }

            function loadAssignees(projectId) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/issue',
                    type: 'POST',
                    data: {
                        action: 'getAssignees',
                        projectId: projectId
                    },
                    success: function (response) {
                        var assigneeSelect = $('#assigneeId');
                        assigneeSelect.empty();
                        assigneeSelect.append('<option value="">Select Assignee</option>');

                        try {
                            const assignees = typeof response === 'string' ? JSON.parse(response) : response;

                            if (Array.isArray(assignees)) {
                                assignees.forEach(function (user) {
                                    assigneeSelect.append(
                                            $('<option>', {
                                                value: user.id,
                                                text: user.fullname
                                            })
                                            );
                                });
                            }

                            // If editing and has assignee ID, select it
                            var currentAssigneeId = '${issue != null ? issue.assignee_id : ""}';
                            if (currentAssigneeId) {
                                assigneeSelect.val(currentAssigneeId);
                            }
                        } catch (e) {
                            console.error('Error parsing assignees:', e);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error loading assignees:', error);
                    }
                });
            }

            $(document).ready(function () {
                var projectId = $('#projectId').val();
                if (projectId) {
                    loadRequirements(projectId);
                    loadAssignees(projectId);
                }
            });
        </script>
    </body>
</html>