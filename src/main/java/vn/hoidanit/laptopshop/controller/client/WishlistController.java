package vn.hoidanit.laptopshop.controller.client;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.domain.Product;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.domain.Wishlist;
import vn.hoidanit.laptopshop.service.ProductService;
import vn.hoidanit.laptopshop.service.WishlistService;

@Controller
public class WishlistController {

    private final WishlistService wishlistService;
    private final ProductService productService;

    public WishlistController(WishlistService wishlistService, ProductService productService) {
        this.wishlistService = wishlistService;
        this.productService = productService;
    }

    @GetMapping("/wishlist")
    public String getWishlistPage(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        long userId = (long) session.getAttribute("id");
        User user = new User();
        user.setId(userId);

        List<Wishlist> wishlists = this.wishlistService.getWishlistByUser(user);
        model.addAttribute("wishlists", wishlists);
        
        return "client/wishlist/show";
    }

    @PostMapping("/wishlist/add")
    public String addProductToWishlist(@RequestParam("productId") long productId, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }

        long userId = (long) session.getAttribute("id");
        User user = new User();
        user.setId(userId);

        Product product = this.productService.fetchProductById(productId).orElse(null);
        if (product != null) {
            this.wishlistService.addProductToWishlist(user, product);
        }

        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/");
    }

    @PostMapping("/wishlist/remove/{id}")
    public String removeProductFromWishlist(@PathVariable long id, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }

        this.wishlistService.removeProductFromWishlist(id);

        return "redirect:/wishlist";
    }
}
