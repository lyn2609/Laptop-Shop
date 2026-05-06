package vn.hoidanit.laptopshop.controller.client;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.domain.CustomOAuth2User;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.service.OrderService;
import vn.hoidanit.laptopshop.service.UploadService;
import vn.hoidanit.laptopshop.service.UserService;

@Controller
public class ProfileController {

    private final UserService userService;
    private final UploadService uploadService;
    private final OrderService orderService;

    public ProfileController(UserService userService, UploadService uploadService, OrderService orderService) {
        this.userService = userService;
        this.uploadService = uploadService;
        this.orderService = orderService;
    }

    private User getCurrentUser(HttpSession session) {
        if (session == null) return null;
        Long id = (Long) session.getAttribute("id");
        if (id != null) {
            User user = this.userService.getUserById(id);
            if (user != null) return user;
        }
        // OAuth2 login
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof CustomOAuth2User oAuth2User) {
            return this.userService.getUserByEmail(oAuth2User.getEmail());
        }
        return null;
    }

    @GetMapping("/profile")
    public String getProfilePage(Model model, HttpServletRequest request) {
        User currentUser = getCurrentUser(request.getSession(false));
        if (currentUser == null) return "redirect:/login";

        model.addAttribute("user", currentUser);
        return "client/profile/show";
    }

    @PostMapping("/profile/update")
    public String updateProfile(HttpServletRequest request,
                                @RequestParam("fullName") String fullName,
                                @RequestParam("phone") String phone,
                                @RequestParam("address") String address,
                                @RequestParam("avatarFile") MultipartFile file,
                                RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(request.getSession(false));
        if (currentUser == null) return "redirect:/login";

        String avatar = currentUser.getAvatar();
        if (!file.isEmpty()) {
            avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
            // update session avatar
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.setAttribute("avatar", avatar);
            }
        }
        // update session full name
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute("fullName", fullName);
        }

        this.userService.updateUserProfile(currentUser, fullName, phone, address, avatar);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin thành công!");
        return "redirect:/profile";
    }

    @GetMapping("/profile/change-password")
    public String getChangePasswordPage(Model model, HttpServletRequest request) {
        User currentUser = getCurrentUser(request.getSession(false));
        if (currentUser == null) return "redirect:/login";

        boolean canChangePassword = currentUser.getPassword() != null && !currentUser.getPassword().isBlank();
        model.addAttribute("user", currentUser);
        model.addAttribute("canChangePassword", canChangePassword);
        return "client/profile/change_password";
    }

    @PostMapping("/profile/change-password")
    public String changePassword(HttpServletRequest request,
                                 @RequestParam("oldPassword") String oldPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(request.getSession(false));
        if (currentUser == null) return "redirect:/login";

        boolean canChangePassword = currentUser.getPassword() != null && !currentUser.getPassword().isBlank();
        if (!canChangePassword) {
            redirectAttributes.addFlashAttribute("errorMessage", "Tài khoản mạng xã hội không thể đổi mật khẩu tại đây.");
            return "redirect:/profile/change-password";
        }

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            return "redirect:/profile/change-password";
        }

        boolean isOldPasswordCorrect = this.userService.checkUserPassword(currentUser, oldPassword);
        if (!isOldPasswordCorrect) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu cũ không chính xác!");
            return "redirect:/profile/change-password";
        }

        this.userService.updatePassword(currentUser, newPassword);
        redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công!");
        return "redirect:/profile/change-password";
    }
}
