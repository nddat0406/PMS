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
            <jsp:include page="../common/pageLoader.jsp"></jsp:include>

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
                                            <table id="app_user" class="table table-hover mb-0">
                                                <thead>
                                                    <tr>
                                                        <td>
                                                            <!-- Search Form -->
                                                            <form action="${pageContext.request.contextPath}/admin/userlist?action=search" method="POST">
                                                            <input type="text" name="keyword" placeholder="Enter keyword to search">
                                                            <input type="submit" value="Search">
                                                        </form>

                                                        <!-- Table for displaying users -->
                                                        <table class="table">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Name</th>
                                                                    <th>Department ID</th>
                                                                    <th>Address</th>
                                                                    <th>Role</th>
                                                                    <th>Status</th>
                                                                    <th>Action</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${requestScope.data}" var="d">
                                                                    <tr>
                                                                        <td class="width45">${d.id}</td>
                                                                        <td>${d.fullname}</td>
                                                                        <td>${d.department.name}</td>
                                                                        <td>${d.address}</td>
                                                                        <td>${d.role}</td>
                                                                        <td>${d.status}</td>
                                                                        <td>
                                                                            <button type="button" class="btn btn-sm btn-outline-secondary" 
                                                                                    onclick="window.location.href = '${pageContext.request.contextPath}/admin/userdetail?id=${d.id}'">
                                                                                <i class="fa fa-edit"></i>
                                                                            </button>


                                                                            <!-- Nút Delete -->
                                                                            <form action="${pageContext.request.contextPath}/admin/userlist?action=delete" method="POST" style="display:inline;">
                                                                                <input type="hidden" name="id" value="${d.id}">
                                                                                <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to delete this user?');">
                                                                                    <i class="fa fa-trash-o"></i>
                                                                                </button>
                                                                            </form>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                        <!-- Pagination Controls -->
                                                        <div>
                                                            <ul class="pagination">
                                                                <c:if test="${currentPage > 1}">
                                                                    <li><a href="${pageContext.request.contextPath}/admin/userlist?page=${currentPage - 1}">&laquo; Previous</a></li>
                                                                    </c:if>
                                                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                                                    <li class="${i == currentPage ? 'active' : ''}">
                                                                        <a href="${pageContext.request.contextPath}/admin/userlist?page=${i}">${i}</a>
                                                                    </li>
                                                                </c:forEach>
                                                                <c:if test="${currentPage < totalPages}">
                                                                    <li><a href="${pageContext.request.contextPath}/admin/userlist?page=${currentPage + 1}">Next &raquo;</a></li>
                                                                    </c:if>
                                                            </ul>
                                                        </div>

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
                                                                                    <input type="text" class="form-control" placeholder="Email" name="email" required>
                                                                                </div>
                                                                                <div class="col-md-4 col-sm-12">
                                                                                    <input type="text" class="form-control" placeholder="Name" name="fullname" required>
                                                                                </div>
                                                                                <div class="col-md-4 col-sm-12">
                                                                                    <input type="text" class="form-control" placeholder="Password" name="password" required>
                                                                                </div>
                                                                                <div class="col-md-4 col-sm-12">
                                                                                    <input type="text" class="form-control" placeholder="Role" name="role" required>
                                                                                </div>
                                                                                <div class="col-md-4 col-sm-12">
                                                                                    <input type="text" class="form-control" placeholder="Status" name="status" required>
                                                                                </div>
                                                                                <div class="col-md-4 col-sm-12">
                                                                                    <input type="text" class="form-control" placeholder="Dept ID *" name="departmentId" required>
                                                                                </div>
                                                                                <div class="col-md-4 col-sm-12">
                                                                                    <input type="text" class="form-control" placeholder="Address *" name="address" required>
                                                                                </div>

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
                                                                                    }
                                                                                    $.extend($.fn.dataTableExt.oStdClasses, extensions);
                                                                                            $('#app_user').dataTable({
                                                                                    responsive: true,
                                                                                    });
                                                                                    });
                                                                                    }
                                                                                    );
                                                                                    document.getElementById("updateButton").onclick = function () {
                                                                                        location.href = "${pageContext.request.contextPath}/admin/userdetail"; // Đường dẫn trang bạn muốn chuyển đến
                                                                                    };
                                                        </script>
                                                        </body>

                                                        <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/app-users.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:37 GMT -->
                                                        </html>