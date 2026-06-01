package com.spaceguard.backend.dto;

import com.spaceguard.backend.entity.SensorStatus;
import com.spaceguard.backend.entity.SensorType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class SensorDTO {
    private Long id;

    @NotBlank(message = "Name is required")
    private String name;

    @NotNull(message = "Type is required")
    private SensorType type;

    @NotNull(message = "Status is required")
    private SensorStatus status;

    @NotNull(message = "Region ID is required")
    private Long regionId;
}
