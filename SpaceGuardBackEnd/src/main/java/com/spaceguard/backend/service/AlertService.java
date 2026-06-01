package com.spaceguard.backend.service;

import com.spaceguard.backend.dto.AlertDTO;
import com.spaceguard.backend.entity.EnvironmentalAlert;
import com.spaceguard.backend.entity.Region;
import com.spaceguard.backend.repository.AlertRepository;
import com.spaceguard.backend.repository.RegionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AlertService {

    private final AlertRepository alertRepository;
    private final RegionRepository regionRepository;

    public List<AlertDTO> findAll() {
        return alertRepository.findAllByOrderByCreatedAtDesc().stream()
                .map(this::toDTO)
                .toList();
    }

    public AlertDTO findById(Long id) {
        return alertRepository.findById(id)
                .map(this::toDTO)
                .orElseThrow(() -> new RuntimeException("Alert not found"));
    }

    public List<AlertDTO> findByRegion(Long regionId) {
        return alertRepository.findByRegionId(regionId).stream()
                .map(this::toDTO)
                .toList();
    }

    public AlertDTO create(AlertDTO dto) {
        Region region = regionRepository.findById(dto.getRegionId())
                .orElseThrow(() -> new RuntimeException("Region not found"));
        EnvironmentalAlert alert = EnvironmentalAlert.builder()
                .title(dto.getTitle())
                .description(dto.getDescription())
                .riskLevel(dto.getRiskLevel())
                .alertType(dto.getAlertType())
                .region(region)
                .build();
        return toDTO(alertRepository.save(alert));
    }

    public AlertDTO update(Long id, AlertDTO dto) {
        EnvironmentalAlert alert = alertRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Alert not found"));
        Region region = regionRepository.findById(dto.getRegionId())
                .orElseThrow(() -> new RuntimeException("Region not found"));
        alert.setTitle(dto.getTitle());
        alert.setDescription(dto.getDescription());
        alert.setRiskLevel(dto.getRiskLevel());
        alert.setAlertType(dto.getAlertType());
        alert.setRegion(region);
        return toDTO(alertRepository.save(alert));
    }

    public void delete(Long id) {
        if (!alertRepository.existsById(id)) {
            throw new RuntimeException("Alert not found");
        }
        alertRepository.deleteById(id);
    }

    private AlertDTO toDTO(EnvironmentalAlert alert) {
        AlertDTO dto = new AlertDTO();
        dto.setId(alert.getId());
        dto.setTitle(alert.getTitle());
        dto.setDescription(alert.getDescription());
        dto.setRiskLevel(alert.getRiskLevel());
        dto.setAlertType(alert.getAlertType());
        dto.setRegionId(alert.getRegion().getId());
        dto.setCreatedAt(alert.getCreatedAt());
        return dto;
    }
}
