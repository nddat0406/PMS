<%-- 
    Document   : UserDetails
    Created on : Sep 14, 2024, 2:33:26 PM
    Author     : DELL
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">


    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/client-add.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:42 GMT -->
    <head>
        <meta charset="utf-8">
        <title>:: Lucid HR BS5 :: Clients Add</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

        <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/x-icon">
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
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Add Clients</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item active">Add</li>
                                            <li class="breadcrumb-item"><a href="index.html">Lucid</a></li>
                                            <li class="breadcrumb-item">Clients</li>
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
                            <form action="${pageContext.request.contextPath}/admin/userdetail?action=edit" method="POST">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row g-3">
                                        <!-- ID (hidden or readonly) -->
                                        <div class="col-md-4 col-sm-12">
                                            <label for="id">User ID</label>
                                            <input type="text" class="form-control" readonly value="${requestScope.updateUser.id}" name="id">
                                        </div>

                                        <!-- Full Name -->
                                        <div class="col-md-4 col-sm-12">
                                            <label for="fullname">Full Name</label>
                                            <input type="text" class="form-control" readonly value="${requestScope.updateUser.fullname}" name="fullname">
                                        </div>

                                        <!-- Address -->
                                        <div class="col-md-4 col-sm-12">
                                            <label for="address">Address</label>
                                            <input type="text" class="form-control" readonly value="${requestScope.updateUser.address}" name="address">
                                        </div>

                                        <!-- Role -->
                                        <div class="col-md-4 col-sm-12">
                                            <label for="role">Role</label>
                                            <select class="form-control" id="role" name="role" required>
                                                <option value="1" <c:if test="${requestScope.updateUser.role == 1}">selected</c:if>>Admin</option>
                                                <option value="2" <c:if test="${requestScope.updateUser.role == 2}">selected</c:if>>User</option>
                                                </select>
                                            </div>

                                            <!-- Status -->
                                            <div class="col-md-4 col-sm-12">
                                                <label for="status">Status:</label>
                                                <select class="form-control" id="status" name="status" required>
                                                    <option value="">-- Select Status --</option>
                                                    <option value="1" <c:if test="${requestScope.updateUser.status == 0}">selected</c:if>>Active</option>
                                                <option value="0" <c:if test="${requestScope.updateUser.status == 1}">selected</c:if>>Inactive</option>
                                                
                                                </select>
                                            </div>

                                            <!-- Department (select dropdown) -->
                                            <div class="col-md-4 col-sm-12">
                                                <label for="departmentId">Department</label>
                                                <select class="form-control" name="departmentId">
                                                <c:forEach var="dept" items="${departments}">
                                                    <option value="${dept.id}" 
                                                            <c:if test="${dept.id == updateUser.department.id}">
                                                                selected
                                                            </c:if>
                                                            >
                                                        ${dept.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Submit Button -->
                                    <div class="mt-3">
                                        <button type="submit" class="btn btn-primary">Update</button>
                                    </div>
                                </div>
                            </div>
                        </form>


                    </div>


                </div>
                <!-- core js file -->
                <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>

                <!-- page js file -->
                <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
                </body>

                <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/client-add.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:42 GMT -->
                </html>
