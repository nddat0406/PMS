
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
        <!-- VENDOR CSS -->
        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    </head>

    <body>

        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">
                    <!-- top navbar -->
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>

                    <!-- Sidbar menu -->
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content" class="profilepage_2 blog-page">
                        <div class="container-fluid">

                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> User Profile</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Lucid</a></li>
                                            <li class="breadcrumb-item active">Domain Configs</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="col-lg-12 col-md-12">
                                        <div class="card mb-3">
                                            <div class="card-body">
                                            <c:set var="baseUrl" value="${pageContext.request.contextPath}" />
                                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link " id="Overview-tab" href="${baseUrl}/domain/domainsetting?action=domainSetting" role="tab">Domain Settings</a>
                                                </li>
                                                <li class="nav-item active" role="presentation" style="width: 150px">
                                                    <a class="nav-link" id="Evaluation-tab" href="${baseUrl}/domain/domaineval" role="tab">Evaluation Criteria</a>
                                                </li>
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link" id="DomainUsers-tab" href="${baseUrl}/domain/domainuser" role="tab">Domain Users</a>
                                                </li>
                                                <li class="nav-item" role="presentation" style="width: 150px">
                                                    <a class="nav-link" id="ProjectPhase-tab" href="${baseUrl}/domain/projectphasecriteria" role="tab">Project Phase</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="card-title">Evaluation Criteria</h6>
                                                    <c:if test="${loginedUser.role!=2}">
                                                        <ul class="header-dropdown">
                                                            <li>
                                                                <button type="button" id="addCriteriaBtn" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addCriteria">Add New</button>
                                                            </li>
                                                            <a class="btn btn-sm btn-outline-success" id="showUpdateMess" hidden data-bs-toggle="modal" data-bs-target="#updateCriteria"><i class="fa fa-pencil" ></i></a>
                                                        </ul>
                                                    </c:if>
                                                </div>
                                                <form action="${baseUrl}/domain/domaineval.jsp" method="get" class="mb-3">
                                                    <input type="hidden" name="action" value="domaineval" />
                                                    <div class="row g-3">
                                                        <div class="input-group mb-3" style="width: 25%">
                                                            <span class="input-group-text" id="basic-addon11">Phase</span>
                                                            <select class="form-select" aria-label="Default select example" name="phaseFilter" id="domainFilter">
                                                                <option value="0" ${phaseFilter==0?'selected':''}>All Phase</option>
                                                                <c:forEach items="${msList}" var="m">
                                                                    <option value="${m.id}" ${phaseFilter==m.id?'selected':''}>${m.name}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <select name="status" class="form-select">
                                                                <option value="">All Statuses</option>
                                                                <option value="1" ${filterStatus == '1' ? 'selected' : ''}>Active</option> 
                                                                <option value="0" ${filterStatus == '0' ? 'selected' : ''}>Inactive</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <button type="submit" class="btn btn-primary">Search</button>
                                                        </div>

                                                        <div class="input-group mb-3" style="width: 15%">
                                                            <input value="${searchKey.trim()}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                            <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                        </div>
                                                    </div>
                                                </form>


                                                <table class="table table-striped">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Name</th>
                                                            <th>Weight</th>
                                                            <th>Phase</th>
                                                            <th>Description</th>
                                                            <th>Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="criteria" items="${criteriaList}">
                                                            <tr>
                                                                <td>${criteria.id}</td>
                                                                <td>${criteria.name}</td>
                                                                <td>${criteria.weight}</td>

                                                                <td>${criteria.phase.name}</td>
                                                                <td>${criteria.description}</td>
                                                                <td>
                                                                   

                                                                    <c:choose>
                                                                        <c:when test="${criteria.status == true}">Active</c:when> 
                                                                        <c:when test="${criteria.status == false}">Inactive</c:when>
                                                                        <c:otherwise>Unknown</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
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
