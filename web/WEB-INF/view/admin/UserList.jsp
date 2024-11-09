<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/app-users.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:37 GMT -->
    <head>
        <meta charset="utf-8">
        <title>:: Lucid HR BS5 :: App Users</title>
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
            <%--<jsp:include page="../common/pageLoader.jsp"></jsp:include>--%>
            <div id="wrapper">

                <!-- top navbar -->
                <jsp:include page="../common/topNavbar.jsp"></jsp:include>

                    <!-- Sidbar menu -->
                <jsp:include page="../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">

                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a>Users</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="index.html">Lucid</a></li>
                                            <li class="breadcrumb-item active">Users</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6 col-sm-12 text-md-end">
                                        <div class="d-inline-flex text-start">
                                            <div class="me-2">
                                                <h6 class="mb-0"><i class="fa fa-user"></i> 1,784</h6>
                                                <small>Visitors</small>
                                            </div>
                                            <span id="bh_visitors"></span>
                                        </div>
                                        <div class="d-inline-flex text-start ms-lg-3 me-lg-3 ms-1 me-1">
                                            <div class="me-2">
                                                <h6 class="mb-0"><i class="fa fa-globe"></i> 325</h6>
                                                <small>Visits</small>
                                            </div>
                                            <span id="bh_visits"></span>
                                        </div>
                                        <div class="d-inline-flex text-start">
                                            <div class="me-2">
                                                <h6 class="mb-0"><i class="fa fa-comments"></i> 13</h6>
                                                <small>Chats</small>
                                            </div>
                                            <span id="bh_chats"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row clearfix">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="card-title">List</h6>
                                            <ul class="header-dropdown">
                                                <li><button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#AddUser">Add User</button></li>
                                            </ul>
                                        </div>
                                        <div class="card-body">
                                            <form action="${pageContext.request.contextPath}/admin/userlist" method="POST">
                                            <input type="hidden" name="action" value="search">

                                            <div class="input-group mb-3" style="width: 100%">
                                                <!-- Keyword Search -->
                                                <input value="${param.keyword}" class="form-control" name="keyword" placeholder="Search here..." type="text" style="width: 20%">


                                                <!-- Status Filter -->
                                                <label for="status" class="input-group-text">Status:</label>
                                                <select name="status" id="status" class="form-select" style="width: 10%;">
                                                    <option value="">All Status</option>
                                                    <option value="1" <c:if test="${param.status == '1'}">selected</c:if>>Active</option>
                                                    <option value="0" <c:if test="${param.status == '0'}">selected</c:if>>Inactive</option>
                                                    </select>

                                                    <!-- Search Button -->
                                                    <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                </div>
                                            </form>
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger">
                                                ${error}
                                            </div>
                                        </c:if>
                                        <!-- Table for displaying users -->
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>
                                                        Name
                                                        <button class="btn btn-sm btn-outline-primary" onclick="window.location.href = '${pageContext.request.contextPath}/admin/userlist?sort=asc'">
                                                            <i class="fa fa-sort-down"></i> 
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-primary" onclick="window.location.href = '${pageContext.request.contextPath}/admin/userlist?sort=desc'">
                                                            <i class="fa fa-sort-up"></i> 

                                                        </button>
                                                    </th>
                                                    <th>Mobile</th>
                                                    <th>Email
                                                        <button class="btn btn-sm btn-outline-primary" onclick="window.location.href = '${pageContext.request.contextPath}/admin/userlist?sort=asc'">
                                                            <i class="fa fa-sort-down"></i> 
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-primary" onclick="window.location.href = '${pageContext.request.contextPath}/admin/userlist?sort=desc'">
                                                            <i class="fa fa-sort-up"></i> 
                                                    </th>
                                                    <th>Department ID
                                                        <button class="btn btn-sm btn-outline-primary" onclick="window.location.href = '${pageContext.request.contextPath}/admin/userlist?sort=asc'">
                                                            <i class="fa fa-sort-down"></i> 
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-primary" onclick="window.location.href = '${pageContext.request.contextPath}/admin/userlist?sort=desc'">
                                                            <i class="fa fa-sort-up"></i> 
                                                    </th>
                                                    <th>Address</th>
                                                    <th>Role</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody class="table-hover" id="tableBody">
                                                <c:forEach items="${requestScope.data}" var="d">
                                                    <tr>
                                                        <td class="width45">${d.id}</td>
                                                        <td>${d.fullname}</td>
                                                        <td>${d.mobile}</td>
                                                        <td>${d.email}</td>
                                                        <td>${d.department.name}</td>
                                                        <td>${d.address}</td>
                                                        <td>
                                                            <div class="input-group mb-3" style="width: 25%">
                                                                <c:choose >
                                                                    <c:when test="${d.role == 1}">
                                                                        <span>Admin</span><br>
                                                                    </c:when>
                                                                    <c:when test="${d.role == 2}">
                                                                        <span>User</span><br>
                                                                    </c:when>
                                                                    <c:when test="${d.role == 3}">
                                                                        <span>QA</span><br>
                                                                    </c:when>
                                                                    <c:when test="${d.role == 4}">
                                                                        <span>PM</span><br>
                                                                    </c:when>
                                                                    <c:when test="${d.role == 5}">
                                                                        <span>Dept Manager</span><br>
                                                                    </c:when>
                                                                    <c:when test="${d.role == 6}">
                                                                        <span>PMO</span><br>
                                                                    </c:when>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="input-group mb-3" style="width: 25%">
                                                                <c:choose >
                                                                    <c:when test="${d.status == 1}">
                                                                        <span class="badge bg-success">Active</span><br>

                                                                    </c:when>
                                                                    <c:when test="${d.status == 0}">
                                                                        <span class="badge bg-secondary">Inactive</span><br>
                                                                    </c:when>

                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-sm btn-outline-secondary" 
                                                                    onclick="window.location.href = '${pageContext.request.contextPath}/admin/userdetail?id=${d.id}'">
                                                                <i class="fa fa-edit"></i>
                                                            </button>
                                                            <form action="${pageContext.request.contextPath}/admin/userlist?action=changeStatus" method="POST">
                                                                <input type="hidden" name="id" value="${d.id}">
                                                                <input type="hidden" name="status" value="${d.status == 1 ? 0 : 1}">
                                                                <button type="submit" class="btn btn-sm ${d.status == 1 ? 'btn-warning' : 'btn-success'}">
                                                                    ${d.status == 1 ? 'Deactivate' : 'Activate'}
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        <nav aria-label="Page navigation example">
                                            <ul class="pagination">

                                                <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/userlist?page=${page == 1 ? 1 : page - 1}">Previous</a>
                                                </li>


                                                <c:forEach begin="1" end="${num}" var="i">
                                                    <li class="page-item ${i == page ? 'active' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/userlist?page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>


                                                <li class="page-item ${page == num ? 'disabled' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/userlist?page=${page + 1}">Next</a>
                                                </li>
                                            </ul>
                                        </nav>

                                        <!-- Modal for Adding User -->
                                        <div class="modal fade" id="AddUser" tabindex="-1" aria-labelledby="AddUser" aria-hidden="true">
                                            <div class="modal-dialog" role="document">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <% String errorMessage = (String) request.getAttribute("error"); %>
                                                        <% if (errorMessage != null) { %>
                                                        <div class="alert alert-danger">
                                                            <%= errorMessage %>
                                                        </div>
                                                        <% } else if (request.getAttribute("successMessage") != null) { %>
                                                        <div class="alert alert-success">
                                                            <%= request.getAttribute("successMessage") %>
                                                        </div>
                                                        <% } %>
                                                        <h6 class="title" id="defaultModalLabel">Add User</h6>
                                                    </div>

                                                    <div class="modal-body">
                                                        <form action="${pageContext.request.contextPath}/admin/userlist?action=add" method="POST" id="addUserForm">
                                                            <div class="row g-2">
                                                                <div class="col-md-4 col-sm-12">
                                                                    <input type="email" class="form-control" placeholder="Email" name="email" required>
                                                                </div>
                                                                <div class="col-md-4 col-sm-12">
                                                                    <input type="text" class="form-control" placeholder="Name" name="fullname" required>
                                                                </div>
                                                                <div class="col-md-4 col-sm-12">
                                                                    <input type="password" class="form-control" placeholder="Password" name="password" required>
                                                                </div>
                                                                <div class="col-md-4 col-sm-12">
                                                                    <label for="role">Role:</label>
                                                                    <select class="form-control" name="role" id="role" required>
                                                                        <option value="">-- Select Role --</option>
                                                                        <option value="1" <c:if test="${param.role == '1'}">selected</c:if>>Admin</option>
                                                                        <option value="2" <c:if test="${param.role == '2'}">selected</c:if>>User</option>
                                                                        <option value="3" <c:if test="${param.role == '3'}">selected</c:if>>QA</option>
                                                                        <option value="4" <c:if test="${param.role == '4'}">selected</c:if>>PM</option>
                                                                        <option value="5" <c:if test="${param.role == '5'}">selected</c:if>>Dept Manager</option>
                                                                        <option value="6" <c:if test="${param.role == '6'}">selected</c:if>>PMO</option>
                                                                        </select>
                                                                    </div>
                                                                    <div class="col-md-4 col-sm-12">
                                                                        <label for="status">Status:</label>
                                                                        <select class="form-control" id="status" name="status" required>
                                                                            <option value="">-- Select Status --</option>
                                                                            <option value="1">Active</option>
                                                                            <option value="0">Inactive</option>

                                                                        </select>
                                                                    </div>
                                                                    <div class="col-md-4 col-sm-12">
                                                                        <label for="departmentId">Department:</label>
                                                                        <select class="form-control" id="departmentId" name="departmentId" required>
                                                                        <c:forEach var="department" items="${departments}">
                                                                            <option value="${department.id}" 
                                                                                    <c:if test="${department.id == param.departmentId}">selected</c:if>>
                                                                                ${department.name}
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>


                                                                <div class="col-md-4 col-sm-12">
                                                                    <input type="text" class="form-control" placeholder="Address" name="address" required>
                                                                </div>

                                                                <!-- Modal Footer with Add and Close Buttons -->
                                                                <div class="modal-footer">
                                                                    <button type="submit" class="btn btn-primary">Add</button>
                                                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- core js file -->
                            <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
                            <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>

                            <!-- page js file -->
                            <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
                            <script>
                                                                        $(document).ready(function () {
                                                                            var extensions = {
                                                                            "sFilter": "dataTables_filter custom_filter_class"

                                                                                    $.extend($.fn.dataTableExt.oStdClasses, extensions);
                                                                            $('#app_user').dataTable({
                                                                                responsive: true
                                                                            });
                                                                        });

                                                                        );
                                                                        document.getElementById("updateButton").onclick = function () {
                                                                            location.href = "${pageContext.request.contextPath}/admin/userdetail"; // Đường dẫn trang bạn muốn chuyển đến
                                                                        };


                            </script>
                            </body>

                            <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/app-users.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:37 GMT -->
                            </html>