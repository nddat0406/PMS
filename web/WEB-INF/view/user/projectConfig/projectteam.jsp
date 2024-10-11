
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sweetalert2.min.css">


        <style>
            /* Container for the text */
            .content-wrapper {
                max-height: 50px; /* Define the height for the collapsed state */
                overflow: hidden; /* Hide the overflow */
                transition-timing-function: ease-in;
                /* Quick on the way out */
                transition: 0.25s;
                position: relative;
            }

            /* When expanded, make the max height very large to reveal all content */
            .content-wrapper.expanded {
                /* This timing applies on the way IN */
                transition-timing-function: ease-out;
                /* A litttttle slower on the way in */
                transition: 0.5s;
                max-height: 1000px; /* Can be any large value to show the full text */
            }

            /* Optional: Add a background gradient at the bottom to indicate more content */
            .content-wrapper::after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 10px; /* Height of the gradient */
                background: linear-gradient(to bottom, transparent,); /* Gradient fading to white */
                transition-timing-function: ease-out;
                /* A litttttle slower on the way in */
                transition: 0.5s;

                display: block;
            }

            /* Remove the gradient when fully expanded */
            .content-wrapper.expanded::after {
                display: none;
            }

            /* The "Read More" button */
            .read-more-btn {
                display: inline-block;
                color: #008ce6;
                cursor: pointer;
            }
            .statusCell{
                cursor: pointer;
            }
            th {
                cursor: pointer;
                position: relative;
            }
            .sort-icon {
                margin-left: 5px;
                font-size: 12px;
                width: 10px;
                height: 20px;
            }
            .nameTd{
                display: flex;
            }
            .nameTd img{
                margin: 0px 15px;
            }
            .accordion-item{
                margin: 10px;
            }
            #accordionExample{
                margin-top: 10px;
            }
            .accordion-button span:first-child{
                width: 80px;
            }
            .starIcon{
                width: 24px;
                height: 24px;
                fill: currentcolor;
                color: rgb(237, 108, 2);
            }
        </style>
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
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Settings-tab " href="eval" role="tab">Evaluation criteria</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Settings-tab" href="member" role="tab">Member</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link active" id="Settings-tab" href="team" role="tab">Team</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="tab-content p-0" id="myTabContent">
                                        <div class="tab-pane fade active show" id="Tab2">
                                            <div class="col-lg-12 col-md-12">
                                                <div class="card">
                                                    <div class="card-header">
                                                        <h6 class="card-title">Project Teams</h6>
                                                    </div>
                                                    <div class="card-body" id="cardbody">
                                                        <form action="team" method="post">
                                                            <input hidden type="text" value="filter" name="action">
                                                            <div style="display: flex; justify-content: space-evenly">
                                                                <div class="input-group mb-3" style="width: 25%">
                                                                    <span class="input-group-text" id="basic-addon11">Milestone</span>
                                                                    <select class="form-select" aria-label="Default select example" name="milestoneFilter" id="milestoneFilter">
                                                                        <option value="0" ${milestoneFilter==0?'selected':''}>All Milestone</option>
                                                                    <c:forEach items="${msList}" var="ms">
                                                                        <option value="${ms.id}" ${milestoneFilter==ms.id?'selected':''}>${ms.name}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="input-group mb-3" style="width: 25%">
                                                                <span class="input-group-text" id="basic-addon11">Status</span>
                                                                <select class="form-select" aria-label="Default select example" name="statusFilter" id="statusFilter">
                                                                    <option value="0" ${sessionScope.statusFilter==0?'selected':''}>All Status</option>
                                                                    <option value="1" ${sessionScope.statusFilter==1?'selected':''}>Active</option>
                                                                    <option value="2" ${sessionScope.statusFilter==2?'selected':''}>InActive</option>
                                                                </select>
                                                            </div>
                                                            <div class="input-group mb-3" style="width: 15%">
                                                                <input value="${searchKey.trim()}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                                <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                            </div>
                                                        </div>
                                                    </form>

                                                    <div class="accordion" id="accordionExample">
                                                        <c:forEach items="${tableData}" var="i">
                                                            <div class="justify-content-center" style=" display: flex;justify-content: center">
                                                                <div class="accordion-item col-lg-10 col-md-10">
                                                                    <h2 class="accordion-header" id="heading${i.id}">
                                                                        <button class="accordion-button align-content-around" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${i.id}" aria-expanded="true" aria-controls="collapse${i.id}">
                                                                            <span> <h5>${i.name}</h5></span> 
                                                                            <span> <h5>(${i.getTeamSize()} Members)</h5></span>
                                                                        </button>
                                                                    </h2>
                                                                    <div id="collapse${i.id}" class="accordion-collapse collapse" aria-labelledby="heading${i.id}" data-bs-parent="#accordionExample">
                                                                        <div class="accordion-body">
                                                                            <span><p>${i.teamLeader.getStatus()==0?"Deactivated User":i.teamLeader.fullname} <svg class="starIcon" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="StarsIcon"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm4.24 16L12 15.45 7.77 18l1.12-4.81-3.73-3.23 4.92-.42L12 5l1.92 4.53 4.92.42-3.73 3.23L16.23 18z"></path></svg>
                                                                                </p></span>
                                                                            
                                                                            <c:forEach items="${i.members}" var="m">
                                                                                <p>${m.getStatus()==0?"Deactivated User":m.fullname}</p>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    <c:if test="${empty tableData}">
                                                        <div class="card-body text-center">
                                                            <h4>No result found!</h4>
                                                        </div>
                                                    </c:if>
                                                    <nav aria-label="Page navigation example">
                                                        <ul class="pagination">
                                                            <li class="page-item"><a class="page-link" href="team?page=${page==1?1:page-1}">Previous</a></li>
                                                                <c:forEach begin="${1}" end="${num}" var="i">
                                                                <li class="page-item ${i==page?'active':''}"><a class="page-link" href="team?page=${i}">${i}</a></li>
                                                                </c:forEach>
                                                            <li class="page-item"><a class="page-link" href="team?page=${page!=num?page+1:page}">Next</a></li>
                                                        </ul>
                                                    </nav>
                                                </div>
                                            </div>
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
        <script src="${pageContext.request.contextPath}/assets/bundles/sweetalert2.bundle.js"></script>

        <!-- page js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
        <script>
            $(document).ready(function () {
                // Event handler for clicking on the table headers
                $(' .sortTableHead').on('click', function () {
                    var $th = $(this);  // Get the clicked <th> element as a jQuery object

                    var name = $th.attr('name');  // Get the 'name' attribute
                    var sortBy = $th.attr('sortBy');  // Get the 'sortBy' attribute
                    changeSort(name, sortBy);
                    $('.sortTableHead .sort-icon').removeClass('fa-sort-up fa-sort-down').addClass('fa-sort');

                    // Toggle the sortBy attribute between 'asc' and 'desc'
                    if (sortBy === 'asc') {
                        sortBy = 'desc';
                        $th.find('.sort-icon').removeClass('fa-sort fa-sort-up').addClass('fa-sort-down'); // Change icon to down
                    } else {
                        sortBy = 'asc';
                        $th.find('.sort-icon').removeClass('fa-sort fa-sort-down').addClass('fa-sort-up'); // Change icon to up
                    }

                    // Set the updated sortBy attribute
                    $th.attr('sortBy', sortBy);
                });
            });
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
            function exportToExel() {
                $.ajax({
                    type: "POST",
                    url: "team", // URL của Servlet
                    data: {action: "export"}, // Gửi action là "export"
                    xhrFields: {
                        responseType: 'blob' // Đặt response là blob để nhận file
                    },
                    success: function (data, status, xhr) {
                        var filename = "Project_Members.xlsx"; // Tên file tải về

                        // Tạo URL từ dữ liệu blob
                        var url = window.URL.createObjectURL(data);
                        var a = document.createElement('a');
                        a.href = url;
                        a.download = filename;

                        // Append link ẩn và tự động nhấn để tải file
                        document.body.appendChild(a);
                        a.click();

                        // Xóa URL khi không còn cần nữa
                        window.URL.revokeObjectURL(url);
                    },
                    error: function (xhr, status, error) {
                        Swal.fire({
                            position: 'top-end',
                            icon: 'error',
                            title: 'Error Exporting File!',
                            showConfirmButton: false,
                            timer: 1500
                        });
                    }
                });
            }
            ;
            <c:if test="${loginedUser.role!=2}">

            function changeStatus(id) {
                $.ajax({
                    url: "team",
                    type: 'post',
                    data: {
                        allocateId: id,
                        action: "changeStatus"
                    },
                    success: function () {
                        $(' #status' + id).load("${pageContext.request.contextPath}/project/team?page=${page} #status" + id + " > *");
                    }
                });
            }
            ;
            </c:if>
            function changeSort(name, sortBy) {
                $.ajax({
                    url: "team",
                    type: 'post',
                    data: {
                        sortBy: sortBy,
                        fieldName: name,
                        action: "sort"
                    },
                    success: function () {
                        $('.tableBody').load("${pageContext.request.contextPath}/project/team?page=${page} .tableBody > *");
                    }
                });
            }
            ;

            history.pushState(null, "", location.href.split("?")[0]);
        </script>
    </body>
</html>
