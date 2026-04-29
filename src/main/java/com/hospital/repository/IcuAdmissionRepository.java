package com.hospital.repository;

import com.hospital.model.IcuAdmission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface IcuAdmissionRepository extends JpaRepository<IcuAdmission, Integer> {
    List<IcuAdmission> findByPatientId(Long patientId);
    List<IcuAdmission> findByDoctorId(Long doctorId);
    List<IcuAdmission> findByStatus(String status);
    IcuAdmission findByIcuIdAndStatus(Integer icuId, String status);
}