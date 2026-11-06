package com.sneakhub.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Peticiones y respuestas de autenticación. */
public final class AuthDtos {

    private AuthDtos() {
    }

    public record LoginRequest(
            @NotBlank(message = "El correo es obligatorio")
            @Email(message = "Correo inválido")
            String email,
            @NotBlank(message = "La contraseña es obligatoria")
            String password) {
    }

    public record RegisterRequest(
            @NotBlank(message = "El nombre es obligatorio")
            String name,
            @NotBlank(message = "El correo es obligatorio")
            @Email(message = "Correo inválido")
            String email,
            @NotBlank(message = "La contraseña es obligatoria")
            @Size(min = 4, message = "La contraseña debe tener mínimo 4 caracteres")
            String password,
            String avatar) {
    }

    public record RefreshRequest(
            @JsonProperty("refresh_token")
            @NotBlank(message = "El refresh_token es obligatorio")
            String refreshToken) {
    }

    /** Mismo formato que usa la app Flutter: access_token y refresh_token. */
    public record AuthResponse(
            @JsonProperty("access_token") String accessToken,
            @JsonProperty("refresh_token") String refreshToken,
            @JsonProperty("token_type") String tokenType,
            @JsonProperty("expires_in") long expiresIn) {
    }
}
