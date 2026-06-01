package com.spaceguard.backend.repository;

import com.spaceguard.backend.entity.EnvironmentalAlert;
import com.spaceguard.backend.entity.RiskLevel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AlertRepository extends JpaRepository<EnvironmentalAlert, Long> {
    List<EnvironmentalAlert> findByRegionId(Long regionId);
    List<EnvironmentalAlert> findByRiskLevel(RiskLevel riskLevel);
    List<EnvironmentalAlert> findAllByOrderByCreatedAtDesc();
}
