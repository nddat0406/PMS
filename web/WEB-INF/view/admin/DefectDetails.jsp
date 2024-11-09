<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Defect Details</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

        <style>
            .form-check-input:checked {
                background-color: #2196F3;
                border-color: #2196F3;
            }

            .form-check-input {
                border: 2px solid #666;
                width: 20px;
                height: 20px;
                cursor: pointer;
            }

            .form-check-label {
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
                                        <h2 class="m-0 fs-5">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i>
                                            </a>
                                            Edit Defect
                                        </h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/defectlist">Defects</a></li>
                                        <li class="breadcrumb-item active">Edit</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="row clearfix">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="card-title">Defect Details</h6>
                                    </div>

                                    <div class="card-body">
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger">
                                                ${error}
                                            </div>
                                        </c:if>

                                        <form action="${pageContext.request.contextPath}/defectdetail" method="POST">
                                            <input type="hidden" name="action" value="edit">
                                            <input type="hidden" name="id" value="${defect.id}">

                                            <div class="row g-3">
                                                <!-- Title -->
                                                <div class="col-md-12">
                                                    <label for="title" class="form-label">Title *</label>
                                                    <input type="text" class="form-control" id="title" name="title" 
                                                           value="${defect.title}" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="projectId" class="form-label">Project *</label>
                                                    <select class="form-select" id="projectId" name="projectId" required>
                                                        <option value="">Select Project</option>
                                                        <c:forEach items="${project}" var="pro">
                                                            <option value="${pro.id}" 
                                                                    ${pro.id == defect.project.id ? 'selected' : ''}>
                                                                ${pro.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <!-- Requirement -->
                                                <div class="col-md-6">
                                                    <label for="requirementId" class="form-label">Requirement *</label>
                                                    <select class="form-select" id="requirementId" name="requirementId" required>
                                                        <option value="">Select Requirement</option>
                                                        <c:forEach items="${requirements}" var="req">
                                                            <option value="${req.id}" 
                                                                    ${req.id == defect.requirement.id ? 'selected' : ''}>
                                                                ${req.title}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Milestone -->
                                                <!-- Severity -->
                                                <div class="col-md-6">
                                                    <label for="serverityId" class="form-label">Severity *</label>
                                                    <select class="form-select" id="serverityId" name="serverityId" required>
                                                        <option value="">Select Severity</option>
                                                        <c:forEach items="${serverities}" var="sev">
                                                            <option value="${sev.id}" 
                                                                    ${sev.id == defect.serverity.id ? 'selected' : ''}>
                                                                ${sev.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Due Date -->
                                                <div class="col-md-6">
                                                    <label for="duedate" class="form-label">Due Date *</label>
                                                    <input type="date" class="form-control" id="duedate" name="duedate" 
                                                           value="${defect.duedate}" required>
                                                </div>

                                                <!-- Status -->
                                                <div class="col-md-6">
                                                    <label for="status" class="form-label">Status *</label>
                                                    <select class="form-select" id="status" name="status" required>
                                                        <option value="1" ${defect.status == 1 ? 'selected' : ''}>Open</option>
                                                        <option value="2" ${defect.status == 2 ? 'selected' : ''}>In Progress</option>
                                                        <option value="3" ${defect.status == 3 ? 'selected' : ''}>Fixed</option>
                                                        <option value="4" ${defect.status == 4 ? 'selected' : ''}>Closed</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Assignee <span class="text-danger">*</span></label>
                                                        <select class="form-select" name="assignee" id="assignee" >
                                                            <option value="">Select Assignee</option>
                                                            <c:forEach items="${users}" var="user">
                                                                <option value="${user.id}" ${user.id == defect.assignee.id ? 'selected' : ''} >
                                                                    ${user.fullname}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <!-- Details -->
                                                <div class="col-12">
                                                    <label for="details" class="form-label">Details</label>
                                                    <textarea class="form-control" id="details" name="details" rows="4">${defect.details}</textarea>
                                                </div>

                                                <!-- Leakage Checkbox -->
                                                <div class="col-md-6">
                                                    <div class="form-check mt-2">
                                                        <input type="checkbox" class="form-check-input" id="leakage" 
                                                               name="leakage" ${defect.leakage ? 'checked' : ''}>
                                                        <label class="form-check-label" for="leakage">Leakage</label>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Submit Buttons -->
                                            <div class="mt-4">
                                                <button type="submit" class="btn btn-primary">
                                                    Update Defect
                                                </button>
                                                <a href="${pageContext.request.contextPath}/defectlist" 
                                                   class="btn btn-secondary">
                                                    Cancel
                                                </a>
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

        <!-- Core JS -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
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

                // Requirement change handler to load related project
                $('#requirementId').change(function () {
                    const reqId = $(this).val();
                    if (reqId) {
                        // Clear current project options
                        $('#projectId').html('<option value="">Select Project</option>');

                        // Load project for selected requirement's project
                        $.get('${pageContext.request.contextPath}/getProject',
                                {requirementId: reqId},
                                function (project) {
                                    console.log(project.name);
                                    $('#projectId').empty();
                                    $('#projectId').append(new Option(project.name, project.id));
                                });
                    }
                });

                // Date validation
                $('#duedate').attr('min', new Date().toISOString().split('T')[0]);
            });
        </script>
    </body>
</html>