<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Phase Details</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

        
    </head>
<body>
    <div id="layout" class="theme-cyan">
        <!-- Page Loader -->
        <jsp:include page="../../common/pageLoader.jsp"></jsp:include>

        <div id="wrapper">
            <!-- Top navbar -->
            <jsp:include page="../../common/topNavbar.jsp"></jsp:include>

            <!-- Sidebar -->
            <jsp:include page="../../common/sidebar.jsp"></jsp:include>

            <div id="main-content">
                <div class="container-fluid">
                    <div class="block-header py-lg-4 py-3">
                        <div class="row g-3">
                            <div class="col-md-6 col-sm-12">
                                <h2 class="m-0 fs-5">
                                    <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                        <i class="fa fa-arrow-left"></i>
                                    </a>
                                    Edit Phase
                                </h2>
                                <ul class="breadcrumb mb-0">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/phaselist">Phases</a></li>
                                    <li class="breadcrumb-item active">Edit</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="row clearfix">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title">Phase Details</h6>
                                </div>

                                <div class="card-body">
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">
                                            ${error}
                                        </div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/phasedetail" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" name="id" value="${phase.id}">

                                        <div class="row g-3">
                                            <!-- Phase ID (Read-only) -->
                                            <div class="col-md-4 col-sm-12">
                                                <label for="id">Phase ID</label>
                                                <input type="text" class="form-control" id="id" value="${phase.id}" readonly>
                                            </div>

                                            <!-- Phase Name -->
                                            <div class="col-md-4 col-sm-12">
                                                <label for="name">Name</label>
                                                <input type="text" class="form-control" id="name" name="name" 
                                                       value="${phase.name}" required>
                                            </div>

                                            <!-- Domain -->
                                            <div class="col-md-4 col-sm-12">
                                                <label for="domainId">Domain</label>
                                                <select class="form-control" id="domainId" name="domainId" required>
                                                    <c:forEach items="${domains}" var="domain">
                                                        <option value="${domain.id}" 
                                                                ${domain.id == phase.domain.id ? 'selected' : ''}>
                                                            ${domain.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <!-- Priority -->
                                            <div class="col-md-4 col-sm-12">
                                                <label for="priority">Priority</label>
                                                <input type="number" class="form-control" id="priority" name="priority"
                                                       value="${phase.priority}" required min="1">
                                            </div>

                                            <!-- Complete Rate -->
                                            <div class="col-md-4 col-sm-12">
                                                <label for="completeRate">Complete Rate (%)</label>
                                                <input type="number" class="form-control" id="completeRate" name="completeRate"
                                                       value="${phase.completeRate}" required min="0" max="100">
                                            </div>

                                            <!-- Details -->
                                            <div class="col-12">
                                                <label for="details">Details</label>
                                                <textarea class="form-control" id="details" name="details" 
                                                          rows="4">${phase.details}</textarea>
                                            </div>

                                            <!-- Final Phase Checkbox -->
                                            <div class="col-md-4 col-sm-12">
                                                <div class="form-check mt-2">
                                                    <input type="checkbox" class="form-check-input" id="finalPhase" 
                                                           name="finalPhase" ${phase.finalPhase ? 'checked' : ''}>
                                                    <label class="form-check-label" for="finalPhase">Final Phase</label>
                                                </div>
                                            </div>

                                            <!-- Status -->
                                            <div class="col-md-4 col-sm-12">
                                                <div class="form-check mt-2">
                                                    <input type="checkbox" class="form-check-input" id="status" 
                                                           name="status" ${phase.status ? 'checked' : ''}>
                                                    <label class="form-check-label" for="status">Active</label>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Submit Buttons -->
                                        <div class="mt-4">
                                            <button type="submit" class="btn btn-primary">
                                                Update Phase
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/phaselist" 
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

    <!-- Core JS Files -->
    <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
</body>
</html>