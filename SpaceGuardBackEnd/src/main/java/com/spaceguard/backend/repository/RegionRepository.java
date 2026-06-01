package com.spaceguard.backend.repository;

import com.spaceguard.backend.entity.Region;
import com.spaceguard.backend.entity.RiskLevel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RegionRepository extends JpaRepository<Region, Long> {
    List<Region> findByRiskLevel(RiskLevel riskLevel);
    List<Region> findByCountry(String country);
}
