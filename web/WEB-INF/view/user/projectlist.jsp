<%-- 
    Document   : projectlist
    Created on : Sep 26, 2024, 5:35:16 PM
    Author     : HP
--%>

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

            <!-- Page Loader -->
            <jsp:include page="../common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">
                    <!-- top navbar -->
                <jsp:include page="../common/topNavbar.jsp"></jsp:include>

                    <!-- Sidbar menu -->
                <jsp:include page="../common/sidebar.jsp"></jsp:include>

                    <div id="main-content" class="profilepage_2 blog-page">
                        <div class="container-fluid">

                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> User Profile</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Lucid</a></li>
                                            <li class="breadcrumb-item active">Project config</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link ${isSetting==null?'active':''}" id="Overview-tab" data-bs-toggle="tab" href="#Tab1" role="tab">Milestone</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link ${isSetting==null?'':'active'}" id="Settings-tab" data-bs-toggle="tab" href="#Tab2" role="tab">Eval criteria</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link ${isSetting==null?'':'active'}" id="Settings-tab" data-bs-toggle="tab" href="#Tab3" role="tab">Member</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link ${isSetting==null?'':'active'}" id="Settings-tab" data-bs-toggle="tab" href="#Tab4" role="tab">Team</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="tab-content p-0" id="myTabContent">
                                    <div class="tab-pane fade  ${isSetting==null?'show active':''}" id="Tab1">
                                        Tab1
                                    </div>
                                    <div class="tab-pane fade ${isSetting==null?'':'show active'}" id="Tab2">
                                        <div class="row justify-content-center">
                                            Tab2
                                        </div>
                                    </div>
                                    <div class="tab-pane fade ${isSetting==null?'':'show active'}" id="Tab3">
                                        <div class="row justify-content-center">
                                            Tab3
                                        </div>
                                    </div>
                                    <div class="tab-pane fade ${isSetting==null?'':'show active'}" id="Tab4">
                                        <div class="row justify-content-center">
                                            Tab4
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
