package vn.hoidanit.laptopshop.controller.client;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.domain.Cart;
import vn.hoidanit.laptopshop.domain.CartDetail;
import vn.hoidanit.laptopshop.domain.CustomOAuth2User;
import vn.hoidanit.laptopshop.domain.Product;
import vn.hoidanit.laptopshop.domain.Product_;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.domain.Voucher;
import vn.hoidanit.laptopshop.domain.dto.ProductCriteriaDTO;
import vn.hoidanit.laptopshop.service.OrderService;
import vn.hoidanit.laptopshop.service.ProductService;
import vn.hoidanit.laptopshop.service.UserService;
import vn.hoidanit.laptopshop.service.VnPayService;
import vn.hoidanit.laptopshop.service.VoucherService;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;


@Controller
public class ItemController {
    private final ProductService productService;
    private final UserService userService;
    private final vn.hoidanit.laptopshop.service.ReviewService reviewService;
    private final OrderService orderService;
    private final VnPayService vnPayService;
    private final VoucherService voucherService;

    public ItemController(ProductService productService, UserService userService, vn.hoidanit.laptopshop.service.ReviewService reviewService, OrderService orderService, VnPayService vnPayService, VoucherService voucherService) {
        this.productService = productService;
        this.userService = userService;
        this.reviewService = reviewService;
        this.orderService = orderService;
        this.vnPayService = vnPayService;
        this.voucherService = voucherService;
    }


    @GetMapping("/product/{id}")
    public String getProductPage(Model model, @PathVariable long id) {
        Product pr = this.productService.fetchProductById(id).get();
        model.addAttribute("product", pr);
        model.addAttribute("id", id);
        
        List<vn.hoidanit.laptopshop.domain.Review> reviews = this.reviewService.getReviewsByProduct(pr);
        double averageRating = this.reviewService.calculateAverageRating(pr);
        
        model.addAttribute("reviews", reviews);
        model.addAttribute("averageRating", averageRating);

        model.addAttribute("appleCount", this.productService.countProductsByFactory("APPLE"));
        model.addAttribute("dellCount", this.productService.countProductsByFactory("DELL"));
        model.addAttribute("asusCount", this.productService.countProductsByFactory("ASUS"));
        model.addAttribute("acerCount", this.productService.countProductsByFactory("ACER"));
        model.addAttribute("lenovoCount", this.productService.countProductsByFactory("LENOVO"));

        return "client/product/detail";
    }    

    @PostMapping("/add-product-to-cart/{id}")
    public String addProductToCart(@PathVariable long id, HttpServletRequest request, RedirectAttributes redirectAttributes){
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            return "redirect:/login";
        }
        String email = (String)session.getAttribute("email");
        try {
            this.productService.handleAddProductToCart(email, id, session, 1);
            redirectAttributes.addFlashAttribute("successMessage", "Đã thêm vào giỏ hàng");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/product/" + id;
    }

    private User getCurrentUser(HttpSession session) {
        Long id = (Long) session.getAttribute("id");
        if (id != null) {
            User user = new User();
            user.setId(id);
            return user;
        }
        // OAuth2 login
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof CustomOAuth2User oAuth2User) {
            return this.userService.getUserByEmail(oAuth2User.getEmail());
        }
        throw new RuntimeException("User not authenticated");
    }

    @GetMapping("/cart")
    public String getCartPage(Model model, HttpServletRequest request) {
        User currentUser = new User();
        HttpSession session = request.getSession(false);
        // long id = (long)session.getAttribute("id");
        // currentUser.setId(id);
        currentUser = getCurrentUser(session);
        Cart cart = this.productService.fetchByUser(currentUser);
        List <CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();
        double totalPrice = 0;
        for(CartDetail cd : cartDetails){
            totalPrice += cd.getPrice() * cd.getQuantity();
        }
        model.addAttribute("cartDetails", cartDetails);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("cart", cart);
        return "client/cart/show";
    }

    @PostMapping("/delete-cart-product/{id}")
    public String deleteCartDetail(@PathVariable long id, HttpServletRequest request){
        HttpSession session = request.getSession(false);
        long cartDetailId = id;
        this.productService.handleRemoveCartDetail(cartDetailId, session);
        return "redirect:/cart";
    }

    @GetMapping("/checkout")
    public String getCheckOutPage(Model model, HttpServletRequest request) {
        User currentUser = new User();
        HttpSession session = request.getSession(false);
        currentUser = getCurrentUser(session);
        Cart cart = this.productService.fetchByUser(currentUser);

        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();

        double totalPrice = 0;
        for (CartDetail cd : cartDetails) {
            totalPrice += cd.getPrice() * cd.getQuantity();
        }

        // Lấy danh sách voucher tự động hiển thị
        List<Voucher> availableVouchers = this.voucherService.fetchAvailableVouchers(totalPrice);

        model.addAttribute("cartDetails", cartDetails);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("availableVouchers", availableVouchers);

        return "client/cart/checkout";
    }

    @PostMapping("/confirm-checkout")
    public String getCheckOutPage(@ModelAttribute("cart") Cart cart) {
        List <CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();
        this.productService.handleUpdateCartBeforeCheckout(cartDetails);
        return "redirect:/checkout";
    }

    // NEW: Cập nhật giỏ hàng riêng, không đi checkout
    @PostMapping("/update-cart")
    public String updateCart(@ModelAttribute("cart") Cart cart, RedirectAttributes redirectAttributes) {
        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();
        this.productService.handleUpdateCartBeforeCheckout(cartDetails);

        if (cart != null && !cartDetails.isEmpty()) {
            Optional<CartDetail> firstDetail = this.productService.findCartDetailById(cartDetails.get(0).getId());
            if (firstDetail.isPresent()) {
                Cart realCart = firstDetail.get().getCart();
                int totalQty = 0;
                for (CartDetail cd : realCart.getCartDetails()) {
                    totalQty += cd.getQuantity();
                }
                realCart.setSum(totalQty);
                this.productService.saveCart(realCart);
            }
        }
        redirectAttributes.addFlashAttribute("successMessage", "Đã cập nhật giỏ hàng");
        return "redirect:/cart";
    }
    
     @PostMapping("/place-order")
    public String handlePlaceOrder(
            HttpServletRequest request,
            @RequestParam("receiverName") String receiverName,
            @RequestParam("receiverAddress") String receiverAddress,
            @RequestParam("receiverPhone") String receiverPhone,
            @RequestParam(value = "voucherCode", required = false) String voucherCode,
            @RequestParam(value = "paymentMethod", defaultValue = "COD") String paymentMethod) {
        User currentUser = new User();// null
        HttpSession session = request.getSession(false);
        currentUser = getCurrentUser(session);

        vn.hoidanit.laptopshop.domain.Order order = this.productService.handlePlaceOrder(currentUser, session, receiverName, receiverAddress, receiverPhone, voucherCode);
        
        if (order != null && "VNPAY".equals(paymentMethod)) {
            // Đặt lại status là PAYMENT_PENDING để chờ VNPay xác nhận
            order.setStatus("PAYMENT_PENDING");
            this.orderService.updateOrder(order);
            
            // Lấy URL gốc (base URL) từ request
            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
            String paymentUrl = vnPayService.createOrder((long) order.getFinalPrice(), String.valueOf(order.getId()), baseUrl);
            return "redirect:" + paymentUrl;
        }

        return "redirect:/thanks";
    }

    @GetMapping("/thanks")
    public String getThankYouPage(Model model) {

        return "client/cart/thanks";
    }

    @PostMapping("/add-product-from-view-detail")
    public String handleAddProductFromViewDetail(
        @RequestParam("id") long id,
        @RequestParam("quantity") long quantity,
        HttpServletRequest request,
        RedirectAttributes redirectAttributes
    ) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            return "redirect:/login";
        }
        if (quantity <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "Số lượng phải lớn hơn 0");
            return "redirect:/product/" + id;
        }
        try {
            String email = (String)session.getAttribute("email");
            this.productService.handleAddProductToCart(email, id, session, quantity);
            redirectAttributes.addFlashAttribute("successMessage", "Đã thêm vào giỏ hàng");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/product/" + id;
    }

    @GetMapping("/products")
    public String getProductPage(Model model, 
        ProductCriteriaDTO productCriteriaDTO, HttpServletRequest request
    ) {
        int page = 1;
        try {
            if(productCriteriaDTO.getPage().isPresent()){
                page = Integer.parseInt(productCriteriaDTO.getPage().get());
            }
            else{
                // page = 1
            }
            
        } catch (Exception e) {
            //page = 1
        }
        Pageable pageable = PageRequest.of(page - 1, 6);
        if(productCriteriaDTO.getSort() != null && productCriteriaDTO.getSort().isPresent()){
            String sort = productCriteriaDTO.getSort().get();
            if(sort.equals("gia-tang-dan")){
                pageable = PageRequest.of(page - 1, 6, Sort.by(Product_.PRICE).ascending());
            }
            else if(sort.equals("gia-giam-dan")){
                pageable = PageRequest.of(page - 1, 6, Sort.by(Product_.PRICE).descending());
            }
            else{
                pageable = PageRequest.of(page - 1, 6);
            }
        }
        Page <Product> prs = this.productService.fetchProductsWithSpec(pageable, productCriteriaDTO);

        List<Product> products = prs.getContent().size() > 0 ? prs.getContent()
                : new ArrayList<Product>();
        
        String qs = request.getQueryString();
        if(qs != null){
            //remove page
            qs = qs.replace("page=" + page, "");
        }
        model.addAttribute("products", products);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", prs.getTotalPages());
        model.addAttribute("queryString", qs);
        return "client/product/show";
    }

    @PostMapping("/cancel-order/{id}")
    public String handleCancelOrder(@PathVariable long id, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        long userId = (long) session.getAttribute("id");
        User currentUser = new User();
        currentUser.setId(userId);
        this.orderService.cancelOrder(id, currentUser);
        return "redirect:/order-history";
    }

}
