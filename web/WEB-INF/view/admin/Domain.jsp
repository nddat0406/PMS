<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Domain</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">
        <link rel="icon" href="favicon.ico" type="image/x-icon">

        <!-- Load jQuery CDN đầu tiên để đảm bảo nó có sẵn trước khi chạy các đoạn mã khác -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <!-- Font Awesome CDN nếu sử dụng các biểu tượng -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha384-k6RqeWeci5ZR/Lv4MR0sA0FfDOMXpsrBmXX3obE5IB6Te93H3mYk5Cv6Nh4lh5EZ" crossorigin="anonymous">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dataTables.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>
    <style>
        .Domain-actions {
            text-align: center;
        }

        .Domain-actions form {
            display: inline-block;
            margin-right: 5px;
        }

        .Domain-actions .btn {
            display: inline-block;
            margin-bottom: 0;
        }
        .action-bar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 10px;
        }

        .action-bar .btn {
            background-color: #1f8eed;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .action-bar .btn:hover {
            background-color: #0f7dd4;
        }
    </style>
    <body>

        <div id="layout" class="theme-cyan">
            <jsp:include page="../common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">
                <jsp:include page="../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../common/sidebar.jsp"></jsp:include>

                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i>
                                            </a> Domain
                                        </h2>
                                        <ul class="breadcrumb mb-0"></ul>
                                    </div>
                                </div>
                            </div>

                            <div class="row clearfix">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-4">
                                        <div class="action-bar">
                                        <c:if test="${loginedUser.role==1}">
                                            <form action="domain?action=add" method="get">
                                                <input type="hidden" name="action" value="add">
                                                <button type="submit" class="btn btn-outline-secondary">Add New</button>
                                            </form>
                                        </c:if>
                                    </div>

                                    <form method="get" action="domain">
                                        <input type="hidden" name="action" value="filter">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <select name="status" class="form-control">
                                                    <option value="">Status</option>
                                                    <option value="1" ${filterStatus == 1 ? 'selected' : ''}>Active</option>
                                                    <option value="0" ${filterStatus == 0 ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="submit" class="btn btn-primary">Filter</button>
                                            </div>
                                        </div>
                                    </form>

                                    <div class="card-body">
                                        <form id="navbar-search" class="navbar-form search-form position-relative d-none d-md-block" method="get" action="domain">
                                            <input type="hidden" name="action" value="search">
                                            <input name="keyword" class="form-control" placeholder="Search here..." type="text" >
                                            <button type="submit" class="btn btn-secondary">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </form>

                                        <table id="Domain" class="table table-hover">
                                            <thead id="tableHead">
                                                <tr>
                                                    <th name="domain.id" sortBy="asc" class="sortTableHead">Id&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="domain.name" sortBy="asc" class="sortTableHead">Name&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="domain.code" sortBy="asc" class="sortTableHead">Code&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                    <th name="domain.status" sortBy="asc" class="sortTableHead">Status&nbsp;<i class="fa fa-sort sort-icon"></i></th>
                                                    <th>Action</th>
                                                    <th>Detail</th>
                                                </tr>
                                            </thead>
                                            <tbody class="tableBody">
                                                <c:forEach items="${listD}" var="d">
                                                    <tr>
                                                        <td>${d.id}</td>
                                                        <td class="project-title">
                                                            <h6 class="fs-6 mb-0">${d.code}</h6>
                                                        </td>
                                                        <td>${d.name}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${d.status == '1'}">
                                                                    <span>Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span>Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <c:if test="${loginedUser.role==1}">
                                                            <td class="Domain-actions">
                                                                <div class="btn-group">
                                                                    <form action="domain?action=edit" method="get" style="display: inline-block;">
                                                                        <input type="hidden" name="action" value="edit">
                                                                        <input type="hidden" name="id" value="${d.id}">
                                                                        <button type="submit" class="btn btn-sm btn-outline-success">
                                                                            <i class="fa fa-edit"></i> 
                                                                        </button>
                                                                    </form>
                                                                    <form action="domain?action=update" method="post" style="display: inline-block;">
                                                                        <input type="hidden" name="id" value="${d.id}">
                                                                        <input type="hidden" name="status" value="${d.status == 1 ? 0 : 1}">
                                                                        <button type="submit" class="btn btn-sm ${d.status == 1 ? 'btn-outline-danger' : 'btn-outline-primary'}">
                                                                            <i class="fa ${d.status == 1 ? 'fa-times' : 'fa-check'}"></i> 
                                                                            ${d.status == 1 ? 'Inactive' : 'Active'}
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </td>
                                                        </c:if>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/domain?domainId=${d.id}" class="btn" >
                                                                <strong>Domain Configs</strong>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>

                                        <nav aria-label="Page navigation example">
                                            <ul class="pagination">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="?action=list&page=${currentPage - 1}&status=${filterStatus}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                                <li class="page-item active"><a class="page-link">${currentPage}</a></li>
                                                <li class="page-item">
                                                    <a class="page-link" href="?action=list&page=${currentPage + 1}&status=${filterStatus}" aria-label="Next">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
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
        <script>
            $(document).ready(function () {
                function sortTable(columnIndex, order) {
                    var rows = $('.tableBody tr').get();

                    rows.sort(function (a, b) {
                        var A = $(a).children('td').eq(columnIndex).text().toUpperCase();
                        var B = $(b).children('td').eq(columnIndex).text().toUpperCase();

                        if (A < B)
                            return order === 'asc' ? -1 : 1;
                        if (A > B)
                            return order === 'asc' ? 1 : -1;
                        return 0;
                    });

                    $.each(rows, function (index, row) {
                        $('.tableBody').append(row);
                    });
                }

                $('.sortTableHead').on('click', function () {
                    var $th = $(this);
                    var columnIndex = $th.index();
                    var sortBy = $th.attr('sortBy');

                    sortTable(columnIndex, sortBy);

                    $('.sortTableHead .sort-icon').removeClass('fa-sort-up fa-sort-down').addClass('fa-sort');
                    if (sortBy === 'asc') {
                        sortBy = 'desc';
                        $th.find('.sort-icon').removeClass('fa-sort fa-sort-up').addClass('fa-sort-down');
                    } else {
                        sortBy = 'asc';
                        $th.find('.sort-icon').removeClass('fa-sort fa-sort-down').addClass('fa-sort-up');
                    }
                    $th.attr('sortBy', sortBy);
                });
            });
        </script>

        <!-- core js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
    </body>
</html>
