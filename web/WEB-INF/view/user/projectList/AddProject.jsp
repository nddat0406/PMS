<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add New Project</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">D
        <style>
            h2 {
                margin-bottom: 20px;
                text-align: center;
            }
            .form-group label {
                font-weight: bold;
            }
            .form-control {
                width: 100%;
                max-width: 400px;
                margin: 0 auto;
            }
            .btn-submit {
                width: 100%;
                max-width: 200px;
                margin: 10px auto;
            }
            .btn-back {
                position: absolute; /* Sử dụng absolute để định vị */
                right: 20px; /* Cách cạnh phải 20px */
                bottom: 20px; /* Cách đáy 20px */
            }
            .alert {
                margin-bottom: 20px;
            }
            .form-container {
                position: relative; /* Để nút "Back" có thể căn chỉnh chính xác */
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
                            <div class="row clearfix">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-4">
                                        <div class="card-body">

                                            <div class="container form-container">
                                                <h2>Add Project</h2>

                                                <!-- Display error or success messages -->
                                            <c:if test="${not empty sessionScope.error}">
                                                <div class="alert alert-danger">${sessionScope.error}</div>
                                                <c:set var="errorDisplayed" value="true"/>
                                            </c:if>
                                            <c:if test="${sessionScope.success == 'true'}">
                                                <div class="alert alert-success">Project added successfully!</div>
                                                <c:set var="successDisplayed" value="true"/>
                                            </c:if>

                                            <form action="${pageContext.request.contextPath}/projectlist?action=add" method="post">
                                                <div class="form-group">
                                                    <label for="code">Code:</label>
                                                    <input type="text" id="code" name="code" class="form-control" required 
                                                           value="${sessionScope.code != null ? sessionScope.code : ''}" placeholder="Enter project code">
                                                </div>

                                                <div class="form-group">
                                                    <label for="name">Name Project:</label>
                                                    <input type="text" id="name" name="name" class="form-control" required 
                                                           value="${sessionScope.name != null ? sessionScope.name : ''}" placeholder="Enter project name">
                                                </div>

                                                <div class="form-group">
                                                    <label for="bizTerm">Select BizTerm:</label>
                                                    <select id="bizTerm" name="bizTerm" class="form-control">
                                                        <c:forEach var="bizTerm" items="${bizTerms}">
                                                            <option value="${bizTerm.id}" <c:if test="${sessionScope.bizTerm == bizTerm.id}">selected</c:if>>
                                                                ${bizTerm.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <div class="form-group">
                                                    <label for="details">Detail:</label>
                                                    <textarea id="details" name="details" class="form-control" rows="3" placeholder="Enter project details">
                                                        ${sessionScope.details != null ? sessionScope.details : ''}
                                                    </textarea>
                                                </div>

                                                <div class="form-group">
                                                    <label for="startDate">Start Date:</label>
                                                    <input type="date" id="startDate" name="startDate" class="form-control" 
                                                           value="${sessionScope.startDateStr != null ? sessionScope.startDateStr : ''}">
                                                </div>

                                                <div class="form-group">
                                                    <label for="status">Status:</label>
                                                    <select id="status" name="status" class="form-control">
                                                        <option value="1" <c:if test="${sessionScope.status == 1}">selected</c:if>>Active</option>
                                                        <option value="0" <c:if test="${sessionScope.status == 0}">selected</c:if>>Deactive</option>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="domainId">Domain:</label>
                                                        <select id="domainId" name="domainId" class="form-control" required>
                                                        <c:forEach var="domain" items="${domains}">
                                                            <option value="${domain.id}" <c:if test="${sessionScope.domainId == domain.id}">selected</c:if>>
                                                                ${domain.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <div class="form-group">
                                                    <label for="departmentId">Department:</label>
                                                    <select id="departmentId" name="departmentId" class="form-control" required>
                                                        <c:forEach var="department" items="${departments}">
                                                            <option value="${department.id}" <c:if test="${sessionScope.departmentId == department.id}">selected</c:if>>
                                                                ${department.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <div class="text-center">
                                                    <button type="submit" class="btn btn-primary btn-submit">Add Project</button>
                                                </div>
                                            </form>

                                            <a href="${pageContext.request.contextPath}/projectlist" class="btn btn-secondary btn-back">Back</a>

                                            <c:if test="${not empty errorDisplayed}">
                                                <c:remove var="error"/>
                                            </c:if>
                                            <c:if test="${not empty successDisplayed}">
                                                <c:remove var="success"/>
                                            </c:if>
                                            <c:remove var="code"/>
                                            <c:remove var="name"/>
                                            <c:remove var="details"/>
                                            <c:remove var="bizTerm"/>
                                            <c:remove var="status"/>
                                            <c:remove var="domainId"/>
                                            <c:remove var="departmentId"/>
                                            <c:remove var="startDateStr"/>
                                        </div>
                                    </div>
                                </div>                
                            </div>
                        </div>
                    </div>
                </div>        
            </div>        
        </div>


        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
