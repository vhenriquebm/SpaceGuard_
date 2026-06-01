package com.spaceguard.backend.config;

import com.spaceguard.backend.entity.*;
import com.spaceguard.backend.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final RegionRepository regionRepository;
    private final AlertRepository alertRepository;
    private final SensorRepository sensorRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        seedAdminUser();
        seedRegionsAndAlerts();
    }

    private void seedAdminUser() {
        if (!userRepository.existsByEmail("admin@spaceguard.com")) {
            userRepository.save(User.builder()
                    .email("admin@spaceguard.com")
                    .passwordHash(passwordEncoder.encode("admin123"))
                    .build());
            log.info("Admin user created — email: admin@spaceguard.com  password: admin123");
        }
    }

    private void seedRegionsAndAlerts() {
        if (regionRepository.count() > 0) return;

        Region amazonas = regionRepository.save(Region.builder()
                .name("Amazonas")
                .country("Brazil")
                .riskLevel(RiskLevel.HIGH)
                .build());

        Region pantanal = regionRepository.save(Region.builder()
                .name("Pantanal")
                .country("Brazil")
                .riskLevel(RiskLevel.CRITICAL)
                .build());

        sensorRepository.save(Sensor.builder()
                .name("Sensor-AM-001")
                .type(SensorType.MULTI)
                .status(SensorStatus.ACTIVE)
                .region(amazonas)
                .build());

        sensorRepository.save(Sensor.builder()
                .name("Sensor-PT-001")
                .type(SensorType.TEMPERATURE)
                .status(SensorStatus.ACTIVE)
                .region(pantanal)
                .build());

        alertRepository.save(EnvironmentalAlert.builder()
                .title("Wildfire Detected — Northern Sector")
                .description("High temperature and smoke levels detected. Immediate action required.")
                .riskLevel(RiskLevel.CRITICAL)
                .alertType(AlertType.FIRE)
                .region(pantanal)
                .build());

        alertRepository.save(EnvironmentalAlert.builder()
                .title("Flooding Risk — River Basin")
                .description("Water levels rising above normal thresholds in low-lying areas.")
                .riskLevel(RiskLevel.HIGH)
                .alertType(AlertType.FLOOD)
                .region(amazonas)
                .build());

        log.info("Sample regions, sensors and alerts created.");
    }
}
