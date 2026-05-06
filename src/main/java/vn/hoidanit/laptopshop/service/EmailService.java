package vn.hoidanit.laptopshop.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

// Lưu ý: Nếu bạn dùng Spring Boot 3.x thì dùng jakarta, nếu dùng Spring Boot 2.x thì đổi thành javax.mail
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    private final JavaMailSender javaMailSender;
    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    public EmailService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    @Async
    public void sendOrderDeliveredEmail(String to, String orderId, String receiverName) {
        if (to == null || to.isEmpty()) {
            logger.warn("Cannot send email: recipient address is null or empty for order {}", orderId);
            return;
        }
        
        try {
            // Dùng MimeMessage để hỗ trợ gửi email định dạng HTML
            MimeMessage message = javaMailSender.createMimeMessage();
            // Tham số 'true' cho phép hỗ trợ multipart (đính kèm file, ảnh, html...)
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setTo(to);
            helper.setSubject("🎉 Thông báo giao hàng thành công - Đơn hàng #" + orderId);
            
            // Thiết kế template HTML nội tuyến (Inline HTML/CSS) bằng Text Block
            String htmlContent = """
                    <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                        <div style="background-color: #0d6efd; color: #ffffff; padding: 25px; text-align: center;">
                            <h2 style="margin: 0; font-size: 24px;">Giao Hàng Thành Công! 📦</h2>
                        </div>
                        
                        <div style="padding: 30px; color: #333333; line-height: 1.6; background-color: #ffffff;">
                            <p style="font-size: 16px; margin-top: 0;">Xin chào <strong>%s</strong>,</p>
                            <p style="font-size: 16px;">Tuyệt vời! Đơn hàng <strong>#%s</strong> của bạn đã được giao đến nơi an toàn.</p>
                            <p style="font-size: 16px;">Cảm ơn bạn đã tin tưởng và mua sắm tại <strong>LaptopShop</strong>. Chúc bạn có những trải nghiệm thật tốt với sản phẩm của chúng tôi!</p>
                            
                            <div style="text-align: center; margin: 35px 0 15px 0;">
                                <a href="#" style="background-color: #198754; color: #ffffff; padding: 14px 28px; text-decoration: none; border-radius: 6px; font-weight: bold; font-size: 16px; display: inline-block;">Xem Chi Tiết Đơn Hàng</a>
                            </div>
                        </div>
                        
                        <div style="background-color: #f8f9fa; padding: 20px; text-align: center; font-size: 13px; color: #6c757d; border-top: 1px solid #eeeeee;">
                            <p style="margin: 0;">Đây là email tự động, vui lòng không trả lời.</p>
                            <p style="margin: 5px 0 0 0;">&copy; 2026 LaptopShop Team. All rights reserved.</p>
                        </div>
                    </div>
                    """.formatted(receiverName, orderId);
            
            // Tham số 'true' ở đây khai báo rằng nội dung này là HTML
            helper.setText(htmlContent, true);
            
            javaMailSender.send(message);
            logger.info("Email sent successfully to {} for order {}", to, orderId);
            
        } catch (Exception e) {
            logger.error("Failed to send email to {} for order {}: {}", to, orderId, e.getMessage());
        }
    }
}