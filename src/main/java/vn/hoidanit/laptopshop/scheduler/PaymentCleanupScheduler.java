package vn.hoidanit.laptopshop.scheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import vn.hoidanit.laptopshop.service.OrderService;

/**
 * Scheduled task: tự động hủy các đơn hàng PAYMENT_PENDING quá 5 phút.
 * Chạy mỗi 1 phút.
 */
@Component
public class PaymentCleanupScheduler {

    private static final Logger logger = LoggerFactory.getLogger(PaymentCleanupScheduler.class);

    private final OrderService orderService;

    public PaymentCleanupScheduler(OrderService orderService) {
        this.orderService = orderService;
    }

    @Scheduled(fixedRate = 60 * 1000) // Chạy mỗi 1 phút
    public void cleanupExpiredPayments() {
        int cancelled = this.orderService.cancelExpiredPendingPayments();
        if (cancelled > 0) {
            logger.info("PaymentCleanup: Đã hủy {} đơn PAYMENT_PENDING quá hạn.", cancelled);
        }
    }
}
