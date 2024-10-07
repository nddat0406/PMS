
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
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link active" id="Settings-tab " href="eval" role="tab">Evaluation criteria</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Settings-tab" href="member" role="tab">Member</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link " id="Settings-tab" href="team" role="tab">Team</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="tab-content p-0" id="myTabContent">
                                        <div class="tab-pane fade active show" id="Tab2">
                                            <div class="col-lg-12 col-md-12">
                                                <div class="card">
                                                    <div class="card-header">
                                                        <h6 class="card-title">Evaluation Criteria</h6>
                                                    <c:if test="${loginedUser.role!=2}">

                                                        <ul class="header-dropdown">
                                                            <li>
                                                                <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addCriteria">Add New</button>
                                                            </li>
                                                        </ul>
                                                    </c:if>
                                                </div>
                                                <div class="card-body" id="cardbody">
                                                    <form action="eval" method="post">
                                                        <input hidden type="text" value="filter" name="action">
                                                        <div style="display: flex; justify-content: space-evenly">
                                                            <div class="input-group mb-3" style="width: 25%">
                                                                <span class="input-group-text" id="basic-addon11">Milestone</span>
                                                                <select class="form-select" aria-label="Default select example" name="milestoneFilter" id="domainFilter" onchange="ChangeFilter()">
                                                                    <option value="0" ${milestoneFilter==0?'selected':''}>All Milestone</option>
                                                                    <c:forEach items="${msList}" var="m">
                                                                        <option value="${m.id}" ${milestoneFilter==m.id?'selected':''}>${m.name}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="input-group mb-3" style="width: 25%">
                                                                <span class="input-group-text" id="basic-addon11">Status</span>
                                                                <select class="form-select" aria-label="Default select example" name="statusFilter" id="statusFilter" onchange="ChangeFilter()">
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

                                                    <table id="pro_list" class="table table-hover mb-0 justify-content-end">
                                                        <thead id="tableHead">
                                                            <tr>
                                                                <th name="id" sortBy="desc" class="sortTableHead">id&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="name" sortBy="desc" class="sortTableHead">Name&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="weight" sortBy="desc" class="sortTableHead">weight&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="milestone.name" sortBy="desc" class="sortTableHead">milestone&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                                <th>description</th>
                                                                    <c:if test="${loginedUser.role!=2}">
                                                                    <th>action</th>
                                                                    </c:if>
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
                                                                        ${i.milestone.name}
                                                                    </td>
                                                                    <td style="width: 400px">
                                                                        <div class="content-wrapper" id="contentWrapper">
                                                                            <p>
                                                                                ${i.description}
                                                                            </p>
                                                                        </div>
                                                                        <span class="read-more-btn" id="readMoreBtn">Read More</span>
                                                                    </td>
                                                                    <c:if test="${loginedUser.role!=2}">
                                                                        <td style="width: 200px">
                                                                            <a class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#updateCriteria" onclick="getModal(${i.id})"><i class="fa fa-pencil" ></i></a>
                                                                            <a href="javascript:void(0);" class="btn btn-sm btn-outline-danger" onclick="deleteStatus(${i.id})"><i class="fa fa-trash"></i></a>
                                                                        </td>
                                                                    </c:if>
                                                                    <c:if test="${loginedUser.role!=2}">
                                                                        <td style="width: 150px" class="statusCell" onclick="changeStatus(${i.id})" id="status${i.id}">
                                                                        </c:if>
                                                                        <c:if test="${loginedUser.role==2}">
                                                                        <td style="width: 150px" class="statusCell">
                                                                        </c:if>
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
                                                    <c:if test="${empty tableData}">
                                                        <div class="card-body text-center">
                                                            <h4>No result found!</h4>
                                                        </div>
                                                    </c:if>
                                                    <nav aria-label="Page navigation example">
                                                        <ul class="pagination">
                                                            <li class="page-item"><a class="page-link" href="eval?page=${page==1?1:page-1}">Previous</a></li>
                                                                <c:forEach begin="${1}" end="${num}" var="i">
                                                                <li class="page-item ${i==page?'active':''}"><a class="page-link" href="eval?page=${i}">${i}</a></li>
                                                                </c:forEach>
                                                            <li class="page-item"><a class="page-link" href="eval?page=${page!=num?page+1:page}">Next</a></li>
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

                <div class="modal fade" id="updateCriteria" tabindex="-1" aria-labelledby="updateCriteria" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form action="eval" method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="defaultModalLabel">Update Criteria</h5>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-2">
                                        <input type="text" name="action" hidden value="update">
                                        <div class="col-md-12">
                                            <label>ID:</label>
                                            <input type="text" class="form-control" placeholder="ID" name="uID" readonly value="${modalItem.id}">
                                        </div>
                                        <div class="col-md-12">
                                            <label>Name*:</label>

                                            <input type="text" class="form-control" placeholder="Name" name="uName" value="${modalItem.name}">
                                        </div>
                                        <div class="col-md-12">
                                            <label>Weight:</label>
                                            <input type="number" min="1" max="100" class="form-control" placeholder="Weight" name="uWeight" value="${modalItem.weight}">
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
                                            <textarea id="id" class="form-control" name="uDescript" rows="8" cols="60">${modalItem.description}</textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Save</button>
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="addCriteria" tabindex="-1" aria-labelledby="addCriteria" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="defaultModalLabel">Add Criteria</h5>
                            </div>
                            <form action="eval" method="post">
                                <div class="modal-body">
                                    <div class="row g-2">
                                        <input type="text" name="action" hidden value="add">
                                        <div class="col-md-6">
                                            <label>Name*:</label>
                                            <input type="text" class="form-control" placeholder="Name" name="Name" value="${oldItem.name}">
                                        </div>
                                        <div class="col-md-6">
                                            <label>Weight:</label>
                                            <input type="number" min="1" max="100" class="form-control" placeholder="Weight" name="Weight" value="${oldItem.weight}">
                                        </div>
                                        <div class="col-md-6">
                                            <label>Milestone</label>
                                            <select name="Milestone" class="form-select">
                                                <c:forEach items="${msList}" var="m">
                                                    <option value="${m.id}" ${oldItem.milestone.id==m.id?'selected':''}>${m.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-12">
                                            <label>Description:</label>
                                            <textarea id="id" class="form-control" name="Descript" rows="8" cols="60">${oldItem.description}</textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Add</button>
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
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

        <!-- page js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
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
        <c:if test="${requestScope.errorMess!=null}">
            <script>
                Swal.fire({
                    position: 'top-end',
                    icon: 'error',
                    title: '${errorMess}',
                    showConfirmButton: false,
                    timer: 1500
                });
            </script>
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
            <c:if test="${loginedUser.role!=2}">
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
                    title: "Do you want to delete criteria with id=" + id + " ?",
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
            function getModal(id) {
                $(' #updateCriteria').load("${pageContext.request.contextPath}/project/eval?page=${page}&modalItemID=" + id + " #updateCriteria > *");
            }
            ;
            </c:if>
            function changeSort(name, sortBy) {
                $.ajax({
                    url: "eval",
                    type: 'post',
                    data: {
                        sortBy: sortBy,
                        fieldName: name,
                        action: "sort"
                    },
                    success: function () {
                        $('.tableBody').load("${pageContext.request.contextPath}/project/eval?page=${page} .tableBody > *");
                    }
                });
            }
            ;
        </script>
    </body>
</html>
