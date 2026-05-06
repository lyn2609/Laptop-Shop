<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Chi tiết đơn hàng - Laptopshop</title>
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
                        <li class="breadcrumb-item"><a href="/order-history">Lịch sử đơn hàng</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Chi tiết: #ORD-${order.id}</li>
                    </ol>
                </nav>
            </div>
            
            <div class="row">
                <div class="col-md-3">
                    <div class="card mb-4">
                        <div class="card-header text-center">
                            <h5>Tài khoản của bạn</h5>
                        </div>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item"><a href="/profile" class="text-dark">Quản lý hồ sơ</a></li>
                            <li class="list-group-item"><a href="/profile/change-password" class="text-dark">Đổi mật khẩu</a></li>
                            <li class="list-group-item active"><a href="/order-history" class="text-white">Lịch sử đơn hàng</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Chi tiết đơn hàng #ORD-${order.id}</h5>
                            <span class="badge bg-secondary p-2">${order.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-sm-6">
                                    <h6 class="mb-3">Người nhận:</h6>
                                    <div><strong>${order.receiverName}</strong></div>
                                    <div>SĐT: ${order.receiverPhone}</div>
                                    <div>Địa chỉ: ${order.receiverAddress}</div>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th>Giá</th>
                                            <th>Số lượng</th>
                                            <th class="text-end">Tạm tính</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${orderDetails}" var="detail">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="/images/product/${detail.product.image}" alt="" style="width: 50px; height: 50px; object-fit: cover;" class="me-3 rounded">
                                                        <a href="/product/${detail.product.id}">${detail.product.name}</a>
                                                    </div>
                                                </td>
                                                <td><fmt:formatNumber value="${detail.price}" type="number"/> đ</td>
                                                <td>${detail.quantity}</td>
                                                <td class="text-end fw-bold"><fmt:formatNumber value="${detail.price * detail.quantity}" type="number"/> đ</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="3" class="text-end"><strong>Tổng cộng:</strong></td>
                                            <td class="text-end text-danger fw-bold fs-5"><fmt:formatNumber value="${order.totalPrice}" type="number"/> đ</td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
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
</body>
</html>
