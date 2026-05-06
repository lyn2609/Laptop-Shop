package vn.hoidanit.laptopshop.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import vn.hoidanit.laptopshop.domain.AuthenticationProvider;
import vn.hoidanit.laptopshop.domain.Role;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.domain.dto.RegisterDTO;
import vn.hoidanit.laptopshop.repository.OrderRepository;
import vn.hoidanit.laptopshop.repository.ProductRepository;
import vn.hoidanit.laptopshop.repository.RoleRepository;
import vn.hoidanit.laptopshop.repository.UserRepository;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;

    public UserService(UserRepository userRepository, RoleRepository roleRepository,
            ProductRepository productRepository, OrderRepository orderRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.productRepository = productRepository;
        this.orderRepository = orderRepository;
    }

    public List<User> getAllUsers() {
        return this.userRepository.findAll();
    }

    public List<User> getAllUsersByEmail(String email) {
        return this.userRepository.findOneByEmail(email);
    }

    public User handleSaveUser(User user) {
        User emily = this.userRepository.save(user);
        System.out.println("emily");
        return emily;
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id);
    }

    public void deleteAUser(long id) {
        this.userRepository.deleteById(id);
    }

    public Role getRoleByName(String name) {
        return this.roleRepository.findByName(name);
    }

    public User registerDTOtoUser(RegisterDTO registerDTO) {
        User user = new User();
        user.setFullName(registerDTO.getFirstName() + " " + registerDTO.getLastName());
        user.setEmail(registerDTO.getEmail());
        user.setPassword(registerDTO.getPassword());
        return user;
    }

    public boolean checkEmailExist(String email) {
        return this.userRepository.existsByEmail(email);
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    public long countUsers() {
        return this.userRepository.count();
    }

    public long countProducts() {
        return this.productRepository.count();
    }

    public long countOrders() {
        return this.orderRepository.count();
    }

    public Page<User> fetchUsers(Pageable page) {
        return this.userRepository.findAll(page);
    }

    public void updateResetPasswordToken(String token, String email) throws UserNotFoundException {
        User user = this.userRepository.findByEmail(email);
        if (user != null) {
            user.setResetPasswordToken(token);
            this.userRepository.save(user);
        } else {
            throw new UserNotFoundException("Could not find any user with the email " + email);
        }
    }

    public User get(String resetPasswordToken) {
        return userRepository.findByResetPasswordToken(resetPasswordToken);
    }

    public void updatePassword(User user, String newPassword) {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        String encodedPassword = passwordEncoder.encode(newPassword);
        user.setPassword(encodedPassword);
        user.setResetPasswordToken(null);
        userRepository.save(user);
    }

    public void createNewCustomerAfterOAuthLoginSuccess(String email, String name, AuthenticationProvider provider) {
        User user = new User();
        user.setEmail(email);
        user.setFullName(name);
        user.setAuthProvider(provider);
        Role customerRole = this.roleRepository.findByName("USER");
        user.setRole(customerRole);
        user.setAvatar("avatar.jpg");

        this.userRepository.save(user);
    }

    public void updateCustomerAfterOAuthLoginSuccess(User user, String name, AuthenticationProvider provider) {
        user.setFullName(name);
        // Do not overwrite LOCAL accounts to GOOGLE when they sign in with the same email.
        if (user.getAuthProvider() == null) {
            user.setAuthProvider(provider);
        }
        if (user.getRole() == null) {
            Role customerRole = this.roleRepository.findByName("USER");
            user.setRole(customerRole);
        }
        if (user.getAvatar() == null || user.getAvatar().isBlank()) {
            user.setAvatar("avatar.jpg");
        }
        this.userRepository.save(user);
    }

    public boolean checkUserPassword(User user, String oldPassword) {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        return passwordEncoder.matches(oldPassword, user.getPassword());
    }

    public void updateUserProfile(User user, String name, String phone, String address, String avatar) {
        user.setFullName(name);
        user.setPhone(phone);
        user.setAddress(address);
        if (avatar != null && !avatar.isEmpty()) {
            user.setAvatar(avatar);
        }
        this.userRepository.save(user);
    }
}
