<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Đổi mật khẩu - Laptopshop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/client/css/bootstrap.min.css" rel="stylesheet">
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
                        <li class="breadcrumb-item active" aria-current="page">Đổi mật khẩu</li>
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
                            <li class="list-group-item"><a href="/profile" class="text-dark">Quản lý hồ sơ</a></li>
                            <li class="list-group-item active"><a href="/profile/change-password" class="text-white">Đổi mật khẩu</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Đổi mật khẩu</h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success">${successMessage}</div>
                            </c:if>
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger">${errorMessage}</div>
                            </c:if>

                            <c:if test="${canChangePassword}">
                                <form action="/profile/change-password" method="POST">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Mật khẩu cũ</label>
                                        <input type="password" class="form-control" name="oldPassword" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Mật khẩu mới</label>
                                        <input type="password" class="form-control" name="newPassword" id="newPassword" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Xác nhận mật khẩu mới</label>
                                        <input type="password" class="form-control" name="confirmPassword" required oninput="checkPasswordMatch(this);">
                                    </div>
                                    <button type="submit" class="btn btn-primary">Xác nhận</button>
                                </form>
                            </c:if>
                            <c:if test="${not canChangePassword}">
                                <div class="alert alert-warning">Bạn đang đăng nhập bằng tài khoản mạng xã hội (${user.authProvider}), nên không thể đổi mật khẩu tại đây.</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/client/js/main.js"></script>

    <script type="text/javascript">
        function checkPasswordMatch(fieldConfirmPassword) {
            const newPassword = document.getElementById("newPassword").value;
            if (fieldConfirmPassword.value !== newPassword) {
                fieldConfirmPassword.setCustomValidity("Mật khẩu xác nhận không khớp!");
            } else {
                fieldConfirmPassword.setCustomValidity("");
            }
        }
    </script>
</body>
</html>
