
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
            .accordion-body div:first-child{
                margin: 10px 60px;
            }
            td:first-child {
                border-top-left-radius: 20px;
                border-bottom-left-radius: 20px;
            }
            td:last-child {
                border-top-right-radius: 20px;
                border-bottom-right-radius: 20px;
            }
            td div{
                padding-bottom: 8px;
            }
            td div img{
                margin-right: 25px
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
                                                            <div class="input-group mb-3" style="width: 15%">
                                                                <input value="${searchKey.trim()}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                                <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                    <div class="accordion" id="accordionExample">
                                                        <c:forEach items="${tableData}" var="i">
                                                            <div class="justify-content-center" style=" display: flex;justify-content: center" id="accordionCont${i.id}">
                                                                <div class="accordion-item col-lg-10 col-md-10">
                                                                    <h2 class="accordion-header" id="heading${i.id}">
                                                                        <div class="accordion-button align-content-around collapsed" data-bs-toggle="collapse" data-bs-target="#collapse${i.id}" aria-expanded="true" aria-controls="collapse${i.id}">
                                                                            <table>
                                                                                <tr>
                                                                                    <td style="width: 100px">                                                                            
                                                                                        <span><h4>${i.name}</h4></span>
                                                                                    </td>
                                                                                    <td style="width: 300px">
                                                                                        <span> <h5>(${i.getTeamSize()} Members)</h5></span>
                                                                                    </td>
                                                                                    <td style="width: 300px">
                                                                                        <span><h6>Topic: ${i.topic}</h6></span>
                                                                                    </td>
                                                                                    <td style="width: 300px">
                                                                                        <span><h6>Milestone: ${i.milestone.name}</h6></span>
                                                                                    </td>
                                                                                    <c:if test="${loginedUser.role!=2}">
                                                                                        <td  style="width: 200px">
                                                                                            <a class="btn btn-sm btn-outline-success stop-toggle" data-bs-toggle="modal" data-bs-target="#updateTeam" 
                                                                                               onclick="getModal(${i.id})"><i class="fa fa-pencil" ></i></a>
                                                                                            <a class="btn btn-sm btn-outline-danger stop-toggle" 
                                                                                               onclick="deleteTeam(${i.id}, '${i.name}')"><i class="fa fa-trash"></i></a>
                                                                                        </td>
                                                                                    </c:if>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </h2>
                                                                    <div id="collapse${i.id}" class="accordion-collapse collapse" aria-labelledby="heading${i.id}" data-bs-parent="#accordionExample">
                                                                        <div  class="card-header" style="padding: 10px 10px 0px 15px">
                                                                            <h6 >Team members:</h6>
                                                                            <c:if test="${loginedUser.role!=2}">
                                                                                <ul class="header-dropdown list-unstyled">
                                                                                    <li>
                                                                                        <button style="margin-top: 20px" type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#addMember" 
                                                                                                onclick="getAddMemberList(${i.id})">Add New Member</button>
                                                                                    </li>
                                                                                </ul>
                                                                            </c:if>
                                                                        </div>
                                                                        <div class="accordion-body">
                                                                            <div>
                                                                                <table class="table table-hover" id="memberTable${i.id}">
                                                                                    <tbody>
                                                                                        <c:if test="${i.teamLeader!=null}">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <div style="display: flex">
                                                                                                        <img src="${i.teamLeader.image}" class="rounded-circle" style="width: 50px; height: 50px" alt="user picture">
                                                                                                        <span>
                                                                                                            <h5 class="mb-0">${i.teamLeader.getStatus()==0?"Deactivated User":i.teamLeader.fullname}&nbsp;<svg class="starIcon" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="StarsIcon"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm4.24 16L12 15.45 7.77 18l1.12-4.81-3.73-3.23 4.92-.42L12 5l1.92 4.53 4.92.42-3.73 3.23L16.23 18z"></path></svg>
                                                                                                            </h5>
                                                                                                            <span>${i.teamLeader.email}</span>
                                                                                                        </span>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <c:if test="${loginedUser.role!=2}">
                                                                                                    <td style="width: 200px">
                                                                                                        <a class="btn btn-sm btn-outline-danger" onclick="deleteMember(${i.id},${i.teamLeader.id}, '${i.teamLeader.getStatus()==0?"Deactivated User":i.teamLeader.fullname}', '${i.name}')"><i class="fa fa-trash"></i></a>
                                                                                                    </td>
                                                                                                </c:if>
                                                                                            </tr>
                                                                                        </c:if>
                                                                                        <c:forEach items="${i.members}" var="m">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <div style="display: flex">
                                                                                                        <img src="${m.image}" class="rounded-circle" style="width: 50px; height: 50px" alt="user picture">
                                                                                                        <span>
                                                                                                            <h5 class="mb-0">${m.getStatus()==0?"Deactivated User":m.fullname}&nbsp;
                                                                                                            </h5>
                                                                                                            <span>${m.email}</span></span>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <c:if test="${loginedUser.role!=2}">
                                                                                                    <td style="width: 200px">
                                                                                                        <a class="btn btn-sm btn-outline-success" 
                                                                                                           onclick="ChangeRole(${i.id},${m.id}, '${m.getStatus()==0?"Deactivated User":m.fullname}', '${i.name}')"><i class="fa fa-pencil" ></i></a>
                                                                                                        <a class="btn btn-sm btn-outline-danger" 
                                                                                                           onclick="deleteMember(${i.id},${m.id}, '${m.getStatus()==0?"Deactivated User":m.fullname}', '${i.name}')"><i class="fa fa-trash"></i></a>
                                                                                                    </td>
                                                                                                </c:if>
                                                                                            </tr>
                                                                                        </c:forEach>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>

                                                                            <div>
                                                                                <P>
                                                                                    <button class="btn btn-primary collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDes${i.id}" aria-expanded="false" aria-controls="collapseDes${i.id}">
                                                                                        Description
                                                                                    </button>
                                                                                </P>
                                                                                <div class="collapse" id="collapseDes${i.id}" style="width: 800px">
                                                                                    <div class="card card-body">
                                                                                        ${i.details}
                                                                                    </div>
                                                                                </div>
                                                                            </div>
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
            <c:if test="${loginedUser.role!=2}">
                <div class="modal fade" id="updateTeam" tabindex="-1" aria-labelledby="updateTeam" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form action="team" method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="defaultModalLabel">Update Criteria</h5>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-2">
                                        <input type="text" name="action" hidden value="update">
                                        <input type="text" name="uID" hidden value="${modalItem.id}">
                                        <div class="col-md-6">
                                            <label>Name*:</label>
                                            <input type="text" class="form-control" placeholder="Name" name="uName" value="${modalItem.name}">
                                        </div>
                                        <div class="col-md-6">
                                            <label>Milestone</label>
                                            <select name="uMilestone" class="form-select">
                                                <c:forEach items="${msList}" var="m">
                                                    <option value="${m.id}" ${modalItem.milestone.id==m.id?'selected':''}>${m.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-12">
                                            <label>Topic:</label>
                                            <input type="text" class="form-control" placeholder="Topic" name="uTopic" value="${modalItem.topic}">
                                        </div>
                                        <div class="col-md-12">
                                            <textarea class="form-control" name="uDescription" rows="8" cols="60">${modalItem.details}</textarea>
                                        </div>
                                    </div>
                                    <c:if test="${UpdateErrorMess!=null}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            <i class="fa fa-times-circle"></i>${UpdateErrorMess}<br>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Save</button>
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="addTeam" tabindex="-1" aria-labelledby="addTeam" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="defaultModalLabel">Add Team</h5>
                            </div>
                            <form action="team" method="post">
                                <div class="modal-body">
                                    <div class="row g-2">
                                        <input type="text" name="action" hidden value="add">
                                        <div class="col-md-6">
                                            <label>Name*:</label>
                                            <input type="text" class="form-control" placeholder="Name" name="Name" value="${oldAddItem.name}">
                                        </div>
                                        <div class="col-md-6">
                                            <label>Milestone</label>
                                            <select name="Milestone" class="form-select">
                                                <c:forEach items="${msList}" var="m">
                                                    <option value="${m.id}" ${oldAddItem.milestone.id==m.id?'selected':''}>${m.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-12">
                                            <label>Topic:</label>
                                            <input type="text" class="form-control" placeholder="Topic" name="Topic" value="${oldAddItem.topic}">
                                        </div>
                                        <div class="col-md-12">
                                            <label>Description:</label>
                                            <textarea class="form-control" name="Description" rows="8" cols="60">${oldAddItem.details}</textarea>
                                        </div>
                                    </div>
                                    <c:if test="${AddErrorMess!=null}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            <i class="fa fa-times-circle"></i> ${AddErrorMess} <br>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Add</button>
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
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
                                                        <input class="select-all" type="checkbox" name="checkbox">
                                                        <span></span>
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
            });

            <c:if test="${loginedUser.role!=2}">
            function addMembers() {
                // Get all selected checkbox values
                var selectedOptions = [];
                $('input[name="addMembers"]:checked').each(function () {
                    selectedOptions.push(this.value);
                });
                var tId = $('#teamAddMember').val();
                var json = JSON.stringify(selectedOptions);
                $('#closeModalBtn').click();
                $.ajax({
                    url: "team",
                    type: 'post',
                    data: {
                        json: json,
                        teamId: tId,
                        action: "addMember"
                    },
                    success: function () {
                        Swal.fire("Added!", "", "success");
                        $(' #memberTable' + tId).load("${pageContext.request.contextPath}/project/team?page=${page} #memberTable" + tId + " > *");
                    }
                });
            }
            ;
            function ChangeRole(tId, mId, name, tname) {
                Swal.fire({
                    title: "Are you sure?",
                    text: "Do you want to make " + name + " to be leader of " + tname + " team ?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "Confirm",
                    confirmButtonColor: "#04AA6D"
                }).then((result) => {
                    /* Read more about isConfirmed, isDenied below */
                    if (result.isConfirmed) {
                        $.ajax({
                            url: "team",
                            type: 'post',
                            data: {
                                memberId: mId,
                                teamId: tId,
                                action: "changeRole"
                            },
                            success: function () {
                                Swal.fire("Changed!", "", "success");
                                $(' #memberTable' + tId).load("${pageContext.request.contextPath}/project/team?page=${page} #memberTable" + tId + " > *");
                            }
                        });
                    }
                });
            }
            ;
            function deleteMember(tId, mId, name, tname) {
                Swal.fire({
                    title: "Are you sure?",
                    text: "Do you want to delete " + name + " from " + tname + " team ?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "Delete",
                    confirmButtonColor: "#FC5A69"
                }).then((result) => {
                    /* Read more about isConfirmed, isDenied below */
                    if (result.isConfirmed) {
                        $.ajax({
                            url: "team",
                            type: 'post',
                            data: {
                                memberId: mId,
                                teamId: tId,
                                action: "deleteMember"
                            },
                            success: function () {
                                Swal.fire("Deleted!", "", "success");
                                $(' #memberTable' + tId).load("${pageContext.request.contextPath}/project/team?page=${page} #memberTable" + tId + " > *");
                            }
                        });
                    }
                });
            }
            ;
            function deleteTeam(id, name) {
                event.stopPropagation();
                Swal.fire({
                    title: "Are you sure?",
                    text: "Do you want to delete the " + name + " team ?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "Delete",
                    confirmButtonColor: "#FC5A69"
                }).then((result) => {
                    /* Read more about isConfirmed, isDenied below */
                    if (result.isConfirmed) {
                        $.ajax({
                            url: "team",
                            type: 'post',
                            data: {
                                teamId: id,
                                action: "delete"
                            },
                            success: function () {
                                Swal.fire("Deleted!", "", "success");
                                $(' #accordionExample').load("${pageContext.request.contextPath}/project/team?page=${page} #accordionExample > *");
                            }
                        });
                    }
                });
            }
            ;
            function getModal(id) {
                $(' #updateTeam').load("${pageContext.request.contextPath}/project/team?page=${page}&modalItemID=" + id + " #updateTeam > *");
            }
            ;
            function getAddMemberList(id) {
                $(' #teamAddMember').val(id);
                console.log(id);
                $(' #tableAddBody').load("${pageContext.request.contextPath}/project/team?page=${page}&teamAddId=" + id + " #tableAddBody > *");
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
