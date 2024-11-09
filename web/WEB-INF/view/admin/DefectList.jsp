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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

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
                                        <!-- Milestone Filter -->
                                        <div class="col-md-2">
                                            <select name="projectId" id="projectId" class="form-select">
                                                <option value="">All Project </option>
                                                <c:forEach items="${project}" var="pro">
                                                    <option value="${pro.id}" ${param.projectId == pro.id ? 'selected' : ''}>
                                                        ${pro.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Severity Filter -->
                                        <div class="col-md-2">
                                            <select name="serverityId" id="serverityId" class="form-select">
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
                                                <th>Project</th>
                                                <th>Requirement</th>
                                                <th>Severity</th>
                                                <th>Leakage</th>
                                                <th>Due Date</th>
                                                <th>Status</th>
                                                <th>Assignee</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${defects}" var="defect">
                                                <tr>
                                                    <td>${defect.id}</td>   
                                                    <td>${defect.title}</td>
                                                    <td>${defect.project.name}</td>
                                                    <td>${defect.requirement.title}</td>
                                                    <td>
                                                        <span class="badge bg-${defect.serverity.id == 1 ? 'danger' : defect.serverity.id == 2 ? 'warning' : 'info'}">
                                                            ${defect.serverity.name}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${defect.leakage ? 'bg-danger' : 'bg-secondary'}">
                                                            ${defect.leakage ? 'Yes' : 'No'}
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
                                                        <td>${defect.assignee.fullname}</td>   
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
                                        <div class="col-md-6">
                                            <label for="projectId" class="form-label">Project *</label>
                                            <select class="form-select" id="selectProject" name="projectId" required>
                                                <option value="">Select Project</option>
                                                <c:forEach items="${project}" var="project">
                                                    <option value="${project.id}">${project.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <!-- Requirement -->
                                        <div class="col-md-6">
                                            <label for="requirementId" class="form-label">Requirement *</label>
                                            <select class="form-select" id="selectReq" name="requirementId" required>
                                                <option value="">Select Requirement</option>
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
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Assignee <span class="text-danger">*</span></label>
                                                <select class="form-select" name="assigneeId" id="selectMember" >
                                                    <option value="">Select Assignee</option>
                                                    <c:forEach items="${users}" var="user">
                                                        <option value="${user.id}" ${defect != null && defect.assignee == user.id ? 'selected' : ''}>
                                                            ${user.fullname}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
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
                                        <button type="submit" class="btn btn-primary" id="addBtn">Add Defect</button>
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
                                                                            };

                                                                            $('#selectProject').on('change', function () {
                                                                                var selectedvalue = $(this).val();
                                                                                $.ajax({
                                                                                    url: "${pageContext.request.contextPath}/defectlist",
                                                                                    type: 'post',
                                                                                    dataType: 'json',
                                                                                    data: {
                                                                                        pId: selectedvalue,
                                                                                        action: "getProjectAdd"
                                                                                    },
                                                                                    success: function (responseData) {
                                                                                        $('#addBtn').prop("disabled", false);
                                                                                        if (responseData.memberList[0].id === -1 || responseData.reqList[0].id === -1) {
                                                                                            $('#addBtn').prop("disabled", true);
                                                                                            $('#addErrorDisplay').css('display', 'block');
                                                                                            $('#addErrorDisplay').find('i').text("Cannot add to this project because the domain for this project has not been set up with roles or there are no more user to add.");
                                                                                        } else {
                                                                                            $('#addErrorDisplay').css('display', 'none');
                                                                                        }
                                                                                        $('#selectMember').empty();
                                                                                        $.each(responseData.memberList, function (index, item) {
                                                                                            var option;
                                                                                            if (item.id === 0 || item.id === -1) {
                                                                                                option = $('<option>')
                                                                                                        .text(item.fullname)
                                                                                                        .val(item.id);
                                                                                            } else {
                                                                                                option = $('<option>')
                                                                                                        .text(item.fullname)
                                                                                                        .val(item.id); // Set the value
                                                                                            }
                                                                                            $('#selectMember').append(option);
                                                                                        });
                                                                                        $('#selectReq').empty();
                                                                                        $.each(responseData.reqList, function (index, item) {
                                                                                            var option;
                                                                                            if (item.id === 0 || item.id === -1) {
                                                                                                option = $('<option>')
                                                                                                        .text(item.name)
                                                                                                        .val(item.id);
                                                                                            } else {
                                                                                                option = $('<option>')
                                                                                                        .text(item.name)
                                                                                                        .val(item.id); // Set the value
                                                                                            }
                                                                                            $('#selectReq').append(option);
                                                                                        });
                                                                                    }
                                                                                });
                                                                            });
                                                                            // Date validation
                                                                            $('#duedate').attr('min', new Date().toISOString().split('T')[0]);
                                                                        });
            </script>
            <!--            <script>$('#projectId').on('change', function () {
                                const projectId = $(this).val();
            
                                if (projectId) {
                                    // Load requirements
                                    loadRequirements(projectId);
                                    // Load assignees
                                    //loadAssignees(projectId);
                                } else {
                                    // Clear both dropdowns if no project selected
                                    $('#requirementId').html('<option value="">Select Requirement</option>');
                                    //$('#assigneeId').html('<option value="">Select Assignee</option>');
                                }
                            });</script>-->
        </body>
    </html>