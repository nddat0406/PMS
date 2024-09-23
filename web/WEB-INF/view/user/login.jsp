<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">


    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/page-login.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:34 GMT -->
    <head>
        <meta charset="utf-8">
        <title>:: Lucid HR BS5 :: Login</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

        <link rel="icon" href="favicon.ico" type="image/x-icon">

        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sweetalert2.min.css">
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <!-- WRAPPER -->
            <div id="wrapper">
                <div class="d-flex h100vh align-items-center auth-main w-100">
                    <div class="auth-box">
                        <div class="top mb-4">
                            <div class="logo">
                                <svg width="130px" height="38px" viewBox="0 0 82.5 22.9">
                                <path d="M12.3,7.2l1.5-3.7l8.1,19.4H19l-2.4-5.7H8.2l1.1-2.5h6.1L12.3,7.2z M14.8,20.2l1,2.7H0L9.5,0h3.1L4.3,20.2H14.8
                                      z M29,18.5v-14h1.6v12.6h6.2v1.5H29V18.5z M49.6,4.5v9.1c0,1.6-0.5,2.9-1.5,3.8s-2.3,1.4-4,1.4s-3-0.5-3.9-1.4s-1.4-2.2-1.4-3.8V4.5
                                      h1.6v9.1c0,1.2,0.3,2.1,1,2.7c0.6,0.6,1.6,0.9,2.8,0.9s2.1-0.3,2.7-0.9c0.6-0.6,1-1.5,1-2.7V4.5H49.6z M59.4,5.7
                                      c-1.5,0-2.8,0.5-3.7,1.5s-1.3,2.4-1.3,4.2s0.4,3.3,1.3,4.3c0.9,1,2.1,1.5,3.7,1.5c1,0,2.1-0.2,3.4-0.5v1.4c-1,0.4-2.2,0.5-3.6,0.5
                                      c-2.1,0-3.7-0.6-4.8-1.9s-1.7-3-1.7-5.4c0-1.4,0.3-2.7,0.8-3.8c0.5-0.9,1.3-1.8,2.3-2.4s2.2-0.9,3.6-0.9c1.5,0,2.8,0.3,3.9,0.8
                                      l-0.7,1.4C61.5,6,60.4,5.7,59.4,5.7z M65.8,18.5v-14h1.6v14.1h-1.6V18.5z M82.5,11.3c0,2.3-0.6,4.1-1.9,5.3s-3.1,1.8-5.4,1.8h-3.9
                                      V4.5h4.3c2.2,0,3.9,0.6,5.1,1.8S82.5,9.2,82.5,11.3z M80.8,11.4c0-1.8-0.5-3.2-1.4-4.1s-2.3-1.4-4.1-1.4h-2.4v11.2h2
                                      c1.9,0,3.4-0.5,4.4-1.4S80.8,13.3,80.8,11.4z" />
                                </svg>
                            </div>
                        </div>
                        <div class="card shadow p-lg-4">
                            <div class="card-header">
                                <p class="fs-5 mb-0">Login to your account</p>
                            </div>
                            <c:if test="${not empty requestScope.success}">
                                <div style="color: green; margin-top: 10px;">
                                ${requestScope.success}
                                </div>
                            </c:if>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/login" method="POST">
                                    <div class="form-floating mb-1">
                                        <input type="email" name="email" class="form-control" placeholder="name@example.com">
                                        <label>Email address</label>
                                    </div>
                                    <div class="form-floating">
                                        <input type="password" name="password" class="form-control" placeholder="Password">
                                        <label>Password</label>
                                    </div>
                                    <div class="form-check my-3">
                                        <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
                                        <label class="form-check-label" for="flexCheckDefault">
                                            Remember me
                                        </label>
                                    </div>
                                    <input type="hidden" name="contain" value="login">
                                    <button type="submit" class="btn btn-primary w-100 px-3 py-2">LOGIN</button>
                                </form>
                                <div class="d-grid gap-2 mt-3 pt-3">
                                    <div class="text-center"><span>OR</span></div>
                                    <button class="btn btn-light"><i class="fab fa-google"></i> Sign in with Gmail</button>
                                </div>
                                <div class="mt-3 pt-3 border-top">
                                    <p class="mb-1"><a href="${pageContext.request.contextPath}/forgot-password"><i class="fa fa-lock me-2"></i>Forgot password?</a></p>
                                    <span>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register</a></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- END WRAPPER -->
        </div>

        <script src="${pageContext.request.contextPath}/assets/bundles/sweetalert2.bundle.js"></script>
        <c:if test="${errorMess!=null}">
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
    </body>

    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/page-login.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:34 GMT -->
</html>