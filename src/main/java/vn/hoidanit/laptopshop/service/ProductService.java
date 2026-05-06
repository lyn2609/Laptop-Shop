package vn.hoidanit.laptopshop.service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.domain.Cart;
import vn.hoidanit.laptopshop.domain.CartDetail;
import vn.hoidanit.laptopshop.domain.Order;
import vn.hoidanit.laptopshop.domain.OrderDetail;
import vn.hoidanit.laptopshop.domain.Product;
import vn.hoidanit.laptopshop.domain.Product_;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.domain.Voucher;
import vn.hoidanit.laptopshop.domain.dto.ProductCriteriaDTO;
import vn.hoidanit.laptopshop.repository.CartDetailRepository;
import vn.hoidanit.laptopshop.repository.CartRepository;
import vn.hoidanit.laptopshop.repository.OrderDetailRepository;
import vn.hoidanit.laptopshop.repository.OrderRepository;
import vn.hoidanit.laptopshop.repository.ProductRepository;
import vn.hoidanit.laptopshop.service.specification.ProductSpecs;


@Service
public class ProductService {
    private final ProductRepository productRepository;
    private final CartRepository cartRepository;
    private final CartDetailRepository cartDetailRepository;
    private final UserService userService;
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final VoucherService voucherService;

    public ProductService(ProductRepository productRepository, CartRepository cartRepository,
        CartDetailRepository cartDetailRepository, UserService userService,
        OrderRepository orderRepository, OrderDetailRepository orderDetailRepository,
        VoucherService voucherService
    ) {
        this.productRepository = productRepository;
        this.cartRepository = cartRepository;
        this.cartDetailRepository = cartDetailRepository;
        this.userService = userService;
        this.orderRepository = orderRepository;
        this.orderDetailRepository = orderDetailRepository;
        this.voucherService = voucherService;
    }

    public Product createProduct(Product pr) {
        return this.productRepository.save(pr);
    }

    private Specification<Product> nameLike(String name) {
        return (root, query, criteriaBuilder) -> criteriaBuilder.like(root.get(Product_.NAME), "%" + name + "%");
    }

    public Page <Product> fetchProducts(Pageable page) {
        return this.productRepository.findAll(page);
    }

    public List<vn.hoidanit.laptopshop.domain.dto.ProductSearchDTO> searchProductsByName(String name) {
        List<Product> products = this.productRepository.findTop5ByNameContainingIgnoreCase(name);
        return products.stream()
                .map(p -> new vn.hoidanit.laptopshop.domain.dto.ProductSearchDTO(
                        p.getId(), p.getName(), p.getImage(), p.getPrice()))
                .toList();
    }


    public Page<Product> fetchProductsWithSpec(Pageable page, ProductCriteriaDTO productCriteriaDTO) {
        if(productCriteriaDTO.getTarget() == null
            && productCriteriaDTO.getFactory() == null
            && productCriteriaDTO.getPrice() == null
            && productCriteriaDTO.getRam() == null
            && productCriteriaDTO.getCpu() == null
            && productCriteriaDTO.getName() == null){
                return this.productRepository.findAll(page);
            }
        Specification <Product> combinedSpec = Specification.where(null);
        if(productCriteriaDTO.getName() != null && productCriteriaDTO.getName().isPresent()){
            Specification <Product> currentSpecs = ProductSpecs.nameLike(productCriteriaDTO.getName().get());
            combinedSpec = combinedSpec.and(currentSpecs);
        }
        if(productCriteriaDTO.getTarget() != null && productCriteriaDTO.getTarget().isPresent()){
            Specification <Product> currentSpecs = ProductSpecs.matchListTarget(productCriteriaDTO.getTarget().get());
            combinedSpec = combinedSpec.and(currentSpecs);
        }
        if(productCriteriaDTO.getFactory() != null && productCriteriaDTO.getFactory().isPresent()){
            Specification <Product> currentSpecs = ProductSpecs.matchListFactory(productCriteriaDTO.getFactory().get());
            combinedSpec = combinedSpec.and(currentSpecs);
        }
        if(productCriteriaDTO.getPrice() != null && productCriteriaDTO.getPrice().isPresent()){
            Specification <Product> currentSpecs = this.buildPriceSpecification(productCriteriaDTO.getPrice().get());
            combinedSpec = combinedSpec.and(currentSpecs);
        }
        if(productCriteriaDTO.getRam() != null && productCriteriaDTO.getRam().isPresent()){
            Specification <Product> currentSpecs = ProductSpecs.matchListRam(productCriteriaDTO.getRam().get());
            combinedSpec = combinedSpec.and(currentSpecs);
        }
        if(productCriteriaDTO.getCpu() != null && productCriteriaDTO.getCpu().isPresent()){
            Specification <Product> currentSpecs = ProductSpecs.matchListCpu(productCriteriaDTO.getCpu().get());
            combinedSpec = combinedSpec.and(currentSpecs);
        }
        return this.productRepository.findAll(combinedSpec, page);
    }

    public Specification<Product> buildPriceSpecification(List<String> price) {
        Specification<Product> combinedSpec = Specification.where(null); // disconjunction
        for (String p : price) {
            double min = 0;
            double max = 0;

            // Set the appropriate min and max based on the price range string
            switch (p) {
                case "duoi-20-trieu":
                    min = 1;
                    max = 20000000;
                    break;
                case "20-25-trieu":
                    min = 20000000;
                    max = 25000000;
                    break;
                case "25-30-trieu":
                    min = 25000000;
                    max = 30000000;
                    break;
                case "tren-30-trieu":
                    min = 30000000;
                    max = 200000000;
                    break;
            }

            if (min != 0 && max != 0) {
                Specification<Product> rangeSpec = ProductSpecs.matchMultiplePrice(min, max);
                combinedSpec = combinedSpec.or(rangeSpec);
            }
        }

        return combinedSpec;
    }


    public Optional<Product> fetchProductById(long id) {
        return this.productRepository.findById(id);
    }

    public long countProductsByFactory(String factory) {
        return this.productRepository.countByFactory(factory);
    }

    public void deleteAProduct(long id){
        this.productRepository.deleteById(id);
    }

    public void handleAddProductToCart(String email, long productId, HttpSession session, long quantity){
        User user = this.userService.getUserByEmail(email);
        if (user == null) {
            throw new RuntimeException("Không tìm thấy người dùng");
        }

        Cart cart = this.cartRepository.findByUser(user);
        if (cart == null) {
            Cart otherCart = new Cart();
            otherCart.setUser(user);
            otherCart.setSum(0);
            cart = this.cartRepository.save(otherCart);
        }

        Optional<Product> productOptional = this.productRepository.findById(productId);
        if (!productOptional.isPresent()) {
            throw new RuntimeException("Không tìm thấy sản phẩm");
        }

        Product realProduct = productOptional.get();

        if (realProduct.getQuantity() <= 0) {
            throw new RuntimeException("Sản phẩm đã hết hàng");
        }

        CartDetail oldDetail = this.cartDetailRepository.findByCartAndProduct(cart, realProduct);

        if (oldDetail == null) {
            if (quantity > realProduct.getQuantity()) {
                throw new RuntimeException("Kho không đủ - chỉ còn " + realProduct.getQuantity() + " sản phẩm");
            }

            CartDetail cd = new CartDetail();
            cd.setCart(cart);
            cd.setProduct(realProduct);
            cd.setPrice(realProduct.getPrice());
            cd.setQuantity(quantity);
            this.cartDetailRepository.save(cd);

            int newSum = (int) (cart.getSum() + quantity);
            cart.setSum(newSum);
            this.cartRepository.save(cart);
            session.setAttribute("sum", newSum);
        } else {
            long totalQty = oldDetail.getQuantity() + quantity;
            if (totalQty > realProduct.getQuantity()) {
                throw new RuntimeException("Kho không đủ - chỉ còn " + realProduct.getQuantity()
                        + " sản phẩm (giỏ đang có " + oldDetail.getQuantity() + ")");
            }

            oldDetail.setQuantity(totalQty);
            this.cartDetailRepository.save(oldDetail);

            int newSum = (int) (cart.getSum() + quantity);
            cart.setSum(newSum);
            this.cartRepository.save(cart);
            session.setAttribute("sum", newSum);
        }
    }

    public Cart fetchByUser(User user){
        return this.cartRepository.findByUser(user);
    }

    public void handleRemoveCartDetail(long cartDetailId, HttpSession session){
        Optional<CartDetail> cartDetailOptional = this.cartDetailRepository.findById(cartDetailId);
        if(cartDetailOptional.isPresent()){
            CartDetail cartDetail = cartDetailOptional.get();
            Cart currentCart = cartDetail.getCart();
            long removedQty = cartDetail.getQuantity();

            this.cartDetailRepository.deleteById(cartDetailId);

            int newSum = (int) (currentCart.getSum() - removedQty);
            if (newSum < 0) newSum = 0;

            if (newSum > 0) {
                currentCart.setSum(newSum);
                this.cartRepository.save(currentCart);
                session.setAttribute("sum", newSum);
            } else {
                this.cartRepository.deleteById(currentCart.getId());
                session.setAttribute("sum", 0);
            }
        }
    }

    public Optional<CartDetail> findCartDetailById(long id) {
        return this.cartDetailRepository.findById(id);
    }

    public void saveCart(Cart cart) {
        this.cartRepository.save(cart);
    }

    public void handleUpdateCartBeforeCheckout(List<CartDetail> cartDetails){
        for(CartDetail cartDetail : cartDetails){
            Optional <CartDetail> cdOptional = this.cartDetailRepository.findById(cartDetail.getId());
            if(cdOptional.isPresent()){
                CartDetail currentCartDetail = cdOptional.get();
                currentCartDetail.setQuantity(cartDetail.getQuantity());
                this.cartDetailRepository.save(currentCartDetail);
            }
        }
    }

    public Order handlePlaceOrder(User user, HttpSession session,
        String receiverName, String receiverAddress, String receiverPhone,
        String voucherCode
    ){
        //step 1: get cart by user
        Cart cart = this.cartRepository.findByUser(user);
        if(cart != null){
            List <CartDetail> cartDetails = cart.getCartDetails();
            if(cartDetails != null && !cartDetails.isEmpty()){
                // create order
                Order order = new Order();
                order.setUser(user);
                order.setReceiverName(receiverName);
                order.setReceiverAddress(receiverAddress);
                order.setReceiverPhone(receiverPhone);
                order.setStatus("PENDING");
                order.setCreatedAt(new Date());

                double sum = 0;
                for(CartDetail cd : cartDetails){
                    sum += cd.getPrice() * cd.getQuantity();
                }
                order.setTotalPrice(sum);

                // Apply voucher if provided
                double discountAmount = 0;
                if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                    try {
                        Voucher voucher = this.voucherService.validateVoucher(voucherCode.trim(), sum);
                        discountAmount = this.voucherService.calculateDiscount(voucher, sum);
                        order.setVoucherCode(voucherCode.trim().toUpperCase());
                        order.setDiscountAmount(discountAmount);
                        this.voucherService.incrementUsedCount(voucher);
                    } catch (RuntimeException e) {
                        // Voucher invalid at order time – ignore silently, place order at full price
                    }
                }
                order.setFinalPrice(sum - discountAmount);
                order = this.orderRepository.save(order);

                // create orderDetail + update stock
                for (CartDetail cd : cartDetails) {
                    OrderDetail orderDetail = new OrderDetail();
                    orderDetail.setOrder(order);
                    orderDetail.setProduct(cd.getProduct());
                    orderDetail.setPrice(cd.getPrice());
                    orderDetail.setQuantity(cd.getQuantity());
                    this.orderDetailRepository.save(orderDetail);

                    // Trừ kho + tăng sold
                    Product product = cd.getProduct();
                    long newQty = product.getQuantity() - cd.getQuantity();
                    product.setQuantity(Math.max(newQty, 0));
                    product.setSold(product.getSold() + cd.getQuantity());
                    this.productRepository.save(product);
                }

                // step 2: delete cart_detail and cart
                for (CartDetail cd : cartDetails) {
                    this.cartDetailRepository.deleteById(cd.getId());
                }
                this.cartRepository.deleteById(cart.getId());

                // step 3: update session
                session.setAttribute("sum", 0);
                
                return order;
            }
        }
        return null;
    }

}
    

