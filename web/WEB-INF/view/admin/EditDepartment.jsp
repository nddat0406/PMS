<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <title>Edit Department</title>
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <style>
            /* CSS tùy ch?nh */
            .custom-select {
                width: 150px; /* Chi?u r?ng tùy ch?nh cho select */
            }
            .form-container {
                max-width: 600px; /* Gi?i h?n chi?u r?ng form */
                margin: 50px auto; /* C?n gi?a form v?i kho?ng cách trên */
            }
            .content {
                padding-top: 100px; /* Cách ??u t? sidebar */
            }
        </style>
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="row clearfix">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-4">
                                        <div class="card-body">
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger">
                                                ${errorMessage}
                                            </div>
                                        </c:if>
                                        <form action="department?action=update" method="post" onsubmit="return validateForm();">
                                            <input type="hidden" name="id" value="${departmentDetail.id}"> <!-- ID c?a phòng ban ?? c?p nh?t -->

                                            <div class="form-group">
                                                <label for="code">Code:</label>
                                                <input type="text" id="code" name="code" class="form-control" value="${departmentDetail.code}" required>
                                            </div>

                                            <div class="form-group">
                                                <label for="name">Name:</label>
                                                <input type="text" id="name" name="name" class="form-control" value="${departmentDetail.name}" required>
                                            </div>

                                            <div class="form-group">
                                                <label for="details">Details:</label>
                                                <textarea id="details" name="details" class="form-control" required>${departmentDetail.details}</textarea>
                                            </div>

                                            <div class="form-group">
                                                <label for="status">Status:</label><br>
                                                <input type="checkbox" id="active" name="status" value="1" ${departmentDetail.status == 1 ? 'checked' : ''}>
                                                <label for="active">Activate</label><br>

                                                <input type="checkbox" id="inactive" name="status" value="0" ${departmentDetail.status == 0 ? 'checked' : ''}>
                                                <label for="inactive">Deactivate</label>
                                            </div>

                                            <div class="form-group">
                                                <label for="parent_department">Phòng ban cha:</label>
                                                <select id="parent_department" name="parent_department" class="form-control custom-select">
                                                    <option value="">chose parent</option>
                                                    <c:forEach var="parent" items="${listParentDepartments}">
                                                        <option value="${parent.id}" ${departmentDetail.parent != null && departmentDetail.parent.id == parent.id ? 'selected' : ''}>${parent.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <button type="submit" class="btn btn-success">Update</button>
                                            <a href="${pageContext.request.contextPath}/admin/department" class="btn btn-secondary">Back</a>
                                        </form>
                                    </div>
                                </div>
                            </div>                
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Thêm jQuery và Bootstrap JS n?u c?n -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
        <script>
                                                document.getElementById("active").addEventListener('change', function () {
                                                    if (this.checked) {
                                                        document.getElementById("inactive").checked = false;
                                                    }
                                                });

                                                document.getElementById("inactive").addEventListener('change', function () {
                                                    if (this.checked) {
                                                        document.getElementById("active").checked = false;
                                                    }
                                                });
        </script>
    </body>
</html>
