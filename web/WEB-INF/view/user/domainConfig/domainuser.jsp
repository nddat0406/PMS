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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sweetalert2.min.css">

        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>

    <body>

        <div id="layout" class="theme-cyan">
            <!-- Page Loader -->
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>

                <div id="wrapper">
                    <!-- Top navbar -->
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>

                    <!-- Sidebar menu -->
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>

                    <div id="main-content" class="profilepage_2 blog-page">
                        <div class="container-fluid">

                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                                <i class="fa fa-arrow-left"></i></a> User Profile
                                        </h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Lucid</a></li>
                                            <li class="breadcrumb-item active">Domain Configs</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                        <c:set var="baseUrl" value="${pageContext.request.contextPath}" />
                                        <ul class="nav nav-tabs" id="myTab" role="tablist">
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link " id="Overview-tab" href="${baseUrl}/domain/domainsetting?action=domainSetting" role="tab">Domain Settings</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link " id="Evaluation-tab" href="${baseUrl}/domain/domaineval" role="tab">Evaluation Criteria</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link active" id="DomainUsers-tab" href="${baseUrl}/domain/domainuser" role="tab">Domain Users</a>
                                            </li>
                                            <li class="nav-item" role="presentation" style="width: 150px">
                                                <a class="nav-link" id="ProjectPhase-tab" href="${pageContext.request.contextPath}/phaselist" role="tab">Project Phase</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <div class="tab-content p-0" id="myTabContent">
                                            <div class="d-flex row justify-content-end mb-2">
                                                <div class="col-lg-4">
                                                    <button type="button" value="export" onclick="exportToExel()" class="btn btn-primary">
                                                        <i class="fas fa-file-excel"></i> Export to Excel
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="tab-pane fade active show" id="Tab1">
                                                <div class="col-md-12"  style="display: flex; justify-content: right">
                                                    <a href="${baseUrl}/domain/domainuser?action=add" type="submit" class="btn btn-success">Add new</a>
                                                </div>
                                                <table id="domainSettingsTable" class="table table-bordered table-striped">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Username</th>
                                                            <th>Email</th>
                                                            <th>Phone</th>

                                                            <th>Status</th>
                                                            <th>Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="user" items="${domainUsers}">
                                                            <tr>
                                                                <td>${user.id}</td>
                                                                <td>${user.user.fullname==null?'Deactivated User':user.user.fullname}</td>
                                                                <td>${user.user.email==null?'Deactivated User':user.user.fullname}</td>
                                                                <td>${user.user.mobile==null?'Deactivated User':user.user.fullname}</td>

                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${user.status == 1}">Active</c:when>
                                                                        <c:when test="${user.status == 0}">Inactive</c:when>
                                                                        <c:otherwise>Unknown</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <a href="${baseUrl}/domain/domainuser?action=edit&id=${user.id}" type="submit" class="btn btn-warning">Detail</a>
                                                                    |

                                                                    <a href="${baseUrl}/domain/domainuser?action=deactive&id=${user.id}" type="submit" class="btn btn-danger">Deactive</a>
                                                                    |
                                                                    <a href="${baseUrl}/domain/domainuser?action=active&id=${user.id}" type="submit" class="btn btn-danger">Active</a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>

                                            </div>
                                        </div>
                                    </div>                            
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <nav aria-label="Page navigation example">
                <ul class="pagination">
                    <li class="page-item"><a class="page-link" href="domainuser?page=${page==1?1:page-1}">Previous</a></li>
                        <c:forEach begin="${1}" end="${num}" var="i">
                        <li class="page-item ${i==page?'active':''}"><a class="page-link" href="domainuser?page=${i}">${i}</a></li>
                        </c:forEach>
                    <li class="page-item"><a class="page-link" href="domainuser?page=${page!=num?page+1:page}">Next</a></li>
                </ul>
            </nav>
        </div>

        <!-- JS file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/sweetalert2.bundle.js"></script>        

        <!-- Page JS file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

        <script>
                                                        $(document).ready(function () {
                                                            $('#domainSettingsTable').DataTable({
                                                                "paging": true,
                                                                "lengthChange": true,
                                                                "searching": true,
                                                                "ordering": true,
                                                                "info": true,
                                                                "autoWidth": false
                                                            });
                                                        });
                                                        function exportToExel() {
                                                            $.ajax({
                                                                type: "POST",
                                                                url: "${pageContext.request.contextPath}/domain", // URL của Servlet
                                                                data: {action: "export"}, // Gửi action là "export"
                                                                xhrFields: {
                                                                    responseType: 'blob' // Đặt response là blob để nhận file
                                                                },
                                                                success: function (data, status, xhr) {
                                                                    var filename = "domain_users.xlsx"; // Tên file tải về
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
        </script>
    </body>
</html>
