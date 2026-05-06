<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Thanh Toán Thất Bại - Laptopshop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

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

    <!-- Single Page Header start -->
    <div class="container-fluid page-header py-5">
        <h1 class="text-center text-white display-6">Thanh Toán Thất Bại</h1>
        <ol class="breadcrumb justify-content-center mb-0">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item active text-white">Thất Bại</li>
        </ol>
    </div>
    <!-- Single Page Header End -->

    <div class="container-fluid py-5 mt-5 text-center">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <i class="fas fa-times-circle text-danger mb-4" style="font-size: 80px;"></i>
                    <h2 class="mb-4">Rất tiếc!</h2>
                    <p class="mb-4 text-danger">${error}</p>
                    <p class="mb-4">Bạn có thể quay lại giỏ hàng và thử phương thức thanh toán khác.</p>
                    <a href="/cart" class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase">
                        Quay lại giỏ hàng
                    </a>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <!-- JavaScript Libraries -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Template Javascript -->
    <script src="/client/js/main.js"></script>
</body>

</html>
