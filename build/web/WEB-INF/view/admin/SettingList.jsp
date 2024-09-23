<%-- 
    Document   : SettingList
    Created on : Sep 23, 2024, 4:14:33 AM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Setting List</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>
    <body>
        <!-- Include Page Loader -->
        <jsp:include page="../common/pageLoader.jsp" />

        <div id="layout" class="theme-cyan">
            <!-- Sidebar -->
            <jsp:include page="../common/sidebar.jsp" />

            <div id="main-content">
                <div class="container-fluid">
                    <!-- Top Navbar -->
                    <jsp:include page="../common/topNavbar.jsp" />

                    <!-- Main Content -->
                    <div class="block-header py-lg-4 py-3">
                        <div class="row g-3">
                            <div class="col-md-6 col-sm-12">
                                <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Setting List</h2>
                            </div>
                        </div>
                    </div>

                    <div class="row clearfix">
                        <div class="col-lg-12 col-md-12">
                            <div class="card mb-4">
                                <!-- Add New Button -->
                                <form action="settings" method="get">
                                    <input type="hidden" name="action" value="add">
                                    <button type="submit" class="btn btn-outline-secondary">Add New Setting</button>
                                </form>

                                <form method="post" action="settings" >
                                    <input type="hidden" name="action" value="filter">

                                    <div class="row">
                                        <!-- Filter by Type -->
                                        <div class="col-md-3">
                                            <select name="filterType" class="form-control">
                                                <option value="">Filter by Type</option>
                                                <option value="1" ${filterType == 1 ? 'selected' : ''}>Type 1</option>
                                                <option value="2" ${filterType == 2 ? 'selected' : ''}>Type 2</option>
                                                <option value="3" ${filterType == 3 ? 'selected' : ''}>Type 3</option>
                                            </select>
                                        </div>

                                        <!-- Filter by Name -->
                                        <div class="col-md-3">
                                            <input type="text" name="keyword" class="form-control" placeholder="Filter by Name" value="${keyword}">
                                        </div>

                                        <!-- Filter by Status -->
                                        <div class="col-md-3">
                                            <select name="filterStatus" class="form-control">
                                                <option value="">Filter by Status</option>
                                                <option value="1" ${filterStatus == 1 ? 'selected' : ''}>Active</option>
                                                <option value="0" ${filterStatus == 0 ? 'selected' : ''}>Inactive</option>

                                            </select>
                                        </div>

                                        <!-- Filter Button -->
                                        <div class="col-md-3">
                                            <button type="submit" class="btn btn-primary">Filter</button>
                                        </div>
                                    </div>
                                </form>
                                <!-- Search Bar -->
                                <div class="card-body">
                                    <form id="navbar-search" class="navbar-form search-form position-relative d-none d-md-block" method="post" action="settings">
                                        <input type="hidden" name="action" value="search">
                                        <input name="keyword" class="form-control" placeholder="Search by Name" type="text" required>
                                        <button type="submit" class="btn btn-secondary">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>

                            <!-- Table for Settings -->
                            <div class="card-body">
                                <table id="settingTable" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Type</th>
                                            <th>Priority</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${listS}" var="setting">
                                            <tr>
                                                <td>${setting.id}</td>
                                                <td>${setting.name}</td>
                                                <td>${setting.type}</td>
                                                <td>${setting.priority}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${setting.status}">
                                                            <span class="badge bg-success">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <!-- Form ch?nh s?a -->
                                                    <form action="settings?action=detail" method="get" style="display: inline-block;">
                                                        <input type="hidden" name="action" value="detail">
                                                        <input type="hidden" name="id" value="${setting.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-success">
                                                            <i class="fa fa-info-circle"></i> 
                                                        </button>
                                                    </form>

                                                    <!-- Form xóa -->
                                                    <form action="settings" method="post" onsubmit="return confirm('Are you sure you want to delete this setting?');" style="display: inline-block;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${setting.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="fa fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <!-- Pagination -->
                                <nav aria-label="Page navigation example">
                                    <ul class="pagination">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?action=list&page=${currentPage - 1}" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <li class="page-item active"><a class="page-link">${currentPage}</a></li>
                                        <li class="page-item">
                                            <a class="page-link" href="?action=list&page=${currentPage + 1}" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Core JS files -->
    <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

    <!-- Initialize DataTable -->
</body>
</html>
