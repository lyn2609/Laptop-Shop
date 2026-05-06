package vn.hoidanit.laptopshop.service;

import java.util.List;

import org.springframework.stereotype.Service;

import vn.hoidanit.laptopshop.domain.Product;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.domain.Wishlist;
import vn.hoidanit.laptopshop.repository.WishlistRepository;

@Service
public class WishlistService {

    private final WishlistRepository wishlistRepository;

    public WishlistService(WishlistRepository wishlistRepository) {
        this.wishlistRepository = wishlistRepository;
    }

    public List<Wishlist> getWishlistByUser(User user) {
        return this.wishlistRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public void addProductToWishlist(User user, Product product) {
        Wishlist existing = this.wishlistRepository.findByUserAndProduct(user, product);
        if (existing == null) {
            Wishlist wishlist = new Wishlist();
            wishlist.setUser(user);
            wishlist.setProduct(product);
            wishlist.setCreatedAt(java.time.LocalDateTime.now());
            this.wishlistRepository.save(wishlist);
        }
    }

    public void removeProductFromWishlist(long id) {
        this.wishlistRepository.deleteById(id);
    }
}
