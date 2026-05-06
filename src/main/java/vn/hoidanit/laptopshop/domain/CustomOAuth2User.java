package vn.hoidanit.laptopshop.domain;

import java.util.Collection;
import java.util.Map;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.io.Serializable;

public class CustomOAuth2User implements OAuth2User, Serializable {
    private static final long serialVersionUID = 1L;

    private final OAuth2User oauth2User;

    public CustomOAuth2User(OAuth2User oauth2User){
        this.oauth2User = oauth2User;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return oauth2User.getAttributes();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return oauth2User.getAuthorities();
    }

    @Override
    public String getName() {
        // This project uses authentication.getName() as email in the success handler.
        String email = oauth2User.getAttribute("email");
        if (email != null && !email.isBlank()) {
            return email;
        }
        String subject = oauth2User.getAttribute("sub");
        return subject != null ? subject : oauth2User.getName();
    }

    public String getFullName(){
        String fullName = oauth2User.getAttribute("name");
        return fullName != null && !fullName.isBlank() ? fullName : getName();
    }

    public String getEmail() {
        String email = oauth2User.getAttribute("email");
        return email != null ? email : getName();
    }

    
}
