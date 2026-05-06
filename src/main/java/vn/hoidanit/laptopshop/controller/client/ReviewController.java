package vn.hoidanit.laptopshop.controller.client;

import java.time.LocalDateTime;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.domain.Product;
import vn.hoidanit.laptopshop.domain.Review;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.service.ProductService;
import vn.hoidanit.laptopshop.service.ReviewService;
import vn.hoidanit.laptopshop.service.UserService;

@Controller
public class ReviewController {

    private final ReviewService reviewService;
    private final ProductService productService;
    private final UserService userService;

    public ReviewController(ReviewService reviewService, ProductService productService, UserService userService) {
        this.reviewService = reviewService;
        this.productService = productService;
        this.userService = userService;
    }

    @PostMapping("/product/review")
    public String addReview(
            @RequestParam("productId") long productId,
            @RequestParam("rating") int rating,
            @RequestParam("content") String content,
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }

        long userId = (long) session.getAttribute("id");
        User user = new User();
        user.setId(userId);
        
        Product product = this.productService.fetchProductById(productId).orElse(null);
        if (product == null) {
            return "redirect:/";
        }

        Review review = new Review();
        review.setUser(user);
        review.setProduct(product);
        review.setRating(rating);
        review.setContent(content);
        review.setCreatedAt(LocalDateTime.now());

        this.reviewService.handleSaveReview(review);

        return "redirect:/product/" + productId;
    }
}
