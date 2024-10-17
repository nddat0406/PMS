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
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i></a> User Profile
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
                                        <c:set var="baseUrl" value="${pageContext.request.contextPath}" />
                                        <ul class="nav nav-tabs" id="myTab" role="tablist">
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link active" id="Overview-tab" href="${baseUrl}/domain/domainsetting?action=domainSetting" role="tab">Domain Settings</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link active" id="Evaluation-tab" href="${baseUrl}/domain/domaineval" role="tab">Evaluation Criteria</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link active" id="DomainUsers-tab" href="${baseUrl}/domain/domainuser" role="tab">Domain Users</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link active" id="ProjectPhase-tab" href="${baseUrl}" role="tab">Project Phase</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>

                                <div class="tab-content p-0" id="myTabContent">
                                    <form action="${baseUrl}/domain" method="post" enctype="multipart/form-data" class="mb-3">
                                        <div class="d-flex justify-content-between mb-2">
                                            <button type="submit" name="action" value="export" class="btn btn-primary">
                                                <i class="fas fa-file-excel"></i> Export to Excel
                                            </button>
                                            <div>
                                                <input type="file" name="file" accept=".xlsx" class="form-control d-inline-block" style="width: auto;"/>
                                                <button type="submit" name="action" value="import" class="btn btn-success">
                                                    <i class="fas fa-file-upload"></i> Import from Excel
                                                </button>
                                                <a href="assets/domain_users.xlsx" download>Template</a>
                                            </div>
                                        </div>
                                    </form>

                                    <div class="tab-pane fade active show" id="Tab1">
                                        <div class="col-md-12"  style="display: flex; justify-content: right">
                                        <a href="${baseUrl}/domain/domainuser?action=add" type="submit" class="btn btn-success">Add new</a>
                                        </div>
                                        <table id="domainSettingsTable" class="table table-bordered table-striped">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Username</th>
                                                    <th>Email</th>
                                                    <th>Phone</th>
                                                    <th>Domain</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="user" items="${domainUsers}">
                                                    <tr>
                                                        <td>${user.id}</td>
                                                        <td>${user.user.fullname}</td>
                                                        <td>${user.user.email}</td>
                                                        <td>${user.user.mobile}</td>
                                                        <td>${user.parent.name}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${user.status == 1}">Active</c:when>
                                                                <c:when test="${user.status == 0}">Inactive</c:when>
                                                                <c:otherwise>Unknown</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <a href="${baseUrl}/domain/domainuser?action=edit&id=${user.id}" type="submit" class="btn btn-warning">Detail</a>
                                                            |
                                                            <a href="${baseUrl}/domain/domainuser?action=delete&id=${user.id}" type="submit" class="btn btn-warning">Delete</a>
                                                            |
                                                            <a href="${baseUrl}/domain/domainuser?action=deactive&id=${user.id}" type="submit" class="btn btn-danger">Deactive</a>
                                                            |
                                                            <a href="${baseUrl}/domain/domainuser?action=active&id=${user.id}" type="submit" class="btn btn-danger">Active</a>
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

        <!-- JS file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <!-- Page JS file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script><script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>

        <script>
            $(document).ready(function () {
                $('#domainSettingsTable').DataTable({
                    "paging": true,
                    "lengthChange": true,
                    "searching": true,
                    "ordering": true,
                    "info": true,
                    "autoWidth": false
                });
            });

        </script>
    </body>
</html>
