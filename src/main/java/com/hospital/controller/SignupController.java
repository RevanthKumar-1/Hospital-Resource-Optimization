package com.hospital.controller;

import com.hospital.model.Patient;
import com.hospital.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;

@Controller
public class SignupController {
	
	@Autowired
    private PatientRepository patientRepository;

    @GetMapping("/signup")
    public String showSignup() {
        return "signup";
    }

    @PostMapping("/signup")
    public String handleSignup(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String phone,
            @RequestParam String dateOfBirth,
            @RequestParam String gender,
            @RequestParam String bloodGroup,
            @RequestParam String address,
            @RequestParam String emergencyContact,
            @RequestParam(required = false) String medicalHistory) {

        // Check if email already exists
        Patient existing = patientRepository.findByEmail(email);
        if (existing != null) {
            return "redirect:/signup?error=emailexists";
        }

        Patient patient = new Patient();
        patient.setName(name);
        patient.setEmail(email);
        patient.setPassword(password);
        patient.setPhone(phone);
        patient.setDateOfBirth(LocalDate.parse(dateOfBirth));
        patient.setGender(gender);
        patient.setBloodGroup(bloodGroup);
        patient.setAddress(address);
        patient.setEmergencyContact(emergencyContact);
        patient.setMedicalHistory(medicalHistory);

        patientRepository.save(patient);

        return "redirect:/?success=true";
    }
}
