package com.hospital.controller;

import com.hospital.model.*;
import com.hospital.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

@Controller
public class DashboardController {

    @Autowired private AdminRepository adminRepository;
    @Autowired private DoctorRepository doctorRepository;
    @Autowired private PatientRepository patientRepository;
    @Autowired private BedRepository bedRepository;
    @Autowired private IcuRepository icuRepository;
    @Autowired private OtRepository otRepository;
    @Autowired private OxygenTankRepository oxygenTankRepository;
    @Autowired private BloodBankRepository bloodBankRepository;
    @Autowired private BedAdmissionRepository bedAdmissionRepository;
    @Autowired private IcuAdmissionRepository icuAdmissionRepository;
    @Autowired private OtScheduleRepository otScheduleRepository;
    @Autowired private DoctorPatientRepository doctorPatientRepository;

    // ─── ADMIN DASHBOARD ──────────────────────────────────────

    @GetMapping("/admin/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        if (session.getAttribute("role") == null ||
            !session.getAttribute("role").equals("ADMIN")) {
            return "redirect:/";
        }

        Long adminId = (Long) session.getAttribute("loggedInId");
        Admin admin = adminRepository.findById(adminId).orElse(null);
        model.addAttribute("admin", admin);

        // Beds
        model.addAttribute("totalBeds", bedRepository.count());
        model.addAttribute("availableBeds", bedRepository.countByStatus("AVAILABLE"));
        model.addAttribute("occupiedBeds", bedRepository.countByStatus("OCCUPIED"));

        // ICU
        model.addAttribute("totalIcu", icuRepository.count());
        model.addAttribute("availableIcu", icuRepository.countByStatus("AVAILABLE"));
        model.addAttribute("occupiedIcu", icuRepository.countByStatus("OCCUPIED"));

        // OT
        model.addAttribute("totalOt", otRepository.count());
        model.addAttribute("availableOt", otRepository.countByStatus("AVAILABLE"));

        // Oxygen
        model.addAttribute("totalOxygen", oxygenTankRepository.count());
        model.addAttribute("availableOxygen", oxygenTankRepository.countByStatus("AVAILABLE"));

        // Doctors & Patients
        model.addAttribute("totalDoctors", doctorRepository.count());
        model.addAttribute("totalPatients", patientRepository.count());

        // Recent doctors and patients (last 5)
        List<Doctor> allDoctors = doctorRepository.findAll();
        List<Patient> allPatients = patientRepository.findAll();
        model.addAttribute("recentDoctors",
            allDoctors.subList(Math.max(0, allDoctors.size() - 5), allDoctors.size()));
        model.addAttribute("recentPatients",
            allPatients.subList(Math.max(0, allPatients.size() - 5), allPatients.size()));

        // Today's OT schedules
        model.addAttribute("todayOtSchedules",
            otScheduleRepository.findByScheduleDate(LocalDate.now()));

        // Active admissions
        model.addAttribute("activeBedAdmissions",
            bedAdmissionRepository.findByStatus("ACTIVE"));
        model.addAttribute("activeIcuAdmissions",
            icuAdmissionRepository.findByStatus("ACTIVE"));

        // Blood bank
        model.addAttribute("bloodBanks", bloodBankRepository.findAll());

        // Helper maps for names
        java.util.Map<Long, String> patientNameMap = new java.util.HashMap<>();
        java.util.Map<Long, String> doctorNameMap = new java.util.HashMap<>();
        for (Patient p : allPatients) patientNameMap.put(p.getId(), p.getName());
        for (Doctor d : allDoctors) doctorNameMap.put(d.getId(), d.getName());
        model.addAttribute("patientNameMap", patientNameMap);
        model.addAttribute("doctorNameMap", doctorNameMap);

        return "admin/dashboard";
    }

    // ─── DOCTOR DASHBOARD ─────────────────────────────────────

    @GetMapping("/doctor/dashboard")
    public String doctorDashboard(HttpSession session, Model model) {
        if (session.getAttribute("role") == null ||
            !session.getAttribute("role").equals("DOCTOR")) {
            return "redirect:/";
        }

        Long doctorId = (Long) session.getAttribute("loggedInId");
        Doctor doctor = doctorRepository.findById(doctorId).orElse(null);
        model.addAttribute("doctor", doctor);

        // Assigned patients
        List<DoctorPatient> assignments =
            doctorPatientRepository.findByDoctorId(doctorId);
        List<DoctorPatient> activeAssignments = assignments.stream()
            .filter(a -> "ACTIVE".equals(a.getStatus()))
            .collect(java.util.stream.Collectors.toList());
        model.addAttribute("activeAssignments", activeAssignments);

        // Fetch patient details for each assignment
        java.util.Map<Long, Patient> patientMap = new java.util.HashMap<>();
        for (DoctorPatient dp : activeAssignments) {
            patientRepository.findById(dp.getPatientId())
                .ifPresent(p -> patientMap.put(p.getId(), p));
        }
        model.addAttribute("patientMap", patientMap);

        // Today's OT schedules for this doctor
        List<OtSchedule> todayOt = otScheduleRepository
            .findByScheduleDate(LocalDate.now())
            .stream()
            .filter(o -> doctorId.equals(o.getDoctorId()))
            .collect(java.util.stream.Collectors.toList());
        model.addAttribute("todayOtSchedules", todayOt);

        // Active bed admissions for this doctor
        List<BedAdmission> bedAdmissions = bedAdmissionRepository
            .findByDoctorId(doctorId)
            .stream()
            .filter(b -> "ACTIVE".equals(b.getStatus()))
            .collect(java.util.stream.Collectors.toList());
        model.addAttribute("bedAdmissions", bedAdmissions);

        // Counts
        model.addAttribute("totalPatients", activeAssignments.size());
        model.addAttribute("todayAppointments", todayOt.size());
        model.addAttribute("activeBeds", bedAdmissions.size());

        return "doctor/dashboard";
    }

    // ─── PATIENT DASHBOARD ────────────────────────────────────

    @GetMapping("/patient/dashboard")
    public String patientDashboard(HttpSession session, Model model) {
        if (session.getAttribute("role") == null ||
            !session.getAttribute("role").equals("PATIENT")) {
            return "redirect:/";
        }

        Long patientId = (Long) session.getAttribute("loggedInId");
        Patient patient = patientRepository.findById(patientId).orElse(null);
        model.addAttribute("patient", patient);

        // Assigned doctor
        DoctorPatient assignment = doctorPatientRepository
            .findByPatientIdAndStatus(patientId, "ACTIVE");
        if (assignment != null) {
            Doctor assignedDoctor = doctorRepository
                .findById(assignment.getDoctorId()).orElse(null);
            model.addAttribute("assignedDoctor", assignedDoctor);
        }

        // Active bed admission
        BedAdmission bedAdmission = bedAdmissionRepository
            .findByStatus("ACTIVE").stream()
            .filter(b -> patientId.equals(b.getPatientId()))
            .findFirst().orElse(null);
        model.addAttribute("bedAdmission", bedAdmission);

        if (bedAdmission != null) {
            Bed bed = bedRepository.findById(bedAdmission.getBedId()).orElse(null);
            model.addAttribute("assignedBed", bed);
        }

        // Active ICU admission
        IcuAdmission icuAdmission = icuAdmissionRepository
            .findByStatus("ACTIVE").stream()
            .filter(i -> patientId.equals(i.getPatientId()))
            .findFirst().orElse(null);
        model.addAttribute("icuAdmission", icuAdmission);

        if (icuAdmission != null) {
            Icu icu = icuRepository.findById(icuAdmission.getIcuId()).orElse(null);
            model.addAttribute("assignedIcu", icu);
        }

        // Upcoming OT schedules
        List<OtSchedule> upcomingOt = otScheduleRepository
            .findByPatientId(patientId).stream()
            .filter(o -> "SCHEDULED".equals(o.getStatus()))
            .collect(java.util.stream.Collectors.toList());
        model.addAttribute("upcomingOtSchedules", upcomingOt);

        if (!upcomingOt.isEmpty()) {
            Ot ot = otRepository.findById(upcomingOt.get(0).getOtId()).orElse(null);
            model.addAttribute("scheduledOt", ot);
        }

        return "patient/dashboard";
    }
}