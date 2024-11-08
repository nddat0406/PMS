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
                                        <c:if test="${not empty groupDetail}">
                                            <form action="domain?action=update" method="post">
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
                                                    <label for="status">Status:</label><br>
                                                    <input type="checkbox" id="active" name="status" value="1" ${groupDetail.status == 1 ? 'checked' : ''}>
                                                    <label for="active">Activate</label><br>

                                                    <input type="checkbox" id="inactive" name="status" value="0" ${groupDetail.status == 0 ? 'checked' : ''}>
                                                    <label for="inactive">Deactivate</label>
                                                </div>

                                                <!-- Các nút hành động -->
                                                <div class="form-actions text-center">
                                                    <button type="submit" class="btn btn-success">Update</button>
                                                    <a href="${pageContext.request.contextPath}/admin/domain" class="btn btn-secondary">Back</a>
                                                </div>
                                            </form>


                                        </c:if>

                                    </div>
                                </div>
                            </div>
                        </div></div></div></div></div>
        <!-- Thêm jQuery và Bootstrap JS nếu cần -->
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
