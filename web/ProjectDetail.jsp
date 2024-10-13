<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Chi Tiết Dự Án</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="WEB-INF/view/common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="WEB-INF/view/common/topNavbar.jsp"></jsp:include>
                <jsp:include page="WEB-INF/view/common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Chi Tiết Dự Án</h2>
                                    </div>
                                </div>
                            </div>

                            <div class="row clearfix">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-4">
                                        <div class="card-body">
                                            <h2 class="m-0">Chi Tiết Dự Án: ${project.name}</h2>

                                        <p>Code: ${project.code}</p>
                                        <p>StartDate: <fmt:formatDate value="${project.startDate}" pattern="dd/MM/yyyy" /></p>
                                        <p>Detail: ${project.details}</p>


                                        <!-- Phần này chỉ hiển thị nếu role là Project Manager -->
                                        <!-- Phần này chỉ hiển thị nếu role là Project Manager -->
                                        <c:if test="${role == 'Project Manager'}">
                                            <form action="${pageContext.request.contextPath}/projectlist?action=update" method="post">
                                                <label for="status">Cập nhật trạng thái dự án:</label><br>

                                                <!-- Radio button cho trạng thái 'Đang thực hiện' -->
                                                <input type="radio" id="status1" name="status" value="1" ${project.status == 1 ? 'checked' : ''}>
                                                <label for="status1">Active</label><br>

                                                <!-- Radio button cho trạng thái 'Hoàn thành' -->
                                                <input type="radio" id="status2" name="status" value="2" ${project.status == 2 ? 'checked' : ''}>
                                                <label for="status2">Deactive</label><br>

                                                <input type="hidden" name="projectId" value="${project.id}" />
                                                <button type="submit" class="btn btn-primary">Update</button>
                                            </form>
                                        </c:if>

                                        <!-- Nếu không phải Project Manager, chỉ hiển thị trạng thái -->
                                        <c:if test="${role != 'Project Manager'}">
                                            <p>Trạng thái hiện tại của dự án: 
                                                <c:choose>
                                                    <c:when test="${project.status == 1}">
                                                        Active
                                                    </c:when>
                                                    <c:otherwise>
                                                        Deactive
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </c:if>


                                        <h2>Milestones</h2>
                                        <table id="Milestones" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Milestone Name</th>
                                                    <th>EndDate</th>
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
                                                                <c:when test="${milestone.status}">
                                                                    Đang thực hiện
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Hoàn thành
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>

                                        <h2>Thành Viên Tham Gia</h2>
                                        <table id="ProjectMembers" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>fullname</th>
                                                    <th>Role</th>
                                                    <th>EffortRate</th>
                                                    <th>StartDate</th>
                                                    <th>EndDate</th>
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

                                        <a href="${pageContext.request.contextPath}/projectlist?action=list" class="btn btn-secondary">Quay lại</a>
                                    </div>
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
