package com.spaceguard.backend.service;

import com.spaceguard.backend.dto.LoginRequest;
import com.spaceguard.backend.dto.LoginResponse;
import com.spaceguard.backend.dto.RegisterRequest;
import com.spaceguard.backend.entity.User;
import com.spaceguard.backend.repository.UserRepository;
import com.spaceguard.backend.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new RuntimeException("Invalid credentials");
        }

        return new LoginResponse(jwtUtil.generateToken(user.getEmail()), user.getEmail());
    }

    public LoginResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already registered");
        }

        User user = userRepository.save(User.builder()
                .email(request.getEmail())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .build());

        return new LoginResponse(jwtUtil.generateToken(user.getEmail()), user.getEmail());
    }
}
