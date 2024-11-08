<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">


    <!-- Mirrored from wrraptheme.com/templates/lucid/hr/bs5/dist/page-register.html by HTTrack Website Copier/3.x [XR&CO'2014], Fri, 13 Sep 2024 06:42:37 GMT -->
    <head>
        <meta charset="utf-8">
        <title>:: Lucid HR BS5 :: Sign Up</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
        <meta name="author" content="WrapTheme, design by: ThemeMakker.com">

        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <!-- VENDOR CSS -->

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" >
        <!-- Icon -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>


        <!-- MAIN CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
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
                                <p class="fs-5 mb-0">Create an account</p>
                            </div>
                            <c:if test="${not empty requestScope.error}">
                                <div style="color: red; margin-top: 10px;">
                                    ${requestScope.error}
                                </div>
                            </c:if>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/register" method="POST" id="regisForm">
                                    <div class="form-floating mb-1">
                                        <input type="full-name" name="fullName" class="form-control" placeholder="full-name">
                                        <label>Full Name</label>
                                    </div>
                                    <div class="form-floating mb-1">
                                        <input type="email" name="email" class="form-control" placeholder="name@example.com" id="emailInput">
                                        <label>Email address</label>
                                    </div>
                                    <div style="color: red; margin-top: 10px;display: none" id="emailMess">

                                    </div>
                                    <c:if test="${not empty requestScope.emailError}">
                                        <div style="color: red; margin-top: 10px;">
                                            ${requestScope.emailError}
                                        </div>
                                    </c:if>
                                    <div class="form-floating mb-1">
                                        <input type="password" name="password" class="form-control" placeholder="Password" id="passInput">
                                        <label>Password</label>
                                    </div>
                                    <div style="color: red; margin-top: 10px;display: none" id="passwordError">

                                    </div>
                                    <c:if test="${not empty requestScope.passwordError}">
                                        <div style="color: red; margin-top: 10px;">
                                            ${requestScope.passwordError}
                                        </div>
                                    </c:if>
                                    <div class="form-floating mb-1">
                                        <input type="password" name="rePassword" class="form-control" placeholder="Re-Password" id="repassInput">
                                        <label>Re-Password</label>
                                    </div>
                                    <c:if test="${not empty requestScope.rePasswordError}">
                                        <div style="color: red; margin-top: 10px;">
                                            ${requestScope.rePasswordError}
                                        </div>
                                    </c:if>
                                    <div class="my-3">
                                        <button type="button" id="registerBtn"  class="btn btn-primary w-100 px-3 py-2 mb-2">REGISTER</button>
                                        <button type="button" id="loadingBtn" class="btn btn-primary w-100 px-3 py-2 mb-2" style="display: none;" disabled="disabled"><i class="fa fa-spinner fa-spin"></i> <span>Loading...</span></button>
                                        <span>Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a></span>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="btn" data-bs-toggle="modal" data-bs-target="#OTPModal" id="toggleOTPModal" hidden></button>
            </div>
            <!-- END WRAPPER -->

            <!-- Verify Email Modal -->

            <div class="modal fade" id="OTPModal" tabindex="-1" aria-labelledby="largeModal" aria-hidden="false">
                <div class="modal-dialog modal-dialog-centered">
                    <form action="verifyEmail" method="post">
                        <input type="hidden" name="action" value="verify">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">OTP Verification</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <label>Enter OTP sended to email: ${oldFilledEmail}</label><br/><br/>
                                <div class="input-group mb-3">
                                    <span class="input-group-text" id="inputGroup-sizing-default">OTP</span>
                                    <input type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default" name="otp" id="otpCode">
                                </div>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert" style="display: none;" id="verifyError">
                                </div>
                            </div>
                            <div class="modal-footer justify-content-center" >
                                <button type="button" class="btn btn-primary" onclick="verifyEmail()" style="width: 100px" id="verifyBtn">Verify</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>
        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>

        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>

        <script>
                                    $(document).ready(function () {
                                        $("#registerBtn").on("click", function (event) {
                                            $('#verifyError').hide();
                                            $('#otpCode').val("");
                                            const password = $("#passInput").val();
                                            const repass = $("#repassInput").val();
                                            if ($("#emailInput").val().trim() === "") {
                                                $("#emailMess").text("Email is required!");
                                                $("#emailMess").show();
                                            }
                                            if ($("#passInput").val().trim() === "" || $("#repassInput").val().trim() === "") {
                                                $("#passwordError").text("Password and Re-password is required!");
                                                $("#passwordError").show();
                                            } else {
                                                if (password !== repass) {
                                                    $("#passwordError").text("Password and Re-password not match!");
                                                    $("#passwordError").show();
                                                } else {
                                                    // Hide error message if passwords match
                                                    $("#passwordError").hide();
                                                    sendVerificationEmail();
                                                }
                                            }
                                        });

                                        // Hide error message when user starts typing in either field
                                        $("#passInput, #repassInput, #emailInput").on("input", function () {
                                            $("#passwordError").hide();
                                            $("#emailMess").hide();
                                        });
                                    });

                                    function sendVerificationEmail() {
                                        const email = $('#emailInput').val();
                                        $.ajax({
                                            type: "POST",
                                            url: "verifyEmail",
                                            data: {
                                                registerEmail: email,
                                                action: "sendEmail"
                                            },
                                            dataType: "json",
                                            beforeSend: function () {
                                                $("#registerBtn").css("display", "none");
                                                $("#loadingBtn").css("display", "block");
                                            },
                                            success: function (response) {
                                                // Check response status
                                                if (response.status === "success") {
                                                    // Display verification modal on success
                                                    $('#toggleOTPModal').click();
                                                } else {
                                                    // Display error message on the page
                                                    $("#emailMess").text(response.message);
                                                    $("#emailMess").css('display', 'block');
                                                }
                                            },
                                            error: function (ts) {
                                                // Handle unexpected errors
                                                $("#emailMess").text(ts.responseText).show();
                                            },
                                            complete: function () {
                                                $("#registerBtn").css("display", "block");
                                                $("#loadingBtn").css("display", "none");
                                            }
                                        });
                                    }
                                    function verifyEmail() {
                                        const otp = $('#otpCode').val();
                                        $.ajax({
                                            type: "POST",
                                            url: "verifyEmail",
                                            data: {
                                                otpValue: otp,
                                                action: "verify"
                                            },
                                            dataType: "json",
                                            success: function (response) {
                                                // Check response status
                                                if (response.status === "success") {
                                                    // Display verification modal on success
                                                    $('#regisForm').submit();
                                                } else {
                                                    // Display error message on the page
                                                    $('#verifyError').html(`<i class="fa fa-times-circle"></i>&nbsp;`+response.message+"<br>");
                                                    $('#verifyError').show();
                                                }
                                            },
                                            error: function (ts) {
                                                // Handle unexpected errors
                                                $("#emailMess").text("Some thing when wrong!").show();
                                            }
                                        });
                                    }
        </script>
    </body>
</html>