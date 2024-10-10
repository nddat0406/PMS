<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>:: Lucid HR BS5 :: Profile</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
    <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <!-- VENDOR CSS -->
    <!-- MAIN CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>

<body>

<div id="layout" class="theme-cyan">
    <!-- Page Loader -->
    <jsp:include page="../../common/pageLoader.jsp"></jsp:include>

    <div id="wrapper">
        <!-- Top navbar -->
        <jsp:include page="../../common/topNavbar.jsp"></jsp:include>

        <!-- Sidebar menu -->
        <jsp:include page="../../common/sidebar.jsp"></jsp:include>
        <div id="main-content" class="profilepage_2 blog-page">
            <div class="container-fluid">

                <div class="block-header py-lg-4 py-3">
                    <div class="row g-3">
                        <div class="col-md-6 col-sm-12">
                            <h2 class="m-0 fs-5">
                                <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> User Profile
                            </h2>
                            <ul class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="/dashboard">Lucid</a></li>
                                <li class="breadcrumb-item active">Domain Configs</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-lg-12 col-md-12">
                        <div class="card mb-3">
                            <div class="card-body">
                                <ul class="nav nav-tabs" id="myTab" role="tablist">
                                    <li class="nav-item" role="presentation" style="width: 150px">
                                        <a class="nav-link" href="ListDomainSettingsController" role="tab">Domain Settings</a>
                                    </li>
                                    <li class="nav-item" role="presentation" style="width: 150px">
                                        <a class="nav-link" href="eval" role="tab">Evaluation criteria</a>
                                    </li>
                                    <li class="nav-item" role="presentation" style="width: 150px">
                                        <a class="nav-link active" href="DomainUserController" role="tab">Domain Users</a>
                                    </li>
                                    <li class="nav-item" role="presentation" style="width: 150px">
                                        <a class="nav-link" href="ProjectPhaseCriteriaController" role="tab">Project Phase</a>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="tab-content p-0" id="myTabContent">
                            <form action="DomainUserController" method="post" enctype="multipart/form-data" class="mb-3">
                                    <div class="d-flex justify-content-between mb-2">
                                        <button type="submit" name="action" value="export" class="btn btn-primary">
                                            <i class="fas fa-file-excel"></i> Export to Excel
                                        </button>
                                        <div>
                                            <input type="file" name="file" accept=".xlsx" class="form-control d-inline-block" style="width: auto;"/>
                                            <button type="submit" name="action" value="import" class="btn btn-success">
                                                <i class="fas fa-file-upload"></i> Import from Excel
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            <div class="tab-pane fade active show" id="Tab1">
                                <table class="table table-bordered table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>User ID</th>
                                            <th>Domain ID</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${domainUsers}">
                                            <tr>
                                                <td>${user.id}</td>
                                                <td>${user.userId}</td>
                                                <td>${user.domainId}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.status == 1}">Active</c:when>
                                                        <c:when test="${user.status == 0}">Inactive</c:when>
                                                        <c:otherwise>Unknown</c:otherwise>
                                                    </c:choose>
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
<!-- Core JS file -->
<script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
<!-- Page JS file -->
<script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

</body>
</html>
