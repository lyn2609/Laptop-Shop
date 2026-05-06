package vn.hoidanit.laptopshop.site.security.oauth;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.domain.AuthenticationProvider;
import vn.hoidanit.laptopshop.domain.CustomOAuth2User;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.service.UserService;

@Component
public class OAuth2LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
    private final UserService userService;

    public OAuth2LoginSuccessHandler(UserService userService) {
        this.userService = userService;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        CustomOAuth2User oAuth2User = (CustomOAuth2User) authentication.getPrincipal();
        String name = oAuth2User.getFullName();
        String email = oAuth2User.getEmail();

        User user = this.userService.getUserByEmail(email);
        if (user == null) {
            // register a new account
            this.userService.createNewCustomerAfterOAuthLoginSuccess(email, name, AuthenticationProvider.GOOGLE);
            user = this.userService.getUserByEmail(email); 
        } else {
            // update existing customer
            this.userService.updateCustomerAfterOAuthLoginSuccess(user, name, AuthenticationProvider.GOOGLE);
        }
        HttpSession session = request.getSession();
        session.setAttribute("id", user.getId());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("fullName", user.getFullName());
        session.setAttribute("avatar", user.getAvatar()); 

        super.onAuthenticationSuccess(request, response, authentication);
    }

}
