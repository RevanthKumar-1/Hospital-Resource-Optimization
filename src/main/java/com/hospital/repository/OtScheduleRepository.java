package com.hospital.repository;

import com.hospital.model.OtSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface OtScheduleRepository extends JpaRepository<OtSchedule, Integer> {
    List<OtSchedule> findByDoctorId(Long doctorId);
    List<OtSchedule> findByPatientId(Long patientId);
    List<OtSchedule> findByScheduleDate(LocalDate date);
    List<OtSchedule> findByOtIdAndScheduleDate(Integer otId, LocalDate date);
    List<OtSchedule> findByStatus(String status);
}