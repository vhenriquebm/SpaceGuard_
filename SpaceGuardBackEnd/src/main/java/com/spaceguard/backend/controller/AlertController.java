package com.spaceguard.backend.controller;

import com.spaceguard.backend.dto.AlertDTO;
import com.spaceguard.backend.service.AlertService;
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
@RequestMapping("/alerts")
@RequiredArgsConstructor
@Tag(name = "Alerts", description = "Environmental alert management")
@SecurityRequirement(name = "bearerAuth")
public class AlertController {

    private final AlertService alertService;

    @GetMapping
    @Operation(summary = "List all alerts (newest first)")
    public ResponseEntity<List<AlertDTO>> findAll() {
        return ResponseEntity.ok(alertService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get alert by ID")
    public ResponseEntity<AlertDTO> findById(@PathVariable Long id) {
        return ResponseEntity.ok(alertService.findById(id));
    }

    @GetMapping("/region/{regionId}")
    @Operation(summary = "Get all alerts for a region")
    public ResponseEntity<List<AlertDTO>> findByRegion(@PathVariable Long regionId) {
        return ResponseEntity.ok(alertService.findByRegion(regionId));
    }

    @PostMapping
    @Operation(summary = "Create a new alert")
    public ResponseEntity<AlertDTO> create(@Valid @RequestBody AlertDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(alertService.create(dto));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update an alert")
    public ResponseEntity<AlertDTO> update(@PathVariable Long id, @Valid @RequestBody AlertDTO dto) {
        return ResponseEntity.ok(alertService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete an alert")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        alertService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
