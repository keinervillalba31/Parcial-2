package com.sneakhub.api.service;

import com.sneakhub.api.config.JwtConfig;
import com.sneakhub.api.entity.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.time.Duration;
import java.time.Instant;

/** Genera y valida los JWT (access y refresh). */
@Service
public class TokenService {

    private final JwtEncoder encoder;
    private final JwtDecoder refreshDecoder;
    private final Duration accessTtl;
    private final Duration refreshTtl;

    public TokenService(JwtEncoder encoder,
                        SecretKey jwtSecretKey,
                        @Value("${app.jwt.access-expiration-minutes}") long accessMinutes,
                        @Value("${app.jwt.refresh-expiration-days}") long refreshDays) {
        this.encoder = encoder;
        this.refreshDecoder = JwtConfig.decoderFor(jwtSecretKey, JwtConfig.TYPE_REFRESH);
        this.accessTtl = Duration.ofMinutes(accessMinutes);
        this.refreshTtl = Duration.ofDays(refreshDays);
    }

    public String generateAccessToken(User user) {
        return generate(user, JwtConfig.TYPE_ACCESS, accessTtl);
    }

    public String generateRefreshToken(User user) {
        return generate(user, JwtConfig.TYPE_REFRESH, refreshTtl);
    }

    public long accessExpirationSeconds() {
        return accessTtl.toSeconds();
    }

    /** Valida un refresh token y devuelve el correo del usuario. Lanza JwtException si no es válido. */
    public String validateRefreshToken(String token) {
        return refreshDecoder.decode(token).getSubject();
    }

    private String generate(User user, String type, Duration ttl) {
        Instant now = Instant.now();
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer("sneakhub-api")
                .subject(user.getEmail())
                .issuedAt(now)
                .expiresAt(now.plus(ttl))
                .claim(JwtConfig.CLAIM_ROLE, user.getRole().name())
                .claim(JwtConfig.CLAIM_TYPE, type)
                .build();
        JwsHeader header = JwsHeader.with(MacAlgorithm.HS256).build();
        return encoder.encode(JwtEncoderParameters.from(header, claims)).getTokenValue();
    }
}
