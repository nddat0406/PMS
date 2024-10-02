<%-- 
    Document   : projectlist
    Created on : Sep 26, 2024, 5:35:16 PM
    Author     : HP
--%>

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

        <style>
            /* Container for the text */
            .content-wrapper {
                max-height: 50px; /* Define the height for the collapsed state */
                overflow: hidden; /* Hide the overflow */
                transition: max-height 0.4s ease-in-out; /* Smooth ease-in-out transition */
                position: relative;
            }

            /* When expanded, make the max height very large to reveal all content */
            .content-wrapper.expanded {
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
                background: linear-gradient(to bottom, transparent, white); /* Gradient fading to white */
                display: block;
            }

            /* Remove the gradient when fully expanded */
            .content-wrapper.expanded::after {
                display: none;
            }

            /* The "Read More" button */
            .read-more-btn {
                display: inline-block;
                color: blue;
                cursor: pointer;
                text-decoration: underline;
            }
        </style>

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
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link ${showTab.equals("milestone")||showTab==null?'active':''}" id="Overview-tab" data-bs-toggle="tab" href="#Tab1" role="tab">Milestone</a></li>
                                            <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link ${showTab.equals("eval")?'active':''}" id="Settings-tab" data-bs-toggle="tab" href="#Tab2" role="tab">Evaluation criteria</a></li>
                                            <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link ${showTab.equals("member")?'active':''}" id="Settings-tab" data-bs-toggle="tab" href="#Tab3" role="tab">Member</a></li>
                                            <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link ${showTab.equals("team")?'active':''}" id="Settings-tab" data-bs-toggle="tab" href="#Tab4" role="tab">Team</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="tab-content p-0" id="myTabContent">
                                    <div class="tab-pane fade  ${showTab.equals("milestone")||showTab==null?'show active':''}" id="Tab1">
                                        Tab1
                                    </div>
                                    <div class="tab-pane fade ${showTab.equals("eval")?'show active':''}" id="Tab2">
                                        <div class="col-lg-12 col-md-12">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="card-title">Evaluation Criteria</h6>
                                                </div>
                                                <div class="card-body" id="cardbody">
                                                    <form action="dashboard" method="post">
                                                        <input hidden type="text" value="filter" name="action">
                                                        <div style="display: flex; justify-content: space-between">
                                                            <div class="input-group mb-3" style="width: 25%">
                                                                <span class="input-group-text" id="basic-addon11">Department</span>
                                                                <select class="form-select" aria-label="Default select example" name="deptFilter" id="deptFilter" onchange="ChangeFilter()">
                                                                    <option value="0" ${deptFilter==0?'selected':''}>All Department</option>
                                                                    <c:forEach items="${deptList}" var="d">
                                                                        <option value="${d.id}" ${deptFilter==d.id?'selected':''}>${d.name}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="input-group mb-3" style="width: 25%">
                                                                <span class="input-group-text" id="basic-addon11">Domain</span>
                                                                <select class="form-select" aria-label="Default select example" name="domainFilter" id="domainFilter" onchange="ChangeFilter()">
                                                                    <option value="0" ${domainFilter==0?'selected':''}>All Domain</option>
                                                                    <c:forEach items="${domainList}" var="d">
                                                                        <option value="${d.id}" ${domainFilter==d.id?'selected':''}>${d.name}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="input-group mb-3" style="width: 25%">
                                                                <span class="input-group-text" id="basic-addon11">Status</span>
                                                                <select class="form-select" aria-label="Default select example" name="statusFilter" id="statusFilter" onchange="ChangeFilter()">
                                                                    <option value="0" ${statusFilter==0?'selected':''}>All Status</option>
                                                                    <option value="1" ${statusFilter==1?'selected':''}>Active</option>
                                                                    <option value="2" ${statusFilter==2?'selected':''}>InActive</option>
                                                                </select>
                                                            </div>
                                                            <div class="input-group mb-3" style="width: 15%">
                                                                <input value="${searchKey.trim()}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                                <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                            </div>
                                                        </div>
                                                    </form>

                                                    <table id="pro_list" class="table table-hover mb-0 justify-content-end">
                                                        <thead id="tableHead">
                                                            <tr>
                                                                <th>id</th>
                                                                <th>Name</th>
                                                                <th>weight</th>
                                                                <th>milestone</th>
                                                                <th>description</th>
                                                                <th>action</th>
                                                                <th>status</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody class="table-hover tableBody" >
                                                            <c:forEach items="${tableData}" var="i">
                                                                <tr>
                                                                    <td>
                                                                        <span>${i.id}</span>
                                                                    </td>
                                                                    <td>
                                                                        ${i.name}
                                                                    </td>
                                                                    <td>
                                                                        ${i.weight} %
                                                                    </td>
                                                                    <td style="width: 200px">
                                                                        iter
                                                                    </td>
                                                                    <td style="width: 400px">
                                                                        <div class="content-wrapper" id="contentWrapper">
                                                                            <p>
                                                                                ${i.description}
                                                                            </p>
                                                                        </div>
                                                                        <span class="read-more-btn" id="readMoreBtn">Read More</span>
                                                                    </td>

                                                                    <td style="width: 200px">
                                                                        <a href="javascript:void(0);" class="btn btn-sm btn-outline-success"><i class="fa fa-pencil"></i></a>
                                                                        <a href="javascript:void(0);" class="btn btn-sm btn-outline-danger"><i class="fa fa-trash"></i></a>
                                                                    </td>
                                                                    <td style="width: 150px">
                                                                        <c:choose >
                                                                            <c:when test="${i.status==true}">
                                                                                <span class="badge bg-success">Active</span><br>
                                                                            </c:when>
                                                                            <c:when test="${i.status==false}">
                                                                                <span class="badge bg-secondary">Inactive</span><br>
                                                                            </c:when>
                                                                        </c:choose>
                                                                    </td>

                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                    <c:if test="${searchSize==0}">
                                                        <div class="card-body text-center">
                                                            <h4>No result found!</h4>
                                                        </div>
                                                    </c:if>
                                                    <nav aria-label="Page navigation example">
                                                        <ul class="pagination">
                                                            <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${page==1?1:page-1}">Previous</a></li>
                                                                <c:forEach begin="${1}" end="${num}" var="i">
                                                                <li class="page-item ${i==page?'active':''}"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${i}">${i}</a></li>
                                                                </c:forEach>
                                                            <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${page+1}">Next</a></li>
                                                        </ul>
                                                    </nav>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade ${showTab.equals("member")?'show active':''}" id="Tab3">
                                        <div class="row justify-content-center">
                                            Tab3
                                        </div>
                                    </div>
                                    <div class="tab-pane fade ${showTab.equals("team")?'show active':''}" id="Tab4">
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
        </script>

    </body>

</html>
