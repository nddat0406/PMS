<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Project Requirements</title>
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
            }
            .is-invalid {
                border-color: #dc3545;
            }
            .complexity-badge {
                padding: 0.25em 0.6em;
                border-radius: 0.25rem;
                font-size: 0.875em;
            }
            .complexity-low {
                background-color: #28a745;
                color: white;
            }
            .complexity-medium {
                background-color: #ffc107;
                color: black;
            }
            .complexity-high {
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
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Issues</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Home</a></li>
                                            <li class="breadcrumb-item active">Issues</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-lg-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="card-title">Requirements List</h6>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="d-flex col-lg-1 justify-content-between align-items-center ms-auto">
                                                    <button class="btn btn-sm btn-primary add-requirement">
                                                        <i class="fa fa-plus"></i> Add
                                                    </button>
                                                </div>
                                                <span style="color: red">${errorMessage}</span>
                                        </div>
                                    </div>

                                    <!-- Filter Section -->
                                    <div class="card-body">
                                        <form action="requirement" method="post">
                                            <input hidden type="text" value="filter" name="action">
                                            <div style="display: flex; justify-content: space-between">
                                                <div class="input-group mb-3" style="width: 25%">
                                                    <span class="input-group-text">Complexity</span>
                                                    <select class="form-select" name="complexityFilter" id="complexityFilter" onchange="ChangeFilter()">
                                                        <option value="0" ${complexityFilter==0?'selected':''}>All Complexity</option>
                                                        <option value="Low" ${complexityFilter=='Low'?'selected':''}>Low</option>
                                                        <option value="Medium" ${complexityFilter=='Medium'?'selected':''}>Medium</option>
                                                        <option value="High" ${complexityFilter=='High'?'selected':''}>High</option>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-3" style="width: 25%">
                                                    <span class="input-group-text">Project</span>
                                                    <select class="form-select" name="projectFilter" id="projectFilter" onchange="ChangeFilter()">
                                                        <option value="0" ${projectFilter==0?'selected':''}>All Projects</option>
                                                        <c:forEach items="${requirementService.getAllProject()}" var="p">
                                                            <option value="${p.id}" ${projectFilter==p.id?'selected':''}>${p.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-3" style="width: 25%">
                                                    <span class="input-group-text">Status</span>
                                                    <select class="form-select" name="statusFilter" id="statusFilter" onchange="ChangeFilter()">
                                                        <option value="0" ${statusFilter==0?'selected':''}>All Status</option>
                                                        <option value="1" ${statusFilter==1?'selected':''}>To Do</option>
                                                        <option value="2" ${statusFilter==2?'selected':''}>In Progress</option>
                                                        <option value="3" ${statusFilter==3?'selected':''}>Completed</option>
                                                        <option value="4" ${statusFilter==4?'selected':''}>Cancelled</option>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-3" style="width: 15%">
                                                    <input value="${searchKey.trim()}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                    <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <div class="card-body">
                                        <table id="requirements_list" class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th name="id" sortBy="desc" class="sortTableHead" aria-sort="none">ID <i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="title" sortBy="desc" class="sortTableHead" aria-sort="none">Title <i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="projectName" sortBy="desc" class="sortTableHead" aria-sort="none">Project <i class="fa fa-sort sort-icon"></i></th>
                                                    <th style="display: none">Details</th>
                                                    <th name="complexity" sortBy="desc" class="sortTableHead" aria-sort="none">Complexity <i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="status" sortBy="desc" class="sortTableHead" aria-sort="none">Status <i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="estimatedEffort" sortBy="desc" class="sortTableHead" aria-sort="none">Effort (h) <i class="fa fa-sort sort-icon"></i></th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody class="tableBody">
                                                <c:forEach items="${tableData}" var="req">
                                                    <tr>
                                                        <td>${req.id}</td>
                                                        <td>${req.title}</td>
                                                        <td>${requirementService.getProjectName(req.projectId)}</td>
                                                        <td style="display: none">
                                                            <div class="content-wrapper">
                                                                <p>${req.details}</p>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="complexity-badge complexity-${req.complexity.toLowerCase()}">${req.complexity}</span>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-${
                                                                  req.status == 0 ? 'secondary' : 
                                                                      req.status == 1 ? 'primary' : 
                                                                      req.status == 2 ? 'info' : 
                                                                      req.status == 3 ? 'warning' :
                                                                      req.status == 4 ? 'success' :
                                                                      req.status == 5 ? 'dark' : 'danger'}">
                                                                      ${req.status == 0 ? 'Pending' : 
                                                                        req.status == 1 ? 'Committed' : 
                                                                        req.status == 2 ? 'Analyze' : 
                                                                        req.status == 3 ? 'Design' :
                                                                        req.status == 4 ? 'Accepted' :
                                                                        req.status == 5 ? 'Coded' : 'Tested'}
                                                                  </span>
                                                            </td>
                                                            <td>${req.estimatedEffort}</td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-secondary view-details" data-id="${req.id}">
                                                                    <i class="fa fa-eye"></i> View Details
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>

                                            <!-- No Results Message -->
                                            <c:if test="${empty tableData}">
                                                <div class="card-body text-center">
                                                    <h4>No requirements found!</h4>
                                                </div>
                                            </c:if>

                                            <!-- Pagination -->
                                            <nav aria-label="Page navigation" class="mt-3">
                                                <ul class="pagination justify-content-center">
                                                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/requirement?page=${page-1}">Previous</a>
                                                    </li>
                                                    <c:forEach begin="1" end="${num}" var="i">
                                                        <li class="page-item ${i == page ? 'active' : ''}">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/requirement?page=${i}">${i}</a>
                                                        </li>
                                                    </c:forEach>
                                                    <li class="page-item ${page == num ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/requirement?page=${page+1}">Next</a>
                                                    </li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


                <!-- Requirement Detail Modal -->
                <!-- Requirement Detail Modal -->
                <div class="modal fade" id="requirementDetailModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Requirement Details</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                            <form id="requirementForm" action="requirement" method="post">
                                <div class="modal-body">
                                    <input type="hidden" name="action" id="formAction" value="update">
                                    <input type="hidden" name="id" id="modalRequirementId">
                                    <input type="hidden" name="userId" id="modalRequirementId" value="${loginedUser.id}">

                                    <div class="mb-3">
                                        <label class="form-label">Title <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="title" id="modalTitle" required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Project <span class="text-danger">*</span></label>
                                        <select class="form-select" name="projectId" id="modalProject" required onchange="loadMilestones(this.value)">
                                            <option value="">Select Project</option>
                                            <c:forEach items="${requirementService.getAllProject()}" var="project">
                                                <option value="${project.id}">${project.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Milestone</label>
                                        <select class="form-select" name="milestoneId" id="modalMilestone">
                                            <option value="">Select Milestone</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Details <span class="text-danger">*</span></label>
                                        <textarea class="form-control" name="details" id="modalDetails" rows="4" required></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Complexity <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="complexity" id="modalComplexity" required 
                                               placeholder="Enter Low, Medium, or High">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Status <span class="text-danger">*</span></label>
                                        <select class="form-select" name="status" id="modalStatus" required>
                                            <option value="0">Pending</option>
                                            <option value="1">Committed</option>
                                            <option value="2">Analyze</option>
                                            <option value="3">Design</option>
                                            <option value="4">Accepted</option>
                                            <option value="5">Coded</option>
                                            <option value="6">Tested</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Estimated Effort (hours) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="estimatedEffort" id="modalEstimatedEffort" 
                                               required min="1" max="20" placeholder="Enter value between 1-20">
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    <button type="submit" id="button-modal-submit" class="btn btn-primary">Save changes</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Scripts -->
            <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
            <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

            <script>
                                // Filter change handler
                                function ChangeFilter() {
                                var complexityFilter = document.getElementById("complexityFilter").value;
                                var projectFilter = document.getElementById("projectFilter").value;
                                var statusFilter = document.getElementById("statusFilter").value;
                                $.ajax({
                                url: "requirement<script>
                                        // Filter change handler
                                                function ChangeFilter() {
                                                var complexityFilter = document.getElementById("complexityFilter").value;
                                                var projectFilter = document.getElementById("projectFilter").value;
                                                var statusFilter = document.getElementById("statusFilter").value;
                                                $.ajax({
                                                url: "requirement",
                                                        type: 'post',
                                                        data: {
                                                        complexityFilter: complexityFilter,
                                                                projectFilter: projectFilter,
                                                                statusFilter: statusFilter,
                                                                action: "filter"
                                                        },
                                                        success: function () {
                                                        $('.tableBody').load("${pageContext.request.contextPath}/requirement?page=${page} .tableBody > *");
                                                        }
                                                });
                                                }

                                        // Form submission handler
                                        $('#button-modal-submit').on('click', function (e) {
                                        e.preventDefault();
                                        if (validateForm()) {
                                        var isEdit = $('#modalRequirementId').val() !== '';
                                        // Set action based on operation
                                        $('#requirementForm').attr('action',
                                                '${pageContext.request.contextPath}/requirement?action=' +
                                                (isEdit ? 'update' : 'add')
                                                );
                                        $('#requirementForm').submit();
                                        }
                                        });
                                        // Error handling functions
                                        function showError(fieldId, message) {
                                        const field = $(`#${fieldId}`);
                                        field.addClass('is-invalid');
                                        field.after(`<div class="invalid-feedback">${message}</div>`);
                                        }

                                        function clearErrors() {
                                        $('.is-invalid').removeClass('is-invalid');
                                        $('.invalid-feedback').remove();
                                        }

                                        // Sorting handlers
                                        $(document).ready(function () {
                                        $('.sortTableHead').on('click', function () {
                                        var $th = $(this);
                                        var name = $th.attr('name');
                                        var sortBy = $th.attr('sortBy');
                                        $('.sortTableHead .sort-icon').removeClass('fa-sort-up fa-sort-down').addClass('fa-sort');
                                        if (sortBy === 'asc') {
                                        sortBy = 'desc';
                                        $th.find('.sort-icon').removeClass('fa-sort fa-sort-up').addClass('fa-sort-down');
                                        } else {
                                        sortBy = 'asc';
                                        $th.find('.sort-icon').removeClass('fa-sort fa-sort-down').addClass('fa-sort-up');
                                        }

                                        $th.attr('sortBy', sortBy);
                                        $.ajax({
                                        url: "requirement",
                                                type: 'post',
                                                data: {
                                                sortBy: sortBy,
                                                        fieldName: name,
                                                        action: "sort"
                                                },
                                                success: function () {
                                                $('.tableBody').load("${pageContext.request.contextPath}/requirement?page=${page} .tableBody > *");
                                                }
                                        });
                                        });
                                        });
                                        // Show more/less for details
                                        $(document).on('click', '.content-wrapper', function() {
                                        $(this).toggleClass('expanded');
                                        });
            </script>

            <script>
                        function showError(fieldId, message) {
                        var field = $('#' + fieldId);
                        field.addClass('is-invalid');
                        field.after('<div class="invalid-feedback">' + message + '</div>');
                        }
            </script>
            <script>
                        function validateForm() {
                        // Clear previous errors
                        $('.is-invalid').removeClass('is-invalid');
                        $('.invalid-feedback').remove();
                        var isValid = true;
                        // Validate title
                        if ($('#modalTitle').val().trim() === '') {
                        showError('modalTitle', 'Title is required');
                        isValid = false;
                        } else if ($('#modalTitle').val().length > 100) {
                        showError('modalTitle', 'Title must be less than 100 characters');
                        isValid = false;
                        }

                        // Validate details
                        if ($('#modalDetails').val().trim() === '') {
                        showError('modalDetails', 'Details are required');
                        isValid = false;
                        } else if ($('#modalDetails').val().length > 1000) {
                        showError('modalDetails', 'Details must be less than 1000 characters');
                        isValid = false;
                        }

                        // Validate complexity
                        var complexity = $('#modalComplexity').val().trim();
                        var validComplexities = ['Low', 'Medium', 'High'];
                        if (!complexity) {
                        showError('modalComplexity', 'Complexity is required');
                        isValid = false;
                        } else if (!validComplexities.includes(complexity)) {
                        showError('modalComplexity', 'Complexity must be Low, Medium, or High');
                        isValid = false;
                        }

                        // Validate project selection
                        if ($('#modalProject').val() === '') {
                        showError('modalProject', 'Project selection is required');
                        isValid = false;
                        }

                        // Validate estimated effort
                        var effort = parseInt($('#modalEstimatedEffort').val());
                        if (isNaN(effort) || effort < 1 || effort > 20) {
                        showError('modalEstimatedEffort', 'Effort must be between 1 and 20 hours');
                        isValid = false;
                        }

                        return isValid;
                        }

                        // Update add requirement handler with complexity text
                        $('.add-requirement').on('click', function () {
                        // Reset form
                        $('#requirementForm')[0].reset();
                        $('#modalRequirementId').val('');
                        // Change title and submit button text
                        $('.modal-title').text('Add New Requirement');
                        $('#button-modal-submit').text('Add Requirement');
                        $('#formAction').val('add');
                        // Set default values
                        $('#modalStatus').val('0'); // Pending
                        $('#modalComplexity').val('Low'); // Default complexity
                        $('#modalEstimatedEffort').val('1'); // Minimum effort

                        // Show the modal
                        var myModal = new bootstrap.Modal(document.getElementById('requirementDetailModal'));
                        myModal.show();
                        });
            </script>

            <script>
                        // Modify the loadMilestones function to return a Promise
                        function loadMilestones(projectId) {
                        return new Promise((resolve, reject) => {
                        if (!projectId) {
                        $('#modalMilestone').html('<option value="">Select Milestone</option>');
                        resolve();
                        return;
                        }

                        $.ajax({
                        url: 'requirement',
                                type: 'POST',
                                data: {
                                action: 'getMilestones',
                                        projectId: projectId
                                },
                                success: function(response) {
                                var milestoneSelect = $('#modalMilestone');
                                milestoneSelect.empty();
                                milestoneSelect.append('<option value="">Select Milestone</option>');
                                // Add new milestone options
                                if (Array.isArray(response)) {
                                response.forEach(function(milestone) {
                                milestoneSelect.append(
                                        '<option value="' + milestone.id + '">' + milestone.name + '</option>'
                                        );
                                });
                                } else {
                                // If response is a string (JSON string), parse it first
                                try {
                                var milestones = JSON.parse(response);
                                milestones.forEach(function(milestone) {
                                milestoneSelect.append(
                                        '<option value="' + milestone.id + '">' + milestone.name + '</option>'
                                        );
                                });
                                } catch (e) {
                                console.error('Error parsing milestone data:', e);
                                }
                                }
                                resolve();
                                },
                                error: function(xhr, status, error) {
                                console.error('Error loading milestones:', error);
                                reject(error);
                                }
                        });
                        });
                        }

    // Function to load requirement milestone
                        function loadRequirementMilestone(requirementId) {
                        return new Promise((resolve, reject) => {
                        $.ajax({
                        url: 'requirement',
                                type: 'POST',
                                data: {
                                action: 'getMilestoneId',
                                        requirementId: requirementId
                                },
                                success: function(milestoneId) {
                                if (milestoneId) {
                                $('#modalMilestone').val(milestoneId);
                                }
                                resolve();
                                },
                                error: function(xhr, status, error) {
                                console.error('Error loading milestone for requirement:', error);
                                reject(error);
                                }
                        });
                        });
                        }

    // Update the view-details click handler
                        $(document).on('click', '.view-details', function() {
                        var row = $(this).closest('tr');
                        var id = row.find('td:eq(0)').text();
                        var title = row.find('td:eq(1)').text();
                        var projectName = row.find('td:eq(2)').text();
                        var details = row.find('td:eq(3) p').text().trim();
                        var complexity = row.find('td:eq(4)').text().trim();
                        var status = row.find('td:eq(5) .badge').text().trim();
                        var estimatedEffort = row.find('td:eq(6)').text();
                        // Change title and submit button text
                        $('.modal-title').text('Edit Requirement');
                        $('#button-modal-submit').text('Save Changes');
                        $('#formAction').val('update');
                        // Populate modal fields
                        $('#modalRequirementId').val(id);
                        $('#modalTitle').val(title);
                        $('#modalDetails').val(details);
                        $('#modalComplexity').val(complexity);
                        $('#modalEstimatedEffort').val(estimatedEffort);
                        // Set status value
                        var statusMap = {
                        'Pending': 0,
                                'Committed': 1,
                                'Analyze': 2,
                                'Design': 3,
                                'Accepted': 4,
                                'Coded': 5,
                                'Tested': 6
                        };
                        $('#modalStatus').val(statusMap[status.trim()]);
                        // Find and select the matching project in the dropdown
                        $('#modalProject option').each(function() {
                        if ($(this).text() === projectName) {
                        $(this).prop('selected', true);
                        var projectId = $(this).val();
                        // Chain the promises
                        loadMilestones(projectId)
                                .then(() => loadRequirementMilestone(id))
                                .catch(error => {
                                console.error('Error in loading data:', error);
                                });
                        }
                        });
                        // Show the modal
                        var myModal = new bootstrap.Modal(document.getElementById('requirementDetailModal'));
                        myModal.show();
                        });
    // Update the onchange handler for project selection
                        $('#modalProject').on('change', function() {
                        var projectId = $(this).val();
                        loadMilestones(projectId)
                                .catch(error => {
                                console.error('Error loading milestones:', error);
                                });
                        });
            </script>


        </body>
    </html>