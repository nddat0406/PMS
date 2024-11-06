<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
            .sortTableHead {
                cursor: pointer;
                position: relative;
            }
            .sort-icon {
                margin-left: 5px;
                font-size: 12px;
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

                        <!-- Button to open modal "Add Project" -->
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
                                    <div class="modal-body">
                                        <!-- Error message if any -->
                                        <c:if test="${not empty sessionScope.error}">
                                            <div class="alert alert-danger">${sessionScope.error}</div>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/projectlist?action=add" method="POST">
                                            <div class="row g-2">
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="code">Project Code</label>
                                                    <input type="text" id="code" name="code" class="form-control" required value="${sessionScope.code}" placeholder="Enter project code">
                                                </div>
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="name">Project Name</label>
                                                    <input type="text" id="name" name="name" class="form-control" required value="${sessionScope.name}" placeholder="Enter project name">
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

                        <!-- Open modal if there is an error -->
                        <c:if test="${param.showAddPopup == 'true'}">
                            <script>
                                document.addEventListener("DOMContentLoaded", function () {
                                    new bootstrap.Modal(document.getElementById("AddProjectModal")).show();
                                });
                            </script>
                        </c:if>
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
                                <div class="col-md-3">
                                    <select name="status" class="form-control">
                                        <option value="">Status</option>
                                        <option value="1" ${status == 1 ? 'selected' : ''}>Active</option>
                                        <option value="2" ${status == 2 ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select name="domainId" class="form-control">
                                        <option value="">Domain</option>
                                        <c:forEach var="domain" items="${domains}">
                                            <option value="${domain.id}" ${domainId == domain.id ? 'selected' : ''}>${domain.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select name="departmentId" class="form-control">
                                        <option value="">Department</option>
                                        <c:forEach var="department" items="${departments}">
                                            <option value="${department.id}" ${departmentId == department.id ? 'selected' : ''}>${department.name}</option>
                                        </c:forEach>
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
                                <input name="keyword" class="form-control" placeholder="Search here..." type="text">
                                <button type="submit" class="btn btn-secondary">
                                    <i class="fa fa-search"></i>
                                </button>
                            </form>
                            <table id="Project" class="table table-hover">
                                <thead>
                                    <tr>
                                        <th class="sortTableHead" name="id" sortBy="asc">ID <i class="fa fa-sort sort-icon"></i></th>
                                        <th class="sortTableHead" name="code" sortBy="asc">Code <i class="fa fa-sort sort-icon"></i></th>
                                        <th class="sortTableHead" name="name" sortBy="asc">Name <i class="fa fa-sort sort-icon"></i></th>
                                        <th name="project.bizTerm" sortBy="asc" class="sortTableHead">Biz Term&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                        <th name="project.domain" sortBy="asc" class="sortTableHead">Domain&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                        <th name="project.department" sortBy="asc" class="sortTableHead">Department&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                        <th class="sortTableHead" name="status" sortBy="asc">Status <i class="fa fa-sort sort-icon"></i></th>
                                        <th class="sortTableHead" name="startDate" sortBy="asc">Start Date <i class="fa fa-sort sort-icon"></i></th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody class="tableBody">
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
                                                <fmt:formatDate value="${project.startDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td class="Project-actions">
                                                <div class="btn-group">
                                                    <form action="project/milestone" method="get" style="display: inline-block;">
                                                        <input type="hidden" name="projectId" value="${project.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-primary">
                                                            <i class="fa fa-cog"></i>
                                                        </button>
                                                    </form>
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
                                        <a class="page-link" href="?action=list&page=${currentPage - 1}&status=${param.status}&domainId=${param.domainId}&departmentId=${param.departmentId}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <li class="page-item active">
                                        <a class="page-link text-primary">${currentPage}</a>
                                    </li>
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

        <script>
            $(document).ready(function () {
                function parseDate(dateString) {
                    // Giả sử định dạng ngày là "dd/MM/yyyy"
                    var parts = dateString.split('/');
                    if (parts.length === 3) {
                        return new Date(parts[2], parts[1] - 1, parts[0]); // Chuyển thành định dạng năm, tháng (0-indexed), ngày
                    }
                    return null;
                }

                function sortTable(columnIndex, order) {
                    var rows = $('.tableBody tr').get();

                    rows.sort(function (a, b) {
                        var A = $(a).children('td').eq(columnIndex).text().toUpperCase();
                        var B = $(b).children('td').eq(columnIndex).text().toUpperCase();

                        // Kiểm tra nếu là cột ngày
                        if (columnIndex === 7) { // Thay [CHỈ_SỐ_CỘT_START_DATE] bằng chỉ số cột của "Start Date"
                            var dateA = parseDate(A);
                            var dateB = parseDate(B);

                            if (dateA && dateB) {
                                return order === 'asc' ? dateA - dateB : dateB - dateA;
                            }
                        }

                        if (A < B) {
                            return order === 'asc' ? -1 : 1;
                        }
                        if (A > B) {
                            return order === 'asc' ? 1 : -1;
                        }
                        return 0;
                    });

                    $.each(rows, function (index, row) {
                        $('.tableBody').append(row);
                    });
                }

                $('.sortTableHead').on('click', function () {
                    var $th = $(this); // Lấy phần tử tiêu đề cột được nhấn
                    var columnIndex = $th.index(); // Lấy chỉ mục cột
                    var sortBy = $th.attr('sortBy'); // Trạng thái sắp xếp hiện tại (asc/desc)

                    // Gọi hàm sắp xếp bảng theo cột
                    sortTable(columnIndex, sortBy);

                    // Cập nhật biểu tượng sắp xếp
                    $('.sortTableHead .sort-icon').removeClass('fa-sort-up fa-sort-down').addClass('fa-sort');
                    if (sortBy === 'asc') {
                        sortBy = 'desc';
                        $th.find('.sort-icon').removeClass('fa-sort fa-sort-up').addClass('fa-sort-down');
                    } else {
                        sortBy = 'asc';
                        $th.find('.sort-icon').removeClass('fa-sort fa-sort-down').addClass('fa-sort-up');
                    }

                    // Cập nhật trạng thái sắp xếp trong thuộc tính `sortBy`
                    $th.attr('sortBy', sortBy);
                });
            });
        </script>

        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
