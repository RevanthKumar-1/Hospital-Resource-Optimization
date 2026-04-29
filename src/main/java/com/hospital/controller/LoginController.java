package com.hospital.controller;

import com.hospital.model.Admin;
import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.repository.AdminRepository;
import com.hospital.repository.DoctorRepository;
import com.hospital.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private PatientRepository patientRepository;

    @GetMapping("/")
    public String showLogin() {
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession session) {

    	
    	Doctor doctor = doctorRepository.findByEmailAndPassword(email, password);
    	if (doctor != null) {
    	    session.setAttribute("loggedInUser", doctor);
    	    session.setAttribute("role", "DOCTOR");
    	    session.setAttribute("userName", doctor.getName());
    	    session.setAttribute("loggedInId", doctor.getId()); 
    	    return "redirect:/doctor/dashboard";
    	}

    	
    	Admin admin = adminRepository.findByEmailAndPassword(email, password);
    	if (admin != null) {
    	    session.setAttribute("loggedInUser", admin);
    	    session.setAttribute("role", "ADMIN");
    	    session.setAttribute("userName", admin.getName());
    	    session.setAttribute("loggedInId", admin.getId()); 
    	    return "redirect:/admin/dashboard";
    	}

    	Patient patient = patientRepository.findByEmailAndPassword(email, password);
    	if (patient != null) {
    	    session.setAttribute("loggedInUser", patient);
    	    session.setAttribute("role", "PATIENT");
    	    session.setAttribute("userName", patient.getName());
    	    session.setAttribute("loggedInId", patient.getId()); 
    	    return "redirect:/patient/dashboard";
    	}

        // Not found in any table
        return "redirect:/?error=true";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}