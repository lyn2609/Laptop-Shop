package vn.hoidanit.laptopshop.service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.hoidanit.laptopshop.domain.Order;
import vn.hoidanit.laptopshop.domain.OrderDetail;
import vn.hoidanit.laptopshop.domain.Product;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.domain.Voucher;
import vn.hoidanit.laptopshop.repository.OrderDetailRepository;
import vn.hoidanit.laptopshop.repository.OrderRepository;
import vn.hoidanit.laptopshop.repository.ProductRepository;
import vn.hoidanit.laptopshop.repository.VoucherRepository;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final ProductRepository productRepository;
    private final VoucherRepository voucherRepository;
    private final EmailService emailService;

    public OrderService(
            OrderRepository orderRepository,
            OrderDetailRepository orderDetailRepository,
            ProductRepository productRepository,
            VoucherRepository voucherRepository,
            EmailService emailService) {
        this.orderDetailRepository = orderDetailRepository;
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
        this.voucherRepository = voucherRepository;
        this.emailService = emailService;
    }

    public List<Order> fetchAllOrders() {
        return this.orderRepository.findAll();
    }

    public Optional<Order> fetchOrderById(long id) {
        return this.orderRepository.findById(id);
    }

    public void deleteOrderById(long id) {
        // delete order detail
        Optional<Order> orderOptional = this.fetchOrderById(id);
        if (orderOptional.isPresent()) {
            Order order = orderOptional.get();
            List<OrderDetail> orderDetails = order.getOrderDetails();
            for (OrderDetail orderDetail : orderDetails) {
                this.orderDetailRepository.deleteById(orderDetail.getId());
            }
        }

        this.orderRepository.deleteById(id);
    }

    public void updateOrder(Order order) {
        Optional<Order> orderOptional = this.fetchOrderById(order.getId());
        if (orderOptional.isPresent()) {
            Order currentOrder = orderOptional.get();
            String oldStatus = currentOrder.getStatus();
            currentOrder.setStatus(order.getStatus());
            this.orderRepository.save(currentOrder);

            if (!"COMPLETE".equals(oldStatus) && "COMPLETE".equals(order.getStatus())) {
                if (currentOrder.getUser() != null && currentOrder.getUser().getEmail() != null) {
                    this.emailService.sendOrderDeliveredEmail(
                        currentOrder.getUser().getEmail(),
                        String.valueOf(currentOrder.getId()),
                        currentOrder.getReceiverName()
                    );
                }
            }
        }
    }

    public List<Order> fetchOrderByUser(User user) {
        return this.orderRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public Page<Order> fetchAllOrders(Pageable page) {
        return this.orderRepository.findAll(page);
    }

    /**
     * Hủy đơn hàng: chỉ cho phép khi status = PENDING
     * - Hoàn lại tồn kho (quantity) và giảm sold
     * - Hoàn lại lượt dùng voucher (nếu có)
     * - Đổi status thành CANCELLED
     */
    @Transactional
    public boolean cancelOrder(long orderId, User currentUser) {
        Optional<Order> orderOptional = this.fetchOrderById(orderId);
        if (orderOptional.isEmpty()) {
            return false;
        }

        Order order = orderOptional.get();

        // Chỉ cho hủy đơn PENDING hoặc PAYMENT_PENDING, và đúng chủ đơn
        String status = order.getStatus();
        boolean isCancellable = "PENDING".equals(status) || "PAYMENT_PENDING".equals(status);
        if (!isCancellable || order.getUser().getId() != currentUser.getId()) {
            return false;
        }

        // 1. Hoàn kho
        List<OrderDetail> orderDetails = order.getOrderDetails();
        for (OrderDetail od : orderDetails) {
            Product product = od.getProduct();
            product.setQuantity(product.getQuantity() + od.getQuantity());
            long newSold = product.getSold() - od.getQuantity();
            product.setSold(Math.max(newSold, 0));
            this.productRepository.save(product);
        }

        // 2. Hoàn voucher (giảm usedCount)
        if (order.getVoucherCode() != null && !order.getVoucherCode().isEmpty()) {
            Optional<Voucher> voucherOpt = this.voucherRepository.findByCodeIgnoreCase(order.getVoucherCode());
            if (voucherOpt.isPresent()) {
                Voucher voucher = voucherOpt.get();
                if (voucher.getUsedCount() > 0) {
                    voucher.setUsedCount(voucher.getUsedCount() - 1);
                    this.voucherRepository.save(voucher);
                }
            }
        }

        // 3. Cập nhật status
        order.setStatus("CANCELLED");
        this.orderRepository.save(order);

        return true;
    }

    /**
     * Tự động hủy tất cả đơn PAYMENT_PENDING đã quá thời hạn (30 phút).
     * Hoàn kho + hoàn voucher + đổi status thành CANCELLED.
     */
    @Transactional
    public int cancelExpiredPendingPayments() {
        // Tìm các đơn PAYMENT_PENDING được tạo trước 5 phút
        Date cutoff = new Date(System.currentTimeMillis() - 5 * 60 * 1000);
        List<Order> expiredOrders = this.orderRepository.findByStatusAndCreatedAtBefore("PAYMENT_PENDING", cutoff);

        int cancelledCount = 0;
        for (Order order : expiredOrders) {
            // Hoàn kho
            List<OrderDetail> orderDetails = order.getOrderDetails();
            for (OrderDetail od : orderDetails) {
                Product product = od.getProduct();
                product.setQuantity(product.getQuantity() + od.getQuantity());
                long newSold = product.getSold() - od.getQuantity();
                product.setSold(Math.max(newSold, 0));
                this.productRepository.save(product);
            }

            // Hoàn voucher
            if (order.getVoucherCode() != null && !order.getVoucherCode().isEmpty()) {
                Optional<Voucher> voucherOpt = this.voucherRepository.findByCodeIgnoreCase(order.getVoucherCode());
                if (voucherOpt.isPresent()) {
                    Voucher voucher = voucherOpt.get();
                    if (voucher.getUsedCount() > 0) {
                        voucher.setUsedCount(voucher.getUsedCount() - 1);
                        this.voucherRepository.save(voucher);
                    }
                }
            }

            // Cập nhật status
            order.setStatus("CANCELLED");
            this.orderRepository.save(order);
            cancelledCount++;
        }
        return cancelledCount;
    }

}
