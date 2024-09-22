<%-- 
    Document   : dashboard
    Created on : Sep 14, 2024, 2:36:11 PM
    Author     : HP
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">


    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/index2.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:41:40 GMT -->
    <head>
        <meta charset="utf-8">
        <title>:: Lucid HR BS5 :: Project Dashboard</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

        <link rel="icon" href="favicon.ico" type="image/x-icon">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">

        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>

    <body>

        <div id="layout" class="theme-cyan">

            <!-- Page Loader -->
            <jsp:include page="common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">

                    <!-- top navbar -->
                <jsp:include page="common/topNavbar.jsp"></jsp:include>


                    <!-- Sidbar menu -->
                <jsp:include page="common/sidebar.jsp"></jsp:include>
                    <div id="main-content">
                        <div class="container-fluid">

                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Project Dashboard</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="index.html">Lucid</a></li>
                                            <li class="breadcrumb-item active">Dashboard</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-2 row-deck mb-2">
                                <div class="col-lg-3 col-md-6 col-sm-6 text-center">
                                    <div class="card chart-color1">
                                        <div class="card-body p-lg-4 text-light">
                                            <h3>${listSize}</h3>
                                        <span>Associated Projects</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 text-center">
                                <div class="card chart-color2">
                                    <div class="card-body p-lg-4 text-light">
                                        <h3>15</h3>
                                        <span>Today Tasks</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 text-center">
                                <div class="card chart-color3">
                                    <div class="card-body p-lg-4">
                                        <h3>125</h3>
                                        <span>Statistics</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 text-center">
                                <div class="card chart-color4">
                                    <div class="card-body p-lg-4 text-light">
                                        <h3>318</h3>
                                        <span>Analytics</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-12 col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="card-title">Project List</h6>
                                    </div>
                                    <div class="card-body" id="cardbody">
                                        <form action="dashboard" method="get" >
                                            <div style="display: flex; justify-content: space-between">
                                                <div class="input-group mb-3" style="width: 25%">
                                                    <span class="input-group-text" id="basic-addon11">Department</span>
                                                    <select class="form-select" aria-label="Default select example" name="deptFilter" id="deptFilter" onchange="ChangeFilter()">
                                                        <option value="0" ${deptFilter==0?'selected':''}>All Department</option>
                                                        <c:forEach items="${deptList}" var="d">
                                                            <option value="${d.id}" ${deptFilter==d.id?'selected':''}>${d.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-3" style="width: 25%">
                                                    <span class="input-group-text" id="basic-addon11">Domain</span>
                                                    <select class="form-select" aria-label="Default select example" name="domainFilter" id="domainFilter" onchange="ChangeFilter()">
                                                        <option value="0" ${domainFilter==0?'selected':''}>All Domain</option>
                                                        <c:forEach items="${domainList}" var="d">
                                                            <option value="${d.id}" ${domainFilter==d.id?'selected':''}>${d.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-3" style="width: 25%">
                                                    <span class="input-group-text" id="basic-addon11">Status</span>
                                                    <select class="form-select" aria-label="Default select example" name="statusFilter" id="statusFilter" onchange="ChangeFilter()">
                                                        <option value="0" ${statusFilter==0?'selected':''}>All Status</option>
                                                        <option value="1" ${statusFilter==1?'selected':''}>Active</option>
                                                        <option value="2" ${statusFilter==2?'selected':''}>InActive</option>
                                                        <option value="3" ${statusFilter==3?'selected':''}>Closed</option>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-3" style="width: 15%">
                                                    <input value="${searchKey.trim()}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                    <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                </div>
                                            </div>
                                        </form>

                                        <table id="pro_list" class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Code</th>
                                                    <th>Biz Term</th>
                                                        <c:if test="${isAdmin==null}" >
                                                        <th>Effort Rate</th>
                                                        <th>Role</th>
                                                        </c:if>
                                                    <th>Status</th>
                                                    <th>Start Date</th>
                                                    <th>Details</th>
                                                </tr>
                                            </thead>
                                            <tbody class="table-hover" id="tableBody">

                                                <c:forEach items="${tableData}" var="l">
                                                    <c:set value="${l.project}" var="p"></c:set>

                                                        <tr>
                                                            <td>
                                                                <h6>${p.code}</h6>
                                                            <span>${p.name}</span>
                                                        </td>
                                                        <td>
                                                            ${p.bizTerm}
                                                        </td>
                                                        <c:if test="${isAdmin==null}" >
                                                            <td>
                                                                <div class="progress" style="height: 5px;">
                                                                    <div class="progress-bar" role="progressbar" aria-valuenow="${l.effortRate}" aria-valuemin="0" aria-valuemax="100" style="width: ${l.effortRate}%;">
                                                                    </div>
                                                                </div>
                                                                <small>Effort Rate: ${l.effortRate}%</small>
                                                            </td>
                                                            <td>${l.projectRole}</td>
                                                        </c:if>
                                                        <td>
                                                            <c:choose >
                                                                <c:when test="${p.status == 1}">
                                                                    <span class="badge bg-success">Active</span><br>

                                                                </c:when>
                                                                <c:when test="${p.status == 2}">
                                                                    <span class="badge bg-secondary">Inactive</span><br>
                                                                </c:when>
                                                                <c:when test="${p.status == 3}">
                                                                    <span class="badge bg-danger">Closed</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>${p.startDate}</td>
                                                        <td>
                                                            <a href="#" class="btn" data-bs-toggle="modal" data-bs-target="#largeModal${p.id}">
                                                                <strong>Project Detail</strong>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        <c:if test="${searchSize==0}">
                                            <div class="card-body text-center">
                                                <h4>No result found!</h4>
                                            </div>
                                        </c:if>
                                        <nav aria-label="Page navigation example">
                                            <ul class="pagination">
                                                <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${page==1?1:page-1}">Previous</a></li>
                                                    <c:forEach begin="${1}" end="${num}" var="i">
                                                    <li class="page-item ${i==page?'active':''}"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${i}">${i}</a></li>
                                                    </c:forEach>
                                                <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${page+1}">Next</a></li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <c:forEach items="${tableData}" var="l">
            <c:set value="${l.project}" var="p"></c:set>
            <div class="modal fade" id="largeModal${p.id}" tabindex="-1" aria-labelledby="largeModal" aria-hidden="true" style="display: none;">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Project details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">

                            <table class="table table-bordered border-primary">

                                <tbody>
                                    <tr>
                                        <td>Managed Department </td>
                                        <td>${p.department.name} </td>
                                    </tr>
                                    <tr>
                                        <td>Managed Domain </td>
                                        <td>${p.domain.name}</td>
                                    </tr>
                                    <tr>
                                        <td>Descriptions</td>
                                        <td>${p.details}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <!-- core js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>

        <!-- page js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/pages/index2.js"></script>
    </body>
</html>