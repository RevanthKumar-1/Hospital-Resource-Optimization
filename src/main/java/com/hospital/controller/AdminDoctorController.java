package com.hospital.controller;

import com.hospital.model.Doctor;
import com.hospital.repository.DoctorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;

@Controller
@RequestMapping("/admin")
public class AdminDoctorController {

    @Autowired
    private DoctorRepository doctorRepository;

    private boolean isAdmin(HttpSession session) {
        return "ADMIN".equals(session.getAttribute("role"));
    }

    @GetMapping("/doctors")
    public String doctorsPage(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/";
        model.addAttribute("doctors", doctorRepository.findAll());
        model.addAttribute("totalDoctors", doctorRepository.count());
        return "admin/doctors";
    }

    @PostMapping("/doctors/add")
    public String addDoctor(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String phone,
            @RequestParam String specialization,
            @RequestParam String qualification,
            @RequestParam String department,
            @RequestParam String practiceStartDate,
            HttpSession session) {

        if (!isAdmin(session)) return "redirect:/";

        // Check if email already exists
        Doctor existing = doctorRepository.findByEmail(email);
        if (existing != null) {
            return "redirect:/admin/doctors?error=emailexists";
        }

        Doctor doctor = new Doctor();
        doctor.setName(name);
        doctor.setEmail(email);
        doctor.setPassword(password);
        doctor.setPhone(phone);
        doctor.setSpecialization(specialization);
        doctor.setQualification(qualification);
        doctor.setDepartment(department);
        doctor.setPracticeStartDate(LocalDate.parse(practiceStartDate));

        doctorRepository.save(doctor);
        return "redirect:/admin/doctors?success=Doctor added successfully";
    }

    @PostMapping("/doctors/delete")
    public String deleteDoctor(@RequestParam Long id, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/";
        doctorRepository.deleteById(id);
        return "redirect:/admin/doctors?success=Doctor removed successfully";
    }
}