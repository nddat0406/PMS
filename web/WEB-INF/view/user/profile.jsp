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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/datepicker.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dropify.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sweetalert2.min.css">
        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

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
                                            <li class="breadcrumb-item"><a href="index.html">Lucid</a></li>
                                            <li class="breadcrumb-item">Pages</li>
                                            <li class="breadcrumb-item active">User Profile</li>
                                        </ul>
                                    </div>

                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                <li class="nav-item" role="presentation"><a class="nav-link ${isSetting==null?'active':''}" id="Overview-tab" data-bs-toggle="tab" href="#Overview" role="tab">Overview</a></li>
                                            <li class="nav-item" role="presentation"><a class="nav-link ${isSetting==null?'':'active'}" id="Settings-tab" data-bs-toggle="tab" href="#Settings" role="tab">Settings</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="tab-content p-0" id="myTabContent">
                                    <div class="tab-pane fade  ${isSetting==null?'show active':''}" id="Overview">
                                        <div class="card mb-3 profile-header">
                                            <div class="card-body text-center">
                                                <div class="profile-image mb-3"><img src="${profile.image}" class="rounded-circle" alt="" style="height: 150px;width: 150px"> </div>
                                                <div>
                                                    <h4 class=""><strong>${profile.fullname}</strong></h4>
                                                    <span>${sessionScope.role}</span>
                                                </div>

                                            </div>
                                        </div>
                                        <div class="card mb-3">
                                            <div class="card-header">
                                                <h6 class="card-title">Info</h6>

                                            </div>
                                            <div class="card-body">
                                                <small class="text-muted">Address: </small>
                                                <p>${profile.address}</p>

                                                <hr>
                                                <small class="text-muted">Email address: </small>
                                                <p>${profile.email}</p>
                                                <hr>
                                                <small class="text-muted">Mobile: </small>
                                                <p>${profile.mobile}</p>
                                                <hr>
                                                <small class="text-muted">Birth Date: </small>
                                                <p>${profile.getBirthdateString()}</p>
                                                <hr>
                                                <small class="text-muted">Working Department </small>
                                                <p class="">${profile.department.name}</p>
                                                <hr>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade ${isSetting==null?'':'show active'}" id="Settings">
                                        <div class="row justify-content-center">
                                            <div class="card mb-3 col-7 ">
                                                <div class="card-body">
                                                    <form action="profile" method="post" enctype="multipart/form-data">
                                                        <h6 class="card-title">Basic Information</h6>
                                                        <div class="row" style="margin-top: 10px">
                                                            <div class="col-lg-12 col-md-12">
                                                                <div class="mb-3">
                                                                    <label>Fullname*: </label>
                                                                    <input type="text" class="form-control" required name="fullname" placeholder="Full Name" value="${profile.fullname}">
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label>Email*: </label>
                                                                    <input type="email" class="form-control" required name="email" placeholder="Email" value="${profile.email}">
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label>Gender*: </label>
                                                                    <div>
                                                                        <label class="fancy-radio">
                                                                            <input name="gender" value="male" type="radio" ${profile.gender?'checked':''}>
                                                                            <span><i></i>Male</span>
                                                                        </label>
                                                                        <label class="fancy-radio">
                                                                            <input name="gender" value="female" type="radio" ${profile.gender?'':'checked'}>
                                                                            <span><i></i>Female</span>
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label>Address: </label>
                                                                    <input type="text" class="form-control" name="address"
                                                                           placeholder="Address" value="${profile.address}">
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label>Phone Number: </label>
                                                                    <input type="text" class="form-control" name="mobile"
                                                                           placeholder="Phone Number" value="${profile.mobile}">
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label">Birth Date:</label>
                                                                    <div class="input-group date" data-date-autoclose="true" data-provide="datepicker">
                                                                        <input type="text" name="birthdate"  class="form-control" value="${profile.getBirthdateString()}"/>
                                                                        <div class="input-group-append">
                                                                            <button class="btn btn-outline-secondary" type="button"><i class="fa fa-calendar"></i></button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <div class="card">
                                                                        <div class="card-header">
                                                                            <h6 class="card-title">Profile Image</h6>
                                                                            <small class="d-block">try to upload png, jpeg and jpg only</small>
                                                                        </div>
                                                                        <div class="card-body">
                                                                            <input type="file" class="dropify" name="image" data-allowed-file-extensions="png jpeg jpg" />
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <c:if test="${error != null}">
                                                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                                                    <c:forEach items="${error}" var="e">
                                                                        <i class="fa fa-times-circle"></i> ${e} <br>
                                                                    </c:forEach>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        <button type="submit" class="btn btn-primary">Update</button> &nbsp;&nbsp;
                                                        <button type="reset" class="btn btn-secondary">Cancel</button>
                                                    </form>
                                                </div>
                                            </div>
                                            <!-- account control -->
                                            <div class="card mb-3 col-4" style="margin-left: 20px; height: 280px">
                                                <form action="changePass" method="post">
                                                    <div class="card-body">
                                                        <div class="row">
                                                            <div class="col-lg-12 col-md-12">
                                                                <h6 class="card-title">Change Password</h6><br>
                                                                <div class="mb-3">
                                                                    <input type="password" class="form-control" name="oldPass" placeholder="Current Password">
                                                                </div>
                                                                <div class="mb-3">
                                                                    <input type="password" class="form-control" name="newPass" placeholder="New Password">
                                                                </div>
                                                                <div class="mb-3">
                                                                    <input type="password" class="form-control" name="reNewPass" placeholder="Confirm New Password">
                                                                </div>
                                                            </div>
                                                            <c:if test="${errorPass != null}">
                                                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                                                        <i class="fa fa-times-circle"></i> ${errorPass} <br>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        <button type="submit" class="btn btn-primary sa-position">Update</button> &nbsp;&nbsp;
                                                        <button type="reset" class="btn btn-secondary">Cancel</button>
                                                    </div>
                                                </form>
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
        <!-- core js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dropify.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/datepicker.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/sweetalert2.bundle.js"></script>
        <!-- page js file -->
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/pages/profile.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/pages/forms/dropify.js"></script>
        <c:if test="${successMess!=null}">
            <script>
                Swal.fire({
                    position: 'top-end',
                    icon: 'success',
                    title: '${successMess}',
                    showConfirmButton: false,
                    timer: 1500
                });
                history.pushState(null, "", location.href.split("?")[0]);
            </script>
        </c:if>

    </body>

</html>
