<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Reset Password - Laptopshop</title>
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
                                    <h3 class="text-center font-weight-light my-4">Reset Password</h3>
                                </div>
                                <div class="card-body">
                                    <form:form method="post" action="/reset-password"
                                        modelAttribute="resetPassword">
                                        <c:set var="errorPassword">
                                            <form:errors path="confirmPassword"
                                                cssClass="invalid-feedback" />
                                        </c:set>
                                        <div class="form-floating mb-3">
                                            <form:input
                                                class="form-control ${not empty errorPassword ? 'is-invalid' : ''}"
                                                type="password" placeholder="Enter your new password"
                                                path="password" id="password" />
                                            <label for="password">Password</label>
                                            ${errorPassword}
                                        </div>

                                        <div class="form-floating mb-3">
                                            <form:input class="form-control" type="password"
                                                placeholder="Confirm password" path="confirmPassword"
                                                id="confirmPassword" oninput="checkPasswordMatch(this);" />
                                            <label for="confirmPassword">Confirm Password</label>
                                        </div>
                                        <div>
                                            <input type="hidden" name="token" value="${token}" />
                                            <input type="hidden" name="${_csrf.parameterName}"
                                                value="${_csrf.token}" />
                                        </div>

                                        <div class="mt-4 mb-0">
                                            <div class="d-grid">
                                                <button class="btn btn-primary btn-block">
                                                    Reset Password
                                                </button>
                                            </div>
                                        </div>
                                        <div class="text-center mt-3">
                                            <a class="small" href="/login">Back to Login</a>
                                        </div>

                                    </form:form>
                                </div>
                                <div class="card-footer text-center py-3">
                                    <div class="small"><a href="/register">Need an account? Sign up!</a>
                                    </div>
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

    <%-- Sửa srcipt -> script, bỏ jQuery dùng vanilla JS --%>
    <script type="text/javascript">
        function checkPasswordMatch(fieldConfirmPassword) {
            const password = document.getElementById("password").value;
            if (fieldConfirmPassword.value !== password) {
                fieldConfirmPassword.setCustomValidity("Passwords don't match");
            } else {
                fieldConfirmPassword.setCustomValidity("");
            }
        }
    </script>
</body>

</html>