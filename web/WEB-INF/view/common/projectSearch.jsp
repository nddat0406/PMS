<%-- 
    Document   : projectSearch
    Created on : Oct 21, 2024, 9:37:01 PM
    Author     : HP
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="project-searching">
    <div class="col-lg-12 card" style=" padding:10px 0px 0px 10px   ;margin-bottom: 10px">
        <h5>Quick Search</h5>
        <div class="card-body ">
            <div class=" col-lg-12 row g-5">
                <div class="col col-lg-4">
                    <form action="${requestScope['javax.servlet.forward.servlet_path']}" method="get">
                        <div class="input-group mb-3 ">
                            <label>Search Project</label>
                            <div class="input-group" style="    flex-wrap: nowrap;">
                                <select class="select2Project form-select" name="projectId" hidden>
                                    <c:forEach var="item" items="${sessionScope.myProjectList}">
                                        <option value="${item.id}" ${sessionScope.selectedProject==item.id?'selected':''}>${item.code} - ${item.name}</option>
                                    </c:forEach>
                                </select>
                                <input type="submit" class="btn btn-outline-info"  value="View Details">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="col col-lg-4">
                    <form action="${pageContext.request.contextPath}/domain" method="get">
                        <div class="input-group mb-3 ">
                            <label>Search Domain</label>
                            <div class="input-group" style="flex-wrap: nowrap;">
                                <select class="select2Project form-select" name="domainId" id="kagawad">
                                    <c:forEach var="d" items="${sessionScope.domainList}">
                                        <option value="${d.id}">${d.code} - ${d.name}</option>
                                    </c:forEach>
                                </select>
                                <input type="submit" id="sendbtn" class="btn btn-outline-info" value="View Details">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
