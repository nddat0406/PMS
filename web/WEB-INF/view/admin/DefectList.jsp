<%-- DefectList.jsp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Defect List</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

        <style>
            .modal .form-check {
                padding-left: 1.8em;
                margin-top: 10px;
            }

            .modal .form-check-input:checked {
                background-color: #2196F3;
                border-color: #2196F3;
            }

            .modal .form-check-input {
                border: 2px solid #666;
                width: 20px;
                height: 20px;
                cursor: pointer;
            }

            .modal .form-check-label {
                cursor: pointer;
                padding-left: 8px;
            }
        </style>
    </head>

    <body>
        <div id="layout" class="theme-cyan">
            <!-- Page Loader -->
            <jsp:include page="../common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">
                    <!-- Top navbar -->
                <jsp:include page="../common/topNavbar.jsp"></jsp:include>

                    <!-- Sidebar -->
                <jsp:include page="../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">Defect List</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="#">Home</a></li>
                                            <li class="breadcrumb-item active">Defects</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title">Defect Management</h6>
                                    <ul class="header-dropdown">
                                        <li>
                                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" 
                                                    data-bs-target="#addDefectModal">
                                                Add New Defect
                                            </button>
                                        </li>
                                    </ul>
                                </div>

                                <div class="card-body">
                                    <!-- Search Form -->
                                    <form action="${pageContext.request.contextPath}/defectlist" method="POST">
                                    <input type="hidden" name="action" value="search">

                                    <div class="row mb-3">
                                        <!-- Keyword Search -->
                                        <div class="col-md-3">
                                            <input type="text" class="form-control" name="keyword" 
                                                   value="${param.keyword}" placeholder="Search title...">
                                        </div>

                                        <!-- Requirement Filter -->
                                        <div class="col-md-2">
                                            <select name="requirementId" class="form-select">
                                                <option value="">All Requirements</option>
                                                <c:forEach items="${requirements}" var="req">
                                                    <option value="${req.id}" ${param.requirementId == req.id ? 'selected' : ''}>
                                                        ${req.title}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Milestone Filter -->
                                        <div class="col-md-2">
                                            <select name="milestoneId" class="form-select">
                                                <option value="">All Milestones</option>
                                                <c:forEach items="${milestones}" var="mile">
                                                    <option value="${mile.id}" ${param.milestoneId == mile.id ? 'selected' : ''}>
                                                        ${mile.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Severity Filter -->
                                        <div class="col-md-2">
                                            <select name="serverityId" class="form-select">
                                                <option value="">All Severities</option>
                                                <c:forEach items="${serverities}" var="sev">
                                                    <option value="${sev.id}" ${param.serverityId == sev.id ? 'selected' : ''}>
                                                        ${sev.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Status Filter -->
                                        <div class="col-md-2">
                                            <select name="status" class="form-select">
                                                <option value="">All Status</option>
                                                <option value="1" ${param.status == '1' ? 'selected' : ''}>Open</option>
                                                <option value="2" ${param.status == '2' ? 'selected' : ''}>In Progress</option>
                                                <option value="3" ${param.status == '3' ? 'selected' : ''}>Fixed</option>
                                                <option value="4" ${param.status == '4' ? 'selected' : ''}>Closed</option>
                                            </select>
                                        </div>

                                        <!-- Search Button -->
                                        <div class="col-md-1">
                                            <button type="submit" class="btn btn-primary w-100">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                                </form>

                                <!-- Error Messages -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger">
                                        ${error}
                                    </div>
                                </c:if>

                                <!-- Defect List Table -->
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Title</th>
                                                <th>Requirement</th>
                                                <th>Milestone</th>
                                                <th>Severity</th>
                                                <th>Due Date</th>
                                                <th>Status</th>
                                                <th>Leakage</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${defects}" var="defect">
                                                <tr>
                                                    <td>${defect.id}</td>
                                                    <td>${defect.title}</td>
                                                    <td>${defect.requirement.title}</td>
                                                    <td>${defect.milestone.name}</td>
                                                    <td>
                                                        <span class="badge bg-${defect.serverity.id == 1 ? 'danger' : defect.serverity.id == 2 ? 'warning' : 'info'}">
                                                            ${defect.serverity.name}
                                                        </span>
                                                    </td>
                                                    <td>${defect.duedate}</td>
                                                    <td>
                                                        <span class="badge ${defect.status == 1 ? 'bg-primary' : 
                                                                             defect.status == 2 ? 'bg-warning' : 
                                                                             defect.status == 3 ? 'bg-info' : 'bg-success'}">
                                                                  ${defect.status == 1 ? 'Open' : 
                                                                    defect.status == 2 ? 'In Progress' : 
                                                                    defect.status == 3 ? 'Fixed' : 'Closed'}
                                                              </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${defect.leakage ? 'bg-danger' : 'bg-secondary'}">
                                                                ${defect.leakage ? 'Yes' : 'No'}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <!-- Edit Button -->
                                                            <a href="${pageContext.request.contextPath}/defectdetail?id=${defect.id}" 
                                                               class="btn btn-sm btn-outline-primary">
                                                                <i class="fa fa-edit"></i>
                                                            </a>

                                                            <!-- Status Change Button (if not closed) -->
                                                            <c:if test="${defect.status != 4}">
                                                                <form action="${pageContext.request.contextPath}/defectlist" 
                                                                      method="POST" style="display: inline;">
                                                                    <input type="hidden" name="action" value="changeStatus">
                                                                    <input type="hidden" name="id" value="${defect.id}">
                                                                    <input type="hidden" name="status" value="${defect.status + 1}">
                                                                    <button type="submit" class="btn btn-sm btn-success">
                                                                        Move to ${defect.status == 1 ? 'In Progress' : 
                                                                                  defect.status == 2 ? 'Fixed' : 'Closed'}
                                                                    </button>
                                                                </form>
                                                            </c:if>

                                                            <!-- Delete Button -->
                                                            <button type="button" class="btn btn-sm btn-danger" 
                                                                    onclick="if (confirm('Are you sure to delete this defect?')) {
                                                                                submitDeleteForm(${defect.id});
                                                                            }">
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="addDefectModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Add New Defect</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <form action="${pageContext.request.contextPath}/defectlist" method="POST">
                                    <input type="hidden" name="action" value="add">

                                    <div class="row g-3">
                                        <!-- Title -->
                                        <div class="col-md-12">
                                            <label for="title" class="form-label">Title *</label>
                                            <input type="text" class="form-control" id="title" name="title" required>
                                        </div>

                                        <!-- Requirement -->
                                        <div class="col-md-6">
                                            <label for="requirementId" class="form-label">Requirement *</label>
                                            <select class="form-select" id="requirementId" name="requirementId" required>
                                                <option value="">Select Requirement</option>
                                                <c:forEach items="${requirements}" var="req">
                                                    <option value="${req.id}">${req.title}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Milestone -->
                                        <div class="col-md-6">
                                            <label for="milestoneId" class="form-label">Milestone *</label>
                                            <select class="form-select" id="milestoneId" name="milestoneId" required>
                                                <option value="">Select Milestone</option>
                                                <c:forEach items="${milestones}" var="mile">
                                                    <option value="${mile.id}">${mile.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Severity -->
                                        <div class="col-md-6">
                                            <label for="serverityId" class="form-label">Severity *</label>
                                            <select class="form-select" id="serverityId" name="serverityId" required>
                                                <option value="">Select Severity</option>
                                                <c:forEach items="${serverities}" var="sev">
                                                    <option value="${sev.id}">${sev.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Due Date -->
                                        <div class="col-md-6">
                                            <label for="duedate" class="form-label">Due Date *</label>
                                            <input type="date" class="form-control" id="duedate" name="duedate" required>
                                        </div>

                                        <!-- Details -->
                                        <div class="col-12">
                                            <label for="details" class="form-label">Details</label>
                                            <textarea class="form-control" id="details" name="details" rows="3"></textarea>
                                        </div>

                                        <!-- Leakage Checkbox -->
                                        <div class="col-md-6">
                                            <div class="form-check">
                                                <input type="checkbox" class="form-check-input" id="leakage" name="leakage">
                                                <label class="form-check-label" for="leakage">Leakage</label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                        <button type="submit" class="btn btn-primary">Add Defect</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Delete Form -->
                <form id="deleteForm" action="${pageContext.request.contextPath}/defectlist" method="POST" style="display: none;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteId">
                </form>
            </div>

            <!-- Add Defect Modal -->


            <!-- Core JS -->
            <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
            <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
            <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

            <script>
                                                                        $(document).ready(function () {
                                                                            // Initialize DataTable
                                                                            $('.table').DataTable({
                                                                                responsive: true
                                                                            });

                                                                            // Submit delete form
                                                                            window.submitDeleteForm = function (id) {
                                                                                document.getElementById('deleteId').value = id;
                                                                                document.getElementById('deleteForm').submit();
                                                                            }

                                                                            // Requirement change handler to load related milestones
                                                                            $('#requirementId').change(function () {
                                                                                const reqId = $(this).val();
                                                                                if (reqId) {
                                                                                    // Clear current milestone options
                                                                                    $('#milestoneId').html('<option value="">Select Milestone</option>');

                                                                                    // Load milestones for selected requirement's project
                                                                                    $.get('${pageContext.request.contextPath}/admin/getMilestones',
                                                                                            {requirementId: reqId},
                                                                                            function (milestones) {
                                                                                                milestones.forEach(function (milestone) {
                                                                                                    $('#milestoneId').append(
                                                                                                            `<option value="${milestone.id}">${milestone.name}</option>`
                                                                                                            );
                                                                                                });
                                                                                            }
                                                                                    );
                                                                                }
                                                                            });

                                                                            // Date validation
                                                                            $('#duedate').attr('min', new Date().toISOString().split('T')[0]);
                                                                        });
            </script>
        </body>
    </html>