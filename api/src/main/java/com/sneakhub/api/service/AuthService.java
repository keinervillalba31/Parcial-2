package com.sneakhub.api.service;

import com.sneakhub.api.dto.AuthDtos.AuthResponse;
import com.sneakhub.api.dto.AuthDtos.LoginRequest;
import com.sneakhub.api.dto.AuthDtos.RegisterRequest;
import com.sneakhub.api.dto.UserResponse;
import com.sneakhub.api.entity.Role;
import com.sneakhub.api.entity.User;
import com.sneakhub.api.exception.ApiException;
import com.sneakhub.api.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final UserRepository users;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;

    public AuthService(UserRepository users, PasswordEncoder passwordEncoder, TokenService tokenService) {
        this.users = users;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        User user = users.findByEmail(request.email().trim().toLowerCase())
                .filter(u -> passwordEncoder.matches(request.password(), u.getPassword()))
                .orElseThrow(() -> ApiException.unauthorized("Correo o contraseña incorrectos"));
        return tokensFor(user);
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        String email = request.email().trim().toLowerCase();
        if (users.existsByEmail(email)) {
            throw ApiException.conflict("Ya existe una cuenta con ese correo");
        }
        String avatar = request.avatar() == null || request.avatar().isBlank()
                ? "https://i.pravatar.cc/150?u=" + email
                : request.avatar();
        User user = users.save(new User(request.name().trim(), email,
                passwordEncoder.encode(request.password()), Role.CUSTOMER, avatar));
        return tokensFor(user);
    }

    @Transactional(readOnly = true)
    public AuthResponse refresh(String refreshToken) {
        String email;
        try {
            email = tokenService.validateRefreshToken(refreshToken);
        } catch (JwtException e) {
            throw ApiException.unauthorized("Refresh token inválido o vencido");
        }
        User user = users.findByEmail(email)
                .orElseThrow(() -> ApiException.unauthorized("El usuario ya no existe"));
        return tokensFor(user);
    }

    @Transactional(readOnly = true)
    public UserResponse profile(String email) {
        return users.findByEmail(email)
                .map(UserResponse::from)
                .orElseThrow(() -> ApiException.notFound("Usuario no encontrado"));
    }

    private AuthResponse tokensFor(User user) {
        return new AuthResponse(
                tokenService.generateAccessToken(user),
                tokenService.generateRefreshToken(user),
                "Bearer",
                tokenService.accessExpirationSeconds());
    }
}
