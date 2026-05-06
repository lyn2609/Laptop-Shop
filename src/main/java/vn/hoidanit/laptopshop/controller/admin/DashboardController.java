package vn.hoidanit.laptopshop.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import vn.hoidanit.laptopshop.repository.VoucherRepository;
import vn.hoidanit.laptopshop.service.UserService;

@Controller
public class DashboardController {
    private final UserService userService;
    private final VoucherRepository voucherRepository;

    public DashboardController(UserService userService, VoucherRepository voucherRepository) {
        this.userService = userService;
        this.voucherRepository = voucherRepository;
    }

    @GetMapping("/admin")
    public String getDashboard(Model model) {
        model.addAttribute("countUsers", this.userService.countUsers());
        model.addAttribute("countProducts", this.userService.countProducts());
        model.addAttribute("countOrders", this.userService.countOrders());
        model.addAttribute("countVouchers", this.voucherRepository.count());
        return "admin/dashboard/show";
    }

}
