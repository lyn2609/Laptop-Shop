package vn.hoidanit.laptopshop.controller.admin;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.service.UploadService;
import vn.hoidanit.laptopshop.service.UserService;


@Controller
public class UserController {
    private final UserService userService;
    private final UploadService uploadService;
    private final PasswordEncoder passwordEncoder;

    public UserController(UploadService uploadService, UserService userService, PasswordEncoder passwordEncoder) {
        this.uploadService = uploadService;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @RequestMapping("/")
    public String getHomePage(Model model){
        List <User> arrUsers = this.userService.getAllUsersByEmail("nhi@gmail.com");
        System.out.println(arrUsers);
        model.addAttribute("eric", "test");
        model.addAttribute("hoidanit", "from controller with model");
        return "hello";
    }

    @RequestMapping("/admin/user")
    public String getUserPage(Model model){
        List <User> users = this.userService.getAllUsers();
        model.addAttribute("users1", users);
        return "admin/user/show";
    }

    @GetMapping("/admin/user/{id}")
    public String getUserDetailPage(Model model, @PathVariable long id){
        User user = this.userService.getUserById(id);
        model.addAttribute("user", user);
        model.addAttribute("id", id);
        return "admin/user/detail";
    }

    @GetMapping("/admin/user/update/{id}")
    public String getUpdatePage(Model model, @PathVariable long id){
        User currentUser = this.userService.getUserById(id);
        model.addAttribute("newUser", currentUser);
        return "admin/user/update";
    }

    @PostMapping("/admin/user/update")
    public String handleUpdateUser(@ModelAttribute("newUser") User yennhi,
            @RequestParam("hoidanitFile") MultipartFile file) {
        User currentUser = this.userService.getUserById(yennhi.getId());

        if (currentUser != null) {
            if (!file.isEmpty()) {
                String avatarImg = this.uploadService.handleSaveUploadFile(file, "avatar");
                currentUser.setAvatar(avatarImg);
            }
            currentUser.setFullName(yennhi.getFullName());
            currentUser.setAddress(yennhi.getAddress());
            currentUser.setPhone(yennhi.getPhone());
            this.userService.handleSaveUser(currentUser);
        }
        return "redirect:/admin/user";
    }

    @GetMapping("/admin/user/create")
    public String getCreateUserPage(Model model){
        model.addAttribute("newUser", new User());
        return "admin/user/create";
    }

    
    @PostMapping(value = "/admin/user/create")
    public String createUserPage(Model model,
            @ModelAttribute("newUser") @Valid User yennhi,
            BindingResult newUserBindingResult,@RequestParam("hoidanitFile") MultipartFile file
        ) {
            List<FieldError> errors = newUserBindingResult.getFieldErrors();
            for (FieldError error : errors) {
                System.out.println(">>>>>>" + error.getField() + " - " + error.getDefaultMessage());
            }
            //validate
            if(newUserBindingResult.hasErrors()){
                return "/admin/user/create";
            }
            
        String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
        String hashPassword = this.passwordEncoder.encode(yennhi.getPassword());
        yennhi.setPassword(hashPassword);
        yennhi.setAvatar(avatar);
        yennhi.setRole(this.userService.getRoleByName(yennhi.getRole().getName()));
        this.userService.handleSaveUser(yennhi);
        return "redirect:/admin/user";
    }

    @GetMapping("/admin/user/delete/{id}")
    public String getDeleteUserPage(Model model, @PathVariable long id){
        model.addAttribute("id", id);
        // User user = new User();
        // user.setId(id);
        model.addAttribute("newUser", new User());
        return "admin/user/delete";
    }

    @PostMapping("/admin/user/delete")
    public String postDeleteUser(Model model, @ModelAttribute("newUser") User yennhi){
        this.userService.deleteAUser(yennhi.getId());
        return "redirect:/admin/user";
    }
}
