<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <title> Lịch sử mua hàng - Laptopshop</title>
                <meta content="width=device-width, initial-scale=1.0" name="viewport">
                <meta content="" name="keywords">
                <meta content="" name="description">

                <!-- Google Web Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
                    rel="stylesheet">

                <!-- Icon Font Stylesheet -->
                <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
                    rel="stylesheet">

                <!-- Libraries Stylesheet -->
                <link href="/client/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
                <link href="/client/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">


                <!-- Customized Bootstrap Stylesheet -->
                <link href="/client/css/bootstrap.min.css" rel="stylesheet">

                <!-- Template Stylesheet -->
                <link href="/client/css/style.css" rel="stylesheet">

                <style>
                    :root {
                        --oh-border: #e9ecef;
                        --oh-muted: #6c757d;
                        --oh-surface: #ffffff;
                        --oh-surface-soft: #f8f9fa;
                        --oh-title: #1f2937;
                    }

                    .order-history-wrap {
                        background: linear-gradient(180deg, #f8fbff 0%, #ffffff 100%);
                    }

                    .order-history-card {
                        background: var(--oh-surface);
                        border: 1px solid var(--oh-border);
                        border-radius: 20px;
                        overflow: hidden;
                        box-shadow: 0 10px 30px rgba(31, 41, 55, 0.06);
                    }

                    .order-history-table {
                        margin-bottom: 0;
                    }

                    .order-history-table thead th {
                        border: 0;
                        background: var(--oh-surface-soft);
                        color: var(--oh-muted);
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.02em;
                        font-size: 13px;
                        padding: 16px 18px;
                    }

                    .order-history-table tbody td,
                    .order-history-table tbody th {
                        vertical-align: middle;
                        border-color: var(--oh-border);
                        padding: 18px;
                    }

                    .order-summary-row {
                        background: #f1f8ff;
                    }

                    .order-summary-label {
                        color: var(--oh-title);
                        font-weight: 700;
                    }

                    .order-summary-muted {
                        color: var(--oh-muted);
                        font-weight: 600;
                    }

                    .order-product-img {
                        width: 72px;
                        height: 72px;
                        object-fit: cover;
                        border: 2px solid #ffffff;
                        box-shadow: 0 4px 14px rgba(0, 0, 0, 0.1);
                    }

                    .order-product-name a {
                        color: #2f7f1f;
                        font-weight: 700;
                        text-decoration: none;
                    }

                    .order-product-name a:hover {
                        text-decoration: underline;
                    }

                    .money-cell {
                        color: #334155;
                        font-weight: 600;
                        white-space: nowrap;
                    }

                    .quantity-pill {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        min-width: 42px;
                        height: 34px;
                        padding: 0 12px;
                        border-radius: 999px;
                        background: #eef6ff;
                        color: #1d4ed8;
                        font-weight: 700;
                        border: 1px solid #dbeafe;
                    }

                    .status-badge {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        min-width: 102px;
                        border-radius: 999px;
                        padding: 8px 14px;
                        font-size: 12px;
                        font-weight: 700;
                        letter-spacing: 0.04em;
                        text-transform: uppercase;
                    }

                    .status-complete {
                        background: #ecfdf3;
                        color: #15803d;
                        border: 1px solid #bbf7d0;
                    }

                    .status-shipping {
                        background: #eff6ff;
                        color: #1d4ed8;
                        border: 1px solid #bfdbfe;
                    }

                    .status-pending {
                        background: #fffbeb;
                        color: #b45309;
                        border: 1px solid #fde68a;
                    }

                    .status-default {
                        background: #f3f4f6;
                        color: #4b5563;
                        border: 1px solid #e5e7eb;
                    }

                    .status-cancelled {
                        background: #fef2f2;
                        color: #dc2626;
                        border: 1px solid #fecaca;
                    }

                    .btn-cancel-order {
                        display: inline-block;
                        margin-top: 6px;
                        padding: 4px 14px;
                        font-size: 12px;
                        font-weight: 600;
                        color: #dc2626;
                        background: #fff;
                        border: 1px solid #fca5a5;
                        border-radius: 999px;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .btn-cancel-order:hover {
                        background: #fef2f2;
                        border-color: #dc2626;
                    }

                    .empty-order {
                        text-align: center;
                        color: var(--oh-muted);
                        font-weight: 600;
                        padding: 40px 20px !important;
                    }

                    @media (max-width: 768px) {
                        .order-history-table thead th,
                        .order-history-table tbody td,
                        .order-history-table tbody th {
                            padding: 12px;
                        }

                        .order-product-img {
                            width: 56px;
                            height: 56px;
                        }

                        .status-badge {
                            min-width: 90px;
                            padding: 6px 10px;
                            font-size: 11px;
                        }
                    }
                </style>
            </head>

            <body>

                <!-- Spinner Start -->
                <div id="spinner"
                    class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
                    <div class="spinner-grow text-primary" role="status"></div>
                </div>
                <!-- Spinner End -->

                <jsp:include page="../layout/header.jsp" />

                <!-- Cart Page Start -->
                <div class="container-fluid py-5 order-history-wrap">
                    <div class="container py-5">
                        <div class="mb-3">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/">Home</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Lịch sử mua hàng</li>
                                </ol>
                            </nav>
                        </div>

                        <div class="order-history-card">
                            <div class="table-responsive">
                                <table class="table order-history-table">
                                <thead>
                                    <tr>
                                        <th scope="col">Sản phẩm</th>
                                        <th scope="col">Tên</th>
                                        <th scope="col">Giá cả</th>
                                        <th scope="col">Số lượng</th>
                                        <th scope="col">Thành tiền</th>
                                        <th scope="col">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${ empty orders}">
                                        <tr>
                                            <td class="empty-order" colspan="6">
                                                Không có đơn hàng nào được tạo
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="order" items="${orders}">
                                        <c:set var="orderTotalQuantity" value="0" />
                                        <c:set var="orderTotalAmount" value="0" />
                                        <c:forEach var="orderDetail" items="${order.orderDetails}">
                                            <c:set var="orderTotalQuantity"
                                                value="${orderTotalQuantity + orderDetail.quantity}" />
                                            <c:set var="orderTotalAmount"
                                                value="${orderTotalAmount + (orderDetail.price * orderDetail.quantity)}" />
                                        </c:forEach>
                                        <tr class="order-summary-row">
                                            <td class="order-summary-label" colspan="2">
                                                <c:choose>
                                                    <c:when test="${not empty order.createdAt}">
                                                        Đơn hàng ngày <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        Đơn hàng gần đây
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="order-summary-muted" colspan="1">-</td>
                                            <td colspan="1">
                                                <span class="quantity-pill">${orderTotalQuantity}</span>
                                            </td>
                                            <td class="money-cell" colspan="1">
                                                <c:choose>
                                                    <c:when test="${not empty order.voucherCode && order.discountAmount > 0}">
                                                        <small style="text-decoration: line-through; color: #999;">
                                                            <fmt:formatNumber type="number" value="${orderTotalAmount}" /> đ
                                                        </small>
                                                        <br/>
                                                        <strong style="color: #e53935;">
                                                            <fmt:formatNumber type="number" value="${order.finalPrice}" /> đ
                                                        </strong>
                                                        <br/>
                                                        <small class="text-success" style="font-size: 11px;">
                                                            <i class="fas fa-tag"></i> ${order.voucherCode}
                                                            (-<fmt:formatNumber type="number" value="${order.discountAmount}" /> đ)
                                                        </small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber type="number" value="${orderTotalAmount}" /> đ
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td colspan="1">
                                                <c:choose>
                                                    <c:when test="${order.status == 'COMPLETE'}">
                                                        <span class="status-badge status-complete">${order.status}</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'SHIPPING'}">
                                                        <span class="status-badge status-shipping">${order.status}</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'PENDING'}">
                                                        <span class="status-badge status-pending">${order.status}</span>
                                                        <br/>
                                                        <form action="/cancel-order/${order.id}" method="post" style="display:inline;"
                                                            onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này?');">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <button type="submit" class="btn-cancel-order">
                                                                <i class="fas fa-times"></i> Hủy đơn
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${order.status == 'CANCELLED'}">
                                                        <span class="status-badge status-cancelled">ĐÃ HỦY</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-default">${order.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <c:forEach var="orderDetail" items="${order.orderDetails}">
                                            <tr>
                                                <th scope="row">
                                                    <div class="d-flex align-items-center">
                                                        <img src="/images/product/${orderDetail.product.image}"
                                                            class="img-fluid me-3 rounded-circle order-product-img" alt="">
                                                    </div>
                                                </th>
                                                <td>
                                                    <p class="mb-0 order-product-name">
                                                        <a href="/product/${orderDetail.product.id}" target="_blank">
                                                            ${orderDetail.product.name}
                                                        </a>
                                                    </p>
                                                </td>
                                                <td>
                                                    <p class="mb-0 money-cell">
                                                        <fmt:formatNumber type="number" value="${orderDetail.price}" />
                                                        đ
                                                    </p>
                                                </td>
                                                <td>
                                                    <span class="quantity-pill">${orderDetail.quantity}</span>
                                                </td>
                                                <td>
                                                    <p class="mb-0 money-cell">
                                                        <fmt:formatNumber type="number"
                                                            value="${orderDetail.price * orderDetail.quantity}" /> đ
                                                    </p>
                                                </td>
                                                <td></td>

                                            </tr>
                                        </c:forEach>
                                        <c:if test="${not empty order.voucherCode && order.discountAmount > 0}">
                                            <tr style="background: #f8fff8;">
                                                <td colspan="4" class="text-end" style="font-weight: 600; color: #555;">
                                                    Tạm tính:
                                                </td>
                                                <td class="money-cell">
                                                    <fmt:formatNumber type="number" value="${orderTotalAmount}" /> đ
                                                </td>
                                                <td></td>
                                            </tr>
                                            <tr style="background: #f0fdf4;">
                                                <td colspan="4" class="text-end" style="font-weight: 600; color: #15803d;">
                                                    <i class="fas fa-tag"></i> Giảm giá (${order.voucherCode}):
                                                </td>
                                                <td class="money-cell" style="color: #15803d;">
                                                    -<fmt:formatNumber type="number" value="${order.discountAmount}" /> đ
                                                </td>
                                                <td></td>
                                            </tr>
                                            <tr style="background: #fff5f5;">
                                                <td colspan="4" class="text-end" style="font-weight: 700; color: #e53935;">
                                                    Tổng thanh toán:
                                                </td>
                                                <td class="money-cell" style="color: #e53935; font-weight: 700; font-size: 16px;">
                                                    <fmt:formatNumber type="number" value="${order.finalPrice}" /> đ
                                                </td>
                                                <td></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>

                                </tbody>
                                </table>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- Cart Page End -->


                <jsp:include page="../layout/footer.jsp" />


                <!-- Back to Top -->
                <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i
                        class="fa fa-arrow-up"></i></a>


                <!-- JavaScript Libraries -->
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="/client/lib/easing/easing.min.js"></script>
                <script src="/client/lib/waypoints/waypoints.min.js"></script>
                <script src="/client/lib/lightbox/js/lightbox.min.js"></script>
                <script src="/client/lib/owlcarousel/owl.carousel.min.js"></script>

                <!-- Template Javascript -->
                <script src="/client/js/main.js"></script>
            </body>

            </html>