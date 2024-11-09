<%-- 
    Document   : topNavbar
    Created on : Sep 13, 2024, 11:45:03 PM
    Author     : HP
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- top navbar -->
<nav class="navbar navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-btn">
            <button type="button" class="btn-toggle-offcanvas"><i class="fa fa-bars"></i></button>
        </div>

        <div class="navbar-brand ps-2">
            <a href="${pageContext.request.contextPath}/dashboard" class="d-flex">
                <svg width="85px" viewBox="0 0 85 25">
                <path class="fill-primary" d="M12.3,7.2l1.5-3.7l8.1,19.4H19l-2.4-5.7H8.2l1.1-2.5h6.1L12.3,7.2z M14.8,20.2l1,2.7H0L9.5,0h3.1L4.3,20.2H14.8
                      z M29,18.5v-14h1.6v12.6h6.2v1.5H29V18.5z M49.6,4.5v9.1c0,1.6-0.5,2.9-1.5,3.8s-2.3,1.4-4,1.4s-3-0.5-3.9-1.4s-1.4-2.2-1.4-3.8V4.5
                      h1.6v9.1c0,1.2,0.3,2.1,1,2.7c0.6,0.6,1.6,0.9,2.8,0.9s2.1-0.3,2.7-0.9c0.6-0.6,1-1.5,1-2.7V4.5H49.6z M59.4,5.7
                      c-1.5,0-2.8,0.5-3.7,1.5s-1.3,2.4-1.3,4.2s0.4,3.3,1.3,4.3c0.9,1,2.1,1.5,3.7,1.5c1,0,2.1-0.2,3.4-0.5v1.4c-1,0.4-2.2,0.5-3.6,0.5
                      c-2.1,0-3.7-0.6-4.8-1.9s-1.7-3-1.7-5.4c0-1.4,0.3-2.7,0.8-3.8c0.5-0.9,1.3-1.8,2.3-2.4s2.2-0.9,3.6-0.9c1.5,0,2.8,0.3,3.9,0.8
                      l-0.7,1.4C61.5,6,60.4,5.7,59.4,5.7z M65.8,18.5v-14h1.6v14.1h-1.6V18.5z M82.5,11.3c0,2.3-0.6,4.1-1.9,5.3s-3.1,1.8-5.4,1.8h-3.9
                      V4.5h4.3c2.2,0,3.9,0.6,5.1,1.8S82.5,9.2,82.5,11.3z M80.8,11.4c0-1.8-0.5-3.2-1.4-4.1s-2.3-1.4-4.1-1.4h-2.4v11.2h2
                      c1.9,0,3.4-0.5,4.4-1.4S80.8,13.3,80.8,11.4z" />
                </svg>
            </a>
        </div>

        <div class="d-flex flex-grow-1 align-items-center">
            <div class="d-flex">
                <form id="navbar-search" class="navbar-form search-form position-relative d-none d-md-block">
                    <input value="" class="form-control" placeholder="Search here..." type="text">
                    <button type="button" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                </form>
            </div>
            <div class="align-items-center">
                <ul class="nav navbar-nav flex-row justify-content-end align-items-center" >
                    <li><a href="${pageContext.request.contextPath}/dashboard" class="icon-menu">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/requirement" class="icon-menu">Requirement</a></li>


                    <li><a href="${pageContext.request.contextPath}/timesheet" class="icon-menu">Timesheets</a></li>
                        <c:if test="${loginedUser.role == '3' || loginedUser.role == '4'}">
                        <li><a href="${pageContext.request.contextPath}/issue" class="icon-menu">Issues</a></li>
                        </c:if>
                        <c:if test="${loginedUser.role != '3' && loginedUser.role != '4'}">
                        <li><a href="${pageContext.request.contextPath}/user-issues" class="icon-menu">Issues</a></li>
                        </c:if>
                    <li><a href="${pageContext.request.contextPath}/defectlist" class="icon-menu">Defect</a></li>

                </ul>
            </div>
            <div class="flex-grow-1">
                <ul class="nav navbar-nav flex-row justify-content-end align-items-center">
                    <li><a href="${pageContext.request.contextPath}/logout" class="icon-menu"><i class="fa fa-sign-out"></i></a></li>
                </ul>
            </div>

        </div>
    </div>
</nav>
