package com.spaceguard.backend.repository;

import com.spaceguard.backend.entity.Sensor;
import com.spaceguard.backend.entity.SensorStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SensorRepository extends JpaRepository<Sensor, Long> {
    List<Sensor> findByRegionId(Long regionId);
    List<Sensor> findByStatus(SensorStatus status);
}
