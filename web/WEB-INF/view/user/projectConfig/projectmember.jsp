
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/select2.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sweetalert2.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>


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
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Project Members</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Lucid</a></li>
                                            <li class="breadcrumb-item active">Project Configs</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        <jsp:include page="../../common/projectSearch.jsp"></jsp:include>

                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Overview-tab" href="milestone" role="tab">Milestone</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Settings-tab " href="eval" role="tab">Evaluation criteria</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link active" id="Settings-tab" href="member" role="tab">Member</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Settings-tab" href="team" role="tab">Team</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="tab-content p-0" id="myTabContent">
                                        <div class="tab-pane fade active show" id="Tab2">
                                            <div class="col-lg-12 col-md-12">
                                                <div class="card">
                                                    <div class="card-header">
                                                        <h6 class="card-title">Project Member</h6>
                                                        <ul class="header-dropdown">
                                                            <li>
                                                                <button onclick="exportToExel()" class="btn btn-success"><i class="fa fa-download"></i><span>&nbsp;Export to Excel</span></button>
                                                            </li>
                                                        </ul>

                                                    </div>
                                                    <div class="card-body" id="cardbody">
                                                        <form action="member" method="post">
                                                            <input hidden type="text" value="filter" name="action">
                                                            <div style="display: flex; justify-content: space-between">
                                                                <div style="display: flex;width: 50%; justify-content: space-between">
                                                                    <div class="input-group mb-3" style="width: 45%">
                                                                        <span class="input-group-text" id="basic-addon11">Department</span>
                                                                        <select class="form-select" aria-label="Default select example" name="deptFilter" id="deptFilter">
                                                                            <option value="0" ${deptFilter==0?'selected':''}>All Department</option>
                                                                        <c:forEach items="${deptList}" var="d">
                                                                            <option value="${d.id}" ${deptFilter==d.id?'selected':''}>${d.name}</option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                                <div class="input-group mb-3" style="width: 45%">
                                                                    <span class="input-group-text" id="basic-addon11">Status</span>
                                                                    <select class="form-select" aria-label="Default select example" name="statusFilter" id="statusFilter">
                                                                        <option value="0" ${sessionScope.statusFilter==0?'selected':''}>All Status</option>
                                                                        <option value="1" ${sessionScope.statusFilter==1?'selected':''}>Active</option>
                                                                        <option value="2" ${sessionScope.statusFilter==2?'selected':''}>InActive</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="input-group mb-3 " style="width: 15%">
                                                                <input value="${searchKey.trim()}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                                <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                            </div>
                                                        </div>
                                                    </form>

                                                    <table id="pro_list" class="table table-hover mb-0 justify-content-end">
                                                        <thead id="tableHead">
                                                            <tr>
                                                                <th name="user.id" sortBy="desc" class="sortTableHead">id&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="user.fullname" sortBy="desc" class="sortTableHead" style="width: 25%;">Name&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="user.department.name" sortBy="desc" class="sortTableHead" >department&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="role.priority" sortBy="desc" class="sortTableHead" style="width: 10%;">Role&nbsp;<i class="fa fa-sort sort-icon" ></i></th>
                                                                <th name="effortRate" sortBy="desc" class="sortTableHead">Effort Rate&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="startDate" sortBy="desc" class="sortTableHead">Start Date&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="endDate" sortBy="desc" class="sortTableHead">End Date&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody class="table-hover tableBody">
                                                            <c:forEach items="${tableData}" var="t">
                                                                <c:set value="${t.user}" var="i"></c:set>
                                                                    <tr>
                                                                        <td class="width45">
                                                                        ${i.id}
                                                                    </td>
                                                                    <td class="nameTd">
                                                                        <img src="${i.image}" class="rounded-circle" style="width: 50px; height: 50px" alt="user picture">
                                                                        <div><h6 class="mb-0">${i.fullname}</h6>
                                                                            <span>${i.email}</span>
                                                                        </div>
                                                                    </td>
                                                                    <td>${i.department.name}</td>

                                                                    <td>${t.getRoleBadge()}</td>
                                                                    <td>
                                                                        <div class="progress" style="height: 5px;">
                                                                            <div class="progress-bar" role="progressbar" aria-valuenow="${t.effortRate}" aria-valuemin="0" aria-valuemax="100" style="width: ${t.effortRate}%;">
                                                                            </div>
                                                                        </div>
                                                                        <small>Effort Rate: ${t.effortRate}%</small>
                                                                    </td>
                                                                    <td><span class="datetime">${t.startDate}</span></td>
                                                                    <td><span class="datetime">${t.endDate}</span></td>

                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                    <c:if test="${empty tableData}">
                                                        <div class="card-body text-center">
                                                            <h4>No result found!</h4>
                                                        </div>
                                                    </c:if>
                                                    <nav aria-label="Page navigation example">
                                                        <ul class="pagination">
                                                            <li class="page-item"><a class="page-link" href="member?page=${page==1?1:page-1}">Previous</a></li>
                                                                <c:forEach begin="${1}" end="${num}" var="i">
                                                                <li class="page-item ${i==page?'active':''}"><a class="page-link" href="member?page=${i}">${i}</a></li>
                                                                </c:forEach>
                                                            <li class="page-item"><a class="page-link" href="member?page=${page!=num?page+1:page}">Next</a></li>
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
        <script src="${pageContext.request.contextPath}/assets/bundles/select2.bundle.js"></script>


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
                                                                        $('.select2Project').select2();

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
                                                                            url: "member", // URL của Servlet
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
                                                                    function changeSort(name, sortBy) {
                                                                        $.ajax({
                                                                            url: "member",
                                                                            type: 'post',
                                                                            data: {
                                                                                sortBy: sortBy,
                                                                                fieldName: name,
                                                                                action: "sort"
                                                                            },
                                                                            success: function () {
                                                                                $('.tableBody').load("${pageContext.request.contextPath}/project/member?page=${page} .tableBody > *");
                                                                            }
                                                                        });
                                                                    }
                                                                    ;

                                                                    history.pushState(null, "", location.href.split("?")[0]);
        </script>
    </body>
</html>
