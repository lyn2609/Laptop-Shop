package vn.hoidanit.laptopshop.controller.client;

import java.io.UnsupportedEncodingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpServletRequest;
import net.bytebuddy.utility.RandomString;
import vn.hoidanit.laptopshop.service.UserNotFoundException;
import vn.hoidanit.laptopshop.service.UserService;
import vn.hoidanit.laptopshop.site.Utility;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.domain.dto.RegisterDTO;

@Controller
public class ForgotPasswordController {
    private final UserService userService;

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String mailFrom;

    public ForgotPasswordController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm(Model model) {
        model.addAttribute("loginUser", "Forgot Password");
        return "client/auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassswordForm(HttpServletRequest request, Model model) throws UnsupportedEncodingException, MessagingException{
        String email = request.getParameter("email");
        String token =RandomString.make(45);
        // System.out.println("Email: " + email);
        // System.out.println("Token: " + token);
        try {
            this.userService.updateResetPasswordToken(token, email);
            String resetPasswordLink = Utility.getSiteURL(request) + "/reset-password?token=" + token;
            sendEmail(email, resetPasswordLink);
            model.addAttribute("success", "We have sent a reset password link to your email. Please check.");
        } catch (UserNotFoundException ex) {
            model.addAttribute("error", ex.getMessage());
        }catch(UnsupportedEncodingException | MessagingException e){
            model.addAttribute("error", "Error sending email.");
        }
        model.addAttribute("loginUser", "Forgot Password");
        return "client/auth/forgot-password";
    }

    private void sendEmail(String email, String resetPasswordLink) throws UnsupportedEncodingException, MessagingException{
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message);
        helper.setFrom(mailFrom, "Laptop Shop Support");
        helper.setTo(email);
        String subject = "Here's the link to reset your password";
        String content = "<p>Hello,</p>"
                + "<p>You have requested to reset your password.</p>"
                + "<p>Click the link below to change your password:</p>"
                + "<p><b><a href=\"" + resetPasswordLink + "\">Change my password</a><b></p>"
                + "<p>Ignore this email if you do remember your password, or you have not made the request.<p>";
        helper.setSubject(subject);
        helper.setText(content, true); 
        mailSender.send(message);
    }

    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam(value = "token") String token, Model model){
        User user = this.userService.get(token);
        if(user == null){
            model.addAttribute("title", "Reset your password");
            model.addAttribute("message", "Invalid Token");
            return "client/auth/message";
        }
        model.addAttribute("resetPassword", new RegisterDTO());
        model.addAttribute("token", token);
        model.addAttribute("loginUser", "Forgot Password");
        return "client/auth/reset-password-form";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(HttpServletRequest request, Model model){
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        User user = this.userService.get(token);
        if(user == null){
            model.addAttribute("title", "Reset your password");
            model.addAttribute("message", "Invalid Token");
            return "client/auth/message";
        }
        else{
            this.userService.updatePassword(user, password);
            model.addAttribute("message", "You have successfully changed your password.");
        }
        return "client/auth/message";
    }

}
