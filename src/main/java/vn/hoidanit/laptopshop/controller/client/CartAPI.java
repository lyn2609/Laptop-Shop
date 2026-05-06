package vn.hoidanit.laptopshop.controller.client;

import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.service.ProductService;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

class CartRequest {
    private long quantity;
    private long productId;

    public long getQuantity() {
        return quantity;
    }

    public void setQuantity(long quantity) {
        this.quantity = quantity;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }
}

@RestController
public class CartAPI {

    private final ProductService productService;

    public CartAPI(ProductService productService) {
        this.productService = productService;
    }

    @PostMapping("/api/add-product-to-cart")
    public ResponseEntity<?> addProductToCart(
            @RequestBody() CartRequest cartRequest,
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("error", "Bạn cần đăng nhập tài khoản");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }

        if (cartRequest.getQuantity() <= 0) {
            Map<String, Object> err = new HashMap<>();
            err.put("error", "Số lượng phải lớn hơn 0");
            return ResponseEntity.badRequest().body(err);
        }

        try {
            String email = (String) session.getAttribute("email");
            this.productService.handleAddProductToCart(
                    email, cartRequest.getProductId(), session, cartRequest.getQuantity());

            int sum = (int) session.getAttribute("sum");
            Map<String, Object> res = new HashMap<>();
            res.put("sum", sum);
            res.put("message", "Đã thêm vào giỏ hàng");
            return ResponseEntity.ok().body(res);
        } catch (RuntimeException e) {
            Map<String, Object> err = new HashMap<>();
            err.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(err);
        }
    }
}
