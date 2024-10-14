<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">


    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/project-list.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:40 GMT -->
    <head>
        <meta charset="utf-8">
        <title>Department</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

        <link rel="icon" href="favicon.ico" type="image/x-icon">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">

        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>
    <style>
        .Domain-actions {
            text-align: center; /* Canh gi?a các nút b?m */
        }

        .Domain-actions form {
            display: inline-block; /* Hi?n th? các form theo hàng ngang */
            margin-right: 5px; /* Thêm kho?ng cách gi?a các nút */
        }

        .Domain-actions .btn {
            display: inline-block; /* ??m b?o nút b?m không b? v? dòng */
            margin-bottom: 0; /* Lo?i b? margin d??i n?u có */
        }
        .action-bar {
            display: flex;
            justify-content: flex-end; /* Đẩy nút sang góc phải */
            margin-bottom: 10px; /* Khoảng cách dưới nút */
        }

        .action-bar .btn {
            background-color: #1f8eed; /* Màu nền */
            color: white; /* Màu chữ */
            padding: 10px 20px; /* Khoảng cách trong nút */
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .action-bar .btn:hover {
            background-color: #0f7dd4; /* Màu khi hover */
        }


    </style>
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
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Department</h2>
                                        <ul class="breadcrumb mb-0">

                                        </ul>
                                    </div>

                                </div>
                            </div>

                            <div class="row clearfix">
                                <div class="col-lg-12 col-md-12">

                                    <div class="card mb-4">
                                        <div class="action-bar">
                                            <form action="department" method="get">
                                                <input type="hidden" name="action" value="add">
                                                <button type="submit" class="btn btn-outline-secondary">Add New</button>
                                            </form>
                                        </div>
                                        <form method="post" action="department">
                                            <input type="hidden" name="action" value="filter">

                                            <div class="row">
                                                <!--                                            <div class="col-md-3">
                                                                                                <input type="text" name="code" class="form-control" placeholder="Filter by Code" value="${filterCode}">
                                                                                            </div>
                                                                                            <div class="col-md-3">
                                                                                                <input type="text" name="name" class="form-control" placeholder="Filter by Name" value="${filterName}">
                                                                                            </div>-->
                                            <div class="col-md-3">
                                                <select name="status" class="form-control">
                                                    <option value="">Status</option>
                                                    <option value="1" ${filterStatus == 1 ? 'selected' : ''}>Active</option>
                                                    <option value="0" ${filterStatus == 0 ? 'selected' : ''}>Deactive</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="submit" class="btn btn-primary">Filter</button>
                                            </div>
                                        </div>
                                    </form>

                                    <div class="card-body">
                                        <form id="navbar-search" class="navbar-form search-form position-relative d-none d-md-block" method="post" action="department">
                                            <!-- Hidden input ?? g?i action là search -->
                                            <input type="hidden" name="action" value="search">

                                            <!-- Input ?? ng??i dùng nh?p t? khóa tìm ki?m -->
                                            <input name="keyword" class="form-control" placeholder="Search here..." type="text" required>

                                            <!-- Nút search s? g?i form -->
                                            <button type="submit" class="btn btn-secondary">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </form>

                                        <table id="Domain" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Id</th>
                                                    <th>Code</th>
                                                    <th>Name</th>
                                                    <th>Parent</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                                <c:forEach items="${listD}" var="d">
                                                    <tr>
                                                        <td>${d.id}</td>
                                                        <td class="project-title">
                                                            <h6 class="fs-6 mb-0">${d.code}</h6>

                                                        </td>
                                                        <td>${d.name}</td>
                                                        <td>
                                                            <c:if test="${d.parent != null}">
                                                                ${d.parent.name}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${d.status == '1'}">
                                                                    <span >Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span >Deactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td class="Domain-actions">
                                                            <div class="btn-group">
                                                                <form action="department?action=edit" method="post" style="display: inline-block;">
                                                                    <input type="hidden" name="action" value="edit">
                                                                    <input type="hidden" name="id" value="${d.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                                                        <i class="fa fa-edit"></i> 
                                                                    </button>
                                                                </form>
                                                                <!-- Nút chuyển đổi trạng thái -->
                                                                <form action="department?action=update" method="post" style="display: inline-block;">
                                                                    <input type="hidden" name="id" value="${d.id}">
                                                                    <input type="hidden" name="status" value="${d.status == 1 ? 0 : 1}">
                                                                    <!-- Nút chuyển đổi trạng thái -->
                                                                    <button type="submit" class="btn btn-sm ${d.status == 1 ? 'btn-outline-danger' : 'btn-outline-primary'}">
                                                                        <i class="fa ${d.status == 1 ? 'fa-times' : 'fa-check'}"></i> 
                                                                        ${d.status == 1 ? 'Inactive' : 'Active'}
                                                                    </button>
                                                                </form>

                                                            </div>

                                                        </td>

                                                    </tr>
                                                </c:forEach>

                                            </tbody>
                                        </table>
                                        <nav aria-label="Page navigation example">
                                            <ul class="pagination">
                                                <!-- Nút Previous -->
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="?action=list&page=${currentPage - 1}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>

                                                <!-- Hi?n th? s? trang hi?n t?i -->
                                                <li class="page-item active"><a class="page-link">${currentPage}</a></li>

                                                <!-- Nút Next -->
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
                $('#project_list').dataTable({
                    responsive: true,
                    pageLength: 10,
                    lengthMenu: [[5, 10, 20, -1], [5, 10, 20, 100]]
                });

                // Tooltip
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl)
                })
            });
        </script>
    </body>

    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/project-list.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:40 GMT -->
</html>