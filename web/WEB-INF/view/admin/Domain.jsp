<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Domain</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>
    <style>
        .Domain-actions {
            text-align: center;
        }

        .Domain-actions form {
            display: inline-block;
            margin-right: 5px;
        }

        .Domain-actions .btn {
            display: inline-block;
            margin-bottom: 0;
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
            <jsp:include page="../common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">
                <jsp:include page="../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i>
                                            </a> Domain
                                        </h2>
                                        <ul class="breadcrumb mb-0"></ul>
                                    </div>
                                </div>
                            </div>

                            <div class="row clearfix">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-4">
                                        <!-- Nút Add New -->
                                        <div class="action-bar">
                                            <form action="domain?action=add" method="get">
                                                <input type="hidden" name="action" value="add">
                                                <button type="submit" class="btn btn-outline-secondary">Add New</button>
                                            </form>
                                        </div>

                                        <form method="get" action="domain">
                                            <input type="hidden" name="action" value="filter">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <select name="status" class="form-control">
                                                        <option value="">Status</option>
                                                        <option value="1" ${filterStatus == 1 ? 'selected' : ''}>Active</option>
                                                    <option value="0" ${filterStatus == 0 ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="submit" class="btn btn-primary">Filter</button>
                                            </div>
                                        </div>
                                    </form>

                                    <div class="card-body">
                                        <form id="navbar-search" class="navbar-form search-form position-relative d-none d-md-block" method="get" action="domain">
                                            <input type="hidden" name="action" value="search">
                                            <input name="keyword" class="form-control" placeholder="Search here..." type="text" required>
                                            <button type="submit" class="btn btn-secondary">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </form>

                                        <table id="Domain" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Id</th>
                                                    <th>Name</th>
                                                    <th>Code</th>
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
                                                            <c:choose>
                                                                <c:when test="${d.status == '1'}">
                                                                    <span>Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span>Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="Domain-actions">
                                                            <div class="btn-group">
                                                                <form action="domain?action=edit" method="get" style="display: inline-block;">
                                                                    <input type="hidden" name="action" value="edit">
                                                                    <input type="hidden" name="id" value="${d.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                                                        <i class="fa fa-edit"></i> 
                                                                    </button>
                                                                </form>
                                                                <!-- Nút chuyển đổi trạng thái -->
                                                                <form action="domain?action=update" method="post" style="display: inline-block;">
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
        </div>

        <!-- core js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
