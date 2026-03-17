<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Forgot Password - Laptopshop</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>

<body class="bg-primary">
    <div id="layoutAuthentication">
        <div id="layoutAuthentication_content">
            <main>
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-5">
                            <div class="card shadow-lg border-0 rounded-lg mt-5">
                                <div class="card-header">
                                    <h3 class="text-center font-weight-light my-4">Forgot Password</h3>
                                </div>
                                <div class="card-body">
                                    <c:if test="${not empty error}">
                                        <div class="my-2" style="color: red;">Email not found. Please try again.</div>
                                    </c:if>
                                    <c:if test="${not empty success}">
                                        <div class="my-2" style="color: green;">Reset link has been sent to your email.</div>
                                    </c:if>

                                    <p class="text-muted mb-3">We will be sending a reset password link to your email.</p>

                                    <form method="post" action="/forgot-password">
                                        <div class="form-floating mb-3">
                                            <input class="form-control" type="email" id="email"
                                                placeholder="Enter your e-mail" name="email" required />
                                            <label for="email">Enter your e-mail</label>
                                        </div>

                                        <div class="mt-4 mb-0">
                                            <div class="d-grid">
                                                <button class="btn btn-primary btn-block">
                                                    Send
                                                </button>
                                            </div>
                                        </div>

                                        <div>
                                            <input type="hidden" name="${_csrf.parameterName}"
                                                value="${_csrf.token}" />
                                        </div>
                                    </form>
                                </div>
                                <div class="card-footer text-center py-3">
                                    <div class="small"><a href="/login">Back to Login</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>

</html>
