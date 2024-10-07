<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Project Milestone</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <style>
            .content-wrapper {
                max-height: 50px;
                overflow: hidden;
                transition: max-height 0.4s ease-in-out;
                position: relative;
            }
            .content-wrapper.expanded {
                max-height: 1000px;
            }
            .read-more-btn {
                display: inline-block;
                color: #008ce6;
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
        <script>
            function changeSort(name, sortBy) {
                $.ajax({
                    url: "milestone",
                    type: 'post',
                    data: {
                        sortBy: sortBy,
                        fieldName: name,
                        action: "sort"
                    },
                    success: function () {
                        $('.tableBody').load("${pageContext.request.contextPath}/project/milestone?page=${page} .tableBody > *");
                    }
                });
            };
        </script>
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>
                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Project Milestones</h2>
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
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link active" id="Overview-tab" href="milestone" role="tab">Milestone</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link" id="Settings-tab" href="eval" role="tab">Evaluation criteria</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link" id="Settings-tab" href="member" role="tab">Member</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link" id="Settings-tab" href="team" role="tab">Team</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="tab-content p-0" id="myTabContent">
                                        <div class="tab-pane fade active show" id="Tab1">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="card-title">Project Milestones</h6>
                                                </div>
                                                <div class="card-body">
                                                    <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                                                        <div class="input-group" style="width: 30%">
                                                            <span class="input-group-text">Priority</span>
                                                            <select class="form-select" id="priorityFilter">
                                                                <option value="0">All Priority</option>
                                                                <option value="1">Low</option>
                                                                <option value="2">Medium</option>
                                                                <option value="3">High</option>
                                                            </select>
                                                        </div>
                                                        <div class="input-group" style="width: 30%">
                                                            <span class="input-group-text">Status</span>
                                                            <select class="form-select" id="statusFilter">
                                                                <option value="all">All Status</option>
                                                                <option value="true">Active</option>
                                                                <option value="false">Inactive</option>
                                                            </select>
                                                        </div>
                                                        <div class="input-group" style="width: 30%">
                                                            <input type="text" class="form-control" id="searchInput" placeholder="Search here...">
                                                            <button class="btn btn-secondary" type="button" onclick="applyFilters()"><i class="fa fa-search"></i></button>
                                                        </div>
                                                    </div>

                                                    <table id="milestone_list" class="table table-hover mb-0">
                                                        <thead>
                                                            <tr>
                                                                <th name="id" sortBy="desc" class="sortTableHead">ID <i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="name" sortBy="desc" class="sortTableHead">Name <i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="priority" sortBy="desc" class="sortTableHead">Priority <i class="fa fa-sort sort-icon"></i></th>
                                                                <th name="endDate" sortBy="desc" class="sortTableHead">End Date <i class="fa fa-sort sort-icon"></i></th>
                                                                <th>Details</th>
                                                                <th name="status" sortBy="desc" class="sortTableHead">Status <i class="fa fa-sort sort-icon"></i></th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody class="tableBody">
                                                        <c:forEach items="${tableData}" var="milestone">
                                                            <tr>
                                                                <td>${milestone.id}</td>
                                                                <td>${milestone.name}</td>
                                                                <td>${milestone.priority}</td>
                                                                <td>${milestone.endDate}</td>
                                                                <td>
                                                                    <div class="content-wrapper">
                                                                        <p>${milestone.details}</p>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${milestone.status}">
                                                                            <span class="badge bg-success">Active</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-secondary">Inactive</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <button class="btn btn-sm btn-outline-secondary view-details">
                                                                        <i class="fa fa-eye"></i> View Details
                                                                    </button>
                                                                    <!--<a href="javascript:void(0);" class="btn btn-sm btn-outline-success"><i class="fa fa-edit"></i></a>-->
                                                                    <!--<a href="javascript:void(0);" class="btn btn-sm btn-outline-danger"><i class="fa fa-trash"></i></a>-->
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
                                                <nav aria-label="Page navigation">
                                                    <ul class="pagination mt-3">
                                                        <li class="page-item"><a class="page-link" href="milestone?page=${page==1?1:page-1}">Previous</a></li>
                                                            <c:forEach begin="1" end="${num}" var="i">
                                                            <li class="page-item ${i==page?'active':''}"><a class="page-link" href="milestone?page=${i}">${i}</a></li>
                                                            </c:forEach>
                                                        <li class="page-item"><a class="page-link" href="milestone?page=${page==num?num:page+1}">Next</a></li>
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

        <div class="modal fade" id="milestoneDetailModal" tabindex="-1" aria-labelledby="milestoneDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="milestoneDetailModalLabel">Milestone Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="milestoneForm" action="${pageContext.request.contextPath}/project/milestone" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="mileStoneId" value="" id="modalMilestoneId">
                            <div class="mb-3">
                                <label for="milestoneName" class="form-label">Name</label>
                                <input type="text" class="form-control" name="milestoneName" id="modalMilestoneName" required>
                            </div>

                            <div class="mb-3">
                                <label for="milestonePriority" class="form-label">Priority</label>
                                <select class="form-select" name="milestonePriority" id="modalMilestonePriority">
                                    <option value="1">1 - Low</option>
                                    <option value="2">2 - Medium</option>
                                    <option value="3">3 - High</option>
                                    <option value="4">4 - Critical</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="milestoneEndDate" class="form-label">End Date</label>
                                <input type="date" name="milestoneEndDate" class="form-control" id="modalMilestoneEndDate" required>
                            </div>

                            <div class="mb-3">
                                <label for="milestoneStatus" class="form-label">Status</label>
                                <select class="form-select" id="modalMilestoneStatus" name="milestoneStatus">
                                    <option value="1">Active</option>
                                    <option value="0">Deactive</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="milestoneDetails" class="form-label">Details</label>
                                <textarea name="milestoneDetails" class="form-control" id="modalMilestoneDetails" rows="3"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-secondary" onclick="document.querySelector('#milestoneForm').submit();">Save changes</button> 
                    </div>

                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
        <script>
                            $(document).ready(function () {
                                $('.view-details').on('click', function () {
                                    var row = $(this).closest('tr');
                                    var id = row.find('td:eq(0)').text();
                                    var name = row.find('td:eq(1)').text();
                                    var priority = row.find('td:eq(2)').text();
                                    var endDate = row.find('td:eq(3)').text();
                                    var status = row.find('td:eq(5) .badge').text().trim().toLowerCase() === 'active' ? 1 : 0;
                                    var details = row.find('td:eq(4)').text() || 'No details available';
                                    console.log(id);
                                    // Đổ dữ liệu vào modal
                                    $('#modalMilestoneId').val(id);
                                    $('#modalMilestoneName').val(name);
                                    $('#modalMilestonePriority').val(priority);
                                    $('#modalMilestoneEndDate').val(endDate);
                                    $('#modalMilestoneStatus').val(status);
                                    $('#modalMilestoneDetails').val(details.trim());

                                    $('#milestoneDetailModal').modal('show');
                                });

                            });

        </script>
    </body>
</html>