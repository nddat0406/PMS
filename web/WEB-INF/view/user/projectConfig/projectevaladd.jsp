
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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    </head>

    <body>

        <div id="layout" class="theme-cyan">
            <!-- Page Loader -->
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
                                            <li class="breadcrumb-item active">Project Configs</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Overview-tab" href="milestone" role="tab">Milestone</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link active" id="Settings-tab " href="eval" role="tab">Evaluation criteria</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Settings-tab" href="member" role="tab">Member</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Settings-tab" href="team" role="tab">Team</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="tab-content p-0" id="myTabContent">
                                        <div class="tab-pane fade active show" id="Tab2">
                                            
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
        <script src="${pageContext.request.contextPath}/assets/bundles/sweetalert2.bundle.js"></script>

        <!-- page js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

        <script>

                                                                        $readMoreBtn = $(' .read-more-btn');
                                                                        $readMoreBtn.on('click', function () {
                                                                            $contentWrapper = $(this).parent().find(' .content-wrapper');
                                                                            // Toggle the "expanded" class on the content wrapper
                                                                            $contentWrapper.toggleClass('expanded');
                                                                            // Toggle the button text between "Read More" and "Read Less"
                                                                            if ($contentWrapper.hasClass('expanded')) {
                                                                                $(this).text('Read Less');
                                                                            } else {
                                                                                $(this).text('Read More');
                                                                            }
                                                                        });
                                                                        function changeStatus(id) {
                                                                            $.ajax({
                                                                                url: "eval",
                                                                                type: 'post',
                                                                                data: {
                                                                                    criteriaId: id,
                                                                                    action: "changeStatus"
                                                                                },
                                                                                success: function () {
                                                                                    $(' #status' + id).load("${pageContext.request.contextPath}/project/eval?page=${page} #status" + id + " > *");
                                                                                }
                                                                            });
                                                                        }
                                                                        ;
                                                                        function deleteStatus(id) {
                                                                            Swal.fire({
                                                                                title: "Do you want to delete criteria with id="+id+" ?",
                                                                                showCancelButton: true,
                                                                                confirmButtonText: "Delete",
                                                                                confirmButtonColor: "#FC5A69"
                                                                            }).then((result) => {
                                                                                /* Read more about isConfirmed, isDenied below */
                                                                                if (result.isConfirmed) {
                                                                                    $.ajax({
                                                                                        url: "eval",
                                                                                        type: 'post',
                                                                                        data: {
                                                                                            criteriaId: id,
                                                                                            action: "delete"
                                                                                        },
                                                                                        success: function () {
                                                                                            Swal.fire("Deleted!", "", "success");
                                                                                            $(' .tableBody').load("${pageContext.request.contextPath}/project/eval?page=${page} .tableBody > *");
                                                                                        }
                                                                                    });
                                                                                }
                                                                            });
                                                                        }
                                                                        ;

        </script>
    </body>
</html>
