package vn.hoidanit.laptopshop.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import vn.hoidanit.laptopshop.domain.Voucher;
import vn.hoidanit.laptopshop.service.VoucherService;

@Controller
public class VoucherController {

    private final VoucherService voucherService;

    public VoucherController(VoucherService voucherService) {
        this.voucherService = voucherService;
    }

    @GetMapping("/admin/voucher")
    public String getVoucherPage(Model model, @RequestParam("page") Optional<String> pageOptional) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.parseInt(pageOptional.get());
            }
        } catch (Exception e) {
            // page = 1
        }
        Pageable pageable = PageRequest.of(page - 1, 10);
        Page<Voucher> prs = this.voucherService.fetchAllVouchers(pageable);
        List<Voucher> listVouchers = prs.getContent();
        model.addAttribute("vouchers", listVouchers);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", prs.getTotalPages());
        return "admin/voucher/show";
    }

    @GetMapping("/admin/voucher/create")
    public String getCreateVoucherPage(Model model) {
        model.addAttribute("newVoucher", new Voucher());
        return "admin/voucher/create";
    }

    @PostMapping("/admin/voucher/create")
    public String handleCreateVoucher(@ModelAttribute("newVoucher") Voucher voucher) {
        // Uppercase code
        voucher.setCode(voucher.getCode().toUpperCase().trim());
        this.voucherService.createVoucher(voucher);
        return "redirect:/admin/voucher";
    }

    @GetMapping("/admin/voucher/update/{id}")
    public String getUpdateVoucherPage(Model model, @PathVariable long id) {
        Optional<Voucher> voucherOpt = this.voucherService.fetchVoucherById(id);
        model.addAttribute("newVoucher", voucherOpt.get());
        return "admin/voucher/update";
    }

    @PostMapping("/admin/voucher/update")
    public String handleUpdateVoucher(@ModelAttribute("newVoucher") Voucher voucher) {
        Voucher current = this.voucherService.fetchVoucherById(voucher.getId()).get();
        current.setCode(voucher.getCode().toUpperCase().trim());
        current.setDiscountType(voucher.getDiscountType());
        current.setDiscountValue(voucher.getDiscountValue());
        current.setMinOrderValue(voucher.getMinOrderValue());
        current.setMaxDiscount(voucher.getMaxDiscount());
        current.setUsageLimit(voucher.getUsageLimit());
        current.setExpiryDate(voucher.getExpiryDate());
        current.setActive(voucher.isActive());
        current.setDescription(voucher.getDescription());
        this.voucherService.updateVoucher(current);
        return "redirect:/admin/voucher";
    }

    @GetMapping("/admin/voucher/delete/{id}")
    public String getDeleteVoucherPage(Model model, @PathVariable long id) {
        model.addAttribute("id", id);
        model.addAttribute("newVoucher", new Voucher());
        return "admin/voucher/delete";
    }

    @PostMapping("/admin/voucher/delete")
    public String handleDeleteVoucher(@ModelAttribute("newVoucher") Voucher voucher) {
        this.voucherService.deleteVoucher(voucher.getId());
        return "redirect:/admin/voucher";
    }
}
