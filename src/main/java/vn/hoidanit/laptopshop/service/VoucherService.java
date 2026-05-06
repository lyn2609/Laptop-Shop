package vn.hoidanit.laptopshop.service;

import java.util.Date;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import vn.hoidanit.laptopshop.domain.Voucher;
import vn.hoidanit.laptopshop.repository.VoucherRepository;

@Service
public class VoucherService {

    private final VoucherRepository voucherRepository;

    public VoucherService(VoucherRepository voucherRepository) {
        this.voucherRepository = voucherRepository;
    }

    // ===== Admin CRUD =====

    public Voucher createVoucher(Voucher voucher) {
        voucher.setUsedCount(0);
        return this.voucherRepository.save(voucher);
    }

    public Voucher updateVoucher(Voucher voucher) {
        return this.voucherRepository.save(voucher);
    }

    public void deleteVoucher(long id) {
        this.voucherRepository.deleteById(id);
    }

    public Optional<Voucher> fetchVoucherById(long id) {
        return this.voucherRepository.findById(id);
    }

    public Page<Voucher> fetchAllVouchers(Pageable pageable) {
        return this.voucherRepository.findAll(pageable);
    }

    /**
     * Lấy danh sách voucher khả dụng để hiển thị cho khách khi checkout.
     * Điều kiện: active = true, chưa hết hạn, chưa hết lượt dùng,
     *            đơn hàng đạt giá trị tối thiểu.
     */
    public java.util.List<Voucher> fetchAvailableVouchers(double orderTotal) {
        java.util.List<Voucher> all = this.voucherRepository.findAll();
        java.util.List<Voucher> available = new java.util.ArrayList<>();
        Date now = new Date();
        for (Voucher v : all) {
            if (!v.isActive()) continue;
            if (v.getExpiryDate() != null && v.getExpiryDate().before(now)) continue;
            if (v.getUsageLimit() > 0 && v.getUsedCount() >= v.getUsageLimit()) continue;
            if (v.getMinOrderValue() > 0 && orderTotal < v.getMinOrderValue()) continue;
            available.add(v);
        }
        return available;
    }

    // ===== Validation logic =====

    /**
     * Validate voucher. Throws RuntimeException with human-readable message on failure.
     */
    public Voucher validateVoucher(String code, double orderTotal) {
        Optional<Voucher> opt = this.voucherRepository.findByCodeIgnoreCase(code);

        if (opt.isEmpty()) {
            throw new RuntimeException("Mã voucher không tồn tại.");
        }

        Voucher v = opt.get();

        if (!v.isActive()) {
            throw new RuntimeException("Mã voucher đã bị vô hiệu hóa.");
        }

        if (v.getExpiryDate() != null && v.getExpiryDate().before(new Date())) {
            throw new RuntimeException("Mã voucher đã hết hạn.");
        }

        if (v.getUsageLimit() > 0 && v.getUsedCount() >= v.getUsageLimit()) {
            throw new RuntimeException("Mã voucher đã hết lượt sử dụng.");
        }

        if (v.getMinOrderValue() > 0 && orderTotal < v.getMinOrderValue()) {
            throw new RuntimeException(
                String.format("Đơn hàng tối thiểu %.0f đ để dùng mã này.", v.getMinOrderValue()));
        }

        return v;
    }

    /**
     * Calculate the actual discount amount for a voucher given an order total.
     */
    public double calculateDiscount(Voucher voucher, double orderTotal) {
        double discount;
        if (voucher.getDiscountType() == Voucher.DiscountType.PERCENT) {
            discount = orderTotal * voucher.getDiscountValue() / 100.0;
            if (voucher.getMaxDiscount() > 0) {
                discount = Math.min(discount, voucher.getMaxDiscount());
            }
        } else {
            // FIXED
            discount = voucher.getDiscountValue();
        }
        // Không được giảm hơn tổng đơn hàng
        return Math.min(discount, orderTotal);
    }

    /**
     * Mark a voucher as used (increment usedCount). Called after successful order.
     */
    public void incrementUsedCount(Voucher voucher) {
        voucher.setUsedCount(voucher.getUsedCount() + 1);
        this.voucherRepository.save(voucher);
    }
}
