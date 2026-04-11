package com.hospital.controller;

import com.hospital.model.User;
import com.hospital.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	@Autowired
    private UserRepository userRepository;

    // Show login page
    @GetMapping("/")
    public String showLogin() {
        return "login";
    }

    // Handle login form submission
    @PostMapping("/login")
    public String handleLogin(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession session) {

        User user = userRepository.findByEmailAndPassword(email, password);

        if (user == null) {
            return "redirect:/?error=true";
        }

        session.setAttribute("loggedInUser", user);

        // Redirect based on role
        switch (user.getRole()) {
            case "ADMIN":   return "redirect:/admin/dashboard";
            case "DOCTOR":  return "redirect:/doctor/dashboard";
            case "PATIENT": return "redirect:/patient/dashboard";
            default:        return "redirect:/?error=true";
        }
    }

    // Logout
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
