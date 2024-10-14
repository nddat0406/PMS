<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Project List</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>
    <style>
        .Project-actions {
            text-align: center;
        }
        .Project-actions form {
            display: inline-block;
            margin-right: 5px;
        }
        .Project-actions .btn {
            display: inline-block;
            margin-bottom: 0;
        }
        .action-bar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 10px;
        }
        .action-bar .btn {
            background-color: #1f8eed;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .action-bar .btn:hover {
            background-color: #0f7dd4;
        }
        .alert {
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            margin-bottom: 15px;
        }
    </style>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">
                    <!-- top navbar -->
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>

                    <!-- Sidbar menu -->
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>
                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Project</h2>
                                        <ul class="breadcrumb mb-0"></ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Hiển thị thông báo thành công (nếu có) -->
                        <c:if test="${not empty sessionScope.message}">
                            <div id="success-alert" class="alert">
                                ${sessionScope.message}
                            </div>
                            <!-- Xóa thông báo khỏi session sau khi hiển thị -->
                            <c:remove var="message" scope="session"/>
                        </c:if>

                        <div class="row clearfix">
                            <div class="col-lg-12 col-md-12">
                                <div class="card mb-4">
                                    <div class="action-bar">
                                        <form action="projectlist?action=add" method="get">
                                            <input type="hidden" name="action" value="add">
                                            <button type="submit" class="btn btn-outline-secondary">Add New Project</button>
                                        </form>
                                    </div>
                                    <form method="get" action="projectlist">
                                        <input type="hidden" name="action" value="filter">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <select name="status" class="form-control">
                                                    <option value="">Status</option>
                                                    <option value="1" ${filterStatus == 1 ? 'selected' : ''}>Active</option>
                                                    <option value="2" ${filterStatus == 2 ? 'selected' : ''}>Deactive</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="submit" class="btn btn-primary">Filter</button>
                                            </div>
                                        </div>
                                    </form>
                                    <div class="card-body">
                                        <form id="navbar-search" class="navbar-form search-form position-relative d-none d-md-block" method="get" action="projectlist">
                                            <input type="hidden" name="action" value="search">
                                            <input name="keyword" class="form-control" placeholder="Search here..." type="text" >
                                            <button type="submit" class="btn btn-secondary">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </form>
                                        <table id="Project" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Code</th>
                                                    <th>Name</th>
                                                    <th>bizTerm</th>
                                                    <th>Status</th>
                                                    <th>Start Date</th>
                                                    <th>Domain</th>
                                                    <th>Department</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${projects}" var="project">
                                                    <tr>
                                                        <td>${project.id}</td>
                                                        <td>${project.code}</td>
                                                        <td>${project.name}</td>
                                                        <td>
                                                            <c:forEach var="bizTerm" items="${bizTerms}">
                                                                <c:if test="${bizTerm.id == project.bizTerm}">
                                                                    ${bizTerm.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </td>

                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${project.status == '1'}">
                                                                    <span>Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span>Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>${project.startDate}</td>
                                                        <td>${project.domain.name}</td>
                                                        <td>${project.department.name}</td>
                                                        <td class="Project-actions">
                                                            <div class="btn-group">
                                                                <form action="projectlist?action=view" method="get" style="display: inline-block;">
                                                                    <input type="hidden" name="action" value="view">
                                                                    <input type="hidden" name="id" value="${project.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-primary">
                                                                        <i class="fa fa-info-circle"></i> 
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

        <!-- Thêm đoạn script để tự động ẩn thông báo sau 3 giây -->
        <script>
            window.setTimeout(function () {
                var alert = document.getElementById("success-alert");
                if (alert) {
                    alert.style.display = 'none';
                }
            }, 1500); // 3000 milliseconds = 3 giây
        </script>

        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
