package com.spaceguard.backend.dto;

import lombok.Data;

@Data
public class LoginResponse {
    private String token;
    private String email;
    private String type = "Bearer";

    public LoginResponse(String token, String email) {
        this.token = token;
        this.email = email;
    }
}
