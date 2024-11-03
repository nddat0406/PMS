<%-- 
    Document   : sidebar
    Created on : Sep 13, 2024, 11:48:48 PM
    Author     : HP
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div id="left-sidebar" class="sidebar" style="background: white">
    <div class="user-account p-3 mb-3">
        <div class="d-flex mb-3 pb-3 border-bottom align-items-center">
            <img src="${sessionScope.loginedUser.image}" class="avatar lg rounded me-3" alt="User Profile Picture">
            <div class="dropdown flex-grow-1">
                <span>Welcome,</span>
                <a href="#" class="dropdown-toggle user-name" data-bs-toggle="dropdown"><strong>${sessionScope.loginedUser.fullname}</strong></a>
                <ul class="dropdown-menu p-2 shadow-sm">
                    <li><a href="${pageContext.request.contextPath}/user/profile"><i class="fa fa-user me-2"></i>My Profile</a></li>
                    <li class="divider"></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fa fa-power-off me-2"></i>Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
    <!-- nav tab: menu list -->
    <ul class="nav nav-tabs text-center mb-2" role="tablist">
        <li class="nav-item flex-fill"><a class="nav-link active" data-bs-toggle="tab" href="#hr_menu" role="tab">Menu</a></li>
        <li class="nav-item flex-fill"><a class="nav-link" data-bs-toggle="tab" href="#setting_menu" role="tab"><i class="fa fa-cog"></i></a></li>
    </ul>

    <!-- nav tab: content -->
    <div class="tab-content  px-0"> 
        <c:if test="${sessionScope.loginedUser.role ==1}">
            <div class="tab-pane active" id="hr_menu">
                <nav class="sidebar-nav">
                    <ul class="main-menu metismenu list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/dashboard"><i class="fa fa-tachometer"></i><span>Dashboard</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/userlist"><i class="fa fa-users"></i><span>User Management</span></a></li>
                        <li>
                            <a href="#Employees" class="has-arrow"><i class="fa fa-building"></i><span>Group Management</span></a>
                            <ul class="list-unstyled">
                                <li><a href="${pageContext.request.contextPath}/admin/department?action=list">Department Management</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/domain?action=list">Domain Management</a></li>
                            </ul>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/projectlist"><i class="fa fa-tasks"></i><span>Project</span></a></li> 

                        <li><a href="${pageContext.request.contextPath}/settings"><i class="fa fa-cogs"></i><span>Setting Management</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/allocation"><i class="fa fa-sitemap"></i><span>Allocation List</span></a></li>

                        <li><a href="${pageContext.request.contextPath}/user/profile"><i class="fa fa-user"></i><span>Users profile</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out"></i><span>Logout</span></a></li>
                    </ul>
                </nav>
            </div>
        </c:if>
        <c:if test="${sessionScope.loginedUser.role!=1}">
            <div class="tab-pane active" id="hr_menu">
                <nav class="sidebar-nav">
                    <ul class="main-menu metismenu list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/dashboard"><i class="fa fa-tachometer"></i><span>Dashboard</span></a></li>

                        <li><a href="${pageContext.request.contextPath}/projectlist"><i class="fa fa-tasks"></i><span>Project</span></a></li> 
                        <li>
                            <a href="#Employees" class="has-arrow"><i class="fa fa-thumb-tack"></i><span>Project Tracking</span></a>
                            <ul class="list-unstyled">
                                <li><a href="emp-all.html">Project issue</a></li>
                                <li><a href="emp-leave.html">Timesheet</a></li>
                                <li><a href="emp-leave.html">Requirement</a></li>
                                <li><a href="emp-leave.html">Milestone</a></li>
                            </ul>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/admin/department"><i class="fa fa-building"></i><span>Department List</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/domain"><i class="fa fa-tags"></i><span>Domain List</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/allocation"><i class="fa fa-sitemap"></i><span>Allocation List</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/user/profile"><i class="fa fa-user"></i><span>Users profile</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out"></i><span>Logout</span></a></li>
                    </ul>
                </nav>

            </div>
        </c:if>
        <div class="tab-pane fade" id="setting_menu" role="tabpanel" >
            <div class="px-3">
                <h6>Choose Skin</h6>
                <ul class="choose-skin list-unstyled">
                    <li data-theme="purple" class="mb-2">
                        <div class="purple"></div>
                        <span>Purple</span>
                    </li>
                    <li data-theme="blue" class="mb-2">
                        <div class="blue"></div>
                        <span>Blue</span>
                    </li>
                    <li data-theme="cyan" class="mb-2">
                        <div class="cyan"></div>
                        <span>Cyan</span>
                    </li>
                    <li data-theme="green" class="mb-2">
                        <div class="green"></div>
                        <span>Green</span>
                    </li>
                    <li data-theme="orange" class="active mb-2">
                        <div class="orange"></div>
                        <span>Orange</span>
                    </li>
                    <li data-theme="blush" class="mb-2">
                        <div class="blush"></div>
                        <span>Blush</span>
                    </li>
                </ul>
                <hr>
                <h6>Theme Option</h6>
                <ul class="list-unstyled">
                    <li class="d-flex align-items-center mb-1">
                        <div class="form-check form-switch theme-switch">
                            <input class="form-check-input" type="checkbox" id="theme-switch">
                            <label class="form-check-label" for="theme-switch">Enable Dark Mode!</label>
                        </div>
                    </li>
                    <li class="d-flex align-items-center mb-1">
                        <div class="form-check form-switch theme-high-contrast">
                            <input class="form-check-input" type="checkbox" id="theme-high-contrast">
                            <label class="form-check-label" for="theme-high-contrast">Enable High Contrast</label>
                        </div>
                    </li>
                    <li class="d-flex align-items-center mb-1">
                        <div class="form-check form-switch theme-rtl">
                            <input class="form-check-input" type="checkbox" id="theme-rtl">
                            <label class="form-check-label" for="theme-rtl">Enable RTL Mode!</label>
                        </div>
                    </li>
                    <li class="d-flex align-items-center mb-1">
                        <div class="form-check form-switch minisidebar-active">
                            <input class="form-check-input" type="checkbox" id="mini-active">
                            <label class="form-check-label" for="mini-active">Mini Sidebar</label>
                        </div>
                    </li>
                </ul>
                <hr>
            </div>
        </div>
    </div>
</div>
