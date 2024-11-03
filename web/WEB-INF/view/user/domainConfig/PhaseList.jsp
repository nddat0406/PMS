<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Project Phases</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <style>
            /* Chung */
            .modal .form-check-input {
                border: 2px solid #666;
                width: 20px;
                height: 20px;
            }

            /* Final Phase checkbox */
            .modal .form-check-input#modalFinalPhase:checked {
                background-color: #4CAF50;  /* Màu xanh lá */
                border-color: #4CAF50;
            }

            /* Status checkbox */
            .modal .form-check-input#modalStatus:checked {
                background-color: #2196F3;  /* Màu xanh dương */
                border-color: #2196F3;
            }

            /* Hover states */
            .modal .form-check-input#modalFinalPhase:hover {
                border-color: #4CAF50;
            }

            .modal .form-check-input#modalStatus:hover {
                border-color: #2196F3;
            }

            /* Focus states */
            .modal .form-check-input#modalFinalPhase:focus {
                box-shadow: 0 0 0 0.25rem rgba(76, 175, 80, 0.25);
            }

            .modal .form-check-input#modalStatus:focus {
                box-shadow: 0 0 0 0.25rem rgba(33, 150, 243, 0.25);
            }

            .modal .form-check {
                padding-left: 1.8em;
                margin-top: 10px;
            }

            .modal .form-check-label {
                font-size: 16px;
                color: #333;
                padding-left: 8px;
            }
        </style>
    </head>

    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>

            <div id="wrapper">
                <!-- top navbar -->
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>

                <!-- Sidbar menu -->
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                <div id="main-content">
                    <div class="container-fluid">
                        <div class="block-header py-lg-4 py-3">
                            <div class="row g-3">
                                <div class="col-md-6 col-sm-12">
                                    <h2 class="m-0 fs-5">Project Phases</h2>
                                    <ul class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                                        <li class="breadcrumb-item active">Phases</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="row clearfix">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="card-title">Phase List</h6>
                                        <ul class="header-dropdown">
                                            <li>
                                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPhaseModal">
                                                    Add New Phase
                                                </button>
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="card-body">
                                        <!-- Search Form -->
                                        <form action="${pageContext.request.contextPath}/phaselist" method="POST">
                                            <input type="hidden" name="action" value="search">

                                            <div class="input-group mb-3">
                                                <!-- Keyword Search -->
                                                <input type="text" class="form-control" name="keyword" 
                                                       value="${param.keyword}" placeholder="Search phase name..." 
                                                       style="width: 30%">

                                                <!-- Domain Filter -->
                                                <label for="domain" class="input-group-text">Domain:</label>
                                                <select name="domainId" id="domain" class="form-select" style="width: 20%;">
                                                    <option value="">All Domains</option>
                                                    <c:forEach items="${domains}" var="d">
                                                        <option value="${d.id}" ${param.domainId == d.id ? 'selected' : ''}>
                                                            ${d.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>

                                                <!-- Status Filter -->
                                                <label for="status" class="input-group-text">Status:</label>
                                                <select name="status" id="status" class="form-select" style="width: 15%;">
                                                    <option value="">All Status</option>
                                                    <option value="true" ${param.status == 'true' ? 'selected' : ''}>Active</option>
                                                    <option value="false" ${param.status == 'false' ? 'selected' : ''}>Inactive</option>
                                                </select>

                                                <!-- Search Button -->
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fa fa-search"></i> Search
                                                </button>
                                            </div>
                                        </form>

                                        <!-- Error Messages -->
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger">
                                                ${error}
                                            </div>
                                        </c:if>

                                        <!-- Phase List Table -->
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Name</th>
                                                    <th>Domain</th>
                                                    <th>Priority</th>
                                                    <th>Complete Rate</th>
                                                    <th>Final Phase</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${phases}" var="phase">
                                                    <tr>
                                                        <td>${phase.id}</td>
                                                        <td>${phase.name}</td>
                                                        <td>${phase.domain.name}</td>
                                                        <td>${phase.priority}</td>
                                                        <td>${phase.completeRate}%</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${phase.finalPhase}">
                                                                    <span class="badge bg-success">Yes</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">No</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${phase.status}">
                                                                    <span class="badge bg-success">Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <!-- Edit Button -->
                                                            <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                    onclick="window.location.href = '${pageContext.request.contextPath}/phasedetail?id=${phase.id}'">
                                                                <i class="fa fa-edit"></i>
                                                            </button>

                                                            <!-- Status Toggle Form -->
                                                            <form action="${pageContext.request.contextPath}/phaselist" method="POST" style="display: inline;">
                                                                <input type="hidden" name="action" value="changeStatus">
                                                                <input type="hidden" name="id" value="${phase.id}">
                                                                <input type="hidden" name="status" value="${!phase.status}">
                                                                <button type="submit" class="btn btn-sm ${phase.status ? 'btn-warning' : 'btn-success'}">
                                                                    ${phase.status ? 'Deactivate' : 'Activate'}
                                                                </button>
                                                            </form>

                                                            <!-- Delete Button -->
                                                            <button type="button" class="btn btn-sm btn-danger" 
                                                                    onclick="showDeleteModal(${phase.id})">
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
            </div>
        </div>

        <!-- Add Phase Modal -->
        <div class="modal fade" id="addPhaseModal" tabindex="-1" aria-labelledby="addPhaseModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addPhaseModalLabel">Add New Phase</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="${pageContext.request.contextPath}/phaselist" method="POST">
                            <input type="hidden" name="action" value="add">

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="name" class="form-label">Phase Name *</label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>

                                <div class="col-md-6">
                                    <label for="domainId" class="form-label">Domain *</label>
                                    <select class="form-control" id="domainId" name="domainId" required>
                                        <option value="">Select Domain</option>
                                        <c:forEach items="${domains}" var="domain">
                                            <option value="${domain.id}">${domain.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label for="priority" class="form-label">Priority *</label>
                                    <input type="number" class="form-control" id="priority" name="priority" 
                                           required min="1" value="1">
                                </div>

                                <div class="col-md-6">
                                    <label for="completeRate" class="form-label">Complete Rate (%) *</label>
                                    <input type="number" class="form-control" id="completeRate" name="completeRate" 
                                           required min="0" max="100" value="0">
                                </div>

                                <div class="col-12">
                                    <label for="details" class="form-label">Details</label>
                                    <textarea class="form-control" id="details" name="details" rows="3"></textarea>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-check" style="padding-left: 1.5em;">
                                        <input type="checkbox" class="form-check-input" id="modalFinalPhase" name="finalPhase" style="cursor: pointer;">
                                        <label class="form-check-label" for="modalFinalPhase" style="cursor: pointer;">
                                            Final Phase
                                        </label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-check" style="padding-left: 1.5em;">
                                        <input type="checkbox" class="form-check-input" id="modalStatus" name="status" checked style="cursor: pointer;">
                                        <label class="form-check-label" for="modalStatus" style="cursor: pointer;">
                                            Active
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-success">Add Phase</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deletePhaseModal" tabindex="-1" aria-labelledby="deletePhaseModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deletePhaseModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this phase?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form id="deletePhaseForm" action="${pageContext.request.contextPath}/phaselist" method="POST" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" id="deletePhaseId" name="id" value="">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Core JS Files -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

        <script>
    $(document).ready(function () {
        $('#phase_table').DataTable({
            responsive: true
        });
    });

    // Function to show delete confirmation modal
    function showDeleteModal(phaseId) {
        document.getElementById('deletePhaseId').value = phaseId;
        var deleteModal = new bootstrap.Modal(document.getElementById('deletePhaseModal'));
        deleteModal.show();
    }
</script>
</body>
</html>