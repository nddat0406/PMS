<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Timesheet Detail</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>
        <div id="layout" class="theme-cyan">
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
                        <c:if test="${ timesheet.status == 1 || timesheet.status == 2}">
                            <!-- Chi tiết Timesheet -->
                            <div class="card">

                                <div class="card-header">
                                    <h5>Timesheet Detail - ID: ${timesheet.id}</h5>
                                </div>
                                <div class="card-body">
                                    <!-- Thông tin chi tiết -->
                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <label><strong>Reporter:</strong></label>
                                            <p>${timesheet.reporter.fullname}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label><strong>Reviewer:</strong></label>
                                            <p>${timesheet.reviewer.fullname}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label><strong>Project:</strong></label>
                                            <p>${timesheet.project.name}</p>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <label><strong>Requirement:</strong></label>
                                            <p>${timesheet.requirement.title}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label><strong>Status:</strong></label>

                                            <p>               ${timesheet.status == 0 ? 'DRAFT' :
                                                                timesheet.status == 1 ? 'SUBMITTED' :
                                                                timesheet.status == 2 ? 'APPROVED' :
                                                                timesheet.status == 3 ? 'REJECTED' : 'Unknown'}</p>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label><strong>Time Created:</strong></label>
                                            <p><fmt:formatDate value="${timesheet.timeCreated}" pattern="dd/MM/yyyy"/></p>
                                        </div>
                                        <div class="col-md-6">
                                            <label><strong>Time Completed:</strong></label>
                                            <p><fmt:formatDate value="${timesheet.timeCompleted}" pattern="dd/MM/yyyy"/></p>
                                        </div>
                                    </div>
                                </c:if>
                                <!-- Nút Quay Lại -->
                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <a href="${pageContext.request.contextPath}/timesheet?action=list" class="btn btn-secondary">Back to List</a>
                                    </div>
                                </div>


                                <!-- for (status:draft,submitted hoặc Admin,prj manager,dept manager,pmo) -->
                                <c:if test="${role == 1 || role == 4 || role == 5 || role == 6 || timesheet.status == 0 || timesheet.status == 3}">
                                    <div class="card mt-4">
                                        <div class="card-header">
                                            <h5>Edit Timesheet</h5>
                                        </div>

                                        <div class="card-body">
                                            <c:if test="${not empty sessionScope.errorMessage}">
                                                <div class="alert alert-danger" role="alert">
                                                    ${sessionScope.errorMessage}
                                                </div>
                                            </c:if>
                                            <form action="${pageContext.request.contextPath}/timesheet" method="POST">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="id" value="${timesheet.id}">

                                                <div class="row mb-3">
                                                    <!-- Project Field -->
                                                    <div class="col-md-4">
                                                        <label for="project"><strong>Project:</strong></label>
                                                        <p class="form-control-plaintext">${timesheet.project.name}</p>
                                                        <input type="hidden" name="projectId" value="${timesheet.project.id}">
                                                    </div>

                                                    <!-- Reporter Field -->
                                                    <c:if test="${role == 1 || role == 4 || role == 5 || role == 6}">
                                                        <div class="col-md-6">
                                                            <label for="reporter"><strong>Reporter:</strong></label>
                                                            <select id="reporter" name="reporter" class="form-control">
                                                                <option value="">Select Reporter</option>
                                                                <c:forEach var="reporter" items="${reporters}">
                                                                    <option value="${reporter.id}" 
                                                                            <c:if test="${sessionScope.reporterId == reporter.id || timesheet.reporter.id == reporter.id}">selected</c:if>>
                                                                        ${reporter.fullname}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${role == 2 || role == 3}">
                                                        <div class="col-md-6">
                                                            <label for="reporter"><strong>Reporter:</strong></label>
                                                            <p class="form-control-plaintext">${sessionScope.loginedUser.fullname}</p>
                                                            <input type="hidden" name="reporter" value="${sessionScope.loginedUser.id}">
                                                        </div>
                                                    </c:if>
                                                </div>

                                                <div class="row mb-3">
                                                    <!-- Reviewer Field -->
                                                    <c:if test="${role == 2 || role == 1 || role == 3}">
                                                        <div class="col-md-6">
                                                            <label for="reviewer"><strong>Reviewer:</strong></label>
                                                            <select id="reviewer" name="reviewer" class="form-control">
                                                                <option value="">Select Reviewer</option>
                                                                <c:forEach var="reviewer" items="${reviewers}">
                                                                    <option value="${reviewer.id}" 
                                                                            <c:if test="${sessionScope.reviewerId == reviewer.id || (timesheet.reviewer != null && timesheet.reviewer.id == reviewer.id)}">selected</c:if>>
                                                                        ${reviewer.fullname}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${role == 4 || role == 5 || role == 6}">
                                                        <div class="col-md-6">
                                                            <label for="reviewer"><strong>Reviewer:</strong></label>
                                                            <p class="form-control-plaintext">${sessionScope.loginedUser.fullname}</p>
                                                            <input type="hidden" name="reviewer" value="${sessionScope.loginedUser.id}">
                                                        </div>
                                                    </c:if>
                                                </div>

                                                <div class="row mb-3">
                                                    <!-- Requirement Field -->
                                                    <div class="col-md-4">
                                                        <label for="requirement"><strong>Requirement:</strong></label>
                                                        <select id="requirement" name="requirementId" class="form-control">
                                                            <option value="">Select Requirement</option>
                                                            <c:forEach var="requirement" items="${requirements}">
                                                                <option value="${requirement.id}" 
                                                                        <c:if test="${sessionScope.requirementId == requirement.id || requirement.id == timesheet.requirement.id}">selected</c:if>>
                                                                    ${requirement.title}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <!-- Status Field -->
                                                    <c:if test="${role == 1 || role == 4 || role == 5 || role == 6}">
                                                        <div class="col-md-4">
                                                            <label for="status"><strong>Status:</strong></label>
                                                            <select id="status" name="status" class="form-control">
                                                                <option value="0" <c:if test="${sessionScope.status == '0' || timesheet.status == 0}">selected</c:if>>Draft</option>
                                                                <option value="1" <c:if test="${sessionScope.status == '1' || timesheet.status == 1}">selected</c:if>>Submitted</option>
                                                                <option value="2" <c:if test="${sessionScope.status == '2' || timesheet.status == 2}">selected</c:if>>Approved</option>
                                                                <option value="3" <c:if test="${sessionScope.status == '3' || timesheet.status == 3}">selected</c:if>>Rejected</option>
                                                                </select>
                                                            </div>
                                                    </c:if>
                                                    <c:if test="${role == 3 || role == 2}">
                                                        <input type="hidden" name="status" value="${timesheet.status}">
                                                    </c:if>
                                                </div>

                                                <div class="row mb-3">
                                                    <!-- Time Fields -->
                                                    <div class="col-md-6">
                                                        <label for="timeCreate"><strong>Time Created:</strong></label>
                                                        <input type="date" id="timeCreate" name="timeCreate" class="form-control" 
                                                               value="${sessionScope.timeCreate != null ? sessionScope.timeCreate : timesheet.timeCreated}" readonly>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="timeComplete"><strong>Time Completed:</strong></label>
                                                        <input type="date" id="timeComplete" name="timeComplete" class="form-control" 
                                                               value="${sessionScope.timeComplete != null ? sessionScope.timeComplete : timesheet.timeCompleted}">
                                                    </div>
                                                </div>


                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <input type="hidden" name="pid" value="${timesheet.project.id}">
                                                        <button type="submit" class="btn btn-primary">Update Timesheet</button>
                                                    </div>
                                                </div>
                                            </form>

                                            <!-- Xóa các giá trị session sau khi sử dụng -->
                                            <c:remove var="errorMessage" scope="session" />
                                            <c:remove var="reporterId" scope="session" />
                                            <c:remove var="reviewerId" scope="session" />
                                            <c:remove var="projectId" scope="session" />
                                            <c:remove var="requirementId" scope="session" />
                                            <c:remove var="timeCreate" scope="session" />
                                            <c:remove var="timeComplete" scope="session" />
                                            <c:remove var="status" scope="session" />
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
