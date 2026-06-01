package com.spaceguard.backend.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class SensorReadingDTO {
    private Long id;
    private Long sensorId;
    private Double temperature;
    private Double smokeLevel;
    private Double waterLevel;
    private LocalDateTime recordedAt;
}
