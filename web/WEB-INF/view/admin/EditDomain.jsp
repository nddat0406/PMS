<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Department</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <style>
            .card {
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }
            .form-container {
                padding: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .btn {
                margin-top: 10px;
            }
            .status-label {
                font-weight: bold;
            }
            .form-group label {
                font-weight: bold;
            }
            .form-row {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
            }
            .form-col {
                flex: 1;
                min-width: 200px;
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

                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Edit Department</h2>
                                    </div>
                                </div>
                            </div>

                            <div class="row clearfix">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card">
                                        <div class="card-body form-container">
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger">
                                                ${errorMessage}
                                            </div>
                                        </c:if>

                                        <form action="domain?action=update" method="post"">
                                            <input type="hidden" name="id" value="${groupDetail.id}"> 
                                            <div class="form-row">
                                                <div class="form-group form-col">
                                                    <label for="code">Code:</label>
                                                    <input type="text" id="code" name="code" class="form-control" value="${groupDetail.code}" required>
                                                </div>
                                                <div class="form-group form-col">
                                                    <label for="name">Name:</label>
                                                    <input type="text" id="name" name="name" class="form-control" value="${groupDetail.name}" required>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="details">Details:</label>
                                                <textarea id="details" name="details" class="form-control" rows="4">${groupDetail.details}</textarea>
                                            </div>

                                            <div class="form-group">
                                                <label for="status" class="status-label">Status:</label><br>
                                                <div class="form-check form-check-inline">
                                                    <input type="radio" id="active" name="status" value="1" class="form-check-input" ${groupDetail.status == 1 ? 'checked' : ''}>
                                                    <label for="active" class="form-check-label">Activate</label>
                                                </div>
                                                <div class="form-check form-check-inline">
                                                    <input type="radio" id="inactive" name="status" value="0" class="form-check-input" ${groupDetail.status == 0 ? 'checked' : ''}>
                                                    <label for="inactive" class="form-check-label">Deactivate</label>
                                                </div>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Update</button>
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
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
