<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
            <title>Tạo Voucher - Laptopshop</title>
            <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
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
                            <h1 class="mt-4">Tạo Voucher mới</h1>
                            <ol class="breadcrumb mb-4">
                                <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="/admin/voucher">Voucher</a></li>
                                <li class="breadcrumb-item active">Tạo mới</li>
                            </ol>
                            <div class="mt-5">
                                <div class="row">
                                    <div class="col-md-6 col-12 mx-auto">
                                        <h3>Thông tin Voucher</h3>
                                        <hr />
                                        <form:form method="post" action="/admin/voucher/create"
                                            modelAttribute="newVoucher">

                                            <div class="mb-3">
                                                <label class="form-label">Mã Voucher:</label>
                                                <form:input type="text" class="form-control" path="code"
                                                    placeholder="VD: SAVE10" required="required"
                                                    style="text-transform: uppercase;" />
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Loại giảm giá:</label>
                                                <form:select class="form-select" path="discountType">
                                                    <form:option value="PERCENT">Phần trăm (%)</form:option>
                                                    <form:option value="FIXED">Số tiền cố định (VNĐ)</form:option>
                                                </form:select>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Giá trị giảm:</label>
                                                <form:input type="number" class="form-control" path="discountValue"
                                                    step="0.01" min="0" required="required"
                                                    placeholder="VD: 10 (nếu %), hoặc 50000 (nếu cố định)" />
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Đơn hàng tối thiểu (VNĐ):</label>
                                                <form:input type="number" class="form-control" path="minOrderValue"
                                                    min="0" placeholder="0 = không giới hạn" />
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Giảm tối đa (VNĐ) - chỉ dùng cho loại %:</label>
                                                <form:input type="number" class="form-control" path="maxDiscount"
                                                    min="0" placeholder="0 = không giới hạn" />
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Giới hạn số lần sử dụng:</label>
                                                <form:input type="number" class="form-control" path="usageLimit"
                                                    min="0" placeholder="0 = không giới hạn" />
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Ngày hết hạn:</label>
                                                <form:input type="datetime-local" class="form-control"
                                                    path="expiryDate" />
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Mô tả:</label>
                                                <form:textarea class="form-control" path="description" rows="3"
                                                    placeholder="Mô tả ngắn về voucher..." />
                                            </div>

                                            <div class="mb-3 form-check">
                                                <form:checkbox class="form-check-input" path="active" />
                                                <label class="form-check-label">Kích hoạt ngay</label>
                                            </div>

                                            <button type="submit" class="btn btn-primary">Tạo Voucher</button>
                                            <a href="/admin/voucher" class="btn btn-secondary">Hủy</a>
                                        </form:form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                    <jsp:include page="../layout/footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
                crossorigin="anonymous"></script>
            <script src="js/scripts.js"></script>
        </body>

        </html>
