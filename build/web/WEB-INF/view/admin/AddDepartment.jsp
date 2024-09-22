<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Group" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Add Department</title>
        <!-- Thêm Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <style>
            /* CSS tùy chỉnh */
            .custom-select {
                width: 150px; /* Chiều rộng tùy chỉnh cho select */
            }
            .form-container {
                max-width: 600px; /* Giới hạn chiều rộng form */
                margin: 50px auto; /* Căn giữa form với khoảng cách trên */
            }
            .content {
                padding-top: 100px; /* Cách đều từ sidebar */
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <!-- Sidebar -->
            <div class="sidebar">
                <jsp:include page="/WEB-INF/view/common/topNavbar.jsp" />
                <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
                <jsp:include page="/WEB-INF/view/common/pageLoader.jsp" />
            </div>

            <!-- Content -->
            <div class="content">
                <div class="form-container">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            ${errorMessage}
                        </div>
                    </c:if>
                    <form action="department?action=add" method="post">
                        <div class="form-group">
                            <label for="code">Code:</label>
                            <input type="text" id="code" name="code" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="name">Name:</label>
                            <input type="text" id="name" name="name" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="details">Detail:</label>
                            <textarea id="details" name="details" class="form-control" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="status">Status:</label>
                            <select id="status" name="status" class="form-control custom-select">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="parent_department">Phòng ban cha:</label>
                            <select id="parent_department" name="parent_department" class="form-control custom-select">
                                <option value="">Parent</option>
                                <c:forEach var="parent" items="${listParentDepartments}">
                                    <option value="${parent.id}">${parent.code}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Các nút hành động -->
                        <div class="form-actions text-center">
                            <button type="submit" class="btn btn-success">Add Department</button>
                            <a href="${pageContext.request.contextPath}/department" class="btn btn-secondary ">Back</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Thêm jQuery và Bootstrap JS nếu cần -->
        <script src="assets/bundles/libscripts.bundle.js"></script>
        <script src="assets/bundles/dataTables.bundle.js"></script>
        <script src="assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
