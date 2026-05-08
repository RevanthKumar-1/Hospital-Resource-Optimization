package com.hospital.controller;

import com.hospital.model.*;
import com.hospital.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminPatientController {

    @Autowired private PatientRepository patientRepository;
    @Autowired private DoctorRepository doctorRepository;
    @Autowired private DoctorPatientRepository doctorPatientRepository;
    @Autowired private BedRepository bedRepository;
    @Autowired private IcuRepository icuRepository;
    @Autowired private OtScheduleRepository otRepository;
    @Autowired private BedAdmissionRepository bedAdmissionRepository;
    @Autowired private IcuAdmissionRepository icuAdmissionRepository;
    @Autowired private OtScheduleRepository otScheduleRepository;

    private boolean isAdmin(HttpSession session) {
        return "ADMIN".equals(session.getAttribute("role"));
    }

    // ─── PATIENTS PAGE ────────────────────────────────────────

    @GetMapping("/patients")
    public String patientsPage(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/";

        model.addAttribute("patients", patientRepository.findAll());
        model.addAttribute("doctors", doctorRepository.findAll());
        model.addAttribute("totalPatients", patientRepository.count());
        model.addAttribute("assignments", doctorPatientRepository.findAll());
        return "admin/patients";
    }

    // ─── ASSIGN DOCTOR TO PATIENT ─────────────────────────────

    @PostMapping("/patients/assign-doctor")
    public String assignDoctor(@RequestParam Long patientId,
                               @RequestParam Long doctorId,
                               HttpSession session) {
        if (!isAdmin(session)) return "redirect:/";

        // Check if already assigned
        boolean exists = doctorPatientRepository
            .existsByDoctorIdAndPatientIdAndStatus(doctorId, patientId, "ACTIVE");
        if (exists) {
            return "redirect:/admin/patients?error=alreadyassigned";
        }

        // Deactivate any existing assignment for this patient
        DoctorPatient existing = doctorPatientRepository
            .findByPatientIdAndStatus(patientId, "ACTIVE");
        if (existing != null) {
            existing.setStatus("INACTIVE");
            doctorPatientRepository.save(existing);
        }

        // Create new assignment
        DoctorPatient assignment = new DoctorPatient();
        assignment.setPatientId(patientId);
        assignment.setDoctorId(doctorId);
        assignment.setStatus("ACTIVE");
        doctorPatientRepository.save(assignment);

        return "redirect:/admin/patients?success=Doctor assigned successfully";
    }

    // ─── REMOVE DOCTOR ASSIGNMENT ─────────────────────────────

    @PostMapping("/patients/remove-doctor")
    public String removeDoctor(@RequestParam Long patientId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/";

        DoctorPatient existing = doctorPatientRepository
            .findByPatientIdAndStatus(patientId, "ACTIVE");
        if (existing != null) {
            existing.setStatus("INACTIVE");
            doctorPatientRepository.save(existing);
        }
        return "redirect:/admin/patients?success=Doctor assignment removed";
    }

    // ─── SCHEDULE PAGE ────────────────────────────────────────

    @GetMapping("/schedule")
    public String schedulePage(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/";

        model.addAttribute("patients", patientRepository.findAll());
        model.addAttribute("doctors", doctorRepository.findAll());
        model.addAttribute("availableBeds", bedRepository.findByStatus("AVAILABLE"));
        model.addAttribute("availableIcus", icuRepository.findByStatus("AVAILABLE"));
        model.addAttribute("availableOts", otRepository.findByStatus("AVAILABLE"));
        model.addAttribute("bedAdmissions", bedAdmissionRepository.findByStatus("ACTIVE"));
        model.addAttribute("icuAdmissions", icuAdmissionRepository.findByStatus("ACTIVE"));
        model.addAttribute("otSchedules", otScheduleRepository.findByStatus("SCHEDULED"));
        return "admin/schedule";
    }

    // ─── ASSIGN BED ───────────────────────────────────────────

    @PostMapping("/schedule/assign-bed")
    public String assignBed(@RequestParam Long patientId,
            @RequestParam Long doctorId,
            @RequestParam Integer bedId,
            @RequestParam String admittedDate,
            @RequestParam String dischargeDate,
            HttpSession session) {
		if (!isAdmin(session)) return "redirect:/";
		
		// ✅ Check: bed already occupied
		BedAdmission existing = bedAdmissionRepository
		.findByBedIdAndStatus(bedId, "ACTIVE");
		if (existing != null) {
		return "redirect:/admin/schedule?tab=bed&error=bedoccupied";
		}
		
		// ✅ Check: discharge must be after admission
		LocalDate admitted = LocalDate.parse(admittedDate);
		LocalDate discharge = LocalDate.parse(dischargeDate);
		if (!discharge.isAfter(admitted)) {
		return "redirect:/admin/schedule?tab=bed&error=invaliddates";
		}
		
		// All good — save admission
		Bed bed = bedRepository.findById(bedId).orElse(null);
		if (bed != null) {
		bed.setStatus("OCCUPIED");
		bedRepository.save(bed);
		}
		
		BedAdmission admission = new BedAdmission();
		admission.setBedId(bedId);
		admission.setPatientId(patientId);
		admission.setDoctorId(doctorId);
		admission.setAdmittedDate(admitted);
		admission.setDischargeDate(discharge);
		admission.setStatus("ACTIVE");
		bedAdmissionRepository.save(admission);
		
		return "redirect:/admin/schedule?tab=bed&success=Bed assigned successfully";
	}

    // ─── RELEASE BED ──────────────────────────────────────────

    @PostMapping("/schedule/release-bed")
    public String releaseBed(@RequestParam Integer admissionId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/";

        BedAdmission admission = bedAdmissionRepository.findById(admissionId).orElse(null);
        if (admission != null) {
            admission.setStatus("DISCHARGED");
            bedAdmissionRepository.save(admission);

            Bed bed = bedRepository.findById(admission.getBedId()).orElse(null);
            if (bed != null) {
                bed.setStatus("AVAILABLE");
                bedRepository.save(bed);
            }
        }
        return "redirect:/admin/schedule?tab=bed&success=Patient discharged successfully";
    }

    // ─── ADMIT TO ICU ─────────────────────────────────────────

    @PostMapping("/schedule/assign-icu")
    public String assignIcu(@RequestParam Long patientId,
                            @RequestParam Long doctorId,
                            @RequestParam Integer icuId,
                            @RequestParam String admittedDate,
                            @RequestParam String dischargeDate,
                            HttpSession session) {
        if (!isAdmin(session)) return "redirect:/";

        Icu icu = icuRepository.findById(icuId).orElse(null);
        if (icu != null) {
            icu.setStatus("OCCUPIED");
            icuRepository.save(icu);
        }

        IcuAdmission admission = new IcuAdmission();
        admission.setIcuId(icuId);
        admission.setPatientId(patientId);
        admission.setDoctorId(doctorId);
        admission.setAdmittedDate(LocalDate.parse(admittedDate));
        admission.setDischargeDate(LocalDate.parse(dischargeDate));
        admission.setStatus("ACTIVE");
        icuAdmissionRepository.save(admission);

        return "redirect:/admin/schedule?tab=icu&success=Patient admitted to ICU successfully";
    }

    // ─── RELEASE ICU ──────────────────────────────────────────

    @PostMapping("/schedule/release-icu")
    public String releaseIcu(@RequestParam Integer admissionId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/";

        IcuAdmission admission = icuAdmissionRepository.findById(admissionId).orElse(null);
        if (admission != null) {
            admission.setStatus("DISCHARGED");
            icuAdmissionRepository.save(admission);

            Icu icu = icuRepository.findById(admission.getIcuId()).orElse(null);
            if (icu != null) {
                icu.setStatus("AVAILABLE");
                icuRepository.save(icu);
            }
        }
        return "redirect:/admin/schedule?tab=icu&success=Patient discharged from ICU";
    }

    // ─── SCHEDULE OT ──────────────────────────────────────────

    @PostMapping("/schedule/assign-ot")
    public String assignOt(@RequestParam Long patientId,
                           @RequestParam Long doctorId,
                           @RequestParam Integer otId,
                           @RequestParam String procedureName,
                           @RequestParam String scheduleDate,
                           @RequestParam String startTime,
                           @RequestParam String endTime,
                           HttpSession session) {

        if (!isAdmin(session)) return "redirect:/";

        LocalDate date = LocalDate.parse(scheduleDate);
        java.time.LocalTime start = java.time.LocalTime.parse(startTime);
        java.time.LocalTime end = java.time.LocalTime.parse(endTime);

        // ✅ Check 1: end time must be after start time
        if (!end.isAfter(start)) {
            return "redirect:/admin/schedule?tab=ot&error=invalidtime";
        }

        // ✅ Check 2: OT conflict — same OT, overlapping time
        List<OtSchedule> otConflicts = otScheduleRepository
            .findConflictingSchedules(otId, date, start, end);
        if (!otConflicts.isEmpty()) {
            return "redirect:/admin/schedule?tab=ot&error=otconflict";
        }

        // ✅ Check 3: Doctor conflict — same doctor, overlapping time
        List<OtSchedule> doctorConflicts = otScheduleRepository
            .findDoctorConflicts(doctorId, date, start, end);
        if (!doctorConflicts.isEmpty()) {
            return "redirect:/admin/schedule?tab=ot&error=doctorconflict";
        }

        // ✅ Check 4: Can't schedule in the past
        if (date.isBefore(LocalDate.now())) {
            return "redirect:/admin/schedule?tab=ot&error=pastdate";
        }

        // All checks passed — save schedule
        OtSchedule schedule = new OtSchedule();
        schedule.setOtId(otId);
        schedule.setPatientId(patientId);
        schedule.setDoctorId(doctorId);
        schedule.setProcedureName(procedureName);
        schedule.setScheduleDate(date);
        schedule.setStartTime(start);
        schedule.setEndTime(end);
        schedule.setStatus("SCHEDULED");
        otScheduleRepository.save(schedule);

        return "redirect:/admin/schedule?tab=ot&success=OT scheduled successfully";
    }

    // ─── COMPLETE / CANCEL OT ─────────────────────────────────

    @PostMapping("/schedule/update-ot")
    public String updateOt(@RequestParam Integer scheduleId,
                           @RequestParam String status,
                           HttpSession session) {
        if (!isAdmin(session)) return "redirect:/";

        OtSchedule schedule = otScheduleRepository.findById(scheduleId).orElse(null);
        if (schedule != null) {
            schedule.setStatus(status);
            otScheduleRepository.save(schedule);

            // If completed or cancelled, free up the OT
            if ("COMPLETED".equals(status) || "CANCELLED".equals(status)) {
                OtSchedule ot = otRepository.findById(schedule.getOtId()).orElse(null);
                if (ot != null) {
                    ot.setStatus("AVAILABLE");
                    otRepository.save(ot);
                }
            }
        }
        return "redirect:/admin/schedule?tab=ot";
    }
    
    @GetMapping("/admin/labs")
    public String adminLabs(HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/";
        return "admin/labs";
    }

    @GetMapping("/admin/external")
    public String adminExternal(HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/";
        return "admin/external";
    }

    @GetMapping("/patient/fitness")
    public String patientFitness(HttpSession session) {
        if (!"PATIENT".equals(session.getAttribute("role"))) return "redirect:/";
        return "patient/fitness";
    }
}