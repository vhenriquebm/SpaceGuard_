package com.spaceguard.backend.service;

import com.spaceguard.backend.dto.SensorDTO;
import com.spaceguard.backend.dto.SensorReadingDTO;
import com.spaceguard.backend.entity.Region;
import com.spaceguard.backend.entity.Sensor;
import com.spaceguard.backend.entity.SensorReading;
import com.spaceguard.backend.repository.RegionRepository;
import com.spaceguard.backend.repository.SensorReadingRepository;
import com.spaceguard.backend.repository.SensorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SensorService {

    private final SensorRepository sensorRepository;
    private final SensorReadingRepository readingRepository;
    private final RegionRepository regionRepository;

    public List<SensorDTO> findAll() {
        return sensorRepository.findAll().stream()
                .map(this::toDTO)
                .toList();
    }

    public SensorDTO findById(Long id) {
        return sensorRepository.findById(id)
                .map(this::toDTO)
                .orElseThrow(() -> new RuntimeException("Sensor not found"));
    }

    public SensorDTO create(SensorDTO dto) {
        Region region = regionRepository.findById(dto.getRegionId())
                .orElseThrow(() -> new RuntimeException("Region not found"));
        Sensor sensor = Sensor.builder()
                .name(dto.getName())
                .type(dto.getType())
                .status(dto.getStatus())
                .region(region)
                .build();
        return toDTO(sensorRepository.save(sensor));
    }

    public SensorDTO update(Long id, SensorDTO dto) {
        Sensor sensor = sensorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Sensor not found"));
        Region region = regionRepository.findById(dto.getRegionId())
                .orElseThrow(() -> new RuntimeException("Region not found"));
        sensor.setName(dto.getName());
        sensor.setType(dto.getType());
        sensor.setStatus(dto.getStatus());
        sensor.setRegion(region);
        return toDTO(sensorRepository.save(sensor));
    }

    public void delete(Long id) {
        if (!sensorRepository.existsById(id)) {
            throw new RuntimeException("Sensor not found");
        }
        sensorRepository.deleteById(id);
    }

    public List<SensorReadingDTO> getReadings(Long sensorId) {
        return readingRepository.findBySensorIdOrderByRecordedAtDesc(sensorId).stream()
                .map(this::toReadingDTO)
                .toList();
    }

    public SensorReadingDTO addReading(Long sensorId, SensorReadingDTO dto) {
        Sensor sensor = sensorRepository.findById(sensorId)
                .orElseThrow(() -> new RuntimeException("Sensor not found"));
        SensorReading reading = SensorReading.builder()
                .sensor(sensor)
                .temperature(dto.getTemperature())
                .smokeLevel(dto.getSmokeLevel())
                .waterLevel(dto.getWaterLevel())
                .build();
        return toReadingDTO(readingRepository.save(reading));
    }

    private SensorDTO toDTO(Sensor sensor) {
        SensorDTO dto = new SensorDTO();
        dto.setId(sensor.getId());
        dto.setName(sensor.getName());
        dto.setType(sensor.getType());
        dto.setStatus(sensor.getStatus());
        dto.setRegionId(sensor.getRegion().getId());
        return dto;
    }

    private SensorReadingDTO toReadingDTO(SensorReading reading) {
        SensorReadingDTO dto = new SensorReadingDTO();
        dto.setId(reading.getId());
        dto.setSensorId(reading.getSensor().getId());
        dto.setTemperature(reading.getTemperature());
        dto.setSmokeLevel(reading.getSmokeLevel());
        dto.setWaterLevel(reading.getWaterLevel());
        dto.setRecordedAt(reading.getRecordedAt());
        return dto;
    }
}
