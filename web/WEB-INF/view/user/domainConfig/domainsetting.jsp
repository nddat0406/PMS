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
                                        <c:set var="baseUrl" value="${pageContext.request.contextPath}" />
                                        <ul class="nav nav-tabs" id="myTab" role="tablist">
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link active" id="Overview-tab" href="${baseUrl}/domain/domainsetting?action=domainSetting" role="tab">Domain Settings</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link" id="Evaluation-tab" href="${baseUrl}/domain/domaineval" role="tab">Evaluation Criteria</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link" id="DomainUsers-tab" href="${baseUrl}/domain/domainuser" role="tab">Domain Users</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link" id="ProjectPhase-tab" href="${pageContext.request.contextPath}/phaselist" role="tab">Project Phase</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <div class="tab-content p-0" id="myTabContent">
                                            <form action="${baseUrl}/domain/domainsetting" method="get" class="mb-3">
                                                <input type="hidden" name="action" value="domainsetting" />
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
                                                    <a href="${baseUrl}/domain/domainsetting?action=add" type="submit" class="btn btn-success">Add new</a>
                                                </div>
                                                <div class="tab-pane fade active show" id="Tab1">
                                                    <h3 class="mt-4">Domain Settings List</h3>
                                                    <table id="domainSettingsTable" class="table table-bordered table-striped">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Setting</th>
                                                                <th>Type</th>
                                                                <th>Priority</th>
                                                                <th>Status</th>
                                                                <th>Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="setting" items="${domainSettings}">
                                                                <tr>
                                                                    <td>${setting.id}</td>
                                                                    <td>${setting.name}</td>
                                                                    <td>${setting.type}</td>
                                                                    <td>${setting.priority}</td>
                                                                    <td>${setting.status == true ? "Active" : "Inactive"}</td>
                                                                    <td>
                                                                        <a href="${baseUrl}/domain/domainsetting?action=edit&id=${setting.id}" type="submit" class="btn btn-warning">Detail</a>
                                                                        
                                                  
                                                                        |
                                                                        <a href="${baseUrl}/domain/domainsetting?action=deactive&id=${setting.id}" type="submit" class="btn btn-danger">Deactive</a>
                                                                        |
                                                                        <a href="${baseUrl}/domain/domainsetting?action=active&id=${setting.id}" type="submit" class="btn btn-danger">Active</a>
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

                    <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>


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
                </div>
            </div>
    </body>
</html>
