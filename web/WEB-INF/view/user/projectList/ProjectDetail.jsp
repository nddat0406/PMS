<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Project Detail</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .container-fluid {
                padding: 20px;
            }
            .block-header {
                margin-bottom: 20px;
            }
            .card {
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            .btn {
                margin-top: 10px;
            }
            .status-label {
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                    <!-- Top Navbar -->
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>

                    <!-- Sidebar Menu -->
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-4">
                                <h2 class="m-0 fs-5">
                                    <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                        <i class="fa fa-arrow-left"></i>
                                    </a>
                                    Project Detail
                                </h2>
                            </div>

                            <div class="row clearfix">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-4">
                                        <div class="card-body">
                                            <h3 class="m-0">Project Detail: ${project.name}</h3>
                                        <p class="status-label">Code: ${project.code}</p>
                                        <p class="status-label">Start Date: <fmt:formatDate value="${project.startDate}" pattern="dd/MM/yyyy" /></p>
                                        <p class="status-label">Detail: ${project.details}</p>

                                        <!-- Phần này chỉ hiển thị nếu role là Project Manager -->
                                        <c:if test="${role == 'Project Manager'}">
                                            <form action="${pageContext.request.contextPath}/projectlist?action=update" method="post">
                                                <label for="status">Update Project Status:</label>
                                                <div class="form-check">
                                                    <input type="radio" id="status1" name="status" value="1" class="form-check-input" ${project.status == 1 ? 'checked' : ''}>
                                                    <label for="status1" class="form-check-label">Activate</label>
                                                </div>
                                                <div class="form-check">
                                                    <input type="radio" id="status2" name="status" value="2" class="form-check-input" ${project.status == 2 ? 'checked' : ''}>
                                                    <label for="status2" class="form-check-label">Deactivate</label>
                                                </div>
                                                <input type="hidden" name="projectId" value="${project.id}" />
                                                <button type="submit" class="btn btn-primary">Update</button>
                                            </form>
                                        </c:if>

                                        <!-- Nếu không phải Project Manager, chỉ hiển thị trạng thái -->
                                        <c:if test="${role != 'Project Manager'}">
                                            <p class="status-label">Current Project Status: 
                                                <c:choose>
                                                    <c:when test="${project.status == 1}">
                                                        <span class="status-label">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-label">Deactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </c:if>

                                        <h3>Milestones</h3>
                                        <table id="Milestones" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Milestone Name</th>
                                                    <th>End Date</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="milestone" items="${milestones}">
                                                    <tr>
                                                        <td>${milestone.name}</td>
                                                        <td><fmt:formatDate value="${milestone.endDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${milestone.status==1}">
                                                                    In Progress
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Completed
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>

                                        <h3>Project Members</h3>
                                        <table id="ProjectMembers" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Full Name</th>
                                                    <th>Role</th>
                                                    <th>Effort Rate</th>
                                                    <th>Start Date</th>
                                                    <th>End Date</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="allocation" items="${allocations}">
                                                    <tr>
                                                        <td>${allocation.user.fullname}</td>
                                                        <td>${allocation.projectRole}</td>
                                                        <td>${allocation.effortRate}%</td>
                                                        <td><fmt:formatDate value="${allocation.startDate}" pattern="dd/MM/yyyy" /></td>
                                                        <td><fmt:formatDate value="${allocation.endDate}" pattern="dd/MM/yyyy" /></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>

                                        <a href="${pageContext.request.contextPath}/projectlist?action=list" class="btn btn-secondary">Back</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
            <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
            <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
