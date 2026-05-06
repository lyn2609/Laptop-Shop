<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <title>${product.name} - Laptopshop</title>
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

                    <meta name="_csrf" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" />

                    <link href="https://cdnjs.cloudflare.com/ajax/libs/jquery-toast-plugin/1.3.2/jquery.toast.min.css"
                        rel="stylesheet">

                    <style>
                        /*
            Phần quan trọng:
            min-width: 0 + overflow-wrap: anywhere
            giúp tên sản phẩm dài không bị tràn sang Categories.
        */

                        .product-detail-content,
                        .product-info-area {
                            min-width: 0;
                        }

                        .product-detail-title {
                            max-width: 100%;
                            font-size: 25px;
                            font-weight: 700;
                            line-height: 1.3;
                            color: #263f4f;
                            margin-bottom: 16px;

                            overflow-wrap: anywhere;
                            word-break: break-word;
                        }

                        .product-image-wrapper {
                            overflow: hidden;
                            background-color: #fff;
                        }

                        .product-image-wrapper img {
                            width: 100%;
                            height: auto;
                            display: block;
                            object-fit: cover;
                        }

                        .product-short-desc {
                            max-width: 100%;
                            overflow-wrap: anywhere;
                            word-break: break-word;
                            color: #657789;
                            line-height: 1.6;
                        }

                        .product-price-detail {
                            color: #263f4f;
                            font-size: 22px;
                            font-weight: 700;
                        }

                        .product-action-buttons {
                            display: flex;
                            align-items: center;
                            flex-wrap: wrap;
                            gap: 10px;
                        }

                        .product-action-buttons form {
                            margin: 0;
                        }

                        .category-box {
                            padding-left: 10px;
                        }

                        .fruite-categorie li {
                            margin-bottom: 14px;
                        }

                        .fruite-name a {
                            text-decoration: none;
                        }

                        .description-text {
                            color: #657789;
                            line-height: 1.7;
                            overflow-wrap: anywhere;
                            word-break: break-word;
                        }

                        @media (max-width: 991px) {
                            .category-box {
                                padding-left: 0;
                                margin-top: 20px;
                            }

                            .product-detail-title {
                                font-size: 23px;
                            }
                        }

                        @media (max-width: 576px) {
                            .product-action-buttons {
                                flex-direction: column;
                                align-items: stretch;
                            }

                            .product-action-buttons button,
                            .product-action-buttons form {
                                width: 100%;
                            }

                            .product-detail-title {
                                font-size: 21px;
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

                    <!-- Single Product Start -->
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
                                                Chi Tiết Sản Phẩm
                                            </li>
                                        </ol>
                                    </nav>
                                </div>

                                <!-- MAIN CONTENT -->
                                <div class="col-lg-8 col-xl-9 product-detail-content">

                                    <div class="row g-4">

                                        <!-- PRODUCT IMAGE -->
                                        <div class="col-lg-6">
                                            <div class="border rounded product-image-wrapper">
                                                <a href="#">
                                                    <img src="/images/product/${product.image}"
                                                        class="img-fluid rounded" alt="${product.name}">
                                                </a>
                                            </div>
                                        </div>

                                        <!-- PRODUCT INFO -->
                                        <div class="col-lg-6 product-info-area">

                                            <h4 class="product-detail-title">
                                                ${product.name}
                                            </h4>

                                            <p class="mb-3">
                                                ${product.factory}
                                            </p>

                                            <h5 class="product-price-detail mb-3">
                                                <fmt:formatNumber type="number" value="${product.price}" /> đ
                                            </h5>

                                            <div class="d-flex mb-4">
                                                <div class="text-secondary">
                                                    Average Rating: ${averageRating}
                                                    <i class="fa fa-star"></i>
                                                </div>
                                            </div>

                                            <p class="mb-4 product-short-desc">
                                                ${product.shortDesc}
                                            </p>

                                            <!-- Stock status -->
                                            <div class="mb-3">
                                                <c:choose>
                                                    <c:when test="${product.quantity <= 0}">
                                                        <span class="badge bg-danger px-3 py-2" style="font-size: 13px;">
                                                            <i class="fas fa-times-circle"></i> Hết hàng
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${product.quantity <= 5}">
                                                        <span class="badge bg-warning text-dark px-3 py-2" style="font-size: 13px;">
                                                            <i class="fas fa-exclamation-triangle"></i> Chỉ còn ${product.quantity} sản phẩm
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success px-3 py-2" style="font-size: 13px;">
                                                            <i class="fas fa-check-circle"></i> Còn hàng (${product.quantity})
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <c:if test="${product.quantity > 0}">
                                            <div class="input-group quantity mb-5" style="width: 100px;">
                                                <div class="input-group-btn">
                                                    <button class="btn btn-sm btn-minus rounded-circle bg-light border">
                                                        <i class="fa fa-minus"></i>
                                                    </button>
                                                </div>

                                                <input type="text"
                                                    class="form-control form-control-sm text-center border-0" value="1"
                                                    data-cart-detail-index="0"
                                                    data-max-qty="${product.quantity}">

                                                <div class="input-group-btn">
                                                    <button class="btn btn-sm btn-plus rounded-circle bg-light border">
                                                        <i class="fa fa-plus"></i>
                                                    </button>
                                                </div>
                                            </div>

                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                            <input class="form-control d-none" type="text" value="${product.id}"
                                                name="id" />

                                            <input class="form-control d-none" type="text" name="quantity"
                                                id="cartDetails0.quantity" value="1" />

                                            <div class="product-action-buttons">
                                                <button data-product-id="${product.id}"
                                                    class="btnAddToCartDetail btn border border-secondary rounded-pill px-4 py-2 text-primary">
                                                    <i class="fa fa-shopping-bag me-2 text-primary"></i>
                                                    Add to cart
                                                </button>

                                                <button data-product-id="${product.id}"
                                                    class="btnBuyNow btn btn-danger rounded-pill px-4 py-2 text-white">
                                                    <i class="fa fa-bolt me-2"></i>
                                                    Mua ngay
                                                </button>

                                                <form action="/wishlist/add" method="post" class="d-inline-block">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />

                                                    <input type="hidden" name="productId" value="${product.id}" />

                                                    <button type="submit"
                                                        class="btn border border-danger rounded-pill px-4 py-2 text-danger">
                                                        <i class="fa fa-heart me-2"></i>
                                                        Add to Wishlist
                                                    </button>
                                                </form>
                                            </div>
                                            </c:if>

                                            <c:if test="${product.quantity <= 0}">
                                            <div class="product-action-buttons">
                                                <button disabled
                                                    class="btn border border-secondary rounded-pill px-4 py-2 text-muted" style="cursor: not-allowed;">
                                                    <i class="fa fa-shopping-bag me-2"></i>
                                                    Hết hàng
                                                </button>
                                            </div>
                                            </c:if>

                                        </div>

                                        <!-- DESCRIPTION AND REVIEWS -->
                                        <div class="col-lg-12">
                                            <nav>
                                                <div class="nav nav-tabs mb-3">

                                                    <button class="nav-link active border-white border-bottom-0"
                                                        type="button" role="tab" id="nav-about-tab" data-bs-toggle="tab"
                                                        data-bs-target="#nav-about" aria-controls="nav-about"
                                                        aria-selected="true">
                                                        Description
                                                    </button>

                                                    <button class="nav-link border-white border-bottom-0" type="button"
                                                        role="tab" id="nav-reviews-tab" data-bs-toggle="tab"
                                                        data-bs-target="#nav-reviews" aria-controls="nav-reviews"
                                                        aria-selected="false">
                                                        Reviews
                                                    </button>

                                                </div>
                                            </nav>

                                            <div class="tab-content mb-5">

                                                <!-- DESCRIPTION TAB -->
                                                <div class="tab-pane active" id="nav-about" role="tabpanel"
                                                    aria-labelledby="nav-about-tab">
                                                    <p class="description-text">
                                                        ${product.detailDesc}
                                                    </p>
                                                </div>

                                                <!-- REVIEWS TAB -->
                                                <div class="tab-pane" id="nav-reviews" role="tabpanel"
                                                    aria-labelledby="nav-reviews-tab">

                                                    <div class="mb-5">

                                                        <c:if test="${empty reviews}">
                                                            <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                                                        </c:if>

                                                        <c:forEach var="r" items="${reviews}">
                                                            <div class="d-flex mb-4">
                                                                <div class="ms-3">
                                                                    <h6 class="mb-1">
                                                                        ${r.user.fullName}
                                                                    </h6>

                                                                    <div class="d-flex mb-2">
                                                                        <c:forEach begin="1" end="5" var="i">
                                                                            <i
                                                                                class="fa fa-star ${i <= r.rating ? 'text-secondary' : 'text-muted'}"></i>
                                                                        </c:forEach>
                                                                    </div>

                                                                    <p>
                                                                        ${r.content}
                                                                    </p>

                                                                    <small class="text-muted">
                                                                        ${r.createdAt}
                                                                    </small>
                                                                </div>
                                                            </div>

                                                            <hr />
                                                        </c:forEach>

                                                    </div>

                                                    <c:if test="${not empty sessionScope.id}">
                                                        <h4 class="mb-4">
                                                            Để lại đánh giá
                                                        </h4>

                                                        <form action="/product/review" method="post">
                                                            <input type="hidden" name="${_csrf.parameterName}"
                                                                value="${_csrf.token}" />

                                                            <input type="hidden" name="productId"
                                                                value="${product.id}" />

                                                            <div class="row g-3">
                                                                <div class="col-12">
                                                                    <label>Rating (1-5)</label>
                                                                    <input type="number" name="rating"
                                                                        class="form-control" min="1" max="5" required />
                                                                </div>

                                                                <div class="col-12">
                                                                    <textarea name="content" class="form-control"
                                                                        rows="5" placeholder="Nội dung đánh giá"
                                                                        required></textarea>
                                                                </div>

                                                                <div class="col-12">
                                                                    <button type="submit"
                                                                        class="btn btn-primary rounded-pill px-4 py-3">
                                                                        Gửi đánh giá
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </c:if>

                                                    <c:if test="${empty sessionScope.id}">
                                                        <p>
                                                            Vui lòng <a href="/login">đăng nhập</a> để viết đánh giá.
                                                        </p>
                                                    </c:if>

                                                </div>

                                            </div>
                                        </div>

                                    </div>
                                </div>
                                <!-- MAIN CONTENT END -->

                                <!-- CATEGORIES -->
                                <div class="col-lg-4 col-xl-3 category-box">

                                    <div class="row g-4 fruite">
                                        <div class="col-lg-12">

                                            <div class="mb-4">
                                                <h4>Categories</h4>

                                                <ul class="list-unstyled fruite-categorie">

                                                    <li>
                                                        <div class="d-flex justify-content-between fruite-name">
                                                            <a href="/products?factory=APPLE">
                                                                <i class="fas fa-laptop me-2"></i>Apple
                                                            </a>
                                                            <span>(${appleCount})</span>
                                                        </div>
                                                    </li>

                                                    <li>
                                                        <div class="d-flex justify-content-between fruite-name">
                                                            <a href="/products?factory=DELL">
                                                                <i class="fas fa-laptop me-2"></i>Dell
                                                            </a>
                                                            <span>(${dellCount})</span>
                                                        </div>
                                                    </li>

                                                    <li>
                                                        <div class="d-flex justify-content-between fruite-name">
                                                            <a href="/products?factory=ASUS">
                                                                <i class="fas fa-laptop me-2"></i>Asus
                                                            </a>
                                                            <span>(${asusCount})</span>
                                                        </div>
                                                    </li>

                                                    <li>
                                                        <div class="d-flex justify-content-between fruite-name">
                                                            <a href="/products?factory=ACER">
                                                                <i class="fas fa-laptop me-2"></i>Acer
                                                            </a>
                                                            <span>(${acerCount})</span>
                                                        </div>
                                                    </li>

                                                    <li>
                                                        <div class="d-flex justify-content-between fruite-name">
                                                            <a href="/products?factory=LENOVO">
                                                                <i class="fas fa-laptop me-2"></i>Lenovo
                                                            </a>
                                                            <span>(${lenovoCount})</span>
                                                        </div>
                                                    </li>

                                                </ul>
                                            </div>

                                        </div>
                                    </div>

                                </div>
                                <!-- CATEGORIES END -->

                            </div>

                        </div>
                    </div>
                    <!-- Single Product End -->

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

                    <script
                        src="https://cdnjs.cloudflare.com/ajax/libs/jquery-toast-plugin/1.3.2/jquery.toast.min.js"></script>

                </body>

                </html>