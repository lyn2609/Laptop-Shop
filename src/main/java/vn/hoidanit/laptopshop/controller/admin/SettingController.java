package vn.hoidanit.laptopshop.controller.admin;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.service.UserService;

@Controller
public class SettingController {

    private final UserService userService;

    public SettingController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/admin/setting")
    public String getSettingPage(Model model, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        User currentAdmin = this.userService.getUserByEmail(email);
        model.addAttribute("admin", currentAdmin);
        return "admin/setting/show";
    }

    @PostMapping("/admin/setting/update-info")
    public String updateInfo(
            @RequestParam("fullName") String fullName,
            @RequestParam("phone") String phone,
            @RequestParam("address") String address,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        User admin = this.userService.getUserByEmail(email);
        if (admin != null) {
            admin.setFullName(fullName);
            admin.setPhone(phone);
            admin.setAddress(address);
            this.userService.handleSaveUser(admin);

            HttpSession session = request.getSession(false);
            if (session != null) {
                session.setAttribute("fullName", fullName);
            }
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin thành công");
        }
        return "redirect:/admin/setting";
    }

    @PostMapping("/admin/setting/change-password")
    public String changePassword(
            @RequestParam("oldPassword") String oldPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu xác nhận không khớp");
            return "redirect:/admin/setting";
        }
        if (newPassword.length() < 6) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 6 ký tự");
            return "redirect:/admin/setting";
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        User admin = this.userService.getUserByEmail(email);

        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        if (!encoder.matches(oldPassword, admin.getPassword())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu cũ không đúng");
            return "redirect:/admin/setting";
        }

        admin.setPassword(encoder.encode(newPassword));
        this.userService.handleSaveUser(admin);
        redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công");
        return "redirect:/admin/setting";
    }
}
