<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
            <title>Quản lý Voucher - Laptopshop</title>
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
                            <h1 class="mt-4">Quản lý Voucher</h1>
                            <ol class="breadcrumb mb-4">
                                <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                                <li class="breadcrumb-item active">Voucher</li>
                            </ol>
                            <div class="mt-5">
                                <div class="row">
                                    <div class="col-12 mx-auto">
                                        <div class="d-flex justify-content-between">
                                            <h3>Danh sách Voucher</h3>
                                            <a href="/admin/voucher/create" class="btn btn-primary">Tạo Voucher mới</a>
                                        </div>

                                        <hr />
                                        <table class="table table-bordered table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Mã</th>
                                                    <th>Loại</th>
                                                    <th>Giá trị</th>
                                                    <th>Đã dùng / Giới hạn</th>
                                                    <th>Hạn sử dụng</th>
                                                    <th>Trạng thái</th>
                                                    <th>Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="v" items="${vouchers}">
                                                    <tr>
                                                        <td>${v.id}</td>
                                                        <td><strong>${v.code}</strong></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${v.discountType == 'PERCENT'}">
                                                                    Phần trăm
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Cố định
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${v.discountType == 'PERCENT'}">
                                                                    ${v.discountValue}%
                                                                    <c:if test="${v.maxDiscount > 0}">
                                                                        <br/><small class="text-muted">(Tối đa <fmt:formatNumber type="number" value="${v.maxDiscount}" /> đ)</small>
                                                                    </c:if>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <fmt:formatNumber type="number" value="${v.discountValue}" /> đ
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            ${v.usedCount} / ${v.usageLimit == 0 ? '∞' : v.usageLimit}
                                                        </td>
                                                        <td>
                                                            <c:if test="${v.expiryDate != null}">
                                                                <fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy HH:mm" />
                                                            </c:if>
                                                            <c:if test="${v.expiryDate == null}">
                                                                Không giới hạn
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${v.active}">
                                                                    <span class="badge bg-success">Hoạt động</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">Tắt</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <a href="/admin/voucher/update/${v.id}"
                                                                class="btn btn-warning btn-sm">Sửa</a>
                                                            <a href="/admin/voucher/delete/${v.id}"
                                                                class="btn btn-danger btn-sm">Xóa</a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        <c:if test="${totalPages > 0}">
                                        <nav aria-label="Page navigation">
                                            <ul class="pagination justify-content-center">
                                                <li class="page-item">
                                                    <a class="${1 eq currentPage ? 'disabled page-link' : 'page-link'}"
                                                        href="/admin/voucher?page=${currentPage - 1}">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                                <c:forEach begin="0" end="${totalPages - 1}" varStatus="loop">
                                                    <li class="page-item">
                                                        <a class="${(loop.index + 1) eq currentPage ? 'active page-link' : 'page-link'}"
                                                            href="/admin/voucher?page=${loop.index + 1}">
                                                            ${loop.index + 1}
                                                        </a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item">
                                                    <a class="${totalPages eq currentPage ? 'disabled page-link' : 'page-link'}"
                                                        href="/admin/voucher?page=${currentPage + 1}">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                        </c:if>
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
