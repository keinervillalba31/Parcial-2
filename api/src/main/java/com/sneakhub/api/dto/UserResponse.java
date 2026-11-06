package com.sneakhub.api.dto;

import com.sneakhub.api.entity.Role;
import com.sneakhub.api.entity.User;

/** Datos públicos del usuario (sin contraseña). */
public record UserResponse(Long id, String name, String email, Role role, String avatar) {

    public static UserResponse from(User user) {
        return new UserResponse(user.getId(), user.getName(), user.getEmail(), user.getRole(), user.getAvatar());
    }
}
