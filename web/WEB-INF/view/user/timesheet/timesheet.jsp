<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Timesheet List</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!-- Thêm các thư viện CSS cần thiết -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <!-- Navbar và Sidebar -->
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                        <c:if test="${not empty message}">
                            <div class="alert alert-info" id="notification">${message}</div>
                            <c:remove var="message" scope="session"/>
                        </c:if>

                        <!-- Tiêu đề và Nút Thêm Timesheet -->
                        <div class="col d-flex justify-content-end">
                            <div class="btn-group">
                                <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#AddTimesheetModal">
                                    Add New Timesheet
                                </button>
                                <button onclick="exportToExcel()" class="btn btn-success">
                                    <i class="fa fa-download"></i>&nbsp;Export to Excel
                                </button>
                            </div>
                        </div>


                        <!-- Form Lọc và Tìm Kiếm -->
                        <form method="get" action="${pageContext.request.contextPath}/timesheet">
                            <input type="hidden" name="action" value="list">
                            <div class="row mb-4">
                                <!-- Bộ lọc Dự án -->
                                <div class="col-md-3">
                                    <select name="projectId" class="form-control">
                                        <option value="">Select Project</option>
                                        <c:forEach var="project" items="${projects}">
                                            <option value="${project.id}"
                                                    <c:if test="${param.projectId == project.id}">selected</c:if>>${project.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Bộ lọc Trạng thái -->
                                <div class="col-md-3">
                                    <select id="status" name="status" class="form-control">
                                        <option value="">Status</option>
                                        <option value="1" <c:if test="${param.status == '1'}">selected</c:if>>Active</option>
                                        <option value="0" <c:if test="${param.status == '0'}">selected</c:if>>Inactive</option>
                                        </select>
                                    </div>
                                    <!-- Nút Lọc -->
                                    <div class="col-md-3">
                                        <button type="submit" class="btn btn-primary">Filter</button>
                                    </div>
                                </div>
                            </form>

                            <!-- Modal Thêm Timesheet -->
                            <div class="modal fade" id="AddTimesheetModal" tabindex="-1" aria-labelledby="AddTimesheetModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="AddTimesheetModalLabel">Add New Timesheet</h5>
                                        </div>
                                        <div class="modal-body">
                                            <form action="${pageContext.request.contextPath}/timesheet" method="POST">
                                            <input type="hidden" name="action" value="add">
                                            <div class="row g-2">
                                                <!-- Reporter Selector -->
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="reporter">Reporter</label>
                                                    <select id="reporter" name="reporter" class="form-control" required>
                                                        <option value="">Select Reporter</option>
                                                        <c:forEach var="reporter" items="${reporters}">
                                                            <option value="${reporter.id}">${reporter.fullname}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Reviewer Selector -->
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="reviewer">Reviewer</label>
                                                    <select id="reviewer" name="reviewer" class="form-control">
                                                        <option value="">Select Reviewer</option>
                                                        <c:forEach var="reviewer" items="${reviewers}">
                                                            <option value="${reviewer.id}">${reviewer.fullname}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Project Selector -->
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="projectId">Project</label>
                                                    <select id="projectId" name="projectId" class="form-control" required>
                                                        <option value="">Select Project</option>
                                                        <c:forEach var="project" items="${projects}">
                                                            <option value="${project.id}">${project.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Requirement Selector -->
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="requirement">Requirement</label>
                                                    <select id="requirement" name="requirementId" class="form-control" required>
                                                        <option value="">Select Requirement</option>
                                                        <c:forEach var="requirement" items="${requirements}">
                                                            <option value="${requirement.id}">${requirement.title}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Time Create Field -->
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="timeCreate">Time Create</label>
                                                    <input type="date" id="timeCreate" name="timeCreate" class="form-control" required>
                                                </div>

                                                <!-- Time Complete Field -->
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="timeComplete">Time Complete</label>
                                                    <input type="date" id="timeComplete" name="timeComplete" class="form-control" required>
                                                </div>

                                                <!-- Status Selector -->
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="status">Status</label>
                                                    <select id="status" name="status" class="form-control">
                                                        <option value="1">Active</option>
                                                        <option value="0">Inactive</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="modal-footer mt-3">
                                                <button type="submit" class="btn btn-primary">Add Timesheet</button>
                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <!-- Form tìm kiếm -->
                        <form id="navbar-search" class="navbar-form search-form position-relative d-none d-md-block" method="get"
                              action="${pageContext.request.contextPath}/timesheet">
                            <input type="hidden" name="action" value="list">
                            <input name="searchKeyword" value="${param.searchKeyword}" class="form-control"
                                   placeholder="Search here..." type="text">
                            <button type="submit" class="btn btn-secondary">
                                <i class="fa fa-search"></i>
                            </button>
                        </form>

                        <!-- Bảng Timesheet -->
                        <div class="card-body">
                            <table id="Timesheet" class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Reporter</th>
                                        <th>Reviewer</th>
                                        <th>Project</th>
                                        <th>Requirement</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty timesheets}">
                                        <tr>
                                            <td colspan="9">No data available.</td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="timesheet" items="${timesheets}">
                                        <tr>
                                            <td>${timesheet.id}</td>
                                            <td>${timesheet.reporter.fullname}</td>
                                            <td>${timesheet.reviewer.fullname}</td>
                                            <td>${timesheet.project.name}</td>
                                            <td>${timesheet.requirement.title}</td>
                                            <td><fmt:formatDate value="${timesheet.timeCreated}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${timesheet.timeCompleted}" pattern="dd/MM/yyyy"/></td>
                                            <td>${timesheet.status == 1 ? 'Active' : 'Inactive'}</td>
                                            <td>
                                                <!-- Nút View/Edit -->
                                                <form action="${pageContext.request.contextPath}/timesheet?action=22222222222222222222222222222" method="get" style="display: inline-block;">
                                                    <input type="hidden" name="action" value="view">
                                                    <input type="hidden" name="id" value="${timesheet.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-primary">
                                                        <i class="fa fa-info-circle"></i> 
                                                    </button>
                                                </form>

                                                <!-- Nút Delete -->
                                                <form action="${pageContext.request.contextPath}/timesheet" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="timesheetId" value="${timesheet.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                                            onclick="return confirm('Are you sure you want to delete this timesheet?');">
                                                        <i class="fa fa-trash"></i>
                                                    </button>
                                                </form>
                                            </td>

                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Phân trang -->
                            <nav aria-label="Page navigation example">
                                <ul class="pagination">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="?action=list&page=${currentPage - 1}&limit=10&searchKeyword=${param.searchKeyword}&status=${param.status}&projectId=${param.projectId.trim()}"
                                           aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <li class="page-item active">
                                        <a class="page-link text-primary">${currentPage}</a>
                                    </li>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="?action=list&page=${currentPage + 1}&limit=10&searchKeyword=${param.searchKeyword}&status=${param.status}&projectId=${param.projectId.trim()}"
                                           aria-label="Next">
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
            function exportToExcel() {
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/timesheet", // URL của Servlet
                    data: {action: "export"}, // Gửi action là "export"
                    xhrFields: {
                        responseType: 'blob' // Đặt response là blob để nhận file
                    },
                    success: function (data, status, xhr) {
                        var filename = "Timesheet_List.xlsx"; // Tên file tải về

                        // Tạo URL từ dữ liệu blob
                        var url = window.URL.createObjectURL(data);
                        var a = document.createElement('a');
                        a.href = url;
                        a.download = filename;

                        // Tự động tải file
                        document.body.appendChild(a);
                        a.click();
                        window.URL.revokeObjectURL(url);
                    },
                    error: function (xhr, status, error) {
                        alert("Error exporting file. Please try again.");
                    }
                });
            }
        </script>
        <script>
            // Nếu có thông báo, ẩn nó sau 3 giây
            $(document).ready(function () {
                const notification = $('#notification');
                if (notification.length) {
                    setTimeout(function () {
                        notification.fadeOut('slow'); // Ẩn thông báo
                    }, 3000); // Thời gian 3000ms = 3 giây
                }
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
