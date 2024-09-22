<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Edit Department</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
            /* CSS t�y ch?nh */
            .custom-select {
                width: 150px; /* Chi?u r?ng t�y ch?nh cho select */
            }
            .form-container {
                max-width: 600px; /* Gi?i h?n chi?u r?ng form */
                margin: 50px auto; /* C?n gi?a form v?i kho?ng c�ch tr�n */
            }
            .content {
                padding-top: 100px; /* C�ch ??u t? sidebar */
            }
    </style>
</head>
<body>
    <div class="container-fluid">
                    <div class="sidebar">
                <jsp:include page="/WEB-INF/view/common/topNavbar.jsp" />
                <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
                <jsp:include page="/WEB-INF/view/common/pageLoader.jsp" />
            </div>
        <div class="content">
            <div class="form-container">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        ${errorMessage}
                    </div>
                </c:if>
                <form action="department?action=update" method="post" onsubmit="return validateForm();">
                    <input type="hidden" name="id" value="${departmentDetail.id}"> <!-- ID c?a ph�ng ban ?? c?p nh?t -->

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
                        <label for="status">Status:</label>
                        <select id="status" name="status" class="form-control custom-select">
                            <option value="1" ${departmentDetail.status == 1 ? 'selected' : ''}>Active</option>
                            <option value="0" ${departmentDetail.status == 0 ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="parent_department">Ph�ng ban cha:</label>
                        <select id="parent_department" name="parent_department" class="form-control custom-select">
                            <option value="">chose parent</option>
                            <c:forEach var="parent" items="${listParentDepartments}">
                                <option value="${parent.id}" ${departmentDetail.parent != null && departmentDetail.parent.id == parent.id ? 'selected' : ''}>${parent.code}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-success">Update</button>
                    <a href="${pageContext.request.contextPath}/department" class="btn btn-secondary">Back</a>

                </form>
            </div>
        </div>
    </div>

    
    
            <!-- Th�m jQuery v� Bootstrap JS n?u c?n -->
        <script src="assets/bundles/libscripts.bundle.js"></script>
        <script src="assets/bundles/dataTables.bundle.js"></script>
        <script src="assets/bundles/mainscripts.bundle.js"></script>
</body>
</html>
