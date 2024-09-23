<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">


    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/project-detail.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:41 GMT -->
    <head>
        <meta charset="utf-8">
        <title>:: Lucid HR BS5 :: Project Detail</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

        <link rel="icon" href="favicon.ico" type="image/x-icon">

        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <style>
            .highlight {
                background-color: #f8f9fa;
                padding: 20px;
            }

            .highlight pre code {
                font-size: inherit;
                color: #212529;
            }

            .nt {
                color: #2f6f9f;
            }

            .na {
                color: #4f9fcf;
            }

            .s {
                color: #d44950;
            }

            pre.prettyprint {
                background-color: #eee;
                border: 0px;
                margin: 0;
                padding: 20px;
                text-align: left;
            }

            .atv,
            .str {
                color: #05AE0E;
            }

            .tag,
            .pln,
            .kwd {
                color: #3472F7;
            }

            .atn {
                color: #2C93FF;
            }

            .pln {
                color: #333;
            }

            .com {
                color: #999;
            }
        </style>

    </head>

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
                                    <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Domain Details</h2>
                                    <ul class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="index.html">Lucid</a></li>
                                        <li class="breadcrumb-item">Domain</li>
                                        <li class="breadcrumb-item active">Domain Details</li>
                                    </ul>
                                </div>
                                <div class="col-md-6 col-sm-12 text-md-end">
                                    <div class="d-inline-flex text-start">
                                        <div class="me-2">
                                            <h6 class="mb-0"><i class="fa fa-user"></i> 1,784</h6>
                                            <small>Visitors</small>
                                        </div>
                                        <span id="bh_visitors"></span>
                                    </div>
                                    <div class="d-inline-flex text-start ms-lg-3 me-lg-3 ms-1 me-1">
                                        <div class="me-2">
                                            <h6 class="mb-0"><i class="fa fa-globe"></i> 325</h6>
                                            <small>Visits</small>
                                        </div>
                                        <span id="bh_visits"></span>
                                    </div>
                                    <div class="d-inline-flex text-start">
                                        <div class="me-2">
                                            <h6 class="mb-0"><i class="fa fa-comments"></i> 13</h6>
                                            <small>Chats</small>
                                        </div>
                                        <span id="bh_chats"></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-2">
                            <div class="col-lg-4 col-md-12">
                                <div class="card mb-2">
                                    <div class="card-body">

                                        <h6 class="card-title mb-4">${groupDetail.name}</h6>
                                        <p>${groupDetail.details}</p>
                                        <!--                                <div class="progress-container progress-info">
                                                                            <span class="progress-badge">Project Status</span>
                                                                            <div class="progress">
                                                                                <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 78%;">
                                                                                    <span class="progress-value">78%</span>
                                                                                </div>
                                                                            </div>-->
                                    </div>
                                </div>
                            </div>
                            <div class="card mb-2">
                                <div class="card-body">
                                    <ul class="list-unstyled basic-list mb-0">
                                        <!--                                    <li class="d-flex justify-content-between mb-3">Cost:<span class="badge bg-primary">$16,785</span></li>
                                                                            <li class="d-flex justify-content-between mb-3">Created:<span class="bg-success badge">14 Mar, 2021</span></li>
                                                                            <li class="d-flex justify-content-between mb-3">Deadline:<span class="bg-info badge">22 Aug, 2021</span></li>
                                                                            <li class="d-flex justify-content-between mb-3">Priority:<span class="bg-danger badge">Highest priority</span></li>-->
                                        <li class="d-flex justify-content-between">Status                   
                    <c:choose>
                        <c:when test="${groupDetail.status == 1}">
                            <span class="badge bg-success">Active</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger">Inactive</span>
                        </c:otherwise>
                    </c:choose></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card mb-2">
                                <div class="card-header">
                                    <h6 class="card-title">Assigned Team</h6>
                                </div>
                                <div class="card-body">
                                    <div class="w_user d-flex align-items-start">
                                        <img class="rounded-circle" src="assets/images/sm/avatar4.jpg" width="72" alt="">
                                        <div class="wid-u-info ms-3">
                                            <h5 class="mb-0">Fidel Tonn</h5>
                                            <span>info@thememakker.com</span>
                                            <p class="text-muted mb-0">Project Lead</p>
                                        </div>
                                    </div>
                                    <hr>
                                    <ul class="right_chat list-unstyled mb-0">
                                        <li class="offline">
                                            <a class="d-flex mb-3" href="javascript:void(0);">
                                                <img class="rounded-circle" src="assets/images/xs/avatar2.jpg" width="45" height="45" alt="">
                                                <div class="ms-3 w-100 text-muted">
                                                    <span class="name d-block">Isabella <small class="float-end">15 Min ago</small></span>
                                                    <span class="message">Contrary to popular belief, Lorem Ipsum is not simply random text</span>
                                                    <span class="status"></span>
                                                </div>
                                            </a>
                                        </li>
                                        <li class="offline">
                                            <a class="d-flex mb-3" href="javascript:void(0);">
                                                <img class="rounded-circle" src="assets/images/xs/avatar1.jpg" width="45" height="45" alt="">
                                                <div class="ms-3 w-100 text-muted">
                                                    <span class="name d-block">Folisise Chosielie <small class="float-end">1 hours ago</small></span>
                                                    <span class="message">There are many variations of passages of Lorem Ipsum available, but the majority</span>
                                                    <span class="status"></span>
                                                </div>
                                            </a>
                                        </li>
                                        <li class="online">
                                            <a class="d-flex mb-3" href="javascript:void(0);">
                                                <img class="rounded-circle" src="assets/images/xs/avatar3.jpg" width="45" height="45" alt="">
                                                <div class="ms-3 w-100 text-muted">
                                                    <span class="name d-block">Alexander <small class="float-end">1 day ago</small></span>
                                                    <span class="message">It is a long established fact that a reader will be distracted</span>
                                                    <span class="status"></span>
                                                </div>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card mb-2">
                                <div class="card-header">
                                    <h6 class="card-title">About Clients</h6>
                                </div>
                                <div class="card-body text-center">
                                    <div class="profile-image mb-3"> <img src="assets/images/user.png" class="rounded-circle" alt=""> </div>
                                    <div>
                                        <h4><strong>Jessica</strong> Doe</h4>
                                        <span>Washington, d.c.</span>
                                    </div>
                                    <div class="mt-3">
                                        <button class="btn btn-primary">Profile</button>
                                        <button class="btn btn-outline-secondary">Message</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-8 col-md-12">
                            <div class="card mb-2">
                                <div class="card-header">
                                    <h6 class="card-title">Project Activity</h6>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <textarea rows="2" class="form-control no-resize" placeholder="Please type what you want..."></textarea>
                                    </div>
                                    <div>
                                        <button class="btn btn-warning"><i class="fa fa-paperclip text-light"></i></button>
                                        <button class="btn btn-warning"><i class="fa fa-camera text-light"></i></button>
                                        <button class="btn btn-primary">Add</button>
                                    </div>
                                </div>
                            </div>
                            <div class="card mb-2">
                                <div class="card-body">
                                    <div class="timeline-item green">
                                        <span class="date">Just now</span>
                                        <h6>iNext - One Page Responsive Template</h6>
                                        <span>Project Lead: <a href="javascript:void(0);" title="Fidel Tonn">Fidel Tonn</a></span>
                                    </div>
                                    <div class="timeline-item warning">
                                        <span class="date">02 Jun 2021</span>
                                        <h6>Add Team Members</h6>
                                        <span>By: <a href="javascript:void(0);" title="Fidel Tonn">Fidel Tonn</a></span>
                                        <div class="msg">
                                            <p>web by far While that's mock-ups and this is politics, are they really so different? I think the only card she has is the Lorem card.</p>
                                            <ul class="list-unstyled team-info d-flex">
                                                <li><img src="assets/images/xs/avatar4.jpg" data-toggle="tooltip" data-placement="top" title="Chris Fox" alt="Avatar"></li>
                                                <li><img src="assets/images/xs/avatar5.jpg" data-toggle="tooltip" data-placement="top" title="Joge Lucky" alt="Avatar"></li>
                                                <li><img src="assets/images/xs/avatar2.jpg" data-toggle="tooltip" data-placement="top" title="Folisise Chosielie" alt="Avatar"></li>
                                                <li><img src="assets/images/xs/avatar1.jpg" data-toggle="tooltip" data-placement="top" title="Joge Lucky" alt="Avatar"></li>
                                            </ul>
                                            <div class="top_counter d-flex">
                                                <div class="icon text-center"><i class="fa fa-file-word-o"></i> </div>
                                                <div class="content ms-3">
                                                    <p class="mb-1">iNext project documentation.doc</p>
                                                    <span>Size: 2.3Mb</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="timeline-item warning">
                                        <span class="date">02 Jun 2021</span>
                                        <h6>Task Assigned</h6>
                                        <span>By: <a href="javascript:void(0);" title="Fidel Tonn">Fidel Tonn</a></span>
                                        <div class="msg">
                                            <p>It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal</p>
                                            <div class="d-flex mb-3">
                                                <img class="media-object rounded width40 mr-3" src="assets/images/xs/avatar1.jpg" alt="" />
                                                <div class="media-body ms-2">
                                                    <h6 class="mb-0">Folisise Chosielie</h6>
                                                    <p class="mb-0"><strong>Detail:</strong> Ipsum is simply dummy text of the printing and typesetting industry. </p>
                                                </div>
                                            </div>
                                            <div class="d-flex">
                                                <img class="media-object rounded width40 mr-3" src="assets/images/xs/avatar5.jpg" alt="" />
                                                <div class="media-body ms-2">
                                                    <h6 class="mb-0">Joge Lucky</h6>
                                                    <p class="mb-0"><strong>Detail:</strong> Ipsum is simply dummy text of the printing and typesetting industry. </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="timeline-item warning">
                                        <span class="date">02 Jun 2021</span>
                                        <h6>Add new code on GitHub</h6>
                                        <span>By: <a href="javascript:void(0);" title="Fidel Tonn">Folisise Chosielie</a></span>
                                        <div class="msg">
                                            <div class="alert alert-success mb-3" role="alert">Code Update Successfully in GitHub</div>
                                            <pre
                                                class="prettyprint prettyprinted"><span class="tag">&lt;span</span><span class="pln"> </span><span class="atn">class</span><span class="pun">=</span><span class="atv">"badge bg-secondary"</span><span class="tag">&gt;</span><span class="pln">Default</span><span class="tag">&lt;/span&gt;</span><span class="pln">
                                                </span><span class="tag">&lt;span</span><span class="pln"> </span><span class="atn">class</span><span class="pun">=</span><span class="atv">"badge bg-primary"</span><span class="tag">&gt;</span><span class="pln">Primary</span><span class="tag">&lt;/span&gt;</span><span class="pln">
                                                </span><span class="tag">&lt;span</span><span class="pln"> </span><span class="atn">class</span><span class="pun">=</span><span class="atv">"badge bg-success"</span><span class="tag">&gt;</span><span class="pln">Success</span><span class="tag">&lt;/span&gt;</span><span class="pln">
                                                </span><span class="tag">&lt;span</span><span class="pln"> </span><span class="atn">class</span><span class="pun">=</span><span class="atv">"badge bg-info"</span><span class="tag">&gt;</span><span class="pln">Info</span><span class="tag">&lt;/span&gt;</span><span class="pln">
                                                </span><span class="tag">&lt;span</span><span class="pln"> </span><span class="atn">class</span><span class="pun">=</span><span class="atv">"badge bg-warning"</span><span class="tag">&gt;</span><span class="pln">Warning</span><span class="tag">&lt;/span&gt;</span><span class="pln">
                                                </span><span class="tag">&lt;span</span><span class="pln"> </span><span class="atn">class</span><span class="pun">=</span><span class="atv">"badge bg-danger"</span><span class="tag">&gt;</span><span class="pln">Danger</span><span class="tag">&lt;/span&gt;</span></pre>
                                        </div>
                                    </div>
                                    <div class="timeline-item danger">
                                        <span class="date">04 Jun 2021</span>
                                        <h6>Project Reports</h6>
                                        <span>By: <a href="javascript:void(0);" title="Fidel Tonn">Fidel Tonn</a></span>
                                        <div class="msg">
                                            <ul class="list-unstyled">
                                                <li class="mb-3">
                                                    <span>Design Bug</span>
                                                    <div class="progress" style="height: 5px;">
                                                        <div class="progress-bar bg-danger" role="progressbar" aria-valuenow="17" aria-valuemin="0" aria-valuemax="100" style="width: 17%;"></div>
                                                    </div>
                                                </li>
                                                <li class="mb-3">
                                                    <span>UI UX Design Task</span>
                                                    <div class="progress" style="height: 5px;">
                                                        <div class="progress-bar" role="progressbar" aria-valuenow="83" aria-valuemin="0" aria-valuemax="100" style="width: 83%;"> </div>
                                                    </div>
                                                </li>
                                                <li class="mb-3">
                                                    <span>Developer Task</span>
                                                    <div class="progress" style="height: 5px;">
                                                        <div class="progress-bar bg-success" role="progressbar" aria-valuenow="49" aria-valuemin="0" aria-valuemax="100" style="width: 49%;"></div>
                                                    </div>
                                                </li>
                                                <li>
                                                    <span>QA (Quality Assurance)</span>
                                                    <div class="progress" style="height: 5px;">
                                                        <div class="progress-bar bg-warning" role="progressbar" aria-valuenow="33" aria-valuemin="0" aria-valuemax="100" style="width: 33%;"></div>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="timeline-item dark">
                                        <span class="date">05 Jun 2021</span>
                                        <h6>Project on Goinng</h6>
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

    <!-- page js file -->
    <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
</body>

<!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/project-detail.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:41 GMT -->
</html>