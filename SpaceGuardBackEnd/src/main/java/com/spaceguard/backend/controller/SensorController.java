package com.spaceguard.backend.controller;

import com.spaceguard.backend.dto.SensorDTO;
import com.spaceguard.backend.dto.SensorReadingDTO;
import com.spaceguard.backend.service.SensorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/sensors")
@RequiredArgsConstructor
@Tag(name = "Sensors", description = "Sensor management")
@SecurityRequirement(name = "bearerAuth")
public class SensorController {

    private final SensorService sensorService;

    @GetMapping
    @Operation(summary = "List all sensors")
    public ResponseEntity<List<SensorDTO>> findAll() {
        return ResponseEntity.ok(sensorService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get sensor by ID")
    public ResponseEntity<SensorDTO> findById(@PathVariable Long id) {
        return ResponseEntity.ok(sensorService.findById(id));
    }

    @PostMapping
    @Operation(summary = "Create a new sensor")
    public ResponseEntity<SensorDTO> create(@Valid @RequestBody SensorDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(sensorService.create(dto));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update a sensor")
    public ResponseEntity<SensorDTO> update(@PathVariable Long id, @Valid @RequestBody SensorDTO dto) {
        return ResponseEntity.ok(sensorService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a sensor")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        sensorService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/readings")
    @Operation(summary = "Get all readings for a sensor")
    public ResponseEntity<List<SensorReadingDTO>> getReadings(@PathVariable Long id) {
        return ResponseEntity.ok(sensorService.getReadings(id));
    }

    @PostMapping("/{id}/readings")
    @Operation(summary = "Add a reading to a sensor")
    public ResponseEntity<SensorReadingDTO> addReading(@PathVariable Long id,
                                                        @RequestBody SensorReadingDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(sensorService.addReading(id, dto));
    }
}
