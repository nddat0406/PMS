<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Project List</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <style>
            .Project-actions {
                text-align: center;
            }
            .Project-actions form {
                display: inline-block;
                margin-right: 5px;
            }
            .action-bar {
                display: flex;
                justify-content: flex-end;
                margin-bottom: 10px;
            }
            .alert {
                padding: 10px;
                background-color: #4CAF50;
                color: white;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">Project</h2>
                                    </div>
                                </div>
                            </div>

                            <!-- Success Message -->
                        <c:if test="${not empty sessionScope.message}">
                            <div id="success-alert" class="alert">${sessionScope.message}</div>
                            <c:remove var="message" scope="session"/>
                        </c:if>

                        <!-- Button để mở modal "Add Project" -->
<<<<<<< HEAD
                        <div class="action-bar">
                            <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#AddProjectModal">Add New Project</button>
                        </div>

                        <!-- Modal "Add Project" -->
                        <div class="modal fade" id="AddProjectModal" tabindex="-1" aria-labelledby="AddProjectModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="AddProjectModalLabel">Add New Project</h5>                                        
                                    </div>
=======
                        <c:if test="${sessionScope.loginedUser.role ==1}">
                            <div class="action-bar">
                                <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#AddProjectModal">Add New Project</button>
                            </div>
                        </c:if>
                        <!-- Modal "Add Project" -->
                        <div class="modal fade" id="AddProjectModal" tabindex="-1" aria-labelledby="AddProjectModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">

                                    <div class="modal-header">
                                        <h5 class="modal-title" id="AddProjectModalLabel">Add New Project</h5>                                        
                                    </div>

>>>>>>> 134bd96f1db29a34a13e6d596deaee75d8a872c3
                                    <div class="modal-body">
                                        <!-- Hiển thị thông báo lỗi nếu có -->
                                        <c:if test="${not empty sessionScope.error}">
                                            <div class="alert alert-danger">${sessionScope.error}</div>
                                        </c:if>

                                        <form action="${pageContext.request.contextPath}/projectlist?action=add" method="POST">
                                            <!-- Các trường form của Add Project -->
                                            <div class="row g-2">
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="code">Project Code</label>
                                                    <input type="text" id="code" name="code" class="form-control" required
                                                           value="${sessionScope.code}" placeholder="Enter project code">
                                                </div>
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="name">Project Name</label>
                                                    <input type="text" id="name" name="name" class="form-control" required
                                                           value="${sessionScope.name}" placeholder="Enter project name">
                                                </div>
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="bizTerm">Select BizTerm</label>
                                                    <select id="bizTerm" name="bizTerm" class="form-control">
                                                        <c:forEach var="bizTerm" items="${bizTerms}">
                                                            <option value="${bizTerm.id}" ${sessionScope.bizTerm == bizTerm.id ? 'selected' : ''}>${bizTerm.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="details">Details</label>
                                                    <textarea id="details" name="details" class="form-control" rows="2">${sessionScope.details}</textarea>
                                                </div>
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="startDate">Start Date</label>
                                                    <input type="date" id="startDate" name="startDate" class="form-control" value="${sessionScope.startDateStr}">
                                                </div>
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="status">Status</label>
                                                    <select id="status" name="status" class="form-control">
                                                        <option value="1" ${sessionScope.status == 1 ? 'selected' : ''}>Active</option>
                                                        <option value="0" ${sessionScope.status == 0 ? 'selected' : ''}>Inactive</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="domainId">Domain</label>
                                                    <select id="domainId" name="domainId" class="form-control">
                                                        <c:forEach var="domain" items="${domains}">
                                                            <option value="${domain.id}" ${sessionScope.domainId == domain.id ? 'selected' : ''}>${domain.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="departmentId">Department</label>
                                                    <select id="departmentId" name="departmentId" class="form-control">
                                                        <c:forEach var="department" items="${departments}">
                                                            <option value="${department.id}" ${sessionScope.departmentId == department.id ? 'selected' : ''}>${department.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="modal-footer mt-3">
                                                <button type="submit" class="btn btn-primary">Add Project</button>
                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Mở modal nếu có lỗi -->
                        <c:if test="${param.showAddPopup == 'true'}">
                            <script>
                                document.addEventListener("DOMContentLoaded", function () {
                                    new bootstrap.Modal(document.getElementById("AddProjectModal")).show();
                                });
                            </script>
                        </c:if>
                        <!-- Xóa tất cả các giá trị lưu trong session sau khi hiển thị -->
                        <c:remove var="error"/>
                        <c:remove var="code"/>
                        <c:remove var="name"/>
                        <c:remove var="details"/>
                        <c:remove var="bizTerm"/>
                        <c:remove var="status"/>
                        <c:remove var="domainId"/>
                        <c:remove var="departmentId"/>
                        <c:remove var="startDateStr"/>
                        <form method="get" action="projectlist">
                            <input type="hidden" name="action" value="filter">
                            <div class="row">
                                <!-- Bộ lọc trạng thái -->
                                <div class="col-md-3">
                                    <select name="status" class="form-control">
                                        <option value="">Status</option>
                                        <option value="1" ${status == 1 ? 'selected' : ''}>Active</option>
                                        <option value="2" ${status == 2 ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>

                                <!-- Bộ lọc domain -->
                                <div class="col-md-3">
                                    <select name="domainId" class="form-control">
                                        <option value="">Domain</option>
                                        <c:forEach var="domain" items="${domains}">
                                            <option value="${domain.id}" ${domainId == domain.id ? 'selected' : ''}>${domain.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Bộ lọc department -->
                                <div class="col-md-3">
                                    <select name="departmentId" class="form-control">
                                        <option value="">Department</option>
                                        <c:forEach var="department" items="${departments}">
                                            <option value="${department.id}" ${departmentId == department.id ? 'selected' : ''}>${department.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Nút lọc -->
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
                                        <th>Domain</th>
                                        <th>Department</th>
                                        <th>Status</th>
                                        <th>Start Date</th>
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
                                            <td>${project.domain.name}</td>
                                            <td>${project.department.name}</td>
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
                                            <td>
                                                <fmt:formatDate value="${project.startDate}" pattern="dd/MM/yyyy" />
                                            </td>

                                            <td class="Project-actions">
                                                <div class="btn-group">
<<<<<<< HEAD
=======
                                                    <form action="project/milestone" method="get" style="display: inline-block;">
                                                        <input type="hidden" name="projectId" value="${project.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-primary">
                                                            <i class="fa fa-cog"></i> <!-- Icon for Project Configs -->
                                                        </button>
                                                    </form>
>>>>>>> 134bd96f1db29a34a13e6d596deaee75d8a872c3
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
                                    <!-- Previous Page Link -->
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?action=list&page=${currentPage - 1}&status=${param.status}&domainId=${param.domainId}&departmentId=${param.departmentId}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>

                                    <!-- Current Page Indicator -->
                                    <li class="page-item active">
                                        <a class="page-link text-primary">${currentPage}</a>
                                    </li>

                                    <!-- Next Page Link -->
                                    <li class="page-item">
                                        <a class="page-link" href="?action=list&page=${currentPage + 1}&status=${param.status}&domainId=${param.domainId}&departmentId=${param.departmentId}" aria-label="Next">
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
    }, 1500);
</script>

<script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
<script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
<script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
</body>
</html>
