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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .container {
                margin-top: 20px;
                margin-bottom: 20px;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h2 {
                margin-bottom: 20px;
            }
            .form-group label {
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="WEB-INF/view/common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="WEB-INF/view/common/topNavbar.jsp"></jsp:include>
                <jsp:include page="WEB-INF/view/common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container">
                            <h2>Add Project</h2>

                            <!-- Display error or success messages -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <c:if test="${param.success == 'true'}">
                            <div class="alert alert-success">Project added successfully!</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/projectlist?action=add" method="post">
                            <div class="form-group">
                                <label for="code">Code:</label>
                                <input type="text" id="code" name="code" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="name">Name Project:</label>
                                <input type="text" id="name" name="name" class="form-control" required>
                            </div>
                            <label for="bizTerm">Select BizTerm:</label>
                            <select id="bizTerm" name="bizTerm">
                                <c:forEach var="bizTerm" items="${bizTerms}">
                                    <option value="${bizTerm.id}">${bizTerm.name}</option>
                                </c:forEach>
                            </select>


                            <div class="form-group">
                                <label for="details">Detail:</label>
                                <textarea id="details" name="details" class="form-control" rows="5"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="startDate">Start Date:</label>
                                <input type="date" id="startDate" name="startDate" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="status">Status:</label>
                                <select id="status" name="status" class="form-control">
                                    <option value="1">Active</option>
                                    <option value="0">Deactive</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="domainId">Domain:</label>
                                <select id="domainId" name="domainId" class="form-control" required>
                                    <c:forEach var="domain" items="${domains}">
                                        <option value="${domain.id}">${domain.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="departmentId">Department:</label>
                                <select id="departmentId" name="departmentId" class="form-control" required>
                                    <c:forEach var="department" items="${departments}">
                                        <option value="${department.id}">${department.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <button type="submit" class="btn btn-primary">Add Project</button>
                            </div>
                        </form>
                        <a href="${pageContext.request.contextPath}/projectlist" class="btn btn-secondary mt-3">Back</a>
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
