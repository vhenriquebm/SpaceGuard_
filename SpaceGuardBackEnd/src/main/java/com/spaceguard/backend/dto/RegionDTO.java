package com.spaceguard.backend.dto;

import com.spaceguard.backend.entity.RiskLevel;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class RegionDTO {
    private Long id;

    @NotBlank(message = "Name is required")
    private String name;

    @NotBlank(message = "Country is required")
    private String country;

    @NotNull(message = "Risk level is required")
    private RiskLevel riskLevel;
}
