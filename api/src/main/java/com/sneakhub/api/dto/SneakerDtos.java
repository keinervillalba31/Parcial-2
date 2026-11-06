package com.sneakhub.api.dto;

import com.sneakhub.api.dto.CatalogDtos.BrandResponse;
import com.sneakhub.api.dto.CatalogDtos.CategoryResponse;
import com.sneakhub.api.entity.Gender;
import com.sneakhub.api.entity.Sneaker;
import jakarta.validation.constraints.*;

import java.util.List;

/** Tenis (el "producto" de la tienda). */
public final class SneakerDtos {

    private SneakerDtos() {
    }

    public record SneakerRequest(
            @NotBlank(message = "El nombre es obligatorio")
            String name,
            String description,
            @NotNull(message = "El precio es obligatorio")
            @Positive(message = "El precio debe ser mayor a 0")
            Double price,
            @NotNull(message = "El stock es obligatorio")
            @PositiveOrZero(message = "El stock no puede ser negativo")
            Integer stock,
            @NotNull(message = "El género es obligatorio (HOMBRE, MUJER, UNISEX)")
            Gender gender,
            String colors,
            @NotEmpty(message = "Debe tener al menos una talla")
            List<@NotNull @Min(value = 20, message = "Talla inválida") @Max(value = 50, message = "Talla inválida") Integer> sizes,
            List<@NotBlank String> images,
            @NotNull(message = "La marca es obligatoria")
            Long brandId,
            @NotNull(message = "La categoría es obligatoria")
            Long categoryId) {
    }

    public record SneakerResponse(
            Long id,
            String name,
            String description,
            Double price,
            Integer stock,
            Gender gender,
            String colors,
            List<Integer> sizes,
            List<String> images,
            BrandResponse brand,
            CategoryResponse category) {

        public static SneakerResponse from(Sneaker s) {
            return new SneakerResponse(
                    s.getId(),
                    s.getName(),
                    s.getDescription(),
                    s.getPrice(),
                    s.getStock(),
                    s.getGender(),
                    s.getColors(),
                    List.copyOf(s.getSizes()),
                    List.copyOf(s.getImages()),
                    BrandResponse.from(s.getBrand()),
                    CategoryResponse.from(s.getCategory()));
        }
    }
}
