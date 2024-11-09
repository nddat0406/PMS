<%-- 
    Document   : SettingDetails
    Created on : Sep 23, 2024, 5:53:48 AM
    Author     : Admin
--%>

<%-- 
    Document   : SettingDetails
    Created on : Sep 23, 2024, 5:53:48 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Setting Details</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Lucid HR & Project Admin Dashboard Template with Bootstrap 5x">
    <meta name="author" content="WrapTheme, design by: ThemeMakker.com">
    
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    
    <!-- MAIN CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
        .error-message {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }
        
        .form-control.error {
            border-color: #dc3545;
            padding-right: calc(1.5em + 0.75rem);
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(0.375em + 0.1875rem) center;
            background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
        }
        
        .form-control.valid {
            border-color: #198754;
            padding-right: calc(1.5em + 0.75rem);
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='M2.3 6.73L.6 4.53c-.4-1.04.46-1.4 1.1-.8l1.1 1.4 3.4-3.8c.6-.63 1.6-.27 1.2.7l-4 4.6c-.43.5-.8.4-1.1.1z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(0.375em + 0.1875rem) center;
            background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
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
                                <h2 class="m-0 fs-5">
                                    <a href="javascript:void(0);" class="btn btn-sm btn-link ps-0 btn-toggle-fullwidth">
                                        <i class="fa fa-arrow-left"></i></a> Setting Details
                                </h2>
                                <ul class="breadcrumb mb-0">
                                    <li class="breadcrumb-item"><a href="index.html">Lucid</a></li>
                                    <li class="breadcrumb-item">Settings</li>
                                    <li class="breadcrumb-item active">Setting Details</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="row g-2">
                        <div class="col-lg-4 col-md-12">
                            <div class="card mb-2">
                                <div class="card-body">
                                    <h6 class="card-title mb-4">${settingDetail.name}</h6>
                                    <p>${settingDetail.description}</p>
                                </div>
                            </div>

                            <div class="card mb-2">
                                <div class="card-body">
                                    <ul class="list-unstyled basic-list mb-0">
                                        <li class="d-flex justify-content-between">Status:                   
                                            <c:choose>
                                                <c:when test="${settings.status == true}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-8 col-md-12">
                            <div class="card mb-2">
                                <div class="card-header">
                                    <h6 class="card-title">Edit Setting</h6>
                                </div>
                                <div class="card-body">
                                    <form id="formeditadd" action="settings" method="post">
                                        <input type="hidden" name="action" value="${settings != null ? 'update' : 'add'}">
                                        <input type="hidden" name="id" value="${settings != null ? settings.id : ''}">
                                        
                                        <div class="mb-3">
                                            <label for="name" class="form-label">Name</label>
                                            <input type="text" class="form-control" name="name" id="name" value="${settings != null ? settings.name : ''}" >
                                        </div>

                                        <div class="mb-3">
                                            <label for="type" class="form-label">Type</label>
                                            <select name="type" id="type" class="form-control" >
                                                <option value="1" ${settings.type == 1 ? 'selected' : ''}>Type 1</option>
                                                <option value="2" ${settings.type == 2 ? 'selected' : ''}>Type 2</option>
                                                <option value="3" ${settings.type == 3 ? 'selected' : ''}>Type 3</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="priority" class="form-label">Priority</label>
                                            <input type="number" class="form-control" name="priority" id="priority" >
                                        </div>

                                        <div class="mb-3">
                                            <label for="status" class="form-label">Status</label>
                                            <select name="status" id="status" class="form-control">
                                                <option value="1" ${settings.status == true ? 'selected' : ''}>Active</option>
                                                <option value="0" ${settings.status == false ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="description" class="form-label">Description</label>
                                            <textarea class="form-control" name="description" id="description" rows="3">${settings != null ? settings.description : ''}</textarea>
                                        </div>

                                        <button type="submit" class="btn btn-primary">${settings != null ? 'Update Setting' : 'Add Setting'}</button>
                                    </form>
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
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('#formeditadd');
            
            // Add error message elements after each form control
            const formControls = form.querySelectorAll('.form-control');
            formControls.forEach(control => {
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.id = control.id + '-error'; // Changed to use plus operator
                control.parentNode.insertBefore(errorDiv, control.nextSibling);
            });
        
            // Validation rules
            const validators = {
                name: {
                    validate: (value) => {
                        if (!value.trim()) return 'Name is required';
                        if (value.length < 2) return 'Name must be at least 2 characters';
                        if (value.length > 50) return 'Name cannot exceed 50 characters';
                        return '';
                    }
                },
                type: {
                    validate: (value) => {
                        if (!value) return 'Type is required';
                        if (!['1', '2', '3'].includes(value)) return 'Please select a valid type';
                        return '';
                    }
                },
                priority: {
                    validate: (value) => {
                        if (!value) return 'Priority is required';
                        if (isNaN(value)) return 'Priority must be a number';
                        if (value < 1) return 'Priority must be greater than 0';
                        if (value > 100) return 'Priority cannot exceed 100';
                        return '';
                    }
                },
                status: {
                    validate: (value) => {
                        if (value === '') return 'Status is required';
                        if (!['0', '1'].includes(value)) return 'Please select a valid status';
                        return '';
                    }
                },
                description: {
                    validate: (value) => {
                        if (!value.trim()) return 'Description is required';
                        if (value.length < 10) return 'Description must be at least 10 characters';
                        if (value.length > 500) return 'Description cannot exceed 500 characters';
                        return '';
                    }
                }
            };
        
            // Validate single field
            function validateField(field) {
                const validator = validators[field.id];
                if (!validator) return true;
        
                const errorDiv = document.getElementById(field.id + '-error'); // Changed to use plus operator
                const errorMessage = validator.validate(field.value);
                
                if (errorMessage) {
                    field.classList.add('error');
                    field.classList.remove('valid');
                    errorDiv.textContent = errorMessage;
                    errorDiv.style.display = 'block';
                    return false;
                } else {
                    field.classList.remove('error');
                    field.classList.add('valid');
                    errorDiv.style.display = 'none';
                    return true;
                }
            }
        
            // Add input event listeners for real-time validation
            formControls.forEach(field => {
                field.addEventListener('input', () => validateField(field));
                field.addEventListener('blur', () => validateField(field));
            });
        
            // Form submission handler
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                
                let isValid = true;
                formControls.forEach(field => {
                    if (!validateField(field)) {
                        isValid = false;
                    }
                });
        
                if (isValid) {
                    // If all validations pass, submit the form
                    this.submit();
                } else {
                    // Focus the first field with an error
                    const firstError = form.querySelector('.form-control.error');
                    if (firstError) {
                        firstError.focus();
                    }
                }
            });
        });
        </script>
</body>
</html>
