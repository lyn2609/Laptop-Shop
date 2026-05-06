<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!-- Navbar start -->
        <div class="container-fluid fixed-top">
            <div class="container px-0">
                <nav class="navbar navbar-light bg-white navbar-expand-xl">
                    <a href="/" class="navbar-brand">
                        <h1 class="text-primary display-6">Laptopshop</h1>
                    </a>
                    <button class="navbar-toggler py-2 px-3" type="button" data-bs-toggle="collapse"
                        data-bs-target="#navbarCollapse">
                        <span class="fa fa-bars text-primary"></span>
                    </button>
                    <div class="collapse navbar-collapse bg-white justify-content-between mx-5" id="navbarCollapse">
                        <div class="navbar-nav">
                            <a href="/" class="nav-item nav-link active">Trang Chủ</a>
                            <a href="/products" class="nav-item nav-link">Sản Phẩm</a>
                        </div>
                        <div class="position-relative mx-auto my-auto d-none d-md-block" style="max-width: 400px; width: 100%;">
                            <input class="form-control border-2 border-secondary w-100 py-2 px-4 rounded-pill" type="text" id="searchInput" placeholder="Tìm kiếm sản phẩm..." autocomplete="off">
                            <div id="autocompleteResults" class="position-absolute w-100 bg-white shadow rounded mt-1" style="display: none; z-index: 1000; max-height: 350px; overflow-y: auto;">
                            </div>
                        </div>
                        <div class="d-flex m-3 me-0">
                            <c:if test="${not empty pageContext.request.userPrincipal}">
                                <a href="/wishlist" class="position-relative me-4 my-auto">
                                    <i class="fa fa-heart fa-2x"></i>
                                </a>
                                <a href="/cart" class="position-relative me-4 my-auto">
                                    <i class="fa fa-shopping-bag fa-2x"></i>
                                    <span
                                        class="position-absolute bg-secondary rounded-circle d-flex align-items-center justify-content-center text-dark px-1"
                                        style="top: -5px; left: 15px; height: 20px; min-width: 20px;" id="sumCart">
                                        ${sessionScope.sum}
                                    </span>
                                </a>
                                <div class="dropdown my-auto">
                                    <a href="#" class="dropdown" role="button" id="dropdownMenuLink"
                                        data-bs-toggle="dropdown" aria-expanded="false" data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                        <i class="fas fa-user fa-2x"></i>
                                    </a>

                                    <ul class="dropdown-menu dropdown-menu-end p-4" aria-labelledby="dropdownMenuLink">
                                        <li class="d-flex align-items-center flex-column" style="min-width: 300px;">
                                            <c:set var="avatarName" value="${fn:trim(sessionScope.avatar)}" />
                                            <c:choose>
                                                <c:when
                                                    test="${not empty avatarName and avatarName ne 'avatar.jpg' and avatarName ne 'null' and not fn:contains(avatarName, '/')}">
                                                    <img style="width: 150px; height: 150px; border-radius: 50%; overflow: hidden;"
                                                        src="/images/avatar/${avatarName}"
                                                        onerror="this.onerror=null;this.src='/client/img/avatar.jpg';" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img style="width: 150px; height: 150px; border-radius: 50%; overflow: hidden;"
                                                        src="/client/img/avatar.jpg"
                                                        onerror="this.onerror=null;this.src='/client/img/avatar.jpg';" />
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="text-center my-3">
                                                <c:choose>
                                                    <c:when test="${not empty sessionScope.fullName}">
                                                        <c:out value="${sessionScope.fullName}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:out value="${pageContext.request.userPrincipal.name}" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </li>

                                        <li><a class="dropdown-item" href="/profile">Quản lý tài khoản</a></li>

                                        <li><a class="dropdown-item" href="/order-history">Lịch sử mua hàng</a></li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li>
                                            <form method="post" action="/logout">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <button class="dropdown-item">Đăng xuất</button>
                                            </form>
                                        </li>
                                    </ul>
                                </div>
                            </c:if>
                            <c:if test="${empty pageContext.request.userPrincipal}">
                                <a href="/login" class="a-login position-relative me-4 my-auto">
                                    Đăng nhập
                                </a>
                            </c:if>
                        </div>
                    </div>
                </nav>
            </div>
        </div>
        <!-- Navbar End -->