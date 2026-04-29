package com.hospital.repository;

import com.hospital.model.BedAdmission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BedAdmissionRepository extends JpaRepository<BedAdmission, Integer> {
    List<BedAdmission> findByPatientId(Long patientId);
    List<BedAdmission> findByDoctorId(Long doctorId);
    List<BedAdmission> findByStatus(String status);
    BedAdmission findByBedIdAndStatus(Integer bedId, String status);
}