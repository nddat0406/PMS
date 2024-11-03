
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/datepicker.min.css">
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
            .timeCol span{
                width: 100%;
                display: flex;
                justify-content: center;
                margin-bottom: 5px

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
                                            <c:if test="${loginedUser.role==1 || loginedUser.role==5 || loginedUser.role==6}">
                                                <ul class="header-dropdown">
                                                    <li>
                                                        <a href="allocation/add" id="addModalBtn" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addModal">Add New Allocation</a>
                                                    </li>
                                                    <a class="btn btn-sm btn-outline-success" id="showUpdateMess" hidden data-bs-toggle="modal" data-bs-target="#updateModal"><i class="fa fa-pencil" ></i></a>
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
                                                            <select class="form-select" aria-label="Default select example" name="userFilter" id="UserFilter">
                                                                <option value="0" ${userFilter==0?'selected':''}>All User</option>
                                                                <c:forEach items="${userFilterlist}" var="u">
                                                                    <option value="${u.id}" ${userFilter==u.id?'selected':''} 
                                                                            data-name='${u.fullname}' data-image='${u.image}' data-email='${u.email}'>${u.fullname} - ${u.email}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="input-group mb-3" style="width: 30%">
                                                            <span class="input-group-text" id="basic-addon11">By Project</span>
                                                            <select class="form-select select2Normal" aria-label="Default select example" name="projectFilter">
                                                                <option value="0" ${projectFilter==0?'selected':''}>All Project</option>
                                                                <c:forEach items="${ProjectFilterList}" var="p">
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
                                                        <th name="status" sortBy="desc" class="sortTableHead">status&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                            <c:if test="${loginedUser.role==1 || loginedUser.role==5 || loginedUser.role==6}">
                                                            <th>Action</th>
                                                            </c:if>
                                                    </tr>
                                                </thead>
                                                <tbody class="table-hover tableBody">
                                                    <c:forEach items="${tableData}" var="t">
                                                        <c:set value="${t.user}" var="i"></c:set>
                                                        <c:set value="${t.project}" var="p"></c:set>
                                                        <tr id="row${t.id}">
                                                            <td class="width45">
                                                                ${t.id}
                                                            </td>
                                                            <td >
                                                                <div class="nameTd">
                                                                    <img src="${i.image}" class="rounded-circle" style="width: 50px; height: 50px" alt="user picture">
                                                                    <div><h6 class="mb-0">${i.fullname}</h6>
                                                                        <span>${i.email}</span>
                                                                    </div>
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
                                                            <td class="timeCol">
                                                                <div>
                                                                    <span >${t.getStartDateString()}</span>
                                                                    <span><i class="fa fa-arrow-down"></i></span>
                                                                    <span>${t.endDate==null?'Not Yet':t.getEndDateString()}</span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                ${t.getStatusString()}
                                                            </td>
                                                            <c:if test="${loginedUser.role==1 || loginedUser.role==5 || loginedUser.role==6}">
                                                                <td  style="width: 200px">
                                                                    <div>
                                                                        <a class="btn btn-sm btn-outline-info btn-action"
                                                                           onclick="changeState(${t.id})"><i class="fa fa-power-off" ></i></a>
                                                                        <a class="btn btn-sm btn-outline-success btn-action" data-bs-toggle="modal" data-bs-target="#updateModal" 
                                                                           onclick="getModal(${t.id})"><i class="fa fa-pencil"></i></a>
                                                                        <a class="btn btn-sm btn-outline-danger btn-action"
                                                                           onclick="deleteAllo(${t.id})"><i class="fa fa-trash" ></i></a>
                                                                    </div>
                                                                </td>
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
            <%--modal section--%>
            <c:if test="${loginedUser.role==1 || loginedUser.role==5 || loginedUser.role==6}">
                <div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="largeModal" aria-hidden="false">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form action="allocation" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="modal-header">
                                    <h5 class="modal-title">Add Allocation</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3 clearfix">
                                        <div class="col-md-12 col-sm-12" style="justify-content: center">
                                            <span class="form-label">Project</span>
                                            <select class="form-select select2Modal" required aria-label="Select Project" id="selectProject" style="width: 100%" name="project">
                                                <c:forEach items="${ProjectFilterList}" var="p">
                                                    <option value="${p.id}">${p.code} - ${p.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-12 col-sm-12">
                                            <label class="form-label">Member to add</label>
                                            <select class="form-select" required multiple data-placeholder="Select Members To Add" name="members" style="width: 100%" id="selectMember" name="member">
                                            </select>
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <label class="form-label">Start Date</label>
                                            <div class="input-group date" data-date-autoclose="true" data-provide="datepicker" data-date-format="dd/mm/yyyy">
                                                <input type="text" class="form-control" placeholder="Start Date" name="startDate" >
                                                <div class="input-group-append">
                                                    <button class="btn btn-outline-secondary" type="button"><i class="fa fa-calendar"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <label class="form-label">End Date</label>
                                            <div class="input-group date" data-date-autoclose="true" data-provide="datepicker" data-date-format="dd/mm/yyyy">
                                                <input type="text" class="form-control" placeholder="End Date" name="endDate" >
                                                <div class="input-group-append">
                                                    <button class="btn btn-outline-secondary" type="button"><i class="fa fa-calendar"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <label class="form-label">Role</label>
                                            <select class="form-select select2Modal" data-placeholder="Select Role" data-minimum-results-for-search="Infinity" required
                                                    id="selectRoleAdd" style="width: 100%" name="role">
                                            </select>
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <label class="form-label">Effort rate</label>
                                            <input type="number" class="form-control" placeholder="Effort Rate" max="100" min="0" value="0" name="effoRate">
                                        </div>
                                    </div>
                                    <div class="alert alert-danger alert-dismissible" role="alert" style="margin: 10px;display: none" id="addErrorDisplay">
                                        <i class="fa fa-times-circle"></i><br>
                                    </div>
                                </div>
                                <c:if test="${addErrorMess!=null}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin: 10px;">
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                        <c:forEach items="${addErrorMess}" var="e">
                                            <i class="fa fa-times-circle"></i> ${e} <br>
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary" id="addBtn">Add</button>
                                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="largeModal" aria-hidden="false">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form action="allocation" method="post">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${modalItem.id}">
                                <div class="modal-header">
                                    <h5 class="modal-title">Update Allocation</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3 clearfix">
                                        <div class="col-md-6 col-sm-12" style="justify-content: center">
                                            <span class="form-label">Project</span>
                                            <input type="text" class="form-control" readonly disabled value="${modalItem.project.name} - ${modalItem.project.name}">
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <div style="display: flex">
                                                <img src="${modalItem.user.image}" class="rounded-circle" style="width: 60px; height: 60px; margin-right:15px " alt="user picture">
                                                <span>
                                                    <h5 class="mb-0">${modalItem.user.fullname}&nbsp;</h5>
                                                    <span>${modalItem.user.email}</span>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <label class="form-label">Start Date</label>
                                            <div class="input-group date" data-date-autoclose="true" data-provide="datepicker" data-date-format="dd/mm/yyyy">
                                                <input type="text" class="form-control" 
                                                       placeholder="Start Date" name="startDate" value="${modalItem.getStartDateString()}" disabled> 
                                            </div>
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <label class="form-label">End Date</label>
                                            <div class="input-group date" data-date-autoclose="true" data-provide="datepicker" data-date-format="dd/mm/yyyy">
                                                <input type="text"  class="form-control" 
                                                       placeholder="End Date" name="endDate" value="${modalItem.getEndDateString()}"> 
                                                <div class="input-group-append">
                                                    <button class="btn btn-outline-secondary" type="button"><i class="fa fa-calendar"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <label class="form-label">Role</label>
                                            <select class="form-select select2Modal" data-placeholder="Select Role" data-minimum-results-for-search="Infinity" required
                                                    id="selectRoleAdd" style="width: 100%" name="role">
                                                <c:forEach items="${modalItem.project.listRole}" var="r">
                                                    <option value="${r.id}" ${r.id==modalItem.role.id?'selected':''} >${r.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6 col-sm-12">
                                            <label class="form-label">Effort rate</label>
                                            <input type="number" class="form-control" placeholder="Effort Rate" max="100" min="0" value="0" name="effoRate" ${modalItem.effortRate}>
                                        </div>
                                    </div>
                                </div>
                                <c:if test="${empty modalItem.project.listRole}">
                                    <div class="alert alert-danger alert-dismissible" role="alert" style="margin: 10px" >
                                        <i class="fa fa-times-circle"></i> Cannot update this allocation because the domain for this project has not been set up with roles<br>
                                    </div>
                                </c:if>
                                <c:if test="${updateErrorMess!=null}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin: 10px;">
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                        <c:forEach items="${updateErrorMess}" var="e">
                                            <i class="fa fa-times-circle"></i> ${e} <br>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary" id="addBtn" ${empty modalItem.project.listRole?'disabled':''}>Update</button>
                                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
        <!-- core js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/sweetalert2.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/datepicker.bundle.js"></script>
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
        <c:if test="${isUpdate!=null}">
            <script>$('#showUpdateMess')[0].click();</script>
        </c:if>
        <c:if test="${isAdd!=null}">
            <script>$('#addModalBtn')[0].click();</script>
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
                $('.datepicker input').datepicker();
                $(".select2Modal").select2({
                    dropdownParent: $('#addModal .modal-content')
                });
                $("#selectMember").select2({
                    templateResult: formatOption,
                    templateSelection: formatSelection,
                    allowClear: true,
                    dropdownParent: $('#addModal .modal-content')
                });
                $("#UserFilter").select2({
                    templateResult: formatOption,
                    templateSelection: formatSelection
                });
            });


            function formatOption(option) {
                if (!option.id || option.id === "0" || option.id === "-1") {
                    return option.text;
                }
                const imageUrl = $(option.element).data('image');
                const name = $(option.element).data('name');
                const email = $(option.element).data('email');
                const $option = $(`
            <div style="display: flex; align-items: center;">
                <img src="` + imageUrl + `" alt="User Icon" style="width: 20px; height: 20px; margin-right: 8px;">
                <div>
                    <div style="font-weight: bold;">` + name + `</div>
                    <div style="font-size: 0.85em; color: gray;">` + email + `</div>
                </div>
            </div>`);
                return $option;
            }
            function formatSelection(option) {
                return $(option.element).data('name') || option.text;
            }
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
        <c:if test="${loginedUser.role==1 || loginedUser.role==5 || loginedUser.role==6}">
            <script>
                $(document).ready(function () {
                    $('#selectProject').on('change', function () {
                        var selectedvalue = $(this).val();
                        $.ajax({
                            url: "allocation",
                            type: 'post',
                            dataType: 'json',
                            data: {
                                PID: selectedvalue,
                                action: "getPrjInfor"
                            },
                            success: function (responseData) {
                                $('#addBtn').prop("disabled", false);
                                if (responseData.memberList[0].id === -1 || responseData.roleList[0].id === -1) {
                                    $('#addBtn').prop("disabled", true);
                                    $('#addErrorDisplay').css('display', 'block');
                                    $('#addErrorDisplay').find('i').text("Cannot add to this project because the domain for this project has not been set up with roles or there are no more user to add.");
                                } else {
                                    $('#addErrorDisplay').css('display', 'none');
                                }
                                $('#selectMember').empty();
                                $.each(responseData.memberList, function (index, item) {
                                    var option;
                                    if (item.id === 0 || item.id === -1) {
                                        option = $('<option>')
                                                .text(item.fullname)
                                                .val(item.id);
                                    } else {
                                        option = $('<option>')
                                                .text(item.fullname + "-" + item.email)
                                                .val(item.id) // Set the value
                                                .attr('data-image', item.image) // Set data-image attribute
                                                .attr('data-name', item.fullname) // Set data-name attribute
                                                .attr('data-email', item.email); // Set data-email attribute
                                    }
                                    $('#selectMember').append(option);
                                });
                                $('#selectRoleAdd').empty();
                                $.each(responseData.roleList, function (index, item) {
                                    $('#selectRoleAdd').append(new Option(item.name, item.id));
                                });
                            }
                        });
                    });
                    $('#selectProject').val($("#selectProject option:first").val());
                    $('#selectProject').trigger('change');
                    $('#selectMember').on('change.select2', function () {
                        const selectedValues = $('#selectMember').val(); // Get selected values
                        const allOptionValue = "0";

                        if (selectedValues && selectedValues.includes(allOptionValue)) {
                            // If "Select All" is selected, select all options except "Select All"
                            const allValuesExceptSelectAll = $('#selectMember option').map(function () {
                                return this.value !== allOptionValue ? this.value : null;
                            }).get();

                            // Set the selected values in Select2
                            $('#selectMember').val(allValuesExceptSelectAll).trigger('change');
                        }
                    });
                });
                function getModal(id) {
                    $(' #updateModal').load("${pageContext.request.contextPath}/allocation?page=${page}&modalItemID=" + id + " #updateModal > *");
                }
                ;
                function changeState(id) {
                    $.ajax({
                        url: "allocation",
                        type: 'post',
                        data: {
                            alloId: id,
                            action: "status"
                        },
                        success: function () {
                            $(' #row' + id).load("${pageContext.request.contextPath}/allocation?page=${page} #row" + id + " > *");
                        }
                    });
                }
                ;
                function deleteAllo(id) {
                    Swal.fire({
                        title: "Are you sure?",
                        text: "Do you want to delete the allocation with id = " + id + " ?",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonText: "Delete",
                        confirmButtonColor: "#FC5A69"
                    }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                            $.ajax({
                                url: "allocation",
                                type: 'post',
                                data: {
                                    alloId: id,
                                    action: "delete"
                                },
                                success: function () {
                                    Swal.fire("Deleted!", "", "success");
                                    $(' .tableBody').load("${pageContext.request.contextPath}/allocation?page=${page} .tableBody > *");
                                }
                            });
                        }
                    });
                }
                ;
            </script>
        </c:if>


    </body>
</html>
