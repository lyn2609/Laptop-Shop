package vn.hoidanit.laptopshop.service;

import java.util.List;

import org.springframework.stereotype.Service;

import vn.hoidanit.laptopshop.domain.Product;
import vn.hoidanit.laptopshop.domain.Review;
import vn.hoidanit.laptopshop.repository.ReviewRepository;

@Service
public class ReviewService {
    
    private final ReviewRepository reviewRepository;

    public ReviewService(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    public Review handleSaveReview(Review review) {
        return this.reviewRepository.save(review);
    }

    public List<Review> getReviewsByProduct(Product product) {
        return this.reviewRepository.findByProductOrderByCreatedAtDesc(product);
    }

    public double calculateAverageRating(Product product) {
        List<Review> reviews = this.getReviewsByProduct(product);
        if (reviews.isEmpty()) {
            return 0;
        }
        double sum = 0;
        for (Review r : reviews) {
            sum += r.getRating();
        }
        return Math.round((sum / reviews.size()) * 10.0) / 10.0;
    }
}
