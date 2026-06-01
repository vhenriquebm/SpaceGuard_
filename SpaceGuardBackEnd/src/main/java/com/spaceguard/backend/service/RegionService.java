package com.spaceguard.backend.service;

import com.spaceguard.backend.dto.RegionDTO;
import com.spaceguard.backend.entity.Region;
import com.spaceguard.backend.repository.RegionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RegionService {

    private final RegionRepository regionRepository;

    public List<RegionDTO> findAll() {
        return regionRepository.findAll().stream()
                .map(this::toDTO)
                .toList();
    }

    public RegionDTO findById(Long id) {
        return regionRepository.findById(id)
                .map(this::toDTO)
                .orElseThrow(() -> new RuntimeException("Region not found"));
    }

    public RegionDTO create(RegionDTO dto) {
        Region region = Region.builder()
                .name(dto.getName())
                .country(dto.getCountry())
                .riskLevel(dto.getRiskLevel())
                .build();
        return toDTO(regionRepository.save(region));
    }

    public RegionDTO update(Long id, RegionDTO dto) {
        Region region = regionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Region not found"));
        region.setName(dto.getName());
        region.setCountry(dto.getCountry());
        region.setRiskLevel(dto.getRiskLevel());
        return toDTO(regionRepository.save(region));
    }

    public void delete(Long id) {
        if (!regionRepository.existsById(id)) {
            throw new RuntimeException("Region not found");
        }
        regionRepository.deleteById(id);
    }

    private RegionDTO toDTO(Region region) {
        RegionDTO dto = new RegionDTO();
        dto.setId(region.getId());
        dto.setName(region.getName());
        dto.setCountry(region.getCountry());
        dto.setRiskLevel(region.getRiskLevel());
        return dto;
    }
}
