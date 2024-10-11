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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css">
    </head>

    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content" class="profilepage_2 blog-page">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i>
                                            </a> User Profile
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
                                                    <a class="nav-link active" id="Overview-tab" href="ListDomainSettingsController" role="tab">Domain Settings</a>
                                                </li>
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link" id="Settings-tab" href="eval" role="tab">Evaluation Criteria</a>
                                                </li>
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link" id="Settings-tab" href="DomainUserController" role="tab">Domain Users</a>
                                                </li>
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link" id="Settings-tab" href="ProjectPhaseCriteriaController" role="tab">Project Phase</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>

                                    <div class="tab-content p-0" id="myTabContent">
                                        <form action="ListDomainSettingsController" method="get" class="mb-3">
                                            <div class="row g-3">
                                                <div class="col-md-4">
                                                    <input type="text" name="search" class="form-control" 
                                                           placeholder="Search by name" 
                                                           value="${not empty searchName ? searchName : ''}">
                                            </div>
                                            <div class="col-md-4">
                                                <select name="status" class="form-select">
                                                    <option value="">All Statuses</option>
                                                    <option value="1" ${filterStatus == '1' ? 'selected' : ''}>Active</option> 
                                                    <option value="0" ${filterStatus == '0' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4">
                                                <button type="submit" class="btn btn-primary">Search</button>
                                            </div>
                                        </div>
                                    </form>
                                    <div class="row g-3">
                                        <div class="col-md-12"  style="display: flex; justify-content: right">
                                            <a href="add" type="submit" class="btn btn-success">Add new</a>
                                        </div>
                                        <div class="tab-pane fade active show" id="Tab1">
                                            <h3 class="mt-4">Domain Settings List</h3>
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Type</th>
                                                        <th>Name</th>
                                                        <th>Details</th>
                                                        <th>Priority</th>
                                                        <th>Domain ID</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="setting" items="${domainSettings}">
                                                        <tr>
                                                            <td>${setting.id}</td>
                                                            <td>${setting.type}</td>
                                                            <td>${setting.name}</td>
                                                            <td>${setting.details}</td>
                                                            <td>${setting.priority}</td>
                                                            <td>${setting.domainId}</td>
                                                            <td>
                                                                <a href="Detail" type="submit" class="btn btn-warning">Detail</a>
                                                                |
                                                                <a href="Deactive" type="submit" class="btn btn-danger">Deactive</a>
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

                    <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
                </div>
            </div>
    </body>
</html>
