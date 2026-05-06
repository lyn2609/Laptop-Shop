<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Hồ sơ cá nhân - Laptopshop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap" rel="stylesheet">
    <!-- Icon Font Stylesheet -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Customized Bootstrap Stylesheet -->
    <link href="/client/css/bootstrap.min.css" rel="stylesheet">
    <!-- Template Stylesheet -->
    <link href="/client/css/style.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />

    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="mb-3 mt-5">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Hồ sơ cá nhân</li>
                    </ol>
                </nav>
            </div>
            
            <div class="row">
                <div class="col-md-3">
                    <div class="card">
                        <div class="card-header text-center">
                            <h5>Tài khoản của bạn</h5>
                        </div>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item active"><a href="/profile" class="text-white">Quản lý hồ sơ</a></li>
                            <li class="list-group-item"><a href="/profile/change-password" class="text-dark">Đổi mật khẩu</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Hồ sơ cá nhân</h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success">${successMessage}</div>
                            </c:if>
                            <form action="/profile/update" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                
                                <div class="mb-3 text-center">
                                    <c:choose>
                                        <c:when test="${not empty user.avatar and user.avatar ne 'avatar.jpg'}">
                                            <img src="/images/avatar/${user.avatar}" alt="Avatar" class="img-thumbnail rounded-circle" style="width: 150px; height: 150px;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="/client/img/avatar.jpg" alt="Avatar" class="img-thumbnail rounded-circle" style="width: 150px; height: 150px;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Email (Không thể thay đổi)</label>
                                    <input type="email" class="form-control" name="email" value="${user.email}" disabled>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Họ và Tên</label>
                                    <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" name="phone" value="${user.phone}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <input type="text" class="form-control" name="address" value="${user.address}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Thay đổi Ảnh đại diện</label>
                                    <input type="file" class="form-control" name="avatarFile" accept="image/*">
                                </div>
                                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <!-- JavaScript Libraries -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/client/js/main.js"></script>
</body>
</html>
