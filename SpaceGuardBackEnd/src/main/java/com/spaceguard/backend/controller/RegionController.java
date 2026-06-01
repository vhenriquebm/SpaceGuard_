package com.spaceguard.backend.controller;

import com.spaceguard.backend.dto.RegionDTO;
import com.spaceguard.backend.service.RegionService;
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
@RequestMapping("/regions")
@RequiredArgsConstructor
@Tag(name = "Regions", description = "Region management")
@SecurityRequirement(name = "bearerAuth")
public class RegionController {

    private final RegionService regionService;

    @GetMapping
    @Operation(summary = "List all regions")
    public ResponseEntity<List<RegionDTO>> findAll() {
        return ResponseEntity.ok(regionService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get region by ID")
    public ResponseEntity<RegionDTO> findById(@PathVariable Long id) {
        return ResponseEntity.ok(regionService.findById(id));
    }

    @PostMapping
    @Operation(summary = "Create a new region")
    public ResponseEntity<RegionDTO> create(@Valid @RequestBody RegionDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(regionService.create(dto));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update a region")
    public ResponseEntity<RegionDTO> update(@PathVariable Long id, @Valid @RequestBody RegionDTO dto) {
        return ResponseEntity.ok(regionService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a region")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        regionService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
