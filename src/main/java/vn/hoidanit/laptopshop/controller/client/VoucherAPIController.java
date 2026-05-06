package vn.hoidanit.laptopshop.controller.client;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import vn.hoidanit.laptopshop.domain.Voucher;
import vn.hoidanit.laptopshop.service.VoucherService;

@RestController
@RequestMapping("/api/voucher")
public class VoucherAPIController {

    private final VoucherService voucherService;

    public VoucherAPIController(VoucherService voucherService) {
        this.voucherService = voucherService;
    }

    @PostMapping("/validate")
    public ResponseEntity<Map<String, Object>> validateVoucher(@RequestBody Map<String, Object> body) {
        Map<String, Object> response = new HashMap<>();

        String code = (String) body.get("code");
        double orderTotal = 0;
        Object totalObj = body.get("orderTotal");
        if (totalObj instanceof Number) {
            orderTotal = ((Number) totalObj).doubleValue();
        }

        try {
            Voucher voucher = this.voucherService.validateVoucher(code, orderTotal);
            double discountAmount = this.voucherService.calculateDiscount(voucher, orderTotal);
            double finalPrice = orderTotal - discountAmount;

            response.put("valid", true);
            response.put("discountAmount", discountAmount);
            response.put("finalPrice", finalPrice);
            response.put("discountType", voucher.getDiscountType().name());
            response.put("discountValue", voucher.getDiscountValue());
            response.put("message", "Áp dụng mã giảm giá thành công!");
            return ResponseEntity.ok(response);

        } catch (RuntimeException e) {
            response.put("valid", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }
}
