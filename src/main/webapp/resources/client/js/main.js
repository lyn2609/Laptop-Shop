(function ($) {
    "use strict";

    // Spinner
    var spinner = function () {
        setTimeout(function () {
            if ($('#spinner').length > 0) {
                $('#spinner').removeClass('show');
            }
        }, 1);
    };
    spinner(0);


    // Fixed Navbar
    $(window).scroll(function () {
        if ($(window).width() < 992) {
            if ($(this).scrollTop() > 55) {
                $('.fixed-top').addClass('shadow');
            } else {
                $('.fixed-top').removeClass('shadow');
            }
        } else {
            if ($(this).scrollTop() > 55) {
                $('.fixed-top').addClass('shadow').css('top', 0);
            } else {
                $('.fixed-top').removeClass('shadow').css('top', 0);
            }
        }
    });


    // Back to top button
    $(window).scroll(function () {
        if ($(this).scrollTop() > 300) {
            $('.back-to-top').fadeIn('slow');
        } else {
            $('.back-to-top').fadeOut('slow');
        }
    });
    $('.back-to-top').click(function () {
        $('html, body').animate({ scrollTop: 0 }, 1500, 'easeInOutExpo');
        return false;
    });


    // Testimonial carousel
    $(".testimonial-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 2000,
        center: false,
        dots: true,
        loop: true,
        margin: 25,
        nav: true,
        navText: [
            '<i class="bi bi-arrow-left"></i>',
            '<i class="bi bi-arrow-right"></i>'
        ],
        responsiveClass: true,
        responsive: {
            0: {
                items: 1
            },
            576: {
                items: 1
            },
            768: {
                items: 1
            },
            992: {
                items: 2
            },
            1200: {
                items: 2
            }
        }
    });


    // vegetable carousel
    $(".vegetable-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1500,
        center: false,
        dots: true,
        loop: true,
        margin: 25,
        nav: true,
        navText: [
            '<i class="bi bi-arrow-left"></i>',
            '<i class="bi bi-arrow-right"></i>'
        ],
        responsiveClass: true,
        responsive: {
            0: {
                items: 1
            },
            576: {
                items: 1
            },
            768: {
                items: 2
            },
            992: {
                items: 3
            },
            1200: {
                items: 4
            }
        }
    });


    // Modal Video
    $(document).ready(function () {
        var $videoSrc;
        $('.btn-play').click(function () {
            $videoSrc = $(this).data("src");
        });
        console.log($videoSrc);

        $('#videoModal').on('shown.bs.modal', function (e) {
            $("#video").attr('src', $videoSrc + "?autoplay=1&amp;modestbranding=1&amp;showinfo=0");
        })

        $('#videoModal').on('hide.bs.modal', function (e) {
            $("#video").attr('src', $videoSrc);
        })

        //add active class to header
        const navElement = $("#navbarCollapse");
        const currentUrl = window.location.pathname;
        navElement.find('a.nav-link').each(function () {
            const link = $(this); // Get the current link in the loop
            const href = link.attr('href'); // Get the href attribute of the link

            if (href === currentUrl) {
                link.addClass('active'); // Add 'active' class if the href matches the current URL
            } else {
                link.removeClass('active'); // Remove 'active' class if the href does not match
            }
        });
    });



    // Product Quantity
    // $('.quantity button').on('click', function () {
    //     var button = $(this);
    //     var oldValue = button.parent().parent().find('input').val();
    //     if (button.hasClass('btn-plus')) {
    //         var newVal = parseFloat(oldValue) + 1;
    //     } else {
    //         if (oldValue > 0) {
    //             var newVal = parseFloat(oldValue) - 1;
    //         } else {
    //             newVal = 0;
    //         }
    //     }
    //     button.parent().parent().find('input').val(newVal);
    // });
    $('.quantity button').on('click', function () {
        let change = 0;

        var button = $(this);
        var oldValue = button.parent().parent().find('input').val();
        if (button.hasClass('btn-plus')) {
            var newVal = parseFloat(oldValue) + 1;
            change = 1;
        } else {
            if (oldValue > 1) {
                var newVal = parseFloat(oldValue) - 1;
                change = -1;
            } else {
                newVal = 1;
            }
        }
        const input = button.parent().parent().find('input');
        input.val(newVal);

        //set form index
        const index = input.attr("data-cart-detail-index")
        const el = document.getElementById(`cartDetails${index}.quantity`);
        $(el).val(newVal);



        //get price
        const price = input.attr("data-cart-detail-price");
        const id = input.attr("data-cart-detail-id");

        const priceElement = $(`p[data-cart-detail-id='${id}']`);
        if (priceElement) {
            const newPrice = +price * newVal;
            priceElement.text(formatCurrency(newPrice.toFixed(2)) + " đ");
        }

        //update total cart price
        const totalPriceElement = $(`p[data-cart-total-price]`);

        if (totalPriceElement && totalPriceElement.length) {
            const currentTotal = totalPriceElement.first().attr("data-cart-total-price");
            let newTotal = +currentTotal;
            if (change === 0) {
                newTotal = +currentTotal;
            } else {
                newTotal = change * (+price) + (+currentTotal);
            }

            //reset change
            change = 0;

            //update
            totalPriceElement?.each(function (index, element) {
                //update text
                $(totalPriceElement[index]).text(formatCurrency(newTotal.toFixed(2)) + " đ");

                //update data-attribute
                $(totalPriceElement[index]).attr("data-cart-total-price", newTotal);
            });
        }
    });

    function formatCurrency(value) {
        // Use the 'vi-VN' locale to format the number according to Vietnamese currency format
        // and 'VND' as the currency type for Vietnamese đồng
        const formatter = new Intl.NumberFormat('vi-VN', {
            style: 'decimal',
            minimumFractionDigits: 0, // No decimal part for whole numbers
        });

        let formatted = formatter.format(value);
        // Replace dots with commas for thousands separator
        formatted = formatted.replace(/\./g, ',');
        return formatted;
    }

    //handle filter products
    $('#btnFilter').click(function (event) {
        event.preventDefault();

        let factoryArr = [];
        let targetArr = [];
        let priceArr = [];
        let ramArr = [];
        let cpuArr = [];
        //factory filter
        $("#factoryFilter .form-check-input:checked").each(function () {
            factoryArr.push($(this).val());
        });

        //target filter
        $("#targetFilter .form-check-input:checked").each(function () {
            targetArr.push($(this).val());
        });

        //price filter
        $("#priceFilter .form-check-input:checked").each(function () {
            priceArr.push($(this).val());
        });

        //ram filter
        $("#ramFilter .form-check-input:checked").each(function () {
            ramArr.push($(this).val());
        });

        //cpu filter
        $("#cpuFilter .form-check-input:checked").each(function () {
            cpuArr.push($(this).val());
        });

        //sort order
        let sortValue = $('input[name="radio-sort"]:checked').val();

        const currentUrl = new URL(window.location.href);
        const searchParams = currentUrl.searchParams;

        // Add or update query parameters
        searchParams.set('page', '1');
        searchParams.set('sort', sortValue);

        //reset
        searchParams.delete('factory');
        searchParams.delete('target');
        searchParams.delete('price');
        searchParams.delete('ram');
        searchParams.delete('cpu');

        if (factoryArr.length > 0) {
            searchParams.set('factory', factoryArr.join(','));
        }

        if (targetArr.length > 0) {
            searchParams.set('target', targetArr.join(','));
        }

        if (priceArr.length > 0) {
            searchParams.set('price', priceArr.join(','));
        }

        if (ramArr.length > 0) {
            searchParams.set('ram', ramArr.join(','));
        }

        if (cpuArr.length > 0) {
            searchParams.set('cpu', cpuArr.join(','));
        }

        // Update the URL and reload the page
        window.location.href = currentUrl.toString();
    });

    //handle auto checkbox after page loading
    // Parse the URL parameters
    const params = new URLSearchParams(window.location.search);

    // Set checkboxes for 'factory'
    if (params.has('factory')) {
        const factories = params.get('factory').split(',');
        factories.forEach(factory => {
            $(`#factoryFilter .form-check-input[value="${factory}"]`).prop('checked', true);
        });
    }

    // Set checkboxes for 'target'
    if (params.has('target')) {
        const targets = params.get('target').split(',');
        targets.forEach(target => {
            $(`#targetFilter .form-check-input[value="${target}"]`).prop('checked', true);
        });
    }

    // Set checkboxes for 'price'
    if (params.has('price')) {
        const prices = params.get('price').split(',');
        prices.forEach(price => {
            $(`#priceFilter .form-check-input[value="${price}"]`).prop('checked', true);
        });
    }

    // Set checkboxes for 'ram'
    if (params.has('ram')) {
        const rams = params.get('ram').split(',');
        rams.forEach(ram => {
            $(`#ramFilter .form-check-input[value="${ram}"]`).prop('checked', true);
        });
    }

    // Set checkboxes for 'cpu'
    if (params.has('cpu')) {
        const cpus = params.get('cpu').split(',');
        cpus.forEach(cpu => {
            $(`#cpuFilter .form-check-input[value="${cpu}"]`).prop('checked', true);
        });
    }

    // Set radio buttons for 'sort'
    if (params.has('sort')) {
        const sort = params.get('sort');
        $(`input[type="radio"][name="radio-sort"][value="${sort}"]`).prop('checked', true);
    }


    //////////////////////////
    //handle add to cart with ajax
    $('.btnAddToCartHomepage').click(function (event) {
        event.preventDefault();

        if (!isLogin()) {
            $.toast({
                heading: 'Lỗi thao tác',
                text: 'Bạn cần đăng nhập tài khoản',
                position: 'top-right',
                icon: 'error'
            })
            return;
        }

        const productId = $(this).attr('data-product-id');
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        $.ajax({
            url: `${window.location.origin}/api/add-product-to-cart`,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            },
            type: "POST",
            data: JSON.stringify({ quantity: 1, productId: productId }),
            contentType: "application/json",

            success: function (response) {
                const sum = +response.sum;
                $("#sumCart").text(sum)
                $.toast({
                    heading: 'Giỏ hàng',
                    text: response.message || 'Đã thêm vào giỏ hàng',
                    position: 'top-right',
                    icon: 'success'
                })

            },
            error: function (xhr) {
                let errorMsg = "Có lỗi xảy ra";
                if (xhr.responseJSON && xhr.responseJSON.error) {
                    errorMsg = xhr.responseJSON.error;
                }
                $.toast({
                    heading: 'Lỗi',
                    text: errorMsg,
                    position: 'top-right',
                    icon: 'error'
                });
            }

        });
    });

    $('.btnAddToCartDetail').click(function (event) {
        event.preventDefault();
        if (!isLogin()) {
            $.toast({
                heading: 'Lỗi thao tác',
                text: 'Bạn cần đăng nhập tài khoản',
                position: 'top-right',
                icon: 'error'
            })
            return;
        }

        const productId = $(this).attr('data-product-id');
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");
        const quantity = $("#cartDetails0\\.quantity").val();
        $.ajax({
            url: `${window.location.origin}/api/add-product-to-cart`,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            },
            type: "POST",
            data: JSON.stringify({ quantity: quantity, productId: productId }),
            contentType: "application/json",

            success: function (response) {
                const sum = +response.sum;
                $("#sumCart").text(sum)
                $.toast({
                    heading: 'Giỏ hàng',
                    text: response.message || 'Đã thêm vào giỏ hàng',
                    position: 'top-right',
                    icon: 'success'
                })

            },
            error: function (xhr) {
                let errorMsg = "Có lỗi xảy ra";
                if (xhr.responseJSON && xhr.responseJSON.error) {
                    errorMsg = xhr.responseJSON.error;
                }
                $.toast({
                    heading: 'Lỗi',
                    text: errorMsg,
                    position: 'top-right',
                    icon: 'error'
                });
            }

        });
    });

    // Nút Mua ngay - thêm vào giỏ rồi chuyển sang checkout
    $('.btnBuyNow').click(function (event) {
        event.preventDefault();
        if (!isLogin()) {
            $.toast({
                heading: 'Lỗi thao tác',
                text: 'Bạn cần đăng nhập tài khoản',
                position: 'top-right',
                icon: 'error'
            });
            return;
        }

        const productId = $(this).attr('data-product-id');
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");
        const quantity = $("#cartDetails0\\.quantity").val();

        $.ajax({
            url: `${window.location.origin}/api/add-product-to-cart`,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            },
            type: "POST",
            data: JSON.stringify({ quantity: quantity, productId: productId }),
            contentType: "application/json",
            success: function (response) {
                window.location.href = '/checkout';
            },
            error: function (xhr) {
                let errorMsg = "Có lỗi xảy ra";
                if (xhr.responseJSON && xhr.responseJSON.error) {
                    errorMsg = xhr.responseJSON.error;
                }
                $.toast({
                    heading: 'Lỗi',
                    text: errorMsg,
                    position: 'top-right',
                    icon: 'error'
                });
            }
        });
    });

    function isLogin() {
        const navElement = $("#navbarCollapse");
        const childLogin = navElement.find('a.a-login');
        if (childLogin.length > 0) {
            return false;
        }
        return true;
    }

    // Autocomplete Search
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.appendChild(document.createTextNode(text));
        return div.innerHTML;
    }

    let searchTimeout = null;
    const $searchInput = $('#searchInput');
    const $resultsContainer = $('#autocompleteResults');

    // Handle Enter key → navigate to products page
    $searchInput.on('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            const query = $(this).val().trim();
            if (query.length > 0) {
                window.location.href = '/products?name=' + encodeURIComponent(query);
            }
        }
    });

    $searchInput.on('keyup', function(e) {
        if (e.key === 'Enter') return; // already handled above

        const query = $(this).val();
        clearTimeout(searchTimeout);
        
        if (query.trim().length === 0) {
            $resultsContainer.hide();
            return;
        }
        
        // Show loading state
        $resultsContainer.html('<div class="p-3 text-center text-muted"><i class="fa fa-spinner fa-spin me-2"></i>Đang tìm kiếm...</div>').show();

        searchTimeout = setTimeout(function() {
            $.ajax({
                url: `${window.location.origin}/api/products/search?query=${encodeURIComponent(query)}`,
                type: 'GET',
                success: function(products) {
                    if (products && products.length > 0) {
                        let html = '<ul class="list-unstyled mb-0">';
                        products.forEach(p => {
                            html += `
                                <li class="search-result-item">
                                    <a href="/product/${p.id}" class="d-flex align-items-center text-decoration-none text-dark p-2">
                                        <img src="/images/product/${escapeHtml(p.image || '')}" class="img-fluid rounded me-2" style="width: 40px; height: 40px; object-fit: cover;" alt="">
                                        <div style="min-width: 0;">
                                            <p class="mb-0 fw-bold text-truncate" style="font-size: 14px;">${escapeHtml(p.name)}</p>
                                            <p class="mb-0 text-danger" style="font-size: 12px;">${formatCurrency(p.price)} đ</p>
                                        </div>
                                    </a>
                                </li>
                            `;
                        });
                        // Show "View all" link when max results returned
                        if (products.length >= 5) {
                            html += `
                                <li class="search-result-item border-top">
                                    <a href="/products?name=${encodeURIComponent(query)}" class="d-block text-center text-primary p-2 text-decoration-none fw-bold" style="font-size: 14px;">
                                        <i class="fa fa-search me-1"></i> Xem tất cả kết quả
                                    </a>
                                </li>
                            `;
                        }
                        html += '</ul>';
                        $resultsContainer.html(html).show();
                    } else {
                        $resultsContainer.html('<div class="p-3 text-center text-muted">Không tìm thấy sản phẩm</div>').show();
                    }
                },
                error: function(err) {
                    console.error("Search error:", err);
                    $resultsContainer.html('<div class="p-3 text-center text-muted">Đã có lỗi xảy ra</div>').show();
                }
            });
        }, 300); // 300ms debounce
    });
    
    // Hide autocomplete when clicking outside
    $(document).on('click', function(e) {
        if (!$(e.target).closest('#searchInput, #autocompleteResults').length) {
            $resultsContainer.hide();
        }
    });


})(jQuery);

