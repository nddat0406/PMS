<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>My Requirements</title>
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
            .complexity-badge {
                padding: 0.25em 0.6em;
                border-radius: 0.25rem;
                font-size: 0.875em;
            }
            .complexity-low {
                background-color: #28a745;
                color: white;
            }
            .complexity-medium {
                background-color: #ffc107;
                color: black;
            }
            .complexity-high {
                background-color: #dc3545;
                color: white;
            }
        </style>
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
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> My Requirements</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Home</a></li>
                                            <li class="breadcrumb-item active">My Requirements</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-lg-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="card-title">My Requirements List</h6>
                                        </div>

                                        <!-- Filter Section -->
                                        <div class="card-body">
                                            <form action="user-requirements" method="post">
                                                <input type="hidden" name="action" value="filter">
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <span class="input-group-text">Project</span>
                                                        <select class="form-select" name="projectFilter" id="projectFilter">
                                                            <option value="0" ${projectFilter==0?'selected':''}>All Projects</option>
                                                            <c:forEach items="${projectService.getAllByUser(loginedUser.id)}" var="p">
                                                                <option value="${p.id}" ${projectFilter==p.id?'selected':''}>${p.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <span class="input-group-text">Status</span>
                                                        <select class="form-select" name="statusFilter" id="statusFilter">
                                                            <option value="-1" ${statusFilter==-1?'selected':''}>All Status</option>
                                                            <option value="0" ${statusFilter==0?'selected':''}>Pending</option>
                                                            <option value="1" ${statusFilter==1?'selected':''}>Committed</option>
                                                            <option value="2" ${statusFilter==2?'selected':''}>Analyze</option>
                                                            <option value="3" ${statusFilter==3?'selected':''}>Design</option>
                                                            <option value="4" ${statusFilter==4?'selected':''}>Accepted</option>
                                                            <option value="5" ${statusFilter==5?'selected':''}>Coded</option>
                                                            <option value="6" ${statusFilter==6?'selected':''}>Tested</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="input-group">
                                                        <input value="${searchKey}" class="form-control" name="searchKey" placeholder="Search here..." type="text">
                                                    </div>
                                                </div>
                                                <div class="col-md-1">
                                                    <button type="submit" class="btn btn-primary">Filter</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-body">
                                        <table id="requirements_list" class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Title</th>
                                                    <th>Project</th>
                                                    <th style="display: none">Details</th>
                                                    <th>Complexity</th>
                                                    <th>Status</th>
                                                    <th>Effort (h)</th>
                                                </tr>
                                            </thead>
                                            <tbody class="tableBody">
                                                <c:forEach items="${tableData}" var="req">
                                                    <tr>
                                                        <td>${req.id}</td>
                                                        <td>${req.title}</td>
                                                        <td>${projectService.getProjectById(req.projectId).name}</td>
                                                        <td style="display: none">
                                                            <div class="content-wrapper">
                                                                <p>${req.details}</p>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="complexity-badge complexity-${req.complexity.toLowerCase()}">${req.complexity}</span>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-${
                                                                  req.status == 0 ? 'secondary' : 
                                                                      req.status == 1 ? 'primary' : 
                                                                      req.status == 2 ? 'info' : 
                                                                      req.status == 3 ? 'warning' :
                                                                      req.status == 4 ? 'success' :
                                                                      req.status == 5 ? 'dark' : 'danger'}">
                                                                      ${req.status == 0 ? 'Pending' : 
                                                                        req.status == 1 ? 'Committed' : 
                                                                        req.status == 2 ? 'Analyze' : 
                                                                        req.status == 3 ? 'Design' :
                                                                        req.status == 4 ? 'Accepted' :
                                                                        req.status == 5 ? 'Coded' : 'Tested'}
                                                                  </span>
                                                            </td>
                                                            <td>${req.estimatedEffort}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>

                                            <!-- No Results Message -->
                                            <c:if test="${empty tableData}">
                                                <div class="card-body text-center">
                                                    <h4>No requirements found!</h4>
                                                </div>
                                            </c:if>

                                            <!-- Pagination -->
                                            <!-- Pagination -->
                                            <nav aria-label="Page navigation" class="mt-3">
                                                <ul class="pagination justify-content-center">
                                                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/user-requirements?page=${page-1}">Previous</a>
                                                    </li>
                                                    <c:forEach begin="1" end="${num}" var="i">
                                                        <li class="page-item ${i == page ? 'active' : ''}">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/user-requirements?page=${i}">${i}</a>
                                                        </li>
                                                    </c:forEach>
                                                    <li class="page-item ${page == num ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/user-requirements?page=${page+1}">Next</a>
                                                    </li>
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

            <!-- Scripts -->
            <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
            <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

            <script>
                // Filter change handler
                function ChangeFilter() {
                    var complexityFilter = document.getElementById("complexityFilter").value;
                    var projectFilter = document.getElementById("projectFilter").value;
                    var statusFilter = document.getElementById("statusFilter").value;

                    $.ajax({
                        url: "user-requirements",
                        type: 'post',
                        data: {
                            complexityFilter: complexityFilter,
                            projectFilter: projectFilter,
                            statusFilter: statusFilter,
                            action: "filter"
                        },
                        success: function () {
                            $('.tableBody').load("${pageContext.request.contextPath}/user-requirements?page=${page} .tableBody > *");
                        }
                    });
                }

                // Show more/less for details
                $(document).on('click', '.content-wrapper', function () {
                    $(this).toggleClass('expanded');
                });
            </script>
        </body>
    </html>