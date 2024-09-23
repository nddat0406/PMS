<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Group" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Chỉnh sửa nhóm</title>
        <!-- Thêm Bootstrap CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <style>
            .custom-select {
                width: 150px; /* Chiều rộng tùy chỉnh cho select */
            }

            .form-container {
                max-width: 600px; /* Giới hạn chiều rộng form */
                margin: 50px auto; /* Căn giữa form với khoảng cách trên */
                padding-top: 100px; /* Khoảng cách từ trên cho form */
            }

            /* Đảm bảo sidebar không che nội dung */
            .sidebar {
                height: 100vh; /* Đảm bảo sidebar đầy chiều cao màn hình */
                overflow: auto; /* Thêm thanh cuộn nếu cần */
            }
            .content {
                padding-top: 100px; /* Cách đều từ sidebar */
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/topNavbar.jsp" />
        <div class="d-flex">
            <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
            <div class="container flex-grow-1">
                <jsp:include page="/WEB-INF/view/common/pageLoader.jsp" />
                <div class="form-container">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            ${errorMessage}
                        </div>
                    </c:if>
                    <c:if test="${not empty groupDetail}">
                        <form action="domain?action=update" method="post" ">
                            <input type="hidden" name="id" value="${groupDetail.id}">
                            <div class="form-group">
                                <label for="code">Code:</label>
                                <input type="text" id="code" name="code" class="form-control" value="${groupDetail.code}" required>
                            </div>
                            <div class="form-group">
                                <label for="name">Name:</label>
                                <input type="text" id="name" name="name" class="form-control" value="${groupDetail.name}" required>
                            </div>
                            <div class="form-group">
                                <label for="details">Detail:</label>
                                <textarea id="details" name="details" class="form-control">${groupDetail.details}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="status">Status:</label>
                                <select id="status" name="status" class="form-control custom-select">
                                    <option value="1" ${groupDetail.status == 1 ? 'selected' : ''}>Active</option>
                                    <option value="0" ${groupDetail.status == 0 ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success">Update</button>
                        </form>
                    </c:if>
                    <a href="http://localhost:9999/Project_Management/domain" class="btn btn-secondary mt-3">Back</a> 
                </div>
            </div>
        </div>

        <!-- Thêm jQuery và Bootstrap JS nếu cần -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
