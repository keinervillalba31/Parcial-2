package com.sneakhub.api.service;

import com.sneakhub.api.config.JwtConfig;
import com.sneakhub.api.entity.RefreshToken;
import com.sneakhub.api.entity.User;
import com.sneakhub.api.repository.RefreshTokenRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;
import java.util.Optional;

/**
 * Genera los tokens de sesión.
 * <ul>
 *   <li>Access token: JWT firmado con HMAC-SHA256, dura poco y no se guarda.</li>
 *   <li>Refresh token: valor aleatorio de 256 bits. En la BD solo queda su hash
 *       SHA-256; al usarse se revoca y se entrega uno nuevo (rotación).</li>
 * </ul>
 */
@Service
public class TokenService {

    private static final SecureRandom RANDOM = new SecureRandom();

    private final JwtEncoder encoder;
    private final RefreshTokenRepository refreshTokens;
    private final Duration accessTtl;
    private final Duration refreshTtl;

    public TokenService(JwtEncoder encoder,
                        RefreshTokenRepository refreshTokens,
                        @Value("${app.jwt.access-expiration-minutes}") long accessMinutes,
                        @Value("${app.jwt.refresh-expiration-days}") long refreshDays) {
        this.encoder = encoder;
        this.refreshTokens = refreshTokens;
        this.accessTtl = Duration.ofMinutes(accessMinutes);
        this.refreshTtl = Duration.ofDays(refreshDays);
    }

    public String generateAccessToken(User user) {
        Instant now = Instant.now();
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer("sneakhub-api")
                .subject(user.getEmail())
                .issuedAt(now)
                .expiresAt(now.plus(accessTtl))
                .claim(JwtConfig.CLAIM_ROLE, user.getRole().name())
                .claim(JwtConfig.CLAIM_TYPE, JwtConfig.TYPE_ACCESS)
                .build();
        JwsHeader header = JwsHeader.with(MacAlgorithm.HS256).build();
        return encoder.encode(JwtEncoderParameters.from(header, claims)).getTokenValue();
    }

    /** Crea un refresh token: el valor real va al cliente, a la BD solo su hash. */
    public String generateRefreshToken(User user) {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        refreshTokens.save(new RefreshToken(hash(token), user, Instant.now().plus(refreshTtl)));
        return token;
    }

    public long accessExpirationSeconds() {
        return accessTtl.toSeconds();
    }

    /**
     * Valida un refresh token y lo revoca para que no se pueda volver a usar.
     * Devuelve el usuario dueño, o vacío si el token no existe, venció o ya se usó.
     */
    public Optional<User> consumeRefreshToken(String token) {
        return refreshTokens.findByTokenHash(hash(token))
                .filter(RefreshToken::isActive)
                .map(stored -> {
                    stored.revoke();
                    return stored.getUser();
                });
    }

    /** Revoca un refresh token (cerrar sesión). Si no existe no hace nada. */
    public void revokeRefreshToken(String token) {
        refreshTokens.findByTokenHash(hash(token)).ifPresent(RefreshToken::revoke);
    }

    static String hash(String token) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256")
                    .digest(token.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 no disponible", e);
        }
    }
}
