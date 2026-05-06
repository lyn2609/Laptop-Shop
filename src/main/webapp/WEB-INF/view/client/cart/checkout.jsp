<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <title> Thanh toán - Laptopshop</title>
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
                    <div class="container-fluid py-5">
                        <div class="container py-5">
                            <div class="mb-3">
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item"><a href="/">Home</a></li>
                                        <li class="breadcrumb-item active" aria-current="page">Thông tin thanh toán</li>
                                    </ol>
                                </nav>
                            </div>

                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th scope="col">Sản phẩm</th>
                                            <th scope="col">Tên</th>
                                            <th scope="col">Giá cả</th>
                                            <th scope="col">Số lượng</th>
                                            <th scope="col">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${ empty cartDetails}">
                                            <tr>
                                                <td colspan="6">
                                                    Không có sản phẩm trong giỏ hàng
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="cartDetail" items="${cartDetails}">

                                            <tr>
                                                <th scope="row">
                                                    <div class="d-flex align-items-center">
                                                        <img src="/images/product/${cartDetail.product.image}"
                                                            class="img-fluid me-5 rounded-circle"
                                                            style="width: 80px; height: 80px;" alt="">
                                                    </div>
                                                </th>
                                                <td>
                                                    <p class="mb-0 mt-4">
                                                        <a href="/product/${cartDetail.product.id}" target="_blank">
                                                            ${cartDetail.product.name}
                                                        </a>
                                                    </p>
                                                </td>
                                                <td>
                                                    <p class="mb-0 mt-4">
                                                        <fmt:formatNumber type="number" value="${cartDetail.price}" /> đ
                                                    </p>
                                                </td>
                                                <td>
                                                    <div class="input-group quantity mt-4" style="width: 100px;">
                                                        <input type="text"
                                                            class="form-control form-control-sm text-center border-0"
                                                            value="${cartDetail.quantity}">
                                                    </div>
                                                </td>
                                                <td>
                                                    <p class="mb-0 mt-4" data-cart-detail-id="${cartDetail.id}">
                                                        <fmt:formatNumber type="number"
                                                            value="${cartDetail.price * cartDetail.quantity}" /> đ
                                                    </p>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${not empty cartDetails}">
                                <form:form action="/place-order" method="post" modelAttribute="cart">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <input type="hidden" name="voucherCode" id="voucherCodeInput" value="" />
                                    <div class="mt-5 row g-4 justify-content-start">
                                        <div class="col-12 col-md-6">
                                            <div class="p-4 ">
                                                <h5>Thông Tin Người Nhận
                                                </h5>
                                                <div class="row">
                                                    <div class="col-12 form-group mb-3">
                                                        <label>Tên người nhận</label>
                                                        <input class="form-control" name="receiverName" required />
                                                    </div>
                                                    <div class="col-12 form-group mb-3">
                                                        <label>Địa chỉ người nhận</label>
                                                        <input class="form-control" name="receiverAddress" required />
                                                    </div>
                                                    <div class="col-12 form-group mb-3">
                                                        <label>Số điện thoại</label>
                                                        <input class="form-control" name="receiverPhone" required />
                                                    </div>
                                                    <div class="mt-4">
                                                        <i class="fas fa-arrow-left"></i>
                                                        <a href="/cart">Quay lại giỏ hàng</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <div class="bg-light rounded">
                                                <div class="p-4">
                                                    <h1 class="display-6 mb-4">Thông Tin <span class="fw-normal">Thanh
                                                            Toán</span>
                                                    </h1>

                                                    <div class="d-flex justify-content-between">
                                                        <h5 class="mb-0 me-4">Phí vận chuyển</h5>
                                                        <div class="">
                                                            <p class="mb-0">0 đ</p>
                                                        </div>
                                                    </div>
                                                    <div class="mt-3 d-flex justify-content-between align-items-center border-top pt-3">
                                                        <h5 class="mb-0 me-4">Phương thức thanh toán</h5>
                                                        <div class="text-end">
                                                            <div class="form-check text-start">
                                                                <input class="form-check-input" type="radio" name="paymentMethod" id="paymentCOD" value="COD" checked>
                                                                <label class="form-check-label" for="paymentCOD">
                                                                    Thanh toán khi nhận hàng (COD)
                                                                </label>
                                                            </div>
                                                            <div class="form-check text-start">
                                                                <input class="form-check-input" type="radio" name="paymentMethod" id="paymentVNPAY" value="VNPAY">
                                                                <label class="form-check-label" for="paymentVNPAY">
                                                                    Thanh toán qua VNPay
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Voucher Section - tự động hiển thị danh sách -->
                                                    <div class="mt-3 pt-3 border-top">
                                                        <h5 class="mb-3">
                                                            <i class="fa fa-tag text-warning me-2"></i>Mã giảm giá khả dụng
                                                        </h5>

                                                        <c:choose>
                                                            <c:when test="${empty availableVouchers}">
                                                                <div class="alert alert-light border small mb-2"
                                                                    style="background-color: #f8f9fa;">
                                                                    <i class="fa fa-info-circle me-1"></i>
                                                                    Hiện chưa có mã giảm giá khả dụng cho đơn hàng này.
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="voucher-list mb-2"
                                                                    style="max-height: 280px; overflow-y: auto;">
                                                                    <c:forEach var="v" items="${availableVouchers}">
                                                                        <div class="voucher-item card mb-2"
                                                                            style="cursor: pointer; transition: all 0.2s;"
                                                                            data-voucher-code="${v.code}"
                                                                            onclick="selectVoucher('${v.code}', this)">
                                                                            <div class="card-body p-3">
                                                                                <div class="d-flex justify-content-between align-items-start">
                                                                                    <div>
                                                                                        <div class="fw-bold text-primary mb-1">
                                                                                            <i class="fa fa-ticket-alt me-1"></i>
                                                                                            ${v.code}
                                                                                        </div>
                                                                                        <c:choose>
                                                                                            <c:when test="${v.discountType == 'PERCENT'}">
                                                                                                <div class="small text-success mb-1">
                                                                                                    Giảm
                                                                                                    <fmt:formatNumber value="${v.discountValue}" pattern="0.#" />%
                                                                                                    <c:if test="${v.maxDiscount > 0}">
                                                                                                        (tối đa
                                                                                                        <fmt:formatNumber value="${v.maxDiscount}" type="number" />đ)
                                                                                                    </c:if>
                                                                                                </div>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <div class="small text-success mb-1">
                                                                                                    Giảm
                                                                                                    <fmt:formatNumber value="${v.discountValue}" type="number" />đ
                                                                                                </div>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                        <c:if test="${v.minOrderValue > 0}">
                                                                                            <div class="small text-muted">
                                                                                                Đơn tối thiểu:
                                                                                                <fmt:formatNumber value="${v.minOrderValue}" type="number" />đ
                                                                                            </div>
                                                                                        </c:if>
                                                                                        <c:if test="${not empty v.description}">
                                                                                            <div class="small text-muted mt-1">
                                                                                                ${v.description}
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </div>
                                                                                    <button type="button"
                                                                                        class="btn btn-sm btn-outline-primary voucher-select-btn">
                                                                                        Chọn
                                                                                    </button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </c:forEach>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <div id="voucherMessage" style="display: none;"
                                                            class="small mb-2"></div>
                                                        <div id="discountRow" style="display: none;"
                                                            class="d-flex justify-content-between text-success">
                                                            <span>Giảm giá:</span>
                                                            <span id="discountDisplay">0 đ</span>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div
                                                    class="py-4 mb-4 border-top border-bottom d-flex justify-content-between">
                                                    <h5 class="mb-0 ps-4 me-4">Tổng số tiền</h5>
                                                    <p class="mb-0 pe-4" id="finalPriceDisplay"
                                                        data-cart-total-price="${totalPrice}">
                                                        <fmt:formatNumber type="number" value="${totalPrice}" /> đ
                                                    </p>
                                                </div>

                                                <button id="btnSubmitOrder"
                                                    class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mb-4 ms-4">
                                                    Xác nhận thanh toán
                                                </button>

                                            </div>
                                        </div>
                                    </div>
                                </form:form>
                            </c:if>

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

                    <script>
                        $(document).ready(function () {
                            function formatCurrency(num) {
                                return new Intl.NumberFormat('vi-VN').format(Math.round(num));
                            }

                            // Update submit button text based on payment method
                            $('input[type=radio][name=paymentMethod]').change(function() {
                                if (this.value === 'VNPAY') {
                                    $('#btnSubmitOrder').text('Xác nhận & Thanh toán VNPay');
                                } else {
                                    $('#btnSubmitOrder').text('Xác nhận thanh toán');
                                }
                            });

                            var originalTotal = parseFloat($('#finalPriceDisplay').data('cart-total-price')) || 0;
                            var csrfToken = $('meta[name="_csrf"]').attr('content') || $('input[name="_csrf"]').val();
                            var csrfHeader = $('meta[name="_csrf_header"]').attr('content') || 'X-CSRF-TOKEN';
                            var currentSelectedVoucher = null;

                            // NEW: Hàm chọn voucher khi click
                            window.selectVoucher = function(code, element) {
                                var msgDiv = $('#voucherMessage');
                                var discountRow = $('#discountRow');

                                // Toggle: click lại để bỏ chọn
                                if (currentSelectedVoucher === code) {
                                    currentSelectedVoucher = null;
                                    $('.voucher-item').removeClass('border-primary').css('border-width', '1px');
                                    $('.voucher-select-btn').removeClass('btn-primary').addClass('btn-outline-primary').text('Chọn');
                                    msgDiv.hide();
                                    discountRow.hide();
                                    $('#voucherCodeInput').val('');
                                    $('#finalPriceDisplay').text(formatCurrency(originalTotal) + ' đ');
                                    return;
                                }

                                var headers = {};
                                headers[csrfHeader] = csrfToken;

                                $.ajax({
                                    url: '/api/voucher/validate',
                                    type: 'POST',
                                    contentType: 'application/json',
                                    headers: headers,
                                    data: JSON.stringify({
                                        code: code,
                                        orderTotal: originalTotal
                                    }),
                                    success: function (res) {
                                        if (res.valid) {
                                            // Reset all
                                            $('.voucher-item').removeClass('border-primary').css('border-width', '1px');
                                            $('.voucher-select-btn').removeClass('btn-primary').addClass('btn-outline-primary').text('Chọn');

                                            // Highlight selected
                                            $(element).addClass('border-primary').css('border-width', '2px');
                                            $(element).find('.voucher-select-btn').removeClass('btn-outline-primary').addClass('btn-primary').text('Đã chọn');

                                            currentSelectedVoucher = code;
                                            msgDiv.text(res.message).removeClass('text-danger').addClass('text-success').show();
                                            discountRow.show();
                                            $('#discountDisplay').text('-' + formatCurrency(res.discountAmount) + ' đ');
                                            $('#finalPriceDisplay').text(formatCurrency(res.finalPrice) + ' đ');
                                            $('#voucherCodeInput').val(code.toUpperCase());
                                        } else {
                                            msgDiv.text(res.message).removeClass('text-success').addClass('text-danger').show();
                                            discountRow.hide();
                                            $('#finalPriceDisplay').text(formatCurrency(originalTotal) + ' đ');
                                            $('#voucherCodeInput').val('');
                                        }
                                    },
                                    error: function () {
                                        msgDiv.text('Lỗi khi kiểm tra voucher.').removeClass('text-success').addClass('text-danger').show();
                                    }
                                });
                            };
                        });
                    </script>
                </body>

                </html>