package vn.hoidanit.laptopshop.controller.client;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import vn.hoidanit.laptopshop.domain.dto.ProductSearchDTO;
import vn.hoidanit.laptopshop.service.ProductService;

@RestController
@RequestMapping("/api/products")
public class ProductAPIController {

    private final ProductService productService;

    public ProductAPIController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/search")
    public ResponseEntity<List<ProductSearchDTO>> searchProducts(@RequestParam("query") String query) {
        if (query == null || query.trim().isEmpty()) {
            return ResponseEntity.ok(List.of());
        }
        List<ProductSearchDTO> products = this.productService.searchProductsByName(query);
        return ResponseEntity.ok(products);
    }
}
