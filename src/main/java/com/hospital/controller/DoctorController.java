package com.hospital.controller;

import com.hospital.model.*;
import com.hospital.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.http.HttpSession;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/doctor")
public class DoctorController {

    @Autowired private DoctorPatientRepository doctorPatientRepository;
    @Autowired private PatientRepository patientRepository;
    @Autowired private BedAdmissionRepository bedAdmissionRepository;
    @Autowired private IcuAdmissionRepository icuAdmissionRepository;
    @Autowired private OtScheduleRepository otScheduleRepository;
    @Autowired private BedRepository bedRepository;
    @Autowired private IcuRepository icuRepository;

    private boolean isDoctor(HttpSession session) {
        return "DOCTOR".equals(session.getAttribute("role"));
    }

    @GetMapping("/patients")
    public String patientsPage(HttpSession session, Model model) {
        if (!isDoctor(session)) return "redirect:/";

        Long doctorId = (Long) session.getAttribute("loggedInId");

        // Get all active assigned patients
        List<DoctorPatient> assignments = doctorPatientRepository
            .findByDoctorId(doctorId).stream()
            .filter(a -> "ACTIVE".equals(a.getStatus()))
            .collect(Collectors.toList());

        // Fetch full patient details
        List<Patient> patients = new ArrayList<>();
        for (DoctorPatient dp : assignments) {
            patientRepository.findById(dp.getPatientId()).ifPresent(patients::add);
        }

        // Bed admissions for this doctor
        Map<Long, BedAdmission> patientBedMap = new HashMap<>();
        List<BedAdmission> bedAdmissions = bedAdmissionRepository
            .findByDoctorId(doctorId).stream()
            .filter(b -> "ACTIVE".equals(b.getStatus()))
            .collect(Collectors.toList());
        for (BedAdmission ba : bedAdmissions) {
            patientBedMap.put(ba.getPatientId(), ba);
        }

        // ICU admissions for this doctor
        Map<Long, IcuAdmission> patientIcuMap = new HashMap<>();
        List<IcuAdmission> icuAdmissions = icuAdmissionRepository
            .findByDoctorId(doctorId).stream()
            .filter(i -> "ACTIVE".equals(i.getStatus()))
            .collect(Collectors.toList());
        for (IcuAdmission ia : icuAdmissions) {
            patientIcuMap.put(ia.getPatientId(), ia);
        }

        // OT schedules for each patient
        Map<Long, List<OtSchedule>> patientOtMap = new HashMap<>();
        for (Patient p : patients) {
            List<OtSchedule> ots = otScheduleRepository
                .findByPatientId(p.getId()).stream()
                .filter(o -> "SCHEDULED".equals(o.getStatus()))
                .collect(Collectors.toList());
            patientOtMap.put(p.getId(), ots);
        }

        // Bed details map
        Map<Integer, Bed> bedMap = new HashMap<>();
        for (Bed b : bedRepository.findAll()) {
            bedMap.put(b.getId(), b);
        }

        // ICU details map
        Map<Integer, Icu> icuMap = new HashMap<>();
        for (Icu i : icuRepository.findAll()) {
            icuMap.put(i.getId(), i);
        }

        model.addAttribute("patients", patients);
        model.addAttribute("patientBedMap", patientBedMap);
        model.addAttribute("patientIcuMap", patientIcuMap);
        model.addAttribute("patientOtMap", patientOtMap);
        model.addAttribute("bedMap", bedMap);
        model.addAttribute("icuMap", icuMap);
        model.addAttribute("totalPatients", patients.size());

        return "doctor/patients";
    }
}