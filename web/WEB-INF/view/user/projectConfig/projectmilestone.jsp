<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Project Milestone</title>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <style>
            .content-wrapper {
                max-height: 50px;
                overflow: hidden;
                transition: max-height 0.4s ease-in-out;
                position: relative;
            }
            .content-wrapper.expanded {
                max-height: 1000px;
            }
            .read-more-btn {
                display: inline-block;
                color: #008ce6;
                cursor: pointer;
            }
            th {
                cursor: pointer;
                position: relative;
            }
            .sort-icon {
                margin-left: 5px;
                font-size: 12px;
                width: 10px;
                height: 20px;
            }


            .error-message {
                font-size: 0.875rem;
                margin-top: 0.25rem;
            }
            .is-invalid {
                border-color: #dc3545;
            }
        </style>
    </head>
    <body>
        <div id="layout" class="theme-cyan">
            <jsp:include page="../../common/pageLoader.jsp"></jsp:include>
                <div id="wrapper">
                <jsp:include page="../../common/topNavbar.jsp"></jsp:include>
                <jsp:include page="../../common/sidebar.jsp"></jsp:include>
                    <div id="main-content">
                        <div class="container-fluid">
                            <div class="block-header py-lg-4 py-3">
                                <div class="row g-3">
                                    <div class="col-md-6 col-sm-12">
                                        <h2 class="m-0 fs-5"><a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth"><i class="fa fa-arrow-left"></i></a> Project Milestones</h2>
                                        <ul class="breadcrumb mb-0">
                                            <li class="breadcrumb-item"><a href="/dashboard">Lucid</a></li>
                                            <li class="breadcrumb-item active">Project Configs</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-lg-12 col-md-12">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link active" id="Overview-tab" href="milestone" role="tab">Milestone</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link" id="Settings-tab" href="eval" role="tab">Evaluation criteria</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link" id="Settings-tab" href="member" role="tab">Member</a></li>
                                                <li class="nav-item" role="presentation" style="width: 150px"><a class="nav-link" id="Settings-tab" href="team" role="tab">Team</a></li>
                                            </ul>
                                        </div>
                                        <div class="card-body">
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="projectSearch" placeholder="Search project...">
                                                <button class="btn btn-primary" type="button" onclick="searchProject()">
                                                    <i class="fa fa-search"></i> Search
                                                </button>
                                                <!--<button class="btn btn-secondary ms-2" type="button" id="viewDetails">View Details</button>-->
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-content p-0" id="myTabContent">
                                        <div class="tab-pane fade active show" id="Tab1">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="card-title">Project Milestones</h6>
                                                    <span style="color: red">${errorMessage}</span>
                                            </div>
                                            <div class="card-body">
                                                <table id="milestone_list" class="table table-hover mb-0">
                                                    <thead>
                                                        <tr>
                                                            <th name="id" sortBy="desc" class="sortTableHead" aria-sort="none">ID <i class="fa fa-sort sort-icon"></i></th>
                                                            <th name="name" sortBy="desc" class="sortTableHead" aria-sort="none">Name <i class="fa fa-sort sort-icon"></i></th>
                                                            <th name="priority" sortBy="desc" class="sortTableHead" aria-sort="none">Priority <i class="fa fa-sort sort-icon"></i></th>
                                                            <th name="endDate" sortBy="desc" class="sortTableHead" aria-sort="none">End Date <i class="fa fa-sort sort-icon"></i></th>
                                                            <th>Details</th>
                                                            <th name="status" sortBy="desc" class="sortTableHead" aria-sort="none">Status <i class="fa fa-sort sort-icon"></i></th>
                                                                <c:if test="${loginedUser.role == 1 || loginedUser.role == 4}">
                                                                <th>Actions</th>
                                                                </c:if>
                                                        </tr>
                                                    </thead>
                                                    <tbody class="tableBody">
                                                        <c:forEach items="${tableData}" var="milestone">
                                                            <tr>
                                                                <td>${milestone.id}</td>
                                                                <td>${milestone.name}</td>
                                                                <td>${milestone.priority}</td>
                                                                <td>${milestone.endDate}</td>
                                                                <td>
                                                                    <div class="content-wrapper">
                                                                        <p>${milestone.details}</p>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${milestone.status == '0'}">
                                                                            <span class="badge bg-secondary">Closed</span>
                                                                        </c:when>
                                                                        <c:when test="${milestone.status == '1'}">
                                                                            <span class="badge bg-primary">In Progress</span>
                                                                        </c:when>
                                                                        <c:when test="${milestone.status == '2'}">
                                                                            <span class="badge bg-warning">Pending</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-info">${milestone.status}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <c:if test="${loginedUser.role == 1 || loginedUser.role == 4}">
                                                                    <td>
                                                                        <button class="btn btn-sm btn-outline-secondary view-details">
                                                                            <i class="fa fa-eye"></i> View Details
                                                                        </button>
                                                                    </td>
                                                                </c:if>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                                <c:if test="${empty tableData}">
                                                    <div class="card-body text-center">
                                                        <h4>No result found!</h4>
                                                    </div>
                                                </c:if>
                                                <nav aria-label="Page navigation example">
                                                    <ul class="pagination">
                                                        <li class="page-item"><a class="page-link" href="milestone?page=${page==1?1:page-1}">Previous</a></li>
                                                            <c:forEach begin="${1}" end="${num}" var="i">
                                                            <li class="page-item ${i==page?'active':''}"><a class="page-link" href="milestone?page=${i}">${i}</a></li>
                                                            </c:forEach>
                                                        <li class="page-item"><a class="page-link" href="milestone?page=${page!=num?page+1:page}">Next</a></li>
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
            </div>
        </div>

        <div class="modal fade" id="milestoneDetailModal" tabindex="-1" aria-labelledby="milestoneDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="milestoneDetailModalLabel">Milestone Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="milestoneForm" action="${pageContext.request.contextPath}/project/milestone" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="mileStoneId" value="" id="modalMilestoneId">
                            <div class="mb-3">
                                <label for="milestoneName" class="form-label">Name</label>
                                <input type="text" 
                                       class="form-control" 
                                       name="milestoneName" 
                                       id="modalMilestoneName" 
                                       maxlength="30" 
                                       required>
                            </div>

                            <div class="mb-3">
                                <label for="milestonePriority" class="form-label">Priority</label>
                                <select class="form-select" name="milestonePriority" id="modalMilestonePriority">
                                    <option value="1">1 - Low</option>
                                    <option value="2">2 - Medium</option>
                                    <option value="3">3 - High</option>
                                    <option value="4">4 - Critical</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="milestoneEndDate" class="form-label">End Date</label>
                                <input type="date" name="milestoneEndDate" class="form-control" id="modalMilestoneEndDate" required>
                            </div>

                            <div class="mb-3">
                                <label for="milestoneStatus" class="form-label">Status</label>
                                <select class="form-select" id="modalMilestoneStatus" name="milestoneStatus">
                                    <option value="0">Closed</option>
                                    <option value="1">In Progress</option>
                                    <option value="2">Pending</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="milestoneDetails" class="form-label">Details</label>
                                <textarea name="milestoneDetails" 
                                          class="form-control" 
                                          id="modalMilestoneDetails" 
                                          rows="3" 
                                          maxlength="500" 
                                          required></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" id="button-modal-submit" class="btn btn-primary text-success">Save changes</button> 
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/bundles/libscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/mainscripts.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/bundles/dataTables.bundle.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/pages/index2.js"></script>
        <script>
                                                    $(document).ready(function () {
                                                        $('.view-details').on('click', function () {
                                                            var row = $(this).closest('tr');
                                                            var id = row.find('td:eq(0)').text();
                                                            var name = row.find('td:eq(1)').text();
                                                            var priority = row.find('td:eq(2)').text();
                                                            var endDate = row.find('td:eq(3)').text();
                                                            var statusText = row.find('td:eq(5) .badge').text().trim();
                                                            var status;
                                                            switch (statusText) {
                                                                case 'Closed':
                                                                    status = 0;
                                                                    break;
                                                                case 'In Progress':
                                                                    status = 1;
                                                                    break;
                                                                case 'Pending':
                                                                    status = 2;
                                                                    break;
                                                                default:
                                                                    status = 1;
                                                            }
                                                            var details = row.find('td:eq(4)').text() || 'No details available';

                                                            $('#modalMilestoneId').val(id);
                                                            $('#modalMilestoneName').val(name);
                                                            $('#modalMilestonePriority').val(priority);
                                                            $('#modalMilestoneEndDate').val(endDate);
                                                            $('#modalMilestoneStatus').val(status);
                                                            $('#modalMilestoneDetails').val(details.trim());

                                                            $('#milestoneDetailModal').modal('show');
                                                        });

                                                        var currentSortField = "${sortFieldName}";
                                                        var currentSortOrder = "${sortOrder}";
                                                        if (currentSortField && currentSortOrder) {
                                                            var $th = $('th[name="' + currentSortField + '"]');
                                                            $th.attr('sortBy', currentSortOrder);
                                                            $th.attr('aria-sort', currentSortOrder === 'asc' ? 'ascending' : 'descending');
                                                            $th.find('.sort-icon')
                                                                    .removeClass('fa-sort')
                                                                    .addClass(currentSortOrder === 'asc' ? 'fa-sort-up' : 'fa-sort-down');
                                                        }

                                                        $('.sortTableHead').on('click', function () {
                                                            var $th = $(this);
                                                            var name = $th.attr('name');
                                                            var sortBy = $th.attr('sortBy');// Reset all icons to default
                                                            $('.sortTableHead .sort-icon').removeClass('fa-sort-up fa-sort-down').addClass('fa-sort');
                                                            $('.sortTableHead').attr('aria-sort', 'none');

                                                            // Update only the clicked column's icon
                                                            if (sortBy === 'asc') {
                                                                sortBy = 'desc';
                                                                $th.find('.sort-icon').removeClass('fa-sort fa-sort-up').addClass('fa-sort-down');
                                                                $th.attr('aria-sort', 'descending');
                                                            } else {
                                                                sortBy = 'asc';
                                                                $th.find('.sort-icon').removeClass('fa-sort fa-sort-down').addClass('fa-sort-up');
                                                                $th.attr('aria-sort', 'ascending');
                                                            }

                                                            $th.attr('sortBy', sortBy);
                                                            changeSort(name, sortBy);
                                                        });
                                                    });

                                                    function changeSort(name, sortBy) {
                                                        $.ajax({
                                                            url: "milestone",
                                                            type: 'post',
                                                            data: {
                                                                sortBy: sortBy,
                                                                fieldName: name,
                                                                action: "sort",
                                                                page: ${page}
                                                            },
                                                            success: function (data) {
                                                                $('.tableBody').html($(data).find('.tableBody').html());
                                                                updatePagination(data);
                                                            },
                                                            error: function (xhr, status, error) {
                                                                console.error("An error occurred: " + error);
                                                                alert("An error occurred while sorting. Please try again.");
                                                            }
                                                        });
                                                    }

                                                    function updatePagination(data) {
                                                        var $newPagination = $(data).find('.pagination');
                                                        if ($newPagination.length) {
                                                            $('.pagination').replaceWith($newPagination);
                                                        }
                                                    }

                                                    history.pushState(null, "", location.href.split("?")[0]);
                                                    function searchProject() {
                                                        var searchTerm = $('#projectSearch').val();
                                                        $.ajax({
                                                            url: "milestone",
                                                            type: 'post',
                                                            data: {
                                                                action: "search",
                                                                searchKey: searchTerm,
                                                                page: 1  // Reset về trang đầu tiên khi tìm kiếm
                                                            },
                                                            success: function (data) {
                                                                $('.tableBody').html($(data).find('.tableBody').html());
                                                                updatePagination(data);
                                                            },
                                                            error: function (xhr, status, error) {
                                                                console.error("An error occurred: " + error);
                                                                alert("An error occurred while searching. Please try again.");
                                                            }
                                                        });
                                                    }
// Add form validation before submit
                                                    document.querySelector('#button-modal-submit').addEventListener('click', function (e) {
                                                        e.preventDefault(); // Prevent default form submission
                                                        console.log("dang submit");
                                                        if (validateForm()) {
                                                            console.log("validate dung")
                                                            document.querySelector('#milestoneForm').submit(); // Submit the form if validation passes
                                                        }
                                                    });

// Add real-time validation
                                                    $('#modalMilestoneName').on('input', function () {
                                                        validateInput(this, 30, 'Name');
                                                    });

                                                    $('#modalMilestoneDetails').on('input', function () {
                                                        validateInput(this, 500, 'Details');
                                                    });

                                                    function validateForm() {
                                                        // Clear previous errors
                                                        clearErrors();

                                                        const name = $('#modalMilestoneName').val().trim();
                                                        const details = $('#modalMilestoneDetails').val().trim();
                                                        let isValid = true;

                                                        // Validate name
                                                        if (!name) {
                                                            showError('modalMilestoneName', 'Name is required');
                                                            isValid = false;
                                                        } else if (name.length > 30) {
                                                            showError('modalMilestoneName', 'Name must be less than 30 characters');
                                                            isValid = false;
                                                        }

                                                        // Validate details
                                                        if (!details) {
                                                            showError('modalMilestoneDetails', 'Details is required');
                                                            isValid = false;
                                                        } else if (details.length > 500) {
                                                            showError('modalMilestoneDetails', 'Details must be less than 500 characters');
                                                            isValid = false;
                                                        }

                                                        return isValid;
                                                    }

                                                    function validateInput(element, maxLength, fieldName) {
                                                        const value = element.value.trim();
                                                        clearError(element.id);

                                                        if (!value) {
                                                            showError(element.id, `${fieldName} is required`);
                                                            return false;
                                                        } else if (value.length > maxLength) {
                                                            showError(element.id, `${fieldName} must be less than ${maxLength} characters`);
                                                            return false;
                                                        }
                                                        return true;
                                                    }

                                                    function showError(elementId, message) {
                                                        const element = document.getElementById(elementId);
                                                        // Remove any existing error for this element
                                                        clearError(elementId);

                                                        const errorDiv = document.createElement('div');
                                                        errorDiv.className = 'error-message text-danger mt-1';
                                                        errorDiv.textContent = message;
                                                        element.parentNode.appendChild(errorDiv);
                                                        element.classList.add('is-invalid');
                                                    }

                                                    function clearError(elementId) {
                                                        const element = document.getElementById(elementId);
                                                        element.classList.remove('is-invalid');
                                                        const existingError = element.parentNode.querySelector('.error-message');
                                                        if (existingError) {
                                                            existingError.remove();
                                                        }
                                                    }

                                                    function clearErrors() {
                                                        document.querySelectorAll('.error-message').forEach(el => el.remove());
                                                        document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
                                                        const formAlert = document.getElementById('formAlert');
                                                        if (formAlert)
                                                            formAlert.remove();
                                                    }

                                                    function showAlert(message) {
                                                        const existingAlert = document.getElementById('formAlert');
                                                        if (existingAlert)
                                                            existingAlert.remove();

                                                        const alertDiv = document.createElement('div');
                                                        alertDiv.id = 'formAlert';
                                                        alertDiv.className = 'alert alert-danger alert-dismissible fade show mb-3';
                                                        alertDiv.innerHTML = `
            ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;

                                                        document.querySelector('#milestoneForm').insertBefore(alertDiv, document.querySelector('#milestoneForm').firstChild);
                                                    }
        </script>
    </body>
</html>