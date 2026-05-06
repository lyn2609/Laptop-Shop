package vn.hoidanit.laptopshop.controller.client;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import vn.hoidanit.laptopshop.config.VnPayConfig;
import vn.hoidanit.laptopshop.domain.Order;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.service.OrderService;

@Controller
public class VnPayReturnController {

    private final OrderService orderService;

    @Value("${vnpay.hash-secret}")
    private String secretKey;

    public VnPayReturnController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping("/vnpay-return")
    public String vnpayReturn(HttpServletRequest request, Model model) {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0) && fieldName.startsWith("vnp_")) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        // Check checksum
        String signValue = VnPayConfig.hmacSHA512(secretKey, hashAllFields(fields));

        System.out.println("=== VNPAY RETURN DEBUG ===");
        System.out.println("vnp_SecureHash from VNPay: " + vnp_SecureHash);
        System.out.println("Calculated signValue: " + signValue);
        System.out.println("vnp_TransactionStatus: " + request.getParameter("vnp_TransactionStatus"));
        System.out.println("vnp_ResponseCode: " + request.getParameter("vnp_ResponseCode"));

        if (signValue.equals(vnp_SecureHash)) {
            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                // Thanh toán thành công
                String orderIdStr = request.getParameter("vnp_TxnRef");
                try {
                    long orderId = Long.parseLong(orderIdStr);
                    Optional<Order> orderOpt = orderService.fetchOrderById(orderId);
                    if (orderOpt.isPresent()) {
                        Order order = orderOpt.get();
                        order.setStatus("PENDING"); // Cập nhật sang PENDING (chờ giao hàng)
                        orderService.updateOrder(order);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return "redirect:/thanks";
            } else {
                // Thanh toán thất bại hoặc bị hủy
                handleFailedOrder(request.getParameter("vnp_TxnRef"));
                model.addAttribute("error", "Thanh toán VNPay thất bại hoặc đã bị hủy (Mã GD: " + request.getParameter("vnp_TransactionStatus") + ").");
                return "client/cart/vnpay-failed";
            }
        } else {
            // Checksum không hợp lệ
            handleFailedOrder(request.getParameter("vnp_TxnRef"));
            model.addAttribute("error", "Chữ ký VNPay không hợp lệ.");
            return "client/cart/vnpay-failed";
        }
    }

    private void handleFailedOrder(String orderIdStr) {
        try {
            long orderId = Long.parseLong(orderIdStr);
            Optional<Order> orderOpt = orderService.fetchOrderById(orderId);
            if (orderOpt.isPresent()) {
                Order order = orderOpt.get();
                // Hoàn lại kho và voucher
                orderService.cancelOrder(orderId, order.getUser());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String hashAllFields(Map<String, String> fields) {
        java.util.List<String> fieldNames = new java.util.ArrayList<>(fields.keySet());
        java.util.Collections.sort(fieldNames);
        StringBuilder sb = new StringBuilder();
        java.util.Iterator<String> itr = fieldNames.iterator();
        boolean first = true;
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                if (!first) {
                    sb.append("&");
                }
                sb.append(fieldName);
                sb.append("=");
                try {
                    sb.append(java.net.URLEncoder.encode(fieldValue, java.nio.charset.StandardCharsets.UTF_8.toString()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                first = false;
            }
        }
        return sb.toString();
    }
}
