<%-- 
    Document   : dashboard
    Created on : Sep 14, 2024, 2:36:11 PM
    Author     : HP
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">


    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/index2.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:41:40 GMT -->
    <head>
        <meta charset="utf-8">
        <title>:: Lucid HR BS5 :: Project Dashboard</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

        <link rel="icon" href="favicon.ico" type="image/x-icon">

        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <style>
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
            #screen{
                display:block;
                background:#41444b;
                
            }
            #timeZone{
                display:inline-block;
                left:45%;
                top:30%;
                margin:auto;
                border-bottom: #ffd31d solid 3px;
            }
            .clockP{
                text-align:center;
                color:#fddb3a;
                text-shadow: 0px 0px 100px rgba(255,211,29,1);
                
            }
            #time{
                font-size:43px;
                font-weight:bold;
            }
            #date{
                font-size:18px;
                font-weight:bold;
            }



        </style>

    </head>

    <body>

        <div id="layout" class="theme-cyan">

            <!-- Page Loader -->
            <jsp:include page="common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">

                    <!-- top navbar -->
                <jsp:include page="common/topNavbar.jsp"></jsp:include>


                    <!-- Sidbar menu -->
                <jsp:include page="common/sidebar.jsp"></jsp:include>
                    <div id="main-content">
                        <div class="container-fluid">

                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Project Dashboard</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="index.html">Lucid</a></li>
                                            <li class="breadcrumb-item active">Dashboard</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-2 row-deck mb-2">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card col-lg-8" style="    justify-content: center;align-items: center;">
                                        <div class="row col-lg-12">
                                            <div class="col-lg-6 col-md-6 col-sm-6 text-center" style="margin-bottom: 10px;">
                                                <div class="card chart-color1">
                                                    <div class="card-body p-lg-4 text-light">
                                                        <h3>${listSize}</h3>
                                                    <span>Associated Projects</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 text-center" style="margin-bottom: 10px;">
                                            <div class="card chart-color2">
                                                <div class="card-body p-lg-4 text-light">
                                                    <h3>${assignedReq}</h3>
                                                    <span>Assigned Requirement</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 text-center" >
                                            <div class="card chart-color5">
                                                <div class="card-body p-lg-4">
                                                    <h3>${assignedIssue}</h3>
                                                    <span>Assigned Issue</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 text-center">
                                            <div class="card chart-color2">
                                                <div id="screen" style="height: 110.6px">
                                                    <div id="timeZone">
                                                        <p class="clockP" id="time" style="margin-bottom: 0px"> Check your watch</p>
                                                        <p class="clockP" id="date" style="margin-bottom: 10px;">Never be late</p>
                                                    </div>
                                                </div>                                            
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card col-lg-4">
                                    <div class="col-lg-12">
                                        <div class="mb-4 col-lg-12">
                                            <div class="">
                                                <div id="apex-circle-gradient"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-12 col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="card-title">Project List</h6>
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
                                                        <option value="3" ${statusFilter==3?'selected':''}>Closed</option>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-3" style="width: 15%">
                                                    <input value="${searchKey.trim()}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                    <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                </div>
                                            </div>
                                        </form>

                                        <table id="pro_list" class="table table-hover mb-0">
                                            <thead id="tableHead">
                                                <tr>
                                                    <th name="project.name" sortBy="desc" class="sortTableHead">Name&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="project.bizTerm" sortBy="desc" class="sortTableHead">Biz Term&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        <c:if test="${loginedUser.role!=1}" >
                                                        <th name="effortRate" sortBy="desc" class="sortTableHead">Effort Rate&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="role.priority" sortBy="desc" class="sortTableHead">Role&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        </c:if>
                                                    <th name="project.status" sortBy="desc" class="sortTableHead">Status&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="project.startDate" sortBy="desc" class="sortTableHead">Start Date&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                    <th>Details&nbsp;</th>
                                                </tr>
                                            </thead>
                                            <tbody class="table-hover tableBody" >
                                                <c:forEach items="${tableData}" var="l">
                                                    <c:set value="${l.project}" var="p"></c:set>
                                                        <tr>
                                                            <td>
                                                                <h6>${p.code}</h6>
                                                            <span>${p.name}</span>
                                                        </td>
                                                        <td>
                                                            ${p.bizTerm}
                                                        </td>
                                                        <c:if test="${loginedUser.role!=1}" >
                                                            <td>
                                                                <div class="progress" style="height: 5px;">
                                                                    <div class="progress-bar" role="progressbar" aria-valuenow="${l.effortRate}" aria-valuemin="0" aria-valuemax="100" style="width: ${l.effortRate}%;">
                                                                    </div>
                                                                </div>
                                                                <small>Effort Rate: ${l.effortRate}%</small>
                                                            </td>
                                                            <td>${l.getRoleBadge()}</td>
                                                        </c:if>
                                                        <td>
                                                            <c:choose >
                                                                <c:when test="${p.status == 1}">
                                                                    <span class="badge bg-success">Active</span><br>
                                                                </c:when>
                                                                <c:when test="${p.status == 2}">
                                                                    <span class="badge bg-secondary">Inactive</span><br>
                                                                </c:when>
                                                                <c:when test="${p.status == 3}">
                                                                    <span class="badge bg-danger">Closed</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>${p.startDate}</td>
                                                        <td>
                                                            <a href="project/milestone?projectId=${p.id}" class="btn" >
                                                                <strong>Project Configs</strong>
                                                            </a>
                                                        </td>
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
                                                <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${page==1?1:page-1}">Previous</a></li>
                                                    <c:forEach begin="${1}" end="${num}" var="i">
                                                    <li class="page-item ${i==page?'active':''}"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${i}">${i}</a></li>
                                                    </c:forEach>
                                                <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/dashboard?page=${page!=num?page+1:page}">Next</a></li>
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

        <!-- core js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/knobchart.bundle.js"></script>

        <!-- page js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/pages/index2.js"></script>
        <script>
                                                        $(document).ready(function () {
                                                            // Event handler for clicking on the table headers
                                                            $(' .sortTableHead').on('click', function () {
                                                                var $th = $(this); // Get the clicked <th> element as a jQuery object

                                                                var name = $th.attr('name'); // Get the 'name' attribute
                                                                var sortBy = $th.attr('sortBy'); // Get the 'sortBy' attribute
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

                                                            var options = {
                                                                chart: {
                                                                    height: 250,
                                                                    type: 'radialBar'
                                                                },
                                                                colors: ['var(--chart-color1)'],
                                                                plotOptions: {
                                                                    radialBar: {
                                                                        startAngle: -135,
                                                                        endAngle: 225,
                                                                        hollow: {
                                                                            margin: 0,
                                                                            size: '70%',
                                                                            background: '#fff',
                                                                            image: undefined,
                                                                            imageOffsetX: 0,
                                                                            imageOffsetY: 0,
                                                                            position: 'front',

                                                                            dropShadow: {
                                                                                enabled: true,
                                                                                top: 3,
                                                                                left: 0,
                                                                                blur: 4,
                                                                                opacity: 0.24
                                                                            }
                                                                        },
                                                                        track: {
                                                                            background: '#fff',
                                                                            strokeWidth: '67%',
                                                                            margin: 0, // margin is in pixels
                                                                            dropShadow: {
                                                                                enabled: true,
                                                                                top: -3,
                                                                                left: 0,
                                                                                blur: 4,
                                                                                opacity: 0.35
                                                                            }
                                                                        },

                                                                        dataLabels: {
                                                                            showOn: 'always',
                                                                            name: {
                                                                                offsetY: -10,
                                                                                show: true,
                                                                                color: '#888',
                                                                                fontSize: '17px'
                                                                            },
                                                                            value: {
                                                                                formatter: function (val) {
                                                                                    return parseInt(val);
                                                                                },
                                                                                color: '#111',
                                                                                fontSize: '36px',
                                                                                show: true,
                                                                            }
                                                                        }
                                                                    }
                                                                },
                                                                fill: {
                                                                    type: 'gradient',
                                                                    gradient: {
                                                                        shade: 'dark',
                                                                        type: 'horizontal',
                                                                        shadeIntensity: 0.5,
                                                                        gradientTocolors: ['var(--chart-color1)'],
                                                                        inverseColors: true,
                                                                        opacityFrom: 1,
                                                                        opacityTo: 1,
                                                                        stops: [0, 100]
                                                                    }
                                                                },
                                                                series: [${avgEffort}],
                                                                stroke: {
                                                                    lineCap: 'round'
                                                                },
                                                                labels: ['Avg Effort']
                                                            };

                                                            var chart = new ApexCharts(
                                                                    document.querySelector("#apex-circle-gradient"),
                                                                    options
                                                                    );

                                                            chart.render();
                                                        });
                                                        function changeSort(name, sortBy) {
                                                            $.ajax({
                                                                url: "dashboard",
                                                                type: 'post',
                                                                data: {
                                                                    sortBy: sortBy,
                                                                    fieldName: name,
                                                                    action: "sort"
                                                                },
                                                                success: function () {
                                                                    $('.tableBody').load("${pageContext.request.contextPath}/dashboard?page=${page} .tableBody > *");
                                                                }
                                                            });
                                                        }
                                                        ;
                                                        function WhatTimeIsIt() {
                                                            //FOR TIME
                                                            let clock = new Date();
                                                            let hour = clock.getHours();
                                                            if (hour < 10) {
                                                                hour = "0" + hour
                                                            }
                                                            let mn = clock.getMinutes();
                                                            if (mn < 10) {
                                                                mn = "0" + mn
                                                            }
                                                            let sec = clock.getSeconds();
                                                            if (sec < 10) {
                                                                sec = "0" + sec
                                                            }
                                                            let timeIs = hour + " : " + mn + " : " + sec;
                                                            document.getElementById("time").innerText = timeIs;
                                                            //For date
                                                            let day = clock.getDate();
                                                            if (day < 10) {
                                                                day = "0" + day;
                                                            }
                                                            let month = (clock.getMonth()) + 1;
                                                            if (month < 10) {
                                                                month = "0" + month;
                                                            }
                                                            let year = clock.getFullYear();
                                                            let date = day + " - " + month + " - " + year;
                                                            document.getElementById("date").innerText = date;
                                                        }
                                                        setInterval(WhatTimeIsIt, 1000);


        </script>
    </body>
</html>