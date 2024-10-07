<%-- 
    Document   : SettingDetails
    Created on : Sep 23, 2024, 5:53:48 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Setting Details</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
    <meta name="author" content="WrapTheme, design by: ThemeMakker.com">
    
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    
    <!-- MAIN CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
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
                                <h2 class="m-0 fs-5">
                                    <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                        <i class="fa fa-arrow-left"></i></a> Setting Details
                                </h2>
                                <ul class="breadcrumb mb-0">
                                    <li class="breadcrumb-item"><a href="index.html">Lucid</a></li>
                                    <li class="breadcrumb-item">Settings</li>
                                    <li class="breadcrumb-item active">Setting Details</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="row g-2">
                        <div class="col-lg-4 col-md-12">
                            <div class="card mb-2">
                                <div class="card-body">
                                    <h6 class="card-title mb-4">${settingDetail.name}</h6>
                                    <p>${settingDetail.description}</p>
                                </div>
                            </div>

                            <div class="card mb-2">
                                <div class="card-body">
                                    <ul class="list-unstyled basic-list mb-0">
                                        <li class="d-flex justify-content-between">Status:                   
                                            <c:choose>
                                                <c:when test="${settings.status == true}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-8 col-md-12">
                            <div class="card mb-2">
                                <div class="card-header">
                                    <h6 class="card-title">Edit Setting</h6>
                                </div>
                                <div class="card-body">
                                    <form action="settings" method="post">
                                        <input type="hidden" name="action" value="${settings != null ? 'update' : 'add'}">
                                        <input type="hidden" name="id" value="${settings != null ? settings.id : ''}">
                                        
                                        <div class="mb-3">
                                            <label for="name" class="form-label">Name</label>
                                            <input type="text" class="form-control" name="name" id="name" value="${settings != null ? settings.name : ''}" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="type" class="form-label">Type</label>
                                            <select name="type" id="type" class="form-control" required>
                                                <option value="1" ${settings.type == 1 ? 'selected' : ''}>Type 1</option>
                                                <option value="2" ${settings.type == 2 ? 'selected' : ''}>Type 2</option>
                                                <option value="3" ${settings.type == 3 ? 'selected' : ''}>Type 3</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="priority" class="form-label">Priority</label>
                                            <input type="number" class="form-control" name="priority" id="priority" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="status" class="form-label">Status</label>
                                            <select name="status" id="status" class="form-control">
                                                <option value="1" ${settings.status == true ? 'selected' : ''}>Active</option>
                                                <option value="0" ${settings.status == false ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="description" class="form-label">Description</label>
                                            <textarea class="form-control" name="description" id="description" rows="3">${settings != null ? settings.description : ''}</textarea>
                                        </div>

                                        <button type="submit" class="btn btn-primary">${settings != null ? 'Update Setting' : 'Add Setting'}</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- core js file -->
    <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>

    <!-- page js file -->
    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
</body>
</html>
