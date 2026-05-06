<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <title>Sản Phẩm - Laptopshop</title>
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
                        .page-link.disabled {
                            color: var(--bs-pagination-disabled-color);
                            pointer-events: none;
                            background-color: var(--bs-pagination-disabled-bg);
                        }

                        /* ================= PRODUCT GRID ================= */

                        .product-col {
                            display: flex;
                        }

                        .fruite-item {
                            width: 100%;
                            height: 390px;
                            display: flex;
                            flex-direction: column;
                            background-color: #fff;
                            overflow: hidden;
                            transition: transform 0.2s ease, box-shadow 0.2s ease;
                        }

                        .fruite-item:hover {
                            transform: translateY(-4px);
                            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
                        }

                        .fruite-img {
                            width: 100%;
                            height: 175px;
                            overflow: hidden;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            background-color: #fff;
                            flex-shrink: 0;
                        }

                        .fruite-img img {
                            width: 100%;
                            height: 100%;
                            object-fit: cover;
                            display: block;
                        }

                        .fruite-item .card-body {
                            flex: 1;
                            display: flex;
                            flex-direction: column;
                            padding: 16px;
                        }

                        .product-name {
                            font-size: 15px;
                            font-weight: 600;
                            line-height: 1.35;
                            height: 42px;
                            margin-bottom: 10px;

                            display: -webkit-box;
                            -webkit-line-clamp: 2;
                            -webkit-box-orient: vertical;

                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .product-name a {
                            color: #333;
                            text-decoration: none;
                        }

                        .product-name a:hover {
                            color: #81c408;
                        }

                        .product-desc {
                            font-size: 13px;
                            color: #777;
                            line-height: 1.4;
                            height: 20px;
                            margin-bottom: 10px;

                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .product-price {
                            font-size: 16px;
                            font-weight: 700;
                            color: #e74c3c;
                            margin-bottom: 14px;
                        }

                        .product-action {
                            margin-top: auto;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            gap: 10px;
                        }

                        .product-action form {
                            margin: 0;
                        }

                        .product-action .btn {
                            width: 46px;
                            height: 38px;
                            padding: 0;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .product-badge {
                            top: 10px;
                            left: 10px;
                            z-index: 2;
                        }

                        @media (max-width: 768px) {
                            .fruite-item {
                                height: 380px;
                            }

                            .fruite-img {
                                height: 170px;
                            }
                        }
                    </style>
                </head>

                <body>

                    <!-- Spinner Start -->
                    <div id="spinner"
                        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50 d-flex align-items-center justify-content-center">
                        <div class="spinner-grow text-primary" role="status"></div>
                    </div>
                    <!-- Spinner End -->

                    <jsp:include page="../layout/header.jsp" />

                    <!-- Product List Start -->
                    <div class="container-fluid py-5 mt-5">
                        <div class="container py-5">

                            <div class="row g-4 mb-5">

                                <div class="col-12">
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item">
                                                <a href="/">Home</a>
                                            </li>
                                            <li class="breadcrumb-item active" aria-current="page">
                                                Danh Sách Sản Phẩm
                                            </li>
                                        </ol>
                                    </nav>
                                </div>

                                <div class="row g-4 fruite">

                                    <!-- FILTER START -->
                                    <div class="col-12 col-md-4">
                                        <div class="row g-4">

                                            <div class="col-12" id="factoryFilter">
                                                <div class="mb-2">
                                                    <b>Hãng sản xuất</b>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-1"
                                                        value="APPLE">
                                                    <label class="form-check-label" for="factory-1">Apple</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-2"
                                                        value="ASUS">
                                                    <label class="form-check-label" for="factory-2">Asus</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-3"
                                                        value="LENOVO">
                                                    <label class="form-check-label" for="factory-3">Lenovo</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-4"
                                                        value="DELL">
                                                    <label class="form-check-label" for="factory-4">Dell</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-5"
                                                        value="LG">
                                                    <label class="form-check-label" for="factory-5">LG</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-6"
                                                        value="ACER">
                                                    <label class="form-check-label" for="factory-6">Acer</label>
                                                </div>
                                            </div>

                                            <div class="col-12" id="targetFilter">
                                                <div class="mb-2">
                                                    <b>Mục đích sử dụng</b>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="target-1"
                                                        value="GAMING">
                                                    <label class="form-check-label" for="target-1">Gaming</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="target-2"
                                                        value="SINHVIEN-VANPHONG">
                                                    <label class="form-check-label" for="target-2">Sinh viên - văn
                                                        phòng</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="target-3"
                                                        value="THIET-KE-DO-HOA">
                                                    <label class="form-check-label" for="target-3">Thiết kế đồ
                                                        họa</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="target-4"
                                                        value="MONG-NHE">
                                                    <label class="form-check-label" for="target-4">Mỏng nhẹ</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="target-5"
                                                        value="DOANH-NHAN">
                                                    <label class="form-check-label" for="target-5">Doanh nhân</label>
                                                </div>
                                            </div>

                                            <div class="col-12" id="priceFilter">
                                                <div class="mb-2">
                                                    <b>Mức giá</b>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="price-2"
                                                        value="duoi-20-trieu">
                                                    <label class="form-check-label" for="price-2">Dưới 20 triệu</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="price-3"
                                                        value="20-25-trieu">
                                                    <label class="form-check-label" for="price-3">Từ 20 - 25
                                                        triệu</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="price-4"
                                                        value="25-30-trieu">
                                                    <label class="form-check-label" for="price-4">Từ 25 - 30
                                                        triệu</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="price-5"
                                                        value="tren-30-trieu">
                                                    <label class="form-check-label" for="price-5">Trên 30 triệu</label>
                                                </div>
                                            </div>

                                            <div class="col-12" id="ramFilter">
                                                <div class="mb-2">
                                                    <b>RAM</b>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="ram-1"
                                                        value="8GB">
                                                    <label class="form-check-label" for="ram-1">8GB</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="ram-2"
                                                        value="16GB">
                                                    <label class="form-check-label" for="ram-2">16GB</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="ram-3"
                                                        value="32GB">
                                                    <label class="form-check-label" for="ram-3">32GB</label>
                                                </div>
                                            </div>

                                            <div class="col-12" id="cpuFilter">
                                                <div class="mb-2">
                                                    <b>CPU</b>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="cpu-1"
                                                        value="Core i3">
                                                    <label class="form-check-label" for="cpu-1">Core i3</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="cpu-2"
                                                        value="Core i5">
                                                    <label class="form-check-label" for="cpu-2">Core i5</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="cpu-3"
                                                        value="Core i7">
                                                    <label class="form-check-label" for="cpu-3">Core i7</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="cpu-4"
                                                        value="Ryzen 5">
                                                    <label class="form-check-label" for="cpu-4">Ryzen 5</label>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <div class="mb-2">
                                                    <b>Sắp xếp</b>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-1"
                                                        value="gia-tang-dan" name="radio-sort">
                                                    <label class="form-check-label" for="sort-1">Giá tăng dần</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-2"
                                                        value="gia-giam-dan" name="radio-sort">
                                                    <label class="form-check-label" for="sort-2">Giá giảm dần</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-3"
                                                        value="gia-nothing" name="radio-sort" checked>
                                                    <label class="form-check-label" for="sort-3">Không sắp xếp</label>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <button
                                                    class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mb-4"
                                                    id="btnFilter">
                                                    Lọc Sản Phẩm
                                                </button>
                                            </div>

                                        </div>
                                    </div>
                                    <!-- FILTER END -->

                                    <!-- PRODUCT LIST START -->
                                    <div class="col-12 col-md-8 text-center">

                                        <div class="row g-4">

                                            <c:if test="${totalPages == 0}">
                                                <div class="col-12">
                                                    Không tìm thấy sản phẩm
                                                </div>
                                            </c:if>

                                            <c:forEach var="product" items="${products}">
                                                <div class="col-md-6 col-lg-4 product-col">

                                                    <div
                                                        class="rounded position-relative fruite-item border border-secondary">

                                                        <div class="fruite-img rounded-top"
                                                            style="<c:if test='${product.quantity <= 0}'>opacity: 0.5;</c:if>">
                                                            <img src="/images/product/${product.image}"
                                                                alt="${product.name}">
                                                        </div>

                                                        <c:choose>
                                                            <c:when test="${product.quantity <= 0}">
                                                                <div
                                                                    class="product-badge text-white bg-danger px-3 py-1 rounded position-absolute">
                                                                    Hết hàng
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${product.quantity <= 5}">
                                                                <div
                                                                    class="product-badge text-dark bg-warning px-3 py-1 rounded position-absolute">
                                                                    Còn ${product.quantity}
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div
                                                                    class="product-badge text-white bg-secondary px-3 py-1 rounded position-absolute">
                                                                    Laptop
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <div class="card-body border-top-0 rounded-bottom">

                                                            <h4 class="product-name">
                                                                <a href="/product/${product.id}">
                                                                    ${product.name}
                                                                </a>
                                                            </h4>

                                                            <p class="product-desc">
                                                                ${product.shortDesc}
                                                            </p>

                                                            <p class="product-price text-center">
                                                                <fmt:formatNumber type="number"
                                                                    value="${product.price}" /> đ
                                                            </p>

                                                            <div class="product-action">

                                                                <c:if test="${product.quantity > 0}">
                                                                <form action="/add-product-to-cart/${product.id}"
                                                                    method="post">
                                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                                        value="${_csrf.token}" />

                                                                    <button
                                                                        class="btn border border-secondary rounded-pill text-primary"
                                                                        type="submit">
                                                                        <i class="fa fa-shopping-bag text-primary"></i>
                                                                    </button>
                                                                </form>
                                                                </c:if>
                                                                <c:if test="${product.quantity <= 0}">
                                                                <button disabled
                                                                    class="btn border border-secondary rounded-pill text-muted"
                                                                    style="cursor: not-allowed;">
                                                                    <i class="fa fa-shopping-bag"></i>
                                                                </button>
                                                                </c:if>

                                                                <form action="/wishlist/add" method="post">
                                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                                        value="${_csrf.token}" />

                                                                    <input type="hidden" name="productId"
                                                                        value="${product.id}" />

                                                                    <button
                                                                        class="btn border border-danger rounded-pill text-danger"
                                                                        type="submit">
                                                                        <i class="fa fa-heart"></i>
                                                                    </button>
                                                                </form>

                                                            </div>

                                                        </div>

                                                    </div>

                                                </div>
                                            </c:forEach>

                                            <c:if test="${totalPages > 0}">
                                                <div class="pagination d-flex justify-content-center mt-5">

                                                    <li class="page-item">
                                                        <a class="${1 eq currentPage ? 'disabled page-link' : 'page-link'}"
                                                            href="/products?page=${currentPage - 1}${queryString}"
                                                            aria-label="Previous">
                                                            <span aria-hidden="true">&laquo;</span>
                                                        </a>
                                                    </li>

                                                    <c:forEach begin="0" end="${totalPages - 1}" varStatus="loop">
                                                        <li class="page-item">
                                                            <a class="${(loop.index + 1) eq currentPage ? 'active page-link' : 'page-link'}"
                                                                href="/products?page=${loop.index + 1}${queryString}">
                                                                ${loop.index + 1}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <li class="page-item">
                                                        <a class="${totalPages eq currentPage ? 'disabled page-link' : 'page-link'}"
                                                            href="/products?page=${currentPage + 1}${queryString}"
                                                            aria-label="Next">
                                                            <span aria-hidden="true">&raquo;</span>
                                                        </a>
                                                    </li>

                                                </div>
                                            </c:if>

                                        </div>

                                    </div>
                                    <!-- PRODUCT LIST END -->

                                </div>

                            </div>

                        </div>
                    </div>
                    <!-- Product List End -->

                    <jsp:include page="../layout/footer.jsp" />

                    <!-- Back to Top -->
                    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top">
                        <i class="fa fa-arrow-up"></i>
                    </a>

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