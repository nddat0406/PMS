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
<<<<<<< HEAD
                                        <option value="1" <c:if test="${param.status == '1'}">selected</c:if>>Active</option>
                                        <option value="0" <c:if test="${param.status == '0'}">selected</c:if>>Inactive</option>
=======
                                        <option value="0" <c:if test="${param.status == '0'}">selected</c:if>>Draft</option>
                                        <option value="1" <c:if test="${param.status == '1'}">selected</c:if>>Submitted</option>
                                        <option value="2" <c:if test="${param.status == '2'}">selected</c:if>>Approved</option>
                                        <option value="3" <c:if test="${param.status == '3'}">selected</c:if>>Rejected</option>
>>>>>>> 134bd96f1db29a34a13e6d596deaee75d8a872c3
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
<<<<<<< HEAD
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
=======
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Thông báo lỗi (nếu có) -->
                                        <c:if test="${not empty sessionScope.errorMessagee}">
                                            <div class="alert alert-danger" role="alert">
                                                ${sessionScope.errorMessagee}
                                            </div>
                                        </c:if>

                                        <form action="${pageContext.request.contextPath}/timesheet" method="POST">
                                            <input type="hidden" name="action" value="add">

                                            <div class="row g-3">
                                                <!-- Reporter Selector -->
                                                <div class="col-md-6">
                                                    <label for="reporter" class="form-label">Reporter</label>
                                                    <c:if test="${role == 2}">
                                                        <input type="text" id="reporterName" name="reporterName" class="form-control" value="${sessionScope.loginedUser.fullname}" readonly>
                                                        <input type="hidden" name="reporter" value="${sessionScope.loginedUser.id}">
                                                    </c:if>
                                                    <c:if test="${role == 1 || role == 4 || role == 5 || role == 6}">
                                                        <select id="reporter" name="reporter" class="form-select">
                                                            <option value="">Select Reporter</option>
                                                            <c:forEach var="reporter" items="${reporters}">
                                                                <option value="${reporter.id}" <c:if test="${sessionScope.reporterId == reporter.id}">selected</c:if>>${reporter.fullname}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </c:if>
                                                </div>

                                                <!-- Reviewer Selector -->
                                                <div class="col-md-6">
                                                    <label for="reviewer" class="form-label">Reviewer</label>
                                                    <c:if test="${role == 4 || role == 5 || role == 6}">
                                                        <input type="text" id="reviewerName" name="reviewerName" class="form-control" value="${sessionScope.loginedUser.fullname}" readonly>
                                                        <input type="hidden" name="reviewer" value="${sessionScope.loginedUser.id}">
                                                    </c:if>
                                                    <c:if test="${role == 1 || role == 2}">
                                                        <select id="reviewer" name="reviewer" class="form-select">
                                                            <option value="">Select Reviewer</option>
                                                            <c:forEach var="reviewer" items="${reviewers}">
                                                                <option value="${reviewer.id}" <c:if test="${sessionScope.reviewerId == reviewer.id}">selected</c:if>>${reviewer.fullname}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </c:if>
                                                </div>

                                                <!-- Project Selector -->
                                                <div class="col-md-6">
                                                    <label for="projectId" class="form-label">Project</label>
                                                    <select id="projectId" name="projectId" class="form-select">
                                                        <option value="">Select Project</option>
                                                        <c:forEach var="project" items="${projects}">
                                                            <option value="${project.id}" <c:if test="${sessionScope.projectId == project.id}">selected</c:if>>${project.name}</option>
>>>>>>> 134bd96f1db29a34a13e6d596deaee75d8a872c3
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Requirement Selector -->
<<<<<<< HEAD
                                                <div class="col-md-4 col-sm-12">
                                                    <label for="requirement">Requirement</label>
                                                    <select id="requirement" name="requirementId" class="form-control" required>
                                                        <option value="">Select Requirement</option>
                                                        <c:forEach var="requirement" items="${requirements}">
                                                            <option value="${requirement.id}">${requirement.title}</option>
=======
                                                <div class="col-md-6">
                                                    <label for="requirement" class="form-label">Requirement</label>
                                                    <select id="requirement" name="requirementId" class="form-select">
                                                        <option value="">Select Requirement</option>
                                                        <c:forEach var="requirement" items="${requirements}">
                                                            <option value="${requirement.id}" <c:if test="${sessionScope.requirementId == requirement.id}">selected</c:if>>${requirement.title}</option>
>>>>>>> 134bd96f1db29a34a13e6d596deaee75d8a872c3
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Time Create Field -->
<<<<<<< HEAD
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
=======
                                                <div class="col-md-6">
                                                    <label for="timeCreate" class="form-label">Time Create</label>
                                                    <input type="date" id="timeCreate" name="timeCreate" class="form-control" value="${sessionScope.timeCreate}">
                                                </div>

                                                <!-- Time Complete Field -->
                                                <div class="col-md-6">
                                                    <label for="timeComplete" class="form-label">Time Complete</label>
                                                    <input type="date" id="timeComplete" name="timeComplete" class="form-control" value="${sessionScope.timeComplete}">
                                                </div>

                                                <!-- Status Selector -->
                                                <div class="col-md-6">
                                                    <label for="status" class="form-label">Status</label>
                                                    <c:if test="${role == 1 || role == 4 || role == 5 || role == 6}">
                                                        <select id="status" name="status" class="form-select">
                                                            <option value="0" <c:if test="${sessionScope.status == '0'}">selected</c:if>>Draft</option>
                                                            <option value="1" <c:if test="${sessionScope.status == '1'}">selected</c:if>>Submitted</option>
                                                            <option value="2" <c:if test="${sessionScope.status == '2'}">selected</c:if>>Approved</option>
                                                            <option value="3" <c:if test="${sessionScope.status == '3'}">selected</c:if>>Rejected</option>
                                                            </select>
                                                    </c:if>
                                                    <c:if test="${role == 2}">
                                                        <input type="text" id="status" name="statusDisplay" class="form-control" value="Draft" readonly>
                                                        <input type="hidden" name="status" value="0">
                                                    </c:if>
                                                </div>

                                            </div>

                                            <div class="modal-footer mt-4">
                                                <button type="submit" class="btn btn-primary">Add Timesheet</button>
                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                                            </div>

>>>>>>> 134bd96f1db29a34a13e6d596deaee75d8a872c3
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

<<<<<<< HEAD

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
=======
                        <!-- Script to open modal if there's an error message -->
                        <script>
                            $(document).ready(function () {
                            <c:if test="${not empty sessionScope.errorMessagee}">
                                $('#AddTimesheetModal').modal('show');
                            </c:if>
                            });
                        </script>

                        <!-- Xóa các giá trị session sau khi sử dụng -->
                        <c:remove var="errorMessagee" scope="session" />
                        <c:remove var="reporterId" scope="session" />
                        <c:remove var="reviewerId" scope="session" />
                        <c:remove var="projectId" scope="session" />
                        <c:remove var="requirementId" scope="session" />
                        <c:remove var="timeCreate" scope="session" />
                        <c:remove var="timeComplete" scope="session" />
                        <c:remove var="status" scope="session" />


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
                                        <td>
                                            ${timesheet.status == 0 ? 'DRAFT' :
                                              timesheet.status == 1 ? 'SUBMITTED' :
                                              timesheet.status == 2 ? 'APPROVED' :
                                              timesheet.status == 3 ? 'REJECTED' : 'Unknown'}
                                        </td>
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
                                            <!-- Nút Submit chỉ hiển thị khi status là DRAFT hoặc REJECTED và role là MEMBER_ROLE -->                                              
                                            <c:if test="${(timesheet.status == 0 || timesheet.status == 3) && role == 2}">
                                                <form action="${pageContext.request.contextPath}/timesheet" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="changestatus">
                                                    <input type="hidden" name="timesheetId" value="${timesheet.id}">
                                                    <input type="hidden" name="newStatus" value="1"> <!-- Đặt status thành SUBMITTED -->
                                                    <button type="submit" class="btn btn-sm btn-outline-success" title="Submit Timesheet">
                                                        <i class="fa fa-paper-plane"></i> <!-- Biểu tượng Submit -->
                                                    </button>
                                                </form>
                                            </c:if>
                                            <!-- Nút Cancel Submission chỉ hiển thị khi status là SUBMITTED và role là MEMBER_ROLE -->
                                            <c:if test="${timesheet.status == 1 && role == 2}">
                                                <form action="${pageContext.request.contextPath}/timesheet" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="changestatus">
                                                    <input type="hidden" name="timesheetId" value="${timesheet.id}">
                                                    <input type="hidden" name="newStatus" value="0"> <!-- Đặt status thành DRAFT -->
                                                    <button type="submit" class="btn btn-sm btn-outline-warning" title="Cancel Submission">
                                                        <i class="fa fa-times-circle"></i> <!-- Biểu tượng Cancel -->
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${(role == 4 || role == 5 || role == 6) && timesheet.status == 1}">
                                                <!-- Nút Approve -->
                                                <form action="${pageContext.request.contextPath}/timesheet" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="changestatus">
                                                    <input type="hidden" name="timesheetId" value="${timesheet.id}">
                                                    <input type="hidden" name="newStatus" value="2"> <!-- Đặt status thành APPROVED -->
                                                    <button type="submit" class="btn btn-sm btn-outline-success" title="Approve Timesheet">
                                                        <i class="fa fa-check-circle"></i> Approve
                                                    </button>
                                                </form>

                                                <!-- Nút Reject -->
                                                <form action="${pageContext.request.contextPath}/timesheet" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="changestatus">
                                                    <input type="hidden" name="timesheetId" value="${timesheet.id}">
                                                    <input type="hidden" name="newStatus" value="3"> <!-- Đặt status thành REJECTED -->
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Reject Timesheet">
                                                        <i class="fa fa-times-circle"></i> Reject
                                                    </button>
                                                </form>
                                            </c:if>
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
>>>>>>> 134bd96f1db29a34a13e6d596deaee75d8a872c3
                    </div>
                </div>
            </div>
        </div>
<<<<<<< HEAD

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
=======
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
    <script>
        // Kiểm tra nếu có thông báo lỗi, tự động mở modal
        $(document).ready(function () {
        <c:if test="${not empty sessionScope.errorMessagee}">
            $('#AddTimesheetModal').modal('show');
        </c:if>
        });
    </script>

    <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
</body>
>>>>>>> 134bd96f1db29a34a13e6d596deaee75d8a872c3
</html>
