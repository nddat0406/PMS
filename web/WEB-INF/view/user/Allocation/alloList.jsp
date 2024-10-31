
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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

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
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Allocation List</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Lucid</a></li>
                                            <li class="breadcrumb-item active">Allocation List</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="col-lg-12 col-md-12">
                                        <div class="card">
                                            <div class="card-header">
                                                <h6 class="card-title">Filter</h6>
                                            <c:if test="${loginedUser.role!=2}">
                                                <ul class="header-dropdown">
                                                    <li>
                                                        <button type="button" id="addTeamButton" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addTeam">Add New Team</button>
                                                    </li>
                                                    <a class="btn btn-sm btn-outline-success" id="showUpdateMess" hidden data-bs-toggle="modal" data-bs-target="#updateTeam"><i class="fa fa-pencil" ></i></a>
                                                </ul>
                                            </c:if>
                                        </div>
                                        <div class="card-body" id="cardbody">
                                            <form action="allocation" method="post">
                                                <input hidden type="text" value="filter" name="action">
                                                <div style="display: flex; justify-content: space-between">
                                                    <div style="display: flex;width: 80%; justify-content: space-between">
                                                        <div class="input-group mb-3" style="width: 30%">
                                                            <span class="input-group-text" id="basic-addon11">By User</span>
                                                            <select class="form-select select2Normal" aria-label="Default select example" name="userFilter">
                                                                <option value="0" ${userFilter==0?'selected':''}>All User</option>
                                                                <c:forEach items="${tableData}" var="a">
                                                                    <c:set value="${a.user}" var="u"></c:set>
                                                                    <option value="${u.id}" ${userFilter==u.id?'selected':''}>${u.fullname}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="input-group mb-3" style="width: 30%">
                                                            <span class="input-group-text" id="basic-addon11">By Project</span>
                                                            <select class="form-select select2Normal" aria-label="Default select example" name="projectFilter">
                                                                <option value="0" ${projectFilter==0?'selected':''}>All Project</option>
                                                                <c:forEach items="${tableData}" var="a">
                                                                    <c:set value="${a.project}" var="p"></c:set>
                                                                    <option value="${p.id}" ${projectFilter==p.id?'selected':''}>${p.code} - ${p.name}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="input-group mb-3" style="width: 30%">
                                                            <span class="input-group-text" id="basic-addon11">Status</span>
                                                            <select class="form-select" aria-label="Default select example" name="statusFilter" id="statusFilter">
                                                                <option value="0" ${sessionScope.statusFilter==0?'selected':''}>All Status</option>
                                                                <option value="1" ${sessionScope.statusFilter==1?'selected':''}>Active</option>
                                                                <option value="2" ${sessionScope.statusFilter==2?'selected':''}>InActive</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="mb-3 " style="width: 15%">
                                                        <button type="submit" class="btn btn-primary" style="width: 60px;"><i class="fa fa-search"></i></button>
                                                    </div>
                                                </div>
                                            </form>

                                            <table id="pro_list" class="table table-hover mb-0 justify-content-end">
                                                <thead id="tableHead">
                                                    <tr>
                                                        <th name="id" sortBy="desc" class="sortTableHead">id&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="user.fullname" sortBy="desc" class="sortTableHead" style="width: 15%;">member&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="project.name" sortBy="desc" class="sortTableHead" >project&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="user.department.name" sortBy="desc" class="sortTableHead" >department&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="user.role" sortBy="desc" class="sortTableHead">Role&nbsp;<i class="fa fa-sort sort-icon" ></i></th>
                                                        <th name="effortRate" sortBy="desc" class="sortTableHead">Effort Rate&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="startDate" sortBy="desc" class="sortTableHead">Start Date&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                        <th name="endDate" sortBy="desc" class="sortTableHead">End Date&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                            <c:if test="${loginedUser.role!=2}">
                                                            <th>Action</th>
                                                            </c:if>
                                                    </tr>
                                                </thead>
                                                <tbody class="table-hover tableBody">
                                                    <c:forEach items="${tableData}" var="t">
                                                        <c:set value="${t.user}" var="i"></c:set>
                                                        <c:set value="${t.project}" var="p"></c:set>
                                                            <tr>
                                                                <td class="width45">
                                                                ${t.id}
                                                            </td>
                                                            <td class="nameTd">
                                                                <img src="${i.image}" class="rounded-circle" style="width: 50px; height: 50px" alt="user picture">
                                                                <div><h6 class="mb-0">${i.fullname}</h6>
                                                                    <span>${i.email}</span>
                                                                </div>
                                                            </td>
                                                            <td>${p.code} - ${p.name} </td>
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
                                                                <c:if test="${loginedUser.role!=2}">

                                                            </c:if>

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
                                                    <li class="page-item"><a class="page-link" href="allocation?page=${page==1?1:page-1}">Previous</a></li>
                                                        <c:forEach begin="${1}" end="${num}" var="i">
                                                        <li class="page-item ${i==page?'active':''}"><a class="page-link" href="allocation?page=${i}">${i}</a></li>
                                                        </c:forEach>
                                                    <li class="page-item"><a class="page-link" href="allocation?page=${page!=num?page+1:page}">Next</a></li>
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
        <%--modal section--%>
        <c:if test="${loginedUser.role!=2}">
            <!-- Add project members modal -->
            <div class="modal fade" id="addMember" tabindex="-1" aria-labelledby="addMember" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="defaultModalLabel">Add Member To Team</h5>
                        </div>
                        <input type="hidden" id="teamAddMember" name="teamId">
                        <div class="modal-body">
                            <div class="table-responsive">
                                <table class="table table-hover c_list">
                                    <thead>
                                        <tr>
                                            <th>
                                                <label class="fancy-checkbox">
                                                    <span><input class="select-all" type="checkbox" name="checkbox" id="select-all">
                                                    </span>
                                                </label>
                                            </th>
                                            <th></th>
                                            <th>Name</th>
                                            <th>Email</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tableAddBody">
                                        <c:forEach items="${addMemberList}" var="u">
                                            <c:if test="${u!=null}">
                                                <tr>
                                                    <td style="width: 50px;">
                                                        <div class="form-check">
                                                            <input class="form-check-input" name="addMembers" type="checkbox" value="${u.id}">
                                                        </div>
                                                    </td>
                                                    <td style="width: 100px">
                                                        <img src="${u.image}" class="rounded-circle avatar" alt="">
                                                    </td>
                                                    <td style="width: 250px">
                                                        <p class="c_name">${u.fullname}
                                                            <c:if test="${u.role==1}">
                                                                <span class="badge bg-danger hidden-sm-down">${u.getRoleString()}</span>

                                                            </c:if>
                                                            <c:if test="${u.role==2}">
                                                                <span class="badge bg-secondary hidden-sm-down">${u.getRoleString()}</span>

                                                            </c:if>
                                                            <c:if test="${u.role==3||u.role==4}">
                                                                <span class="badge bg-success hidden-sm-down">${u.getRoleString()}</span>
                                                            </c:if>
                                                            <c:if test="${u.role==5||u.role==6}">
                                                                <span class="badge bg-info hidden-sm-down">${u.getRoleString()}</span>
                                                            </c:if>
                                                        </p>
                                                    </td>
                                                    <td style="width: 200px">
                                                        <span class="email"><i class="fa fa-envelope"></i>&nbsp;&nbsp;${u.email}</span>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" onclick="addMembers()">Add</button>
                            <button type="button" id="closeModalBtn" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- core js file -->
    <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/bundles/sweetalert2.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/bundles/select2.bundle.js"></script>

    <!-- page js file -->
    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/pages/table/table-basic.js"></script>
    <c:if test="${requestScope.successMess!=null}">
        <script>
                                Swal.fire({
                                    position: 'top-end',
                                    icon: 'success',
                                    title: '${successMess}',
                                    showConfirmButton: false,
                                    timer: 1500
                                });
        </script>
    </c:if>

    <c:if test="${isAdd!=null}">
        <script>$('#addTeamButton').click();</script>
    </c:if>
    <c:if test="${isUpdate!=null}">
        <script>$('#showUpdateMess')[0].click();</script>
    </c:if>

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
            $('.select2Normal').select2();
        });
        function changeSort(name, sortBy) {
            $.ajax({
                url: "allocation",
                type: 'post',
                data: {
                    sortBy: sortBy,
                    fieldName: name,
                    action: "sort"
                },
                success: function () {
                    $('.tableBody').load("${pageContext.request.contextPath}/allocation?page=${page} .tableBody > *");
                }
            });
        }
        ;
        history.pushState(null, "", location.href.split("?")[0]);
    </script>



</body>
</html>
