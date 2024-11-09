<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>:: Lucid HR BS5 :: Profile</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css">
    </head>

    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content" class="profilepage_2 blog-page">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i>
                                            </a> User Profile
                                        </h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Lucid</a></li>
                                            <li class="breadcrumb-item active">Domain Configs</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-3">
                                            <div class="card-body">
                                            <c:set var="baseUrl" value="${pageContext.request.contextPath}" />
                                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link " id="Overview-tab" href="${baseUrl}/domain/domainsetting?action=domainSetting" role="tab">Domain Settings</a>
                                                </li>
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link active" id="Evaluation-tab" href="${baseUrl}/domain/domaineval" role="tab">Evaluation Criteria</a>
                                                </li>
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link" id="DomainUsers-tab" href="${baseUrl}/domain/domainuser" role="tab">Domain Users</a>
                                                </li>
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link" id="ProjectPhase-tab" href="${pageContext.request.contextPath}/phaselist" role="tab">Project Phase</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>

                                <div class="tab-content p-0" id="myTabContent">
                                    <div class="row g-3">
                                        <div class="col-md-12"  style="display: flex; justify-content: right">
                                            <a href="${baseUrl}/domain/domainuser?action=add" type="submit" class="btn btn-success">Add new</a>
                                        </div>
                                        <div class="tab-pane fade active show" id="Tab1">
                                            <h3 class="mt-4">Add Domain Eval</h3>
                                            <c:if test="${not empty errors}">
                                                <div class="alert alert-danger">
                                                    <ul>
                                                        <c:forEach var="error" items="${errors}">
                                                            <li>${error}</li>
                                                            </c:forEach>
                                                    </ul>
                                                </div>
                                            </c:if>
                                            <form action="${baseUrl}/domain" method="post">
                                                <input type="hidden" name="action" value="adddomaineval" />
                                                <div class="form-group">
                                                    <label for="name">Criteria Name:</label>
                                                    <input type="text" class="form-control" id="name" name="name" placeholder="Enter criteria name" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="weight">Weight:</label>
                                                    <input type="number" step="0.01" class="form-control" id="weight" name="weight" placeholder="Enter weight" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="weight">Project Phase:</label>
                                                    <select name="phase" required class="form-select">
                                                        <c:forEach items="${projectsphases}" var="p">
                                                            <option value="${p.id}">${p.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="status">Status:</label>
                                                    <select class="form-control" id="status" name="status">
                                                        <option value="1">Active</option>
                                                        <option value="0">Inactive</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="description">Description:</label>
                                                    <textarea class="form-control" id="description" name="description" rows="3" placeholder="Enter description"></textarea>
                                                </div>

                                                <button type="submit" class="btn btn-primary">Submit</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
                </div>
            </div>
    </body>
</html>