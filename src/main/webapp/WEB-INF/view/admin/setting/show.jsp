<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="Cài đặt Admin - Laptopshop" />
    <title>Cài đặt - Admin</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>

<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Cài đặt tài khoản</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Settings</li>
                    </ol>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="row">
                        <div class="col-xl-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-user me-1"></i> Thông tin cá nhân
                                </div>
                                <div class="card-body">
                                    <form action="/admin/setting/update-info" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Email</label>
                                            <input type="email" class="form-control" value="${admin.email}" disabled />
                                            <small class="text-muted">Email không thể thay đổi</small>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Họ và tên <span class="text-danger">*</span></label>
                                            <input type="text" name="fullName" class="form-control"
                                                value="${admin.fullName}" required />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Số điện thoại</label>
                                            <input type="text" name="phone" class="form-control"
                                                value="${admin.phone}" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Địa chỉ</label>
                                            <input type="text" name="address" class="form-control"
                                                value="${admin.address}" />
                                        </div>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Cập nhật thông tin
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-lock me-1"></i> Đổi mật khẩu
                                </div>
                                <div class="card-body">
                                    <form action="/admin/setting/change-password" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                                            <input type="password" name="oldPassword" class="form-control" required />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Mật khẩu mới <span class="text-danger">*</span></label>
                                            <input type="password" name="newPassword" class="form-control"
                                                required minlength="6" />
                                            <small class="text-muted">Tối thiểu 6 ký tự</small>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                                            <input type="password" name="confirmPassword" class="form-control"
                                                required minlength="6" />
                                        </div>
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                        </button>
                                    </form>
                                </div>
                            </div>
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-info-circle me-1"></i> Thông tin tài khoản
                                </div>
                                <div class="card-body">
                                    <p><strong>Vai trò:</strong>
                                        <span class="badge bg-danger">${admin.role.name}</span>
                                    </p>
                                    <p><strong>ID tài khoản:</strong> #${admin.id}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>

</html>
