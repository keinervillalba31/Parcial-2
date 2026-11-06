package com.sneakhub.api.dto;

import com.sneakhub.api.entity.Brand;
import com.sneakhub.api.entity.Category;
import jakarta.validation.constraints.NotBlank;

/** Marcas y categorías. */
public final class CatalogDtos {

    private CatalogDtos() {
    }

    public record BrandRequest(@NotBlank(message = "El nombre es obligatorio") String name, String logo) {
    }

    public record BrandResponse(Long id, String name, String logo) {
        public static BrandResponse from(Brand brand) {
            return new BrandResponse(brand.getId(), brand.getName(), brand.getLogo());
        }
    }

    public record CategoryRequest(@NotBlank(message = "El nombre es obligatorio") String name) {
    }

    public record CategoryResponse(Long id, String name) {
        public static CategoryResponse from(Category category) {
            return new CategoryResponse(category.getId(), category.getName());
        }
    }
}
