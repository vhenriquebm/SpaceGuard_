package com.spaceguard.backend.dto;

import com.spaceguard.backend.entity.AlertType;
import com.spaceguard.backend.entity.RiskLevel;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AlertDTO {
    private Long id;

    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    @NotNull(message = "Risk level is required")
    private RiskLevel riskLevel;

    @NotNull(message = "Alert type is required")
    private AlertType alertType;

    @NotNull(message = "Region ID is required")
    private Long regionId;

    private LocalDateTime createdAt;
}
