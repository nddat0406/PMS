<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Internal Server Error - 500</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>

    <body>
        <div id="layout" class="theme-cyan">
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
                            <div class="card-header fs-4 fw-bold">
                                500<br />Internal Server Error
                            </div>
                            <div class="card-body">
                                <p>We're currently experiencing an error. Please try again later.</p>
                                <div class="mt-3">
                                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary"><i class="fa fa-home me-2"></i>Home</a>
                                    <a class="btn btn-danger"  data-bs-toggle="collapse" data-bs-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
                                        <i class="fa fa-bug me-2" ></i>See Cause</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="collapse" id="collapseExample">
                        <div >
                            <div class="card shadow p-lg-4" style="margin: 20px;max-width: 1200px">
                                <div class="card-header fs-4 fw-bold">
                                    500<br />Internal Server Error
                                </div>
                                <div class="card-body">
                                    <p><strong>Error Message:</strong> <%= exception.getMessage() %></p>
                                    <div class="stack-trace mt-3">
                                        <p><strong>Stack Trace:</strong></p>
                                        <pre style="max-height: 600px;max-width: 1200px; word-wrap: break-word">
                                            <%
                                                // Print the full stack trace
                                                exception.printStackTrace(new java.io.PrintWriter(out));
                                            %>
                                        </pre>
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
</html>
